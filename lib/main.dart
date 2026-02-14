import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/bloc/app_bloc_observer.dart';

import 'core/di/injection_container.dart';
import 'core/router/routes.dart';
import 'core/router/routes.gr.dart';
import 'feature/analytics/presentation/bloc/analytics_event.dart';
import 'firebase_options.dart';
import 'feature/auth/presentation/bloc/auth_bloc.dart';
import 'feature/auth/presentation/login/bloc/login_bloc.dart';
import 'feature/auth/presentation/register/bloc/register_bloc.dart';
import 'feature/home/presentation/bloc/home_bloc.dart';
import 'feature/home/presentation/bloc/book_details_bloc.dart';
import 'feature/analytics/presentation/bloc/analytics_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Initialize all dependencies using GetIt
  await initializeDependencies();

  Bloc.observer = AppBlocObserver();

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
        // Global Home BLoC - Factory from GetIt
        BlocProvider<HomeBloc>(create: (context) => sl<HomeBloc>()),
        BlocProvider<BookDetailsBloc>(
          create: (context) => sl<BookDetailsBloc>(),
        ),
        BlocProvider<AnalyticsBloc>(create: (context) => sl<AnalyticsBloc>()),
      ],
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is Authenticated) {
            // Re-load history for the authenticated user
            context.read<HomeBloc>().add(LoadSearchHistoryEvent(state.user.id));
            context.read<AnalyticsBloc>().add(
              LoadAnalyticsEvent(state.user.id),
            );
            _appRouter.replaceAll([const MainNavigationShellRoute()]);
          } else if (state is Unauthenticated) {
            // Clear UI states
            context.read<HomeBloc>().add(ResetHomeEvent());
            context.read<AnalyticsBloc>().add(ResetAnalyticsEvent());
            _appRouter.replaceAll([const LoginRoute()]);
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
