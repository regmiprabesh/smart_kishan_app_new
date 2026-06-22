import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_kishan/core/di/injector.dart';
import 'package:smart_kishan/core/enums/app_mode.dart';
import 'package:smart_kishan/core/services/local_storage_service.dart';
import 'package:smart_kishan/features/auth/data/auth_flow_args.dart';
import 'package:smart_kishan/features/auth/data/otp_purpose.dart';
import 'package:smart_kishan/features/auth/view/forgot_password_phone_screen.dart';
import 'package:smart_kishan/features/auth/cubit/otp_cubit.dart';
import 'package:smart_kishan/features/auth/view/otp_screen.dart';
import 'package:smart_kishan/features/auth/cubit/phone_entry_cubit.dart';
import 'package:smart_kishan/features/auth/cubit/register_details_cubit.dart';
import 'package:smart_kishan/features/auth/view/register_details_screen.dart';
import 'package:smart_kishan/features/auth/view/register_phone_screen.dart';
import 'package:smart_kishan/features/auth/cubit/reset_password_cubit.dart';
import 'package:smart_kishan/features/auth/view/reset_password_screen.dart';
import 'package:smart_kishan/features/auth/cubit/session_cubit.dart';
import 'package:smart_kishan/features/auth/cubit/session_state.dart';
import 'package:smart_kishan/features/auth/cubit/sign_in_cubit.dart';
import 'package:smart_kishan/features/auth/view/sign_in_screen.dart';
import 'package:smart_kishan/features/common/comint_soon_screen.dart';
import 'package:smart_kishan/features/farmer/crop_info/cubit/crop_info_cubit.dart';
import 'package:smart_kishan/features/farmer/crop_info/view/crop_info_args.dart';
import 'package:smart_kishan/features/farmer/crop_info/view/crop_info_detail_screen.dart';
import 'package:smart_kishan/features/farmer/crop_info/view/crop_info_list_screen.dart';
import 'package:smart_kishan/features/farmer/daily_activity/cubit/daily_activity_cubit.dart';
import 'package:smart_kishan/features/farmer/daily_activity/view/activity_args.dart';
import 'package:smart_kishan/features/farmer/daily_activity/view/add_daily_activity_screen.dart';
import 'package:smart_kishan/features/farmer/daily_activity/view/daily_activity_list_screen.dart';
import 'package:smart_kishan/features/farmer/dashboard/farmer_dashboard_screen.dart';
import 'package:smart_kishan/features/farmer/farmland/cubit/farmland_cubit.dart';
import 'package:smart_kishan/features/farmer/farmland/view/add_farmland_screen.dart';
import 'package:smart_kishan/features/farmer/farmland/view/farmland_args.dart';
import 'package:smart_kishan/features/farmer/farmland/view/farmland_detail_screen.dart';
import 'package:smart_kishan/features/farmer/farmland/view/farmland_list_screen.dart';
import 'package:smart_kishan/features/farmer/govt_services/service_centers/cubit/service_center_detail_cubit.dart';
import 'package:smart_kishan/features/farmer/govt_services/service_centers/cubit/service_center_list_cubit.dart';
import 'package:smart_kishan/features/farmer/govt_services/service_centers/view/service_center_detail_args.dart';
import 'package:smart_kishan/features/farmer/govt_services/service_centers/view/service_center_detail_screen.dart';
import 'package:smart_kishan/features/farmer/govt_services/service_centers/view/service_center_list_screen.dart';
import 'package:smart_kishan/features/farmer/govt_services/subsidies/cubit/subsidy_apply_cubit.dart';
import 'package:smart_kishan/features/farmer/govt_services/subsidies/cubit/subsidy_list_cubit.dart';
import 'package:smart_kishan/features/farmer/govt_services/subsidies/view/subsidy_apply_screen.dart';
import 'package:smart_kishan/features/farmer/govt_services/subsidies/view/subsidy_detail_args.dart';
import 'package:smart_kishan/features/farmer/govt_services/subsidies/view/subsidy_detail_screen.dart';
import 'package:smart_kishan/features/farmer/govt_services/subsidies/view/subsidy_list_screen.dart';
import 'package:smart_kishan/features/farmer/inventory/cubit/inventory_cubit.dart';
import 'package:smart_kishan/features/farmer/inventory/view/add_inventory_item_screen.dart';
import 'package:smart_kishan/features/farmer/inventory/view/inventory_item_args.dart';
import 'package:smart_kishan/features/farmer/inventory/view/inventory_list_screen.dart';
import 'package:smart_kishan/features/farmer/ledger/cubit/ledger_cubit.dart';
import 'package:smart_kishan/features/farmer/ledger/view/expense_screen.dart';
import 'package:smart_kishan/features/farmer/ledger/view/income_screen.dart';
import 'package:smart_kishan/features/farmer/market_price/cubit/market_price_cubit.dart';
import 'package:smart_kishan/features/farmer/market_price/view/market_price_screen.dart';
import 'package:smart_kishan/features/farmer/notes/cubit/notes_cubit.dart';
import 'package:smart_kishan/features/farmer/notes/view/add_note_screen.dart';
import 'package:smart_kishan/features/farmer/notes/view/note_args.dart';
import 'package:smart_kishan/features/farmer/notes/view/notes_list_screen.dart';
import 'package:smart_kishan/features/farmer/weather/cubit/weather_cubit.dart';
import 'package:smart_kishan/features/language/language_selection_screen.dart';
import 'package:smart_kishan/features/onboarding/introduction_screen.dart';
import 'package:smart_kishan/features/startup/splash_screen.dart';

