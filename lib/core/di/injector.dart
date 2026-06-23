import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_kishan/app/router/app_router.dart';
import 'package:smart_kishan/app/theme/theme_cubit.dart';
import 'package:smart_kishan/core/config/env.dart';
import 'package:smart_kishan/core/network/api_client.dart';
import 'package:smart_kishan/core/services/geocoding_service.dart';
import 'package:smart_kishan/core/services/local_storage_service.dart';
import 'package:smart_kishan/core/services/location_service.dart';
import 'package:smart_kishan/core/services/notification_service.dart';
import 'package:smart_kishan/core/services/routing_service.dart';
import 'package:smart_kishan/features/auth/data/auth_repository.dart';
import 'package:smart_kishan/features/auth/cubit/session_cubit.dart';
import 'package:smart_kishan/features/farmer/crop_info/data/crop_info_repository.dart';
import 'package:smart_kishan/features/farmer/daily_activity/data/activity_repository.dart';
import 'package:smart_kishan/features/farmer/farmland/data/farmland_repository.dart';
import 'package:smart_kishan/features/farmer/govt_services/service_centers/data/service_center_repository.dart';
import 'package:smart_kishan/features/farmer/govt_services/subsidies/data/subsidy_repository.dart';
import 'package:smart_kishan/features/farmer/inventory/data/inventory_item_repository.dart';
import 'package:smart_kishan/features/farmer/market_price/data/market_price_repository.dart';
import 'package:smart_kishan/features/farmer/notes/data/note_repository.dart';
import 'package:smart_kishan/features/farmer/weather/data/weather_repository.dart';
import 'package:smart_kishan/features/language/cubit/locale_cubit.dart';
import 'package:smart_kishan/features/profile/data/location_repository.dart';
import 'package:smart_kishan/shared/data/unit_repository.dart';

/// Global service locator. Registration happens here and ONLY here —
/// no scattered Get.put calls.
final sl = GetIt.instance;

Future<void> initDependencies() async {
  // ── Core ──────────────────────────────────────────────────────
  sl.registerSingleton<LocalStorageService>(await LocalStorageService.init());

  sl.registerLazySingleton<NotificationService>(NotificationService.new);

  sl.registerLazySingleton<LocationService>(() => LocationService());

  sl.registerLazySingleton<GeocodingService>(() => GeocodingService());

  sl.registerLazySingleton<ApiClient>(
    () => ApiClient(
      baseUrl: Env.apiBaseUrl,
      storage: sl(),
      // Lazy closure → no circular dependency with SessionCubit.
      // ONE session-expiry path for the whole app.
      onUnauthorized: () => sl<SessionCubit>().expire(),
    ),
  );

  // ── Repositories ──────────────────────────────────────────────
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepository(api: sl(), storage: sl(), notifications: sl()),
  );
  // sl.registerLazySingleton<ProfileRepository>(
  //   () => ProfileRepository(api: sl(), storage: sl()),
  // );
  sl.registerLazySingleton<WeatherRepository>(() => WeatherRepository());
  sl.registerLazySingleton<LocationRepository>(
    () => LocationRepository(api: sl(), storage: sl()),
  );
  sl.registerLazySingleton<NoteRepository>(() => NoteRepository(api: sl()));
  sl.registerLazySingleton<UnitRepository>(() => UnitRepository(api: sl()));
  sl.registerLazySingleton<InventoryItemRepository>(
    () => InventoryItemRepository(api: sl()),
  );
  sl.registerLazySingleton<ActivityRepository>(
    () => ActivityRepository(api: sl()),
  );
  sl.registerLazySingleton<FarmlandRepository>(
    () => FarmlandRepository(api: sl()),
  );
  sl.registerLazySingleton<MarketPriceRepository>(
    () => MarketPriceRepository(api: sl()),
  );
  sl.registerLazySingleton<CropInfoRepository>(
    () => CropInfoRepository(api: sl()),
  );
  sl.registerLazySingleton<RoutingService>(() => RoutingService());
  sl.registerLazySingleton<ServiceCenterRepository>(
    () => ServiceCenterRepository(api: sl()),
  );
  sl.registerLazySingleton<SubsidyRepository>(
    () => SubsidyRepository(api: sl()),
  );

  // ── Global cubits (app-lifetime; feature cubits are created per
  //    route in app_router.dart, never registered here) ──────────
  sl.registerLazySingleton<SessionCubit>(() => SessionCubit(sl()));
  sl.registerLazySingleton<LocaleCubit>(() => LocaleCubit(sl()));
  sl.registerLazySingleton<ThemeCubit>(() => ThemeCubit(sl()));

  // ── Router (needs SessionCubit for the redirect guard) ────────
  sl.registerLazySingleton<GoRouter>(() => createRouter(sl()));
}
