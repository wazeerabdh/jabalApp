import 'package:dio/dio.dart';

import 'package:get_it/get_it.dart';
import 'package:hexacom_user/common/reposotories/language_repo.dart';
import 'package:hexacom_user/deleviry/commons/providers/localization_provider.dart';
import 'package:hexacom_user/deleviry/commons/providers/location_provider.dart';
import 'package:hexacom_user/deleviry/commons/providers/theme_provider.dart';
import 'package:hexacom_user/deleviry/features/auth/providers/auth_provider.dart';
import 'package:hexacom_user/deleviry/features/chat/domain/reposotories/chat_repo.dart';
import 'package:hexacom_user/deleviry/features/order/domain/reposotories/order_repo.dart';
import 'package:hexacom_user/deleviry/features/order/domain/reposotories/tracker_repo.dart';
import 'package:hexacom_user/deleviry/features/order/providers/order_provider.dart';
import 'package:hexacom_user/deleviry/features/order/providers/tracker_provider.dart';
import 'package:hexacom_user/deleviry/features/profile/domain/reposotories/profile_repo.dart';
import 'package:hexacom_user/deleviry/features/profile/providers/profile_provider.dart';
import 'package:hexacom_user/features/auth/domain/reposotories/auth_repo.dart';
import 'package:hexacom_user/features/splash/domain/reposotories/splash_repo.dart';
import 'package:hexacom_user/provider/language_provider.dart';
import 'package:hexacom_user/utill/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'data/datasource/remote/dio/dio_client.dart';
import 'data/datasource/remote/dio/logging_interceptor.dart';
import 'features/chat/providers/chat_provider.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Core
  sl.registerLazySingleton(() => DioClient_D(AppConstants.baseUrl, sl(), loggingInterceptor: sl(), sharedPreferences: sl()));

  // Repository
  sl.registerLazySingleton(() => SplashRepo(sharedPreferences: sl(), dioClient: sl()));
  sl.registerLazySingleton(() => LanguageRepo());
  sl.registerLazySingleton(() => AuthRepo(dioClient: sl(), sharedPreferences: sl()));
  sl.registerLazySingleton(() => ProfileRepo_D(dioClient: sl(), sharedPreferences: sl()));
  sl.registerLazySingleton(() => OrderRepo_D(dioClient: sl(), sharedPreferences: sl()));
  sl.registerLazySingleton(() => TrackerRepo_D(dioClient: sl(), sharedPreferences: sl()));
  sl.registerLazySingleton(() => ChatRepo_D(dioClient: sl(), sharedPreferences: sl()));

  // Provider
  sl.registerFactory(() => ThemeProvider_D(sharedPreferences: sl()));

  sl.registerFactory(() => LocalizationProvider_D(sharedPreferences: sl()));
  sl.registerFactory(() => LanguageProvider(languageRepo: sl()));
  sl.registerFactory(() => AuthProvider_D(authRepo: sl()));
  sl.registerFactory(() => ProfileProvider_D(profileRepo: sl()));
  sl.registerFactory(() => OrderProvider_D(orderRepo: sl()));
  sl.registerFactory(() => LocationProvider_D(sharedPreferences: sl()));
  sl.registerFactory(() => TrackerProvider_D(trackerRepo: sl()));
  sl.registerFactory(() => ChatProvider_D(chatRepo: sl()));

  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => Dio());
  sl.registerLazySingleton(() => LoggingInterceptor_D());
}
