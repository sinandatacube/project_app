import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import 'package:projects/cubit/authentication/authenication_cubit.dart';
import 'package:projects/my_app.dart';
import 'package:projects/screens/authentication/forgot_password.dart';
import 'package:projects/screens/authentication/registration.dart';
import 'package:projects/screens/home/home_screen.dart';
import 'package:projects/utils/email_validation.dart';
import 'package:projects/utils/snackBar.dart';
import 'package:projects/utils/text_field.dart';
import 'package:projects/utils/toast.dart';
import 'package:projects/utils/text_styles.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final ValueNotifier<bool> _obscureText = ValueNotifier<bool>(true);

  late final AuthenicationCubit _authCubit;

  @override
  void initState() {
    super.initState();
    _authCubit = AuthenicationCubit();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _obscureText.dispose();
    _authCubit.close();
    super.dispose();
  }

  void _login() {
    if (!_formKey.currentState!.validate()) return;

    if (!isValidEmail(_emailController.text.trim())) {
      showSnackBar(context, "Enter valid email");
      return;
    }

    _authCubit.loginUser(
      _emailController.text.trim(),
      _passwordController.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: size.width * 0.06),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: size.height * 0.12),

                  Text(
                    "Hello, Welcome Back! 👋",
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onBackground,
                    ),
                  ),

                  SizedBox(height: size.height * 0.06),

                  _buildLabel("Email"),
                  const SizedBox(height: 8),
                  CustomTextField(
                    prefixIcon: Icons.email,
                    controller: _emailController,
                    isNumber: false,
                  ),
                  _buildLabel("Password"),
                  const SizedBox(height: 5),
                  ValueListenableBuilder(
                    valueListenable: _obscureText,
                    builder: (context, v, _) {
                      return Stack(
                        children: [
                          CustomTextField(
                            obscureText: v,
                            prefixIcon: Icons.lock,

                            controller: _passwordController,
                            isNumber: false,
                          ),

                          Positioned(
                            right: 3,
                            child: IconButton(
                              onPressed:
                                  () =>
                                      _obscureText.value = !_obscureText.value,
                              icon: Icon(
                                v ? Icons.visibility_off : Icons.visibility,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),

                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed:
                          () => navigatorKey.currentState?.push(
                            MaterialPageRoute(builder: (_) => ForgotPassword()),
                          ),
                      child: const Text("Forgot Password?"),
                    ),
                  ),

                  SizedBox(height: size.height * 0.03),

                  BlocConsumer<AuthenicationCubit, AuthenicationState>(
                    bloc: _authCubit,
                    listener: (context, state) {
                      if (state is AuthFailed) {
                        showSnackBar(context, state.error);
                      } else if (state is AuthSuccess) {
                        showToast(state.note, true);
                        navigatorKey.currentState?.pushAndRemoveUntil(
                          MaterialPageRoute(builder: (_) => HomeScreen()),
                          (route) => false,
                        );
                      }
                    },
                    builder: (context, state) {
                      return SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: state is AuthLoading ? () {} : _login,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: theme.primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child:
                              state is AuthLoading
                                  ? LoadingAnimationWidget.staggeredDotsWave(
                                    color: Colors.white,
                                    size: 28,
                                  )
                                  : const Text(
                                    "Login",
                                    style: TextStyle(fontSize: 16),
                                  ),
                        ),
                      );
                    },
                  ),

                  SizedBox(height: size.height * 0.18),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Not yet registered? "),
                      TextButton(
                        onPressed:
                            () => navigatorKey.currentState?.push(
                              MaterialPageRoute(builder: (_) => Registration()),
                            ),
                        child: const Text("Sign up"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: bodyTextStyle.copyWith(
        fontWeight: FontWeight.w600,
        color: Colors.grey[800],
      ),
    );
  }
}
