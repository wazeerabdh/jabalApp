import 'package:dio/dio.dart';
import 'package:souqexpress/common/reposotories/language_repo.dart';
import 'package:souqexpress/deleviry/commons/providers/localization_provider.dart';
import 'package:souqexpress/deleviry/commons/providers/location_provider.dart';
import 'package:souqexpress/deleviry/commons/providers/theme_provider.dart';
import 'package:souqexpress/deleviry/data/datasource/remote/dio/dio_client.dart';
import 'package:souqexpress/deleviry/data/datasource/remote/dio/logging_interceptor.dart';
import 'package:souqexpress/deleviry/features/auth/domain/reposotories/auth_repo.dart';
import 'package:souqexpress/deleviry/features/auth/providers/auth_provider.dart';
import 'package:souqexpress/deleviry/features/chat/domain/reposotories/chat_repo.dart';
import 'package:souqexpress/deleviry/features/chat/providers/chat_provider.dart';
import 'package:souqexpress/deleviry/features/order/domain/reposotories/order_repo.dart';
import 'package:souqexpress/deleviry/features/order/domain/reposotories/tracker_repo.dart';
import 'package:souqexpress/deleviry/features/order/providers/order_provider.dart';
import 'package:souqexpress/deleviry/features/order/providers/tracker_provider.dart';
import 'package:souqexpress/deleviry/features/profile/domain/reposotories/profile_repo.dart';
import 'package:souqexpress/deleviry/features/profile/providers/profile_provider.dart';
import 'package:souqexpress/features/address/domain/reposotories/location_repo.dart';
import 'package:souqexpress/features/address/providers/location_provider.dart';
import 'package:souqexpress/features/auth/domain/reposotories/auth_repo.dart';
import 'package:souqexpress/features/auth/providers/registration_provider.dart';
import 'package:souqexpress/features/auth/providers/verification_provider.dart';
import 'package:souqexpress/features/checkout/providers/checkout_provider.dart';
import 'package:souqexpress/features/home/domain/reposotories/banner_repo.dart';
import 'package:souqexpress/features/cart/domain/reposotories/cart_repo.dart';
import 'package:souqexpress/features/category/domain/reposotories/category_repo.dart';
import 'package:souqexpress/features/chat/domain/reposotories/chat_repo.dart';
import 'package:souqexpress/features/coupon/domain/reposotories/coupon_repo.dart';
import 'package:souqexpress/common/reposotories/news_letter_repo.dart';
import 'package:souqexpress/features/notification/domain/reposotories/notification_repo.dart';
import 'package:souqexpress/features/order/domain/reposotories/order_repo.dart';
import 'package:souqexpress/common/reposotories/product_repo.dart';
import 'package:souqexpress/features/onboarding/domain/reposotories/onboarding_repo.dart';
import 'package:souqexpress/features/rate_review/providers/rate_review_provider.dart';
import 'package:souqexpress/features/search/domain/reposotories/search_repo.dart';
import 'package:souqexpress/features/profile/domain/reposotories/profile_repo.dart';
import 'package:souqexpress/features/splash/domain/reposotories/splash_repo.dart';
import 'package:souqexpress/features/track/providers/order_map_provider.dart';
import 'package:souqexpress/features/wishlist/domain/reposotories/wishlist_repo.dart';
import 'package:souqexpress/features/auth/providers/auth_provider.dart';
import 'package:souqexpress/features/home/providers/banner_provider.dart';
import 'package:souqexpress/features/cart/providers/cart_provider.dart';
import 'package:souqexpress/features/category/providers/category_provider.dart';
import 'package:souqexpress/features/chat/providers/chat_provider.dart';
import 'package:souqexpress/features/coupon/providers/coupon_provider.dart';
import 'package:souqexpress/features/flash_sale/providers/flash_sale_provider.dart';
import 'package:souqexpress/provider/localization_provider.dart';
import 'package:souqexpress/provider/news_provider.dart';
import 'package:souqexpress/features/notification/providers/notification_provider.dart';
import 'package:souqexpress/features/order/providers/order_provider.dart';
import 'package:souqexpress/features/address/providers/address_provider.dart';
import 'package:souqexpress/features/product/providers/product_provider.dart';
import 'package:souqexpress/provider/language_provider.dart';
import 'package:souqexpress/features/onboarding/providers/onboarding_provider.dart';
import 'package:souqexpress/features/search/providers/search_provider.dart';
import 'package:souqexpress/features/profile/providers/profile_provider.dart';
import 'package:souqexpress/features/splash/providers/splash_provider.dart';
import 'package:souqexpress/provider/theme_provider.dart';
import 'package:souqexpress/features/wishlist/providers/wishlist_provider.dart';
import 'package:souqexpress/utill/app_constants.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'data/datasource/remote/dio/dio_client.dart';
import 'data/datasource/remote/dio/logging_interceptor.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Core
  sl.registerLazySingleton(() => DioClient(AppConstants.baseUrl, sl(), loggingInterceptor: sl(), sharedPreferences: sl()));
  // Repository
  sl.registerLazySingleton(() => SplashRepo(sharedPreferences: sl(), dioClient: sl()));
  sl.registerLazySingleton(() => CategoryRepo(dioClient: sl()));
  sl.registerLazySingleton(() => BannerRepo(dioClient: sl()));
  sl.registerLazySingleton(() => ProductRepo(dioClient: sl()));
  // sl.registerLazySingleton(() => LanguageRepo());
  sl.registerLazySingleton(() => OnBoardingRepo(dioClient: sl()));
  sl.registerLazySingleton(() => CartRepo(sharedPreferences: sl()));
  sl.registerLazySingleton(() => OrderRepo(dioClient: sl(), sharedPreferences: sl()));
  sl.registerLazySingleton(() => ChatRepo(dioClient: sl(), sharedPreferences: sl()));
  //sl.registerLazySingleton(() => AuthRepo(dioClient: sl(), sharedPreferences: sl()));
  sl.registerLazySingleton(() => AuthRepo_D(dioClient: sl(), sharedPreferences: sl()));
  sl.registerLazySingleton(() => LocationRepo(dioClient: sl(), sharedPreferences: sl()));
  sl.registerLazySingleton(() => ProfileRepo(dioClient: sl(), sharedPreferences: sl()));
  sl.registerLazySingleton(() => SearchRepo(dioClient: sl(), sharedPreferences: sl()));
  sl.registerLazySingleton(() => NotificationRepo(dioClient: sl()));
  sl.registerLazySingleton(() => CouponRepo(dioClient: sl()));
  sl.registerLazySingleton(() => WishListRepo(dioClient: sl()));
  sl.registerLazySingleton(() => NewsLetterRepo(dioClient: sl()));
  sl.registerLazySingleton(() => DioClient_D(AppConstants.baseUrl, sl(), loggingInterceptor: sl(), sharedPreferences: sl()));
  // Repository
  sl.registerLazySingleton(() => LanguageRepo());
  sl.registerLazySingleton(() => AuthRepo(dioClient: sl(), sharedPreferences: sl()));
  sl.registerLazySingleton(() => ProfileRepo_D(dioClient: sl(), sharedPreferences: sl()));
  sl.registerLazySingleton(() => OrderRepo_D(dioClient: sl(), sharedPreferences: sl()));
  sl.registerLazySingleton(() => TrackerRepo_D(dioClient: sl(), sharedPreferences: sl()));
  sl.registerLazySingleton(() => ChatRepo_D(dioClient: sl(), sharedPreferences: sl()));

  // Provider
  sl.registerFactory(() => ThemeProvider_D(sharedPreferences: sl()));

  sl.registerFactory(() => LocalizationProvider_D(sharedPreferences: sl()));
  // sl.registerFactory(() => LanguageProvider(languageRepo: sl()));
  sl.registerFactory(() => AuthProvider_D(authRepo: sl()));
  sl.registerFactory(() => ProfileProvider_D(profileRepo1: sl()));
  sl.registerFactory(() => OrderProvider_D(orderRepo: sl()));
  sl.registerFactory(() => LocationProvider_D(sharedPreferences: sl()));
  sl.registerFactory(() => TrackerProvider_D(trackerRepo: sl()));
  sl.registerFactory(() => ChatProvider_D(chatRepo: sl()));

  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  // sl.registerLazySingleton(() => Dio());
  sl.registerLazySingleton(() => LoggingInterceptor_D());
  // Provider
  sl.registerFactory(() => ThemeProvider(sharedPreferences: sl()));
  sl.registerFactory(() => SplashProvider(splashRepo: sl(),sharedPreferences: sl()));
  sl.registerFactory(() => LocalizationProvider(sharedPreferences: sl(), dioClient: sl()));
  sl.registerFactory(() => LanguageProvider(languageRepo: sl()));
  sl.registerFactory(() => OnBoardingProvider(onboardingRepo: sl(), sharedPreferences: sl()));
  sl.registerFactory(() => CategoryProvider(categoryRepo: sl()));
  sl.registerFactory(() => BannerProvider(bannerRepo: sl()));
  sl.registerFactory(() => ProductProvider(productRepo: sl()));
  sl.registerFactory(() => CartProvider(cartRepo: sl()));
  sl.registerFactory(() => OrderProvider(orderRepo: sl()));
  sl.registerFactory(() => OrderMapProvider());
  sl.registerFactory(() => CheckoutProvider(orderRepo: sl()));
  sl.registerFactory(() => ChatProvider(chatRepo: sl(), notificationRepo: sl()));
  sl.registerFactory(() => AuthProvider(authRepo: sl()));
  sl.registerFactory(() => RegistrationProvider(authRepo: sl()));
  sl.registerFactory(() => VerificationProvider(authRepo: sl()));
  sl.registerFactory(() => AddressProvider(sharedPreferences: sl(), locationRepo: sl()));
  sl.registerFactory(() => LocationProvider(sharedPreferences: sl(), locationRepo: sl()));
  // sl.registerFactory(() => const DeliveryManRegistrationScreen_D());
  sl.registerFactory(() => ProfileProvider(profileRepo: sl()));
  sl.registerFactory(() => NotificationProvider(notificationRepo: sl()));
  sl.registerFactory(() => WishListProvider(wishListRepo: sl()));
  sl.registerFactory(() => CouponProvider(couponRepo: sl()));
  sl.registerFactory(() => SearchProvider(searchRepo: sl()));
  sl.registerFactory(() => NewsLetterProvider(newsLetterRepo: sl()));
  sl.registerFactory(() => FlashSaleProvider(productRepo: sl()));
  sl.registerFactory(() => RateReviewProvider(productRepo: sl()));
  // External
  // sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => Dio());
  sl.registerLazySingleton(() => LoggingInterceptor());
}