import 'app_routes.dart';

/// Central router. THE feature here is [_redirect]: a single guard that
/// replaces the old scattered launch logic AND the hand-rolled
/// pending-deep-link queue:
///
///   - session restoring  → held at /splash (target kept in ?from=)
///   - first launch       → language → introduction
///   - logged out         → auth screens only (target kept in ?from=)
///   - logged in          → never sees splash/auth/onboarding again;
///                          lands on ?from= target or the mode dashboard
///
/// So a notification tapped while logged-out flows naturally:
///   push /subsidies/12 → redirect → /sign-in?from=/subsidies/12
///   → login → redirect → /subsidies/12. No queue, no special cases.
GoRouter createRouter(SessionCubit sessionCubit) {
  return GoRouter(
    initialLocation: AppRoutePath.splash,
    debugLogDiagnostics: kDebugMode,
    // Re-run the redirect whenever the session changes — this is what
    // makes "emit(Authenticated) == navigation".
    refreshListenable: _StreamListenable(sessionCubit.stream),
    redirect: (context, state) => _redirect(sessionCubit, state),
    routes: [
      GoRoute(
        path: AppRoutePath.splash,
        builder: (_, __) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutePath.selectLanguage,
        builder: (_, __) => const LanguageSelectionScreen(),
      ),
      GoRoute(
        path: AppRoutePath.introduction,
        builder: (_, __) => const IntroductionScreen(),
      ),
      GoRoute(
        path: AppRoutePath.signIn,
        builder: (_, __) => BlocProvider(
          create: (_) => SignInCubit(sl(), sl()),
          child: const SignInScreen(),
        ),
      ),
      GoRoute(
        path: AppRoutePath.registerPhone,
        builder: (_, __) => BlocProvider(
          create: (_) =>
              PhoneEntryCubit(sl(), purpose: OtpPurpose.registration),
          child: const RegisterPhoneScreen(),
        ),
      ),
      GoRoute(
        path: AppRoutePath.forgotPasswordPhone,
        builder: (_, __) => BlocProvider(
          create: (_) =>
              PhoneEntryCubit(sl(), purpose: OtpPurpose.passwordReset),
          child: const ForgotPasswordPhoneScreen(),
        ),
      ),

      GoRoute(
        path: AppRoutePath.otp,
        redirect: (_, state) =>
            state.extra is OtpFlowArgs ? null : AppRoutePath.signIn,
        builder: (_, state) => BlocProvider(
          create: (_) => OtpCubit(sl(), state.extra as OtpFlowArgs),
          child: const OtpScreen(),
        ),
      ),
      GoRoute(
        path: AppRoutePath.registerDetails,
        redirect: (_, state) =>
            state.extra is VerifiedFlowArgs ? null : AppRoutePath.signIn,
        builder: (_, state) => BlocProvider(
          create: (_) =>
              RegisterDetailsCubit(sl(), state.extra as VerifiedFlowArgs),
          child: const RegisterDetailsScreen(),
        ),
      ),
      GoRoute(
        path: AppRoutePath.resetPassword,
        redirect: (_, state) =>
            state.extra is VerifiedFlowArgs ? null : AppRoutePath.signIn,
        builder: (_, state) => BlocProvider(
          create: (_) =>
              ResetPasswordCubit(sl(), state.extra as VerifiedFlowArgs),
          child: const ResetPasswordScreen(),
        ),
      ),

      GoRoute(
        path: AppRoutePath.farmerDashboard,
        builder: (_, __) => MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => WeatherCubit(sl(), sl())..load()),
            BlocProvider(create: (_) => NotesCubit(sl())..load()),
            BlocProvider(create: (_) => InventoryCubit(sl(), sl())..load()),
            BlocProvider(create: (_) => DailyActivityCubit(sl(), sl())..load()),
            BlocProvider(create: (_) => FarmlandCubit(sl())..load()),
          ],
          child: const FarmerDashboardScreen(),
        ),
      ),
      GoRoute(
        path: AppRoutePath.notes,
        builder: (_, state) {
          final cubit = state.extra as NotesCubit;
          return NotesListScreen(notesCubit: cubit);
        },
      ),
      GoRoute(
        path: AppRoutePath.addNote,
        builder: (_, state) {
          final args = state.extra as NoteArgs;
          return AddNoteScreen(args: args);
        },
      ),
      GoRoute(
        path: AppRoutePath.inventory,
        builder: (_, state) =>
            InventoryListScreen(cubit: state.extra as InventoryCubit),
      ),
      GoRoute(
        path: AppRoutePath.addInventoryItem,
        builder: (_, state) =>
            AddInventoryItemScreen(args: state.extra as InventoryItemArgs),
      ),
      GoRoute(
        path: AppRoutePath.dailyActivity,
        builder: (_, state) =>
            DailyActivityListScreen(cubit: state.extra as DailyActivityCubit),
      ),
      GoRoute(
        path: AppRoutePath.addDailyActivity,
        builder: (_, state) =>
            AddDailyActivityScreen(args: state.extra as ActivityArgs),
      ),
      GoRoute(
        path: AppRoutePath.income,
        redirect: (_, state) => state.extra is DailyActivityCubit
            ? null
            : AppRoutePath.farmerDashboard,
        builder: (_, state) => BlocProvider(
          create: (_) => LedgerCubit(state.extra as DailyActivityCubit),
          child: Builder(
            builder: (ctx) => IncomeScreen(cubit: ctx.read<LedgerCubit>()),
          ),
        ),
      ),
      GoRoute(
        path: AppRoutePath.expense,
        redirect: (_, state) => state.extra is DailyActivityCubit
            ? null
            : AppRoutePath.farmerDashboard,
        builder: (_, state) => BlocProvider(
          create: (_) => LedgerCubit(state.extra as DailyActivityCubit),
          child: Builder(
            builder: (ctx) => ExpenseScreen(cubit: ctx.read<LedgerCubit>()),
          ),
        ),
      ),
      GoRoute(
        path: AppRoutePath.farmlands,
        builder: (_, state) {
          final extra = state.extra;
          if (extra is FarmlandCubit) return FarmlandListScreen(cubit: extra);
          // Fallback (deep link / no extra): self-create.
          return BlocProvider(
            create: (_) => FarmlandCubit(sl())..load(),
            child: Builder(
              builder: (ctx) =>
                  FarmlandListScreen(cubit: ctx.read<FarmlandCubit>()),
            ),
          );
        },
      ),
      GoRoute(
        path: AppRoutePath.farmlandDetail,
        redirect: (_, s) =>
            s.extra is FarmlandArgs &&
                (s.extra as FarmlandArgs).farmland != null
            ? null
            : AppRoutePath.farmlands,
        builder: (_, s) {
          final a = s.extra as FarmlandArgs;
          return FarmlandDetailScreen(
            farmlandId: a.farmland!.id!,
            cubit: a.cubit,
          );
        },
      ),
      GoRoute(
        path: AppRoutePath.addFarmland,
        redirect: (_, state) =>
            state.extra is FarmlandArgs ? null : AppRoutePath.farmlands,
        builder: (_, state) =>
            AddFarmlandScreen(args: state.extra as FarmlandArgs),
      ),
      GoRoute(
        path: AppRoutePath.marketPrices,
        builder: (_, __) => BlocProvider(
          create: (_) =>
              MarketPriceCubit(sl())..load(), // sl() → MarketPriceRepository
          child: Builder(
            builder: (ctx) =>
                MarketPriceScreen(cubit: ctx.read<MarketPriceCubit>()),
          ),
        ),
      ),
      GoRoute(
        path: AppRoutePath.cropInfoList,
        builder: (_, __) => BlocProvider(
          create: (_) => CropInfoCubit(sl())..load(),
          child: Builder(
            builder: (ctx) =>
                CropInfoListScreen(cubit: ctx.read<CropInfoCubit>()),
          ),
        ),
      ),
      GoRoute(
        path: AppRoutePath.cropInfoDetail,
        redirect: (_, s) =>
            s.extra is CropInfoArgs ? null : AppRoutePath.cropInfoList,
        builder: (_, s) =>
            CropInfoDetailScreen(crop: (s.extra as CropInfoArgs).crop),
      ),
      GoRoute(
        path: AppRoutePath.serviceCenters,
        builder: (context, state) => BlocProvider(
          create: (_) => ServiceCenterListCubit(sl(), sl(), sl())..load(),
          child: const ServiceCenterListScreen(),
        ),
      ),
      GoRoute(
        path: AppRoutePath.serviceCenterDetail,
        builder: (context, state) {
          final args = state.extra as ServiceCenterDetailArgs;
          return BlocProvider(
            create: (_) => ServiceCenterDetailCubit(sl(), args.id)..load(),
            child: const ServiceCenterDetailScreen(),
          );
        },
      ),
      GoRoute(
        path: AppRoutePath.subsidies,
        builder: (context, state) => BlocProvider(
          create: (_) => SubsidyListCubit(sl()),
          child: const SubsidyListScreen(),
        ),
      ),
      // stubs — replaced as each slice lands
      GoRoute(
        path: AppRoutePath.subsidyDetail,
        builder: (_, state) {
          final args = state.extra as SubsidyDetailArgs;
          return SubsidyDetailScreen(args: args);
        },
      ),
      GoRoute(
        path: AppRoutePath.subsidyApply,
        builder: (_, state) {
          final args = state.extra as SubsidyDetailArgs;
          return BlocProvider(
            create: (_) => SubsidyApplyCubit(sl()),
            child: SubsidyApplyScreen(args: args),
          );
        },
      ),
      GoRoute(
        path: AppRoutePath.mySubsidyApplications,
        builder: (_, __) => const ComingSoonScreen(title: 'My applications'),
      ),
      GoRoute(
        path: AppRoutePath.mySubsidyRequests,
        builder: (_, __) => const ComingSoonScreen(title: 'My requests'),
      ),
      // // Phase 3 replaces these with the real dashboards.
      // GoRoute(
      //   path: AppRoutePath.farmerDashboard,
      //   builder: (_, __) =>
      //       const PlaceholderDashboard(title: 'Farmer Dashboard'),
      // ),
      // GoRoute(
      //   path: AppRoutePath.customerDashboard,
      //   builder: (_, __) =>
      //       const PlaceholderDashboard(title: 'Customer Dashboard'),
      // ),
      // GoRoute(
      //   path: AppRoutePath.vendorDashboard,
      //   builder: (_, __) =>
      //       const PlaceholderDashboard(title: 'Vendor Dashboard'),
      // ),
      // Feature placeholders (Phase 4+) — wired so nav works now.
      GoRoute(
        path: AppRoutePath.myUsers,
        builder: (_, __) => const ComingSoonScreen(title: 'Users'),
      ),
      GoRoute(
        path: AppRoutePath.chatbot,
        builder: (_, __) => const ComingSoonScreen(title: 'Chatbot'),
      ),
      GoRoute(
        path: AppRoutePath.myDeliveryAddresses,
        builder: (_, __) => const ComingSoonScreen(title: 'Delivery Addresses'),
      ),
      GoRoute(
        path: AppRoutePath.orderHistory,
        builder: (_, __) => const ComingSoonScreen(title: 'Orders'),
      ),
      GoRoute(
        path: AppRoutePath.buyersGroup,
        builder: (_, __) => const ComingSoonScreen(title: 'Buyers Groups'),
      ),

      // Phase 2 adds: register-phone, otp, register-details,
      // forgot-password-phone, reset-password.
    ],
  );
}

