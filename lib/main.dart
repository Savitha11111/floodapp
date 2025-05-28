import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'services/api_service.dart';
import 'services/location_service.dart';
import 'providers/flood_data_provider.dart';
import 'screens/home_screen.dart';
import 'screens/splash_screen.dart';
import 'utils/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Hive for local storage
  await Hive.initFlutter();
  
  runApp(const FloodScopeApp());
}

class FloodScopeApp extends StatelessWidget {
  const FloodScopeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<ApiService>(create: (_) => ApiService()),
        Provider<LocationService>(create: (_) => LocationService()),
        ChangeNotifierProvider<FloodDataProvider>(
          create: (context) => FloodDataProvider(
            context.read<ApiService>(),
            context.read<LocationService>(),
          ),
        ),
      ],
      child: MaterialApp(
        title: 'FloodScope AI',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        home: const SplashScreen(),
        debugShowCheckedModeBanner: false,
        routes: {
          '/home': (context) => const HomeScreen(),
        },
      ),
    );
  }
}