import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import 'package:projects/cubit/authentication/authenication_cubit.dart';
import 'package:projects/my_app.dart';
import 'package:projects/screens/authentication/login_screen.dart';
import 'package:projects/utils/email_validation.dart';
import 'package:projects/utils/snackBar.dart';
import 'package:projects/utils/text_field.dart';
import 'package:projects/utils/text_styles.dart';
import 'package:projects/utils/toast.dart';

class Registration extends StatefulWidget {
  const Registration({super.key});

  @override
  State<Registration> createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _rePasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  late final AuthenicationCubit _registrationCubit;

  final ValueNotifier<bool> _obscurePassword = ValueNotifier(true);
  final ValueNotifier<bool> _obscureConfirmPassword = ValueNotifier(true);

  @override
  void initState() {
    super.initState();
    _registrationCubit = AuthenicationCubit();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _rePasswordController.dispose();
    _obscurePassword.dispose();
    _obscureConfirmPassword.dispose();
    _registrationCubit.close();
    super.dispose();
  }

  void _register() {
    if (!_formKey.currentState!.validate()) return;

    if (!isValidEmail(_emailController.text.trim())) {
      showSnackBar(context, "Enter valid email");
      return;
    }
    if (_passwordController.text.trim() != _rePasswordController.text.trim()) {
      showSnackBar(context, "Passwords do not match");
      return;
    }

    _registrationCubit.registerUser(
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
                    "Sign Up",
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onBackground,
                    ),
                  ),

                  SizedBox(height: 12),

                  _buildLabel("Email"),
                  const SizedBox(height: 8),

                  CustomTextField(
                    prefixIcon: Icons.email,
                    hintText: "Enter your email",
                    controller: _emailController,
                    isNumber: false,
                  ),
                  SizedBox(height: 12),

                  _buildLabel("Password"),
                  const SizedBox(height: 8),
                  ValueListenableBuilder(
                    valueListenable: _obscurePassword,
                    builder: (context, v, _) {
                      return Stack(
                        children: [
                          CustomTextField(
                            obscureText: v,
                            prefixIcon: Icons.lock,
                            hintText: "Enter your password",

                            controller: _passwordController,
                            isNumber: false,
                          ),

                          Positioned(
                            right: 3,
                            child: IconButton(
                              onPressed:
                                  () =>
                                      _obscurePassword.value =
                                          !_obscurePassword.value,
                              icon: Icon(
                                v ? Icons.visibility_off : Icons.visibility,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),

                  SizedBox(height: 12),

                  _buildLabel("Confirm Password"),
                  const SizedBox(height: 8),
                  ValueListenableBuilder(
                    valueListenable: _obscureConfirmPassword,
                    builder: (context, v, _) {
                      return Stack(
                        children: [
                          CustomTextField(
                            obscureText: v,
                            prefixIcon: Icons.lock,
                            hintText: "Re enter your password",

                            controller: _rePasswordController,
                            isNumber: false,
                          ),

                          Positioned(
                            right: 3,
                            child: IconButton(
                              onPressed:
                                  () =>
                                      _obscureConfirmPassword.value =
                                          !_obscureConfirmPassword.value,
                              icon: Icon(
                                v ? Icons.visibility_off : Icons.visibility,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),

                  // ValueListenableBuilder<bool>(
                  //   valueListenable: _obscureConfirmPassword,
                  //   builder: (context, obscure, _) {
                  //     return Stack(
                  //       alignment: Alignment.centerRight,
                  //       children: [
                  //         CustomTextField(
                  //           obscureText: obscure,
                  //           prefixIcon: Icons.lock,
                  //           hintText: "Enter your password",

                  //           controller: _rePasswordController,
                  //           isNumber: false,
                  //         ),
                  //         Positioned(
                  //           right: 3,
                  //           child: IconButton(
                  //             onPressed:
                  //                 () =>
                  //                     _obscureConfirmPassword.value =
                  //                         !_obscureConfirmPassword.value,
                  //             icon: Icon(
                  //               obscure
                  //                   ? Icons.visibility_off
                  //                   : Icons.visibility,
                  //             ),
                  //           ),
                  //         ),
                  //       ],
                  //     );
                  //   },
                  // ),
                  SizedBox(height: size.height * 0.05),

                  BlocConsumer<AuthenicationCubit, AuthenicationState>(
                    bloc: _registrationCubit,
                    listener: (context, state) {
                      if (state is AuthSuccess) {
                        showToast(state.note, true);
                        navigatorKey.currentState?.pushAndRemoveUntil(
                          MaterialPageRoute(
                            builder: (_) => const LoginScreen(),
                          ),
                          (route) => false,
                        );
                      }
                      if (state is AuthFailed) {
                        showSnackBar(context, state.error);
                      }
                    },
                    builder: (context, state) {
                      return SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: state is AuthLoading ? null : _register,
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
                                    "Register",
                                    style: TextStyle(fontSize: 16),
                                  ),
                        ),
                      );
                    },
                  ),

                  SizedBox(height: size.height * 0.15),
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
