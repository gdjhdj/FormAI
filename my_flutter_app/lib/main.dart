import 'package:flutter/material.dart';
import 'screens/LiftSelectionPage.dart';
import 'screens/LoginScreen.dart';
import 'screens/HomeScreen.dart';
import 'screens/InfoUpload.dart';
import 'screens/SettingsScreen.dart';
import 'screens/SignupScreen.dart';
import 'screens/PasswordChange.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/ProfileScreen.dart';
import 'screens/WorkoutTrackerScreen.dart';
import 'screens/HelpAndSupportScreen.dart';
import 'screens/AboutScreen.dart';

final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.light);



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final bool isDarkMode = prefs.getBool('isDarkMode') ?? false;
  themeNotifier.value = isDarkMode ? ThemeMode.dark : ThemeMode.light;
  final bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
  runApp(GymWorkoutApp(isLoggedIn: isLoggedIn));
}

class GymWorkoutApp extends StatelessWidget {

  final bool isLoggedIn;
  const GymWorkoutApp({Key? key, required this.isLoggedIn}) : super(key: key);



  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (context, currentMode, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'My Gym Coach',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            scaffoldBackgroundColor: Colors.grey[50],
            appBarTheme: AppBarTheme(
              elevation: 0,
              backgroundColor: Colors.white,
              foregroundColor: Colors.black87,
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            inputDecorationTheme: InputDecorationTheme(
              filled: true,
              fillColor: Colors.grey[100],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.blue),
              ),
            ),
          ),
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            primarySwatch: Colors.blue,
          ),
          themeMode: currentMode,
          initialRoute: isLoggedIn ? '/home' : '/login',
          routes: {
            '/login': (context) => LoginScreen(),
            '/signup': (context) => SignupScreen(),
            '/home': (context) => HomeScreen(),
            '/lifts': (context) => LiftSelectionPage(),
            '/info': (context) => InfoUpload(),
            '/settings': (context) => SettingsScreen(),
            '/change_password': (context) => PasswordChangeScreen(),
            '/profile': (context) => ProfileScreen(),
            '/tracker': (context) => WorkoutTrackerScreen(),
            '/help': (context) => HelpAndSupportScreen(),
            '/about': (context) => AboutScreen(),
          }
        );
      },
    );
  }
}  