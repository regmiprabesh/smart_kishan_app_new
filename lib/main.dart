import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:smart_kishan/app/app.dart';
import 'package:smart_kishan/core/di/injector.dart';
import 'package:smart_kishan/core/services/location_service.dart';
import 'package:smart_kishan/core/services/notification_service.dart';
import 'package:smart_kishan/features/auth/session/cubit/session_cubit.dart';
import 'package:smart_kishan/firebase_options.dart';

@pragma('vm:entry-point')
Future<void> _firebaseBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: '.env');

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging.onBackgroundMessage(_firebaseBackgroundHandler);

  await initDependencies();

  await Future.wait([
    initializeDateFormatting('ne_NP'),
    initializeDateFormatting('en'),
  ]);

  sl<SessionCubit>().restore(); // intentionally not awaited
  sl<NotificationService>().init(); // intentionally not awaited
  sl<LocationService>().ensurePermission();
  runApp(const SmartKishanApp());
}
