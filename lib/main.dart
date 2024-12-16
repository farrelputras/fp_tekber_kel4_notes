import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'screens/onboarding_screen.dart';
import 'package:provider/provider.dart'; // Import Provider package
import '/pomodoro_service.dart'; // Import TimerService

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    ChangeNotifierProvider<TimerService>(
      // Wrap the app with ChangeNotifierProvider
      create: (_) => TimerService(), // Provide TimerService here
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode =
      ThemeMode.system; // Default: mengikuti pengaturan sistem

  void _updateThemeMode(ThemeMode mode) {
    setState(() {
      _themeMode = mode; // Perbarui tema aplikasi
      print("Theme mode updated to: $mode"); // Debugging
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Notes App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.yellow),
        useMaterial3: true,
        fontFamily: "SourGummy",
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark, // Mode gelap
        scaffoldBackgroundColor:
            const Color.fromARGB(255, 51, 42, 55), // Latar belakang gelap
        primaryColor: const Color.fromARGB(255, 113, 2, 132), // Warna utama
        colorScheme: const ColorScheme.dark(
          primary: Color.fromARGB(255, 205, 157, 213), // Warna elemen utama
          secondary: Color.fromARGB(255, 59, 30, 109), // Warna elemen sekunder
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(
              color: Color.fromARGB(255, 255, 255, 255)), // Warna teks utama
          bodyMedium: TextStyle(
              color: Color.fromARGB(179, 183, 183, 183)), // Warna teks sekunder
        ),
        fontFamily: "SourGummy",
      ),
      themeMode: _themeMode, // Terapkan tema berdasarkan pilihan
      home: OnboardingScreen(onThemeChanged: _updateThemeMode),
    );
  }
}