const _authPaths = {
  AppRoutePath.signIn,
  AppRoutePath.registerPhone,
  AppRoutePath.registerDetails,
  AppRoutePath.forgotPasswordPhone,
  AppRoutePath.otp,
  AppRoutePath.resetPassword,
};

const _onboardingPaths = {
  AppRoutePath.selectLanguage,
  AppRoutePath.introduction,
};

String? _redirect(SessionCubit sessionCubit, GoRouterState state) {
  final session = sessionCubit.state;
  final location = state.matchedLocation;
  final from = state.uri.queryParameters['from'];

  final inAuth = _authPaths.contains(location);
  final inOnboarding = _onboardingPaths.contains(location);
  final atSplash = location == AppRoutePath.splash;

  String withFrom(String path, String? target) => target == null
      ? path
      : Uri(path: path, queryParameters: {'from': target}).toString();

  // 1) Session still restoring → hold at splash, remember the target
  //    (covers deep links / notification taps at cold start).
  if (session is SessionUnknown) {
    if (atSplash) return null;
    return withFrom(AppRoutePath.splash, state.uri.toString());
  }

  // 2) First launch → onboarding flow only.
  if (sl<LocalStorageService>().isFirstLaunch) {
    return inOnboarding ? null : AppRoutePath.selectLanguage;
  }

  // 3) Logged out → auth screens only; keep carrying the target.
  if (session is Unauthenticated) {
    if (inAuth) return null;
    return withFrom(
      AppRoutePath.signIn,
      atSplash ? from : state.uri.toString(),
    );
  }

  // 4) Logged in → never splash/auth/onboarding; go to the carried
  //    target, or the dashboard for the current mode.
  if (session is Authenticated && (atSplash || inAuth || inOnboarding)) {
    return from ?? dashboardPathForMode(session.mode);
  }

  return null;
}

/// Bridges a bloc Stream to the Listenable go_router expects.
class _StreamListenable extends ChangeNotifier {
  _StreamListenable(Stream<dynamic> stream) {
    _subscription = stream.listen((_) => notifyListeners());
  }
  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
