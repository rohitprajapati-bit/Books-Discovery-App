import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_route/auto_route.dart';

import 'core/di/injection_container.dart';
import 'core/router/routes.dart';
import 'core/router/routes.gr.dart';
import 'firebase_options.dart';
import 'feature/auth/presentation/bloc/auth_bloc.dart';
import 'feature/auth/presentation/bloc/auth_event.dart';
import 'feature/auth/presentation/bloc/auth_state.dart';
import 'feature/auth/presentation/login/bloc/login_bloc.dart';
import 'feature/auth/presentation/register/bloc/register_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Initialize all dependencies using GetIt
  await initializeDependencies();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final _appRouter = AppRouter();

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // Global Auth BLoC - Singleton from GetIt
        BlocProvider<AuthBloc>(
          create: (context) => sl<AuthBloc>()..add(AuthCheckRequested()),
        ),
        // Login BLoC - Factory from GetIt
        BlocProvider<LoginBloc>(create: (context) => sl<LoginBloc>()),
        // Register BLoC - Factory from GetIt
        BlocProvider<RegisterBloc>(create: (context) => sl<RegisterBloc>()),
      ],
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          print('Auth state changed: ${state.runtimeType}'); // Debug log
          if (state is Authenticated) {
            print('Navigating to HomeScreen'); // Debug log
            _appRouter.replaceAll([const HomeScreenRoute()]);
          } else if (state is Unauthenticated) {
            print('Navigating to LoginScreen'); // Debug log
            _appRouter.replaceAll([const LoginScreenRoute()]);
          }
        },
        child: MaterialApp.router(
          routerConfig: _appRouter.config(),
          debugShowCheckedModeBanner: false,
          title: 'Books Discovery',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
        ),
      ),
    );
  }
}
