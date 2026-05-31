import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'widgets/dashboard_page.dart';
import 'themes/app_theme.dart';
import 'constants/app_constants.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseMessaging.instance.requestPermission();

  final token = await FirebaseMessaging.instance.getToken();

  print('FCM TOKEN: $token');

  await Supabase.initialize(
    url: AppConstants.supabaseUrl, //[cite: 1, 8]
    anonKey: AppConstants.supabaseAnonKey, //[cite: 1, 8]
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: AppConstants.appName, //[cite: 1, 8]
      theme: AppTheme.lightTheme, // Loads your beautiful new website-inspired look[cite: 8]
      home: const DashboardPage(), // Launches your premium interactive calendar dashboard[cite: 8]
    );
  }
}
