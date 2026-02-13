import 'package:auto_route/auto_route.dart';
import 'package:books_discovery_app/feature/auth/presentation/bloc/auth_bloc.dart';
import 'package:books_discovery_app/feature/auth/presentation/bloc/auth_event.dart';
import 'package:books_discovery_app/feature/auth/presentation/bloc/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/router/routes.gr.dart';
import '../../shared/widgets/email_field.dart';
import '../../shared/widgets/forgot_button.dart';
import '../../shared/widgets/login_button.dart';
import '../../shared/widgets/password_field.dart';
import '../../shared/widgets/sign_up_button.dart';
import '../../shared/widgets/sign_with_google_button.dart';
import '../bloc/login_bloc.dart';
import '../bloc/login_event.dart';
import '../bloc/login_state.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
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
      child: BlocListener<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state is LoginSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Welcome ${state.user.name}!'),
                backgroundColor: Colors.green,
              ),
            );
          } else if (state is LoginFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error), backgroundColor: Colors.red),
            );
          }
        },
        child: BlocBuilder<LoginBloc, LoginState>(
          builder: (context, state) {
            return Form(
              key: _formKey,
              child: Column(
                children: [
                  EmailTextField(controller: _emailController),
                  const SizedBox(height: 16),
                  PasswordTextField(controller: _passwordController),
                  const SizedBox(height: 24),
                  LoginButton(
                    isLoading: state is LoginLoading,
                    onPressed: state is LoginLoading
                        ? () {}
                        : () {
                            if (_formKey.currentState!.validate()) {
                              context.read<LoginBloc>().add(
                                LoginSubmitted(
                                  email: _emailController.text.trim(),
                                  password: _passwordController.text,
                                ),
                              );
                            }
                          },
                  ),
                  const SizedBox(height: 16),
                  ForgotButton(onPressed: () {}),
                  const SizedBox(height: 16),
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
                  const Divider(height: 32),
                  SignUpButton(
                    onPressed: () {
                      context.router.push(SignupScreenRoute());
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
