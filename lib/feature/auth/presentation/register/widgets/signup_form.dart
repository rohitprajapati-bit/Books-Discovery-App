import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/auth_bloc.dart';
import '../../bloc/auth_event.dart';
import '../../bloc/auth_state.dart';
import '../../shared/widgets/sign_with_google_button.dart';
import 'confirm_password_field.dart';
import '../../shared/widgets/email_field.dart';
import '../../shared/widgets/password_field.dart';
import 'name_field.dart';
import 'sign_in_link_button.dart';
import '../../shared/widgets/login_button.dart';
import '../bloc/register_bloc.dart';
import '../bloc/register_event.dart';
import '../bloc/register_state.dart';

class SignupForm extends StatefulWidget {
  const SignupForm({super.key});

  @override
  State<SignupForm> createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<AuthBloc, AuthState>(
          listener: (context, authState) {
            if (authState is AuthFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(authState.error),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
        ),
        BlocListener<RegisterBloc, RegisterState>(
          listener: (context, state) {
            if (state is RegisterSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Welcome ${state.user.name}! Account created successfully.',
                  ),
                  backgroundColor: Colors.green,
                ),
              );
              Navigator.pop(context);
            } else if (state is RegisterFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.error),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
        ),
      ],
      child: BlocBuilder<RegisterBloc, RegisterState>(
        builder: (context, state) {
          final isLoading = state is RegisterLoading;
          return Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: Column(
                children: [
                  NameTextField(controller: _nameController),
                  const SizedBox(height: 16),
                  EmailTextField(controller: _emailController),
                  const SizedBox(height: 16),
                  PasswordTextField(
                    controller: _passwordController,
                    isRegistration: true,
                  ),
                  const SizedBox(height: 16),
                  ConfirmPasswordTextField(
                    controller: _confirmPasswordController,
                    passwordController: _passwordController,
                  ),
                  const SizedBox(height: 15),
                  LoginButton(
                    title: "Sign Up",
                    isLoading: isLoading,
                    onPressed: isLoading
                        ? () {}
                        : () {
                            if (_formKey.currentState!.validate()) {
                              context.read<RegisterBloc>().add(
                                RegisterSubmitted(
                                  name: _nameController.text.trim(),
                                  email: _emailController.text.trim(),
                                  password: _passwordController.text,
                                  confirmPassword:
                                      _confirmPasswordController.text,
                                ),
                              );
                            }
                          },
                  ),
                  SignInLinkButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, authState) {
                      return SignWithGoogleButton(
                        isLoading: authState is AuthLoading,
                        onPressed: authState is AuthLoading
                            ? () {}
                            : () {
                                context.read<AuthBloc>().add(
                                  const AuthGoogleSignInRequested(),
                                );
                              },
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
