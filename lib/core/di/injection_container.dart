import 'package:get_it/get_it.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../feature/auth/data/datasources/auth_local_datasource.dart';
import '../../feature/auth/data/datasources/auth_remote_datasource.dart';
import '../../feature/auth/data/repositories/auth_repository_impl.dart';
import '../../feature/auth/domain/repositories/auth_repository.dart';
import '../../feature/auth/domain/usecases/get_current_user_usecase.dart';
import '../../feature/auth/domain/usecases/google_signin_usecase.dart';
import '../../feature/auth/domain/usecases/login_usecase.dart';
import '../../feature/auth/domain/usecases/logout_usecase.dart';
import '../../feature/auth/domain/usecases/register_usecase.dart';
import '../../feature/auth/presentation/bloc/auth_bloc.dart';
import '../../feature/auth/presentation/login/bloc/login_bloc.dart';
import '../../feature/auth/presentation/register/bloc/register_bloc.dart';
import '../../feature/home/data/datasources/book_local_datasource.dart';
import '../../feature/home/data/datasources/book_remote_datasource.dart';
import '../../feature/home/data/repositories/book_repository_impl.dart';
import '../../feature/home/domain/repositories/book_repository.dart';
import '../../feature/home/domain/usecases/clear_search_history_usecase.dart';
import '../../feature/home/domain/usecases/get_search_history_usecase.dart';
import '../../feature/home/domain/usecases/save_search_history_usecase.dart';
import '../../feature/home/domain/usecases/search_books_usecase.dart';
import '../../feature/home/domain/usecases/search_books_by_isbn_usecase.dart';
import '../../feature/home/presentation/bloc/home_bloc.dart';
import '../network/dio_client.dart';

final sl = GetIt.instance; // sl = Service Locator

/// Initialize all dependencies
Future<void> initializeDependencies() async {
  // ============================================================================
  // External Dependencies (Third-party packages)
  // ============================================================================

  // Firebase Auth
  sl.registerLazySingleton<firebase_auth.FirebaseAuth>(
    () => firebase_auth.FirebaseAuth.instance,
  );

  // Firestore
  sl.registerLazySingleton<FirebaseFirestore>(() => FirebaseFirestore.instance);

  // Google Sign-In
  sl.registerLazySingleton<GoogleSignIn>(() => GoogleSignIn());

  // SharedPreferences
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);

  // Dio Client
  sl.registerLazySingleton<DioClient>(() => DioClient());

  // ============================================================================
  // Data Sources
  // ============================================================================

  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(
      firebaseAuth: sl(),
      googleSignIn: sl(),
      firestore: sl(),
    ),
  );

  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(sharedPreferences: sl()),
  );

  sl.registerLazySingleton<BookRemoteDataSource>(
    () => BookRemoteDataSourceImpl(dioClient: sl()),
  );

  sl.registerLazySingleton<BookLocalDataSource>(
    () => BookLocalDataSourceImpl(sharedPreferences: sl()),
  );

  // ============================================================================
  // Repositories
  // ============================================================================

  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: sl(), localDataSource: sl()),
  );

  sl.registerLazySingleton<BookRepository>(
    () => BookRepositoryImpl(remoteDataSource: sl(), localDataSource: sl()),
  );

  // ============================================================================
  // Use Cases
  // ============================================================================

  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => RegisterUseCase(sl()));
  sl.registerLazySingleton(() => GoogleSignInUseCase(sl()));
  sl.registerLazySingleton(() => LogoutUseCase(sl()));
  sl.registerLazySingleton(() => GetCurrentUserUseCase(sl()));

  sl.registerLazySingleton(() => SearchBooksUseCase(repository: sl()));
  sl.registerLazySingleton(() => SearchBooksByISBNUseCase(sl()));
  sl.registerLazySingleton(() => GetSearchHistoryUseCase(repository: sl()));
  sl.registerLazySingleton(() => SaveSearchHistoryUseCase(repository: sl()));
  sl.registerLazySingleton(() => ClearSearchHistoryUseCase(repository: sl()));

  // ============================================================================
  // BLoCs (Factory - new instance every time)
  // ============================================================================

  // Global Auth BLoC - Singleton (one instance for entire app)
  sl.registerLazySingleton<AuthBloc>(
    () => AuthBloc(
      getCurrentUserUseCase: sl(),
      logoutUseCase: sl(),
      googleSignInUseCase: sl(),
    ),
  );

  // Login BLoC - Factory (new instance every time, needs AuthBloc)
  sl.registerFactory<LoginBloc>(
    () => LoginBloc(loginUseCase: sl(), authBloc: sl()),
  );

  // Register BLoC - Factory (new instance every time, needs AuthBloc)
  sl.registerFactory<RegisterBloc>(
    () => RegisterBloc(registerUseCase: sl(), authBloc: sl()),
  );

  // Home BLoC
  sl.registerFactory<HomeBloc>(
    () => HomeBloc(
      searchBooksUseCase: sl(),
      searchBooksByISBNUseCase: sl(),
      getSearchHistoryUseCase: sl(),
      saveSearchHistoryUseCase: sl(),
      clearSearchHistoryUseCase: sl(),
    ),
  );
}
