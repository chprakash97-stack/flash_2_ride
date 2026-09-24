import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart'; // 1. ఇక్కడ ఇంపోర్ట్ చేయండి
import 'firebase_options.dart'; // 2. ఫ్లట్టర్ ఫైర్ క్రియేట్ చేసిన ఆప్షన్స్ ఫైల్
import 'theme/app_theme.dart';
import 'providers/auth_provider.dart';
import 'providers/ride_provider.dart';
import 'screens/splash_screen.dart';

void main() async { // 3. async యాడ్ చేయండి
  WidgetsFlutterBinding.ensureInitialized();
  
  // 4. Firebase ని ఇనిషియలైజ్ చేయండి
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const Flash2RideApp());
}

class Flash2RideApp extends StatelessWidget {
  const Flash2RideApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => RideProvider()),
      ],
      child: MaterialApp(
        title: 'Flash2Ride',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const SplashScreen(),
      ),
    );
  }
}