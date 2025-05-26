// import 'dart:developer';

// import 'package:flutter/material.dart';
// import 'package:projects/my_app.dart';
// import 'package:projects/screens/authentication/login_screen.dart';
// import 'package:projects/screens/home/home_screen.dart';

// import 'package:shared_preferences/shared_preferences.dart';

// class SplashScreen extends StatelessWidget {
//   const SplashScreen({super.key});

//   Future<bool> checkIsLoggedInOrNot() async {
//     SharedPreferences sp = await SharedPreferences.getInstance();
//     String? useruid = sp.getString("useruid");
//     log(useruid.toString(), name: "uid");
//     if (useruid != null) {
//       return true;
//     } else {
//       return false;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: FutureBuilder(
//         future: checkIsLoggedInOrNot(),
//         builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(
//               child: LinearProgressIndicator(color: Colors.white),
//             );
//           } else if (snapshot.hasData) {
//             bool isLoggedIn = snapshot.data!;
//             Future.microtask(() {
//               isLoggedIn
//                   ? navigatorKey.currentState?.pushAndRemoveUntil(
//                     MaterialPageRoute(builder: (_) => HomeScreen()),
//                     (route) => false,
//                   )
//                   : navigatorKey.currentState?.pushAndRemoveUntil(
//                     MaterialPageRoute(builder: (_) => LoginScreen()),
//                     (route) => false,
//                   );
//             });
//             return const SizedBox();
//           } else if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           } else {
//             return const Center(child: Text('Something went wrong.'));
//           }
//         },
//       ),
//     );
//   }
// }
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:projects/my_app.dart';
import 'package:projects/screens/authentication/login_screen.dart';
import 'package:projects/screens/home/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateBasedOnAuth();
  }

  Future<void> _navigateBasedOnAuth() async {
    try {
      final isLoggedIn = await _checkIsLoggedIn();
      final target = isLoggedIn ? HomeScreen() : LoginScreen();

      await Future.delayed(const Duration(milliseconds: 1500)); // Splash pause
      navigatorKey.currentState?.pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => target),
        (route) => false,
      );
    } catch (e) {
      log('Error checking login: $e');
    }
  }

  Future<bool> _checkIsLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final userUid = prefs.getString("useruid");
    log(userUid.toString(), name: "uid");
    return userUid != null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        child: Center(child: Image.asset("assets/logo/logo.png")),

        // Column(
        //   mainAxisAlignment: MainAxisAlignment.center,
        //   children: [
        //     // const FlutterLogo(size: 100),
        //     // const SizedBox(height: 24),

        //     // const SizedBox(height: 16),
        //     // const SizedBox(
        //     //   width: 200,
        //     //   child: LinearProgressIndicator(
        //     //     color: Colors.white,
        //     //     backgroundColor: Colors.white24,
        //     //     minHeight: 4,
        //     //     semanticsLabel: "Checking login...",
        //     //   ),
        //     // ),
        //   ],
        // ),
      ),
    );
  }
}
