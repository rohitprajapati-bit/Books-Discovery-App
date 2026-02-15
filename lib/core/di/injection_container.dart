import 'package:get_it/get_it.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../feature/profile/presentation/bloc/profile_bloc.dart';
import '../../feature/profile/data/datasources/profile_remote_datasource.dart';
import '../../feature/profile/data/repositories/profile_repository_impl.dart';
import '../../feature/profile/domain/repositories/profile_repository.dart';
import '../../feature/profile/domain/usecases/update_profile_picture_usecase.dart';
import '../../feature/profile/domain/usecases/update_profile_name_usecase.dart';

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
import '../../feature/home/domain/usecases/extract_text_usecase.dart';
import '../../feature/book_details/domain/usecases/get_books_by_author_usecase.dart';
import '../../feature/book_details/domain/usecases/generate_ai_summary_usecase.dart';
import '../../feature/book_details/domain/usecases/get_ai_recommendations_usecase.dart';
import '../../feature/home/domain/services/ocr_service.dart';
import '../../feature/book_details/domain/services/ai_service.dart';
import '../../feature/home/data/services/ocr_service.dart';
import '../../feature/book_details/data/services/gemini_service_impl.dart';
import '../../feature/home/presentation/bloc/home_bloc.dart';
import '../../feature/book_details/presentation/bloc/book_details_bloc.dart';
import '../../feature/analytics/presentation/bloc/analytics_bloc.dart';
import '../../feature/analytics/domain/usecases/get_cached_books_usecase.dart';
import '../../feature/analytics/data/services/trending_socket_service.dart';
import '../../feature/contacts/domain/repositories/contacts_repository.dart';
import '../../feature/contacts/data/repositories/contacts_repository_impl.dart';
import '../../feature/contacts/domain/usecases/get_contacts_usecase.dart';
import '../../feature/contacts/presentation/bloc/contacts_bloc.dart';
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

  // Firebase Storage
  sl.registerLazySingleton<FirebaseStorage>(() => FirebaseStorage.instance);

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
      storage: sl(),
    ),
  );

  sl.registerLazySingleton<ProfileRemoteDataSource>(
    () => ProfileRemoteDataSourceImpl(
      firebaseAuth: sl(),
      firestore: sl(),
      storage: sl(),
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

  sl.registerLazySingleton<OCRService>(() => OCRServiceImpl());

  sl.registerLazySingleton<AIService>(
    () => GeminiServiceImpl(apiKey: 'AIzaSyC7Fj6Oc2bRVTlWF7iRi9_aImiTzTALFnI'),
  );

  sl.registerLazySingleton<TrendingSocketService>(
    () => TrendingSocketServiceImpl(),
  );

  // ============================================================================
  // Repositories
  // ============================================================================

  sl.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(remoteDataSource: sl()),
  );

  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: sl(), localDataSource: sl()),
  );

  sl.registerLazySingleton<BookRepository>(
    () => BookRepositoryImpl(remoteDataSource: sl(), localDataSource: sl()),
  );

  sl.registerLazySingleton<ContactsRepository>(() => ContactsRepositoryImpl());

  // ============================================================================
  // Use Cases
  // ============================================================================

  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => RegisterUseCase(sl()));
  sl.registerLazySingleton(() => GoogleSignInUseCase(sl()));
  sl.registerLazySingleton(() => LogoutUseCase(sl()));
  sl.registerLazySingleton(() => GetCurrentUserUseCase(sl()));

  sl.registerLazySingleton(() => UpdateProfilePictureUseCase(sl()));
  sl.registerLazySingleton(() => UpdateProfileNameUseCase(sl()));

  sl.registerLazySingleton(() => SearchBooksUseCase(repository: sl()));
  sl.registerLazySingleton(() => SearchBooksByISBNUseCase(sl()));
  sl.registerLazySingleton(() => GetSearchHistoryUseCase(repository: sl()));
  sl.registerLazySingleton(() => SaveSearchHistoryUseCase(repository: sl()));
  sl.registerLazySingleton(() => ClearSearchHistoryUseCase(repository: sl()));
  sl.registerLazySingleton(() => ExtractTextUseCase(sl()));
  sl.registerLazySingleton(() => GetBooksByAuthorUseCase(sl()));
  sl.registerLazySingleton(() => GenerateAISummaryUseCase(sl()));
  sl.registerLazySingleton(() => GetAIRecommendationsUseCase(sl()));
  sl.registerLazySingleton(() => GetCachedBooksUseCase(sl()));
  sl.registerLazySingleton(() => GetContactsUseCase(sl()));

  // ============================================================================
  // BLoCs (Factory - new instance every time)
  // ============================================================================

  // Global Auth BLoC - Singleton (one instance for entire app)
  sl.registerLazySingleton<AuthBloc>(
    () => AuthBloc(
      getCurrentUserUseCase: sl(),
      logoutUseCase: sl(),
      googleSignInUseCase: sl(),
      clearSearchHistoryUseCase: sl(),
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
      extractTextUseCase: sl(),
    ),
  );

  sl.registerFactory<BookDetailsBloc>(
    () => BookDetailsBloc(
      getBooksByAuthorUseCase: sl(),
      generateAISummaryUseCase: sl(),
      getAIRecommendationsUseCase: sl(),
    ),
  );

  sl.registerFactory<AnalyticsBloc>(
    () => AnalyticsBloc(
      getCachedBooksUseCase: sl(),
      trendingSocketService: sl(),
      getSearchHistoryUseCase: sl(),
    ),
  );

  sl.registerFactory<ContactsBloc>(
    () => ContactsBloc(getContactsUseCase: sl()),
  );

  sl.registerFactory<ProfileBloc>(
    () => ProfileBloc(
      updateProfilePictureUseCase: sl(),
      updateProfileNameUseCase: sl(),
    ),
  );
}
