import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
part 'authenication_state.dart';

class AuthenicationCubit extends Cubit<AuthenicationState> {
  AuthenicationCubit() : super(AuthenicationInitial());

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  registerUser(String email, String password) async {
    try {
      emit(AuthLoading());

      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = result.user;

      if (user != null) {
        await _firestore.collection('users').doc(user.uid).set({
          'uid': user.uid,
          'email': email,
          'password': password,
          'status': 'offline',
          'createdAt': FieldValue.serverTimestamp(),
        });
      }
      emit(AuthSuccess(note: "Registration Success"));

      // return 'success';
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        emit(
          AuthFailed(error: 'This email is already registered. Please login.'),
        );

        // return 'This email is already registered. Please login.';
      } else if (e.code == 'invalid-email') {
        emit(AuthFailed(error: 'Invalid email address format.'));
        // return 'Invalid email address format.';
      } else if (e.code == 'weak-password') {
        emit(
          AuthFailed(
            error: 'Password is too weak. It should be at least 6 characters.',
          ),
        );
      } else {
        return e.message;
      }
    } catch (e) {
      emit(AuthFailed(error: 'An unexpected error occurred'));
      // return 'An unexpected error occurred';
    }
  }

  //************************************************ */
  Future<String?> loginUser(String email, String password) async {
    try {
      emit(AuthLoading());
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = result.user;

      if (user != null) {
        //**************  store uid in local storage

        await _firestore.collection('users').doc(user.uid).set({
          'status': 'online',
        }, SetOptions(merge: true));

        //store uid in local storage
        SharedPreferences sp = await SharedPreferences.getInstance();
        sp.setString("useremail", user.email ?? "");
        sp.setString("useruid", user.uid);
        emit(AuthSuccess(note: "Login Success"));

        // return 'success';
      } else {
        return 'Login failed. Please try again.';
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        emit(AuthFailed(error: 'No user found for this email.'));

        // return 'No user found for this email.';
      } else if (e.code == 'wrong-password') {
        emit(AuthFailed(error: 'Incorrect password.'));

        return 'Incorrect password.';
      } else if (e.code == 'invalid-email') {
        emit(AuthFailed(error: 'Invalid email address format.'));

        // return 'Invalid email address format.';
      } else {
        return e.message;
      }
    } catch (e) {
      emit(AuthFailed(error: 'An unexpected error occurred'));

      // return 'An unexpected error occurred';
    }
  }

  //******************************************  */
  logout() async {
    try {
      emit(AuthLoading());
      SharedPreferences sp = await SharedPreferences.getInstance();
      String? userUid = sp.getString('useruid');

      await _firestore.collection('users').doc(userUid).set({
        'status': 'offline',
      }, SetOptions(merge: true));

      sp.remove("useruid");
      sp.remove("useremail");
      await _auth.signOut();

      emit(AuthSuccess(note: "Logged out"));
    } catch (e) {
      emit(AuthFailed(error: "Failed to Logged out"));
    }
  }
}
