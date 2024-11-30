import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fp_tekber_kel4_notes/screens/myapp_screen.dart';

class OnboardingScreen extends StatefulWidget {
  final Function(ThemeMode) onThemeChanged;
  const OnboardingScreen({Key? key, required this.onThemeChanged})
      : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  double _progress = 0; // Nilai progress
  bool _showButton = false; // Tombol "Get Started" tampil jika true
  int _currentImageIndex = 0; // Indeks gambar saat ini
  late Timer _timer;

  final List<String> _imagePaths = [
    'assets/gambar1.png',
    'assets/gambar2.png',
    'assets/gambar3.png',
  ];

  @override
  void initState() {
    super.initState();
    _startLoading(); // Jalankan animasi progress bar
    _startImageRotation(); // Animasi rotasi gambar
  }

  @override
  void dispose() {
    _timer.cancel(); // Hentikan timer saat screen ditutup
    super.dispose();
  }

  void _startLoading() async {
    for (int i = 1; i <= 10; i++) {
      await Future.delayed(const Duration(milliseconds: 300));
      setState(() {
        _progress = i / 10; // Perbarui progress
      });
    }
    setState(() {
      _showButton = true; // Tampilkan tombol setelah loading selesai
    });
  }

  void _startImageRotation() {
    _timer = Timer.periodic(const Duration(milliseconds: 1500), (timer) {
      setState(() {
        _currentImageIndex = (_currentImageIndex + 1) % _imagePaths.length;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // Ambil tema aktif
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: theme.brightness == Brightness.dark
              ? [Colors.grey.shade900, Colors.grey.shade800] // Warna untuk dark mode
              : [Colors.yellow.shade100, Colors.yellow.shade300], // Warna untuk light mode
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Rotating Image
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 800),
              child: Image.asset(
                _imagePaths[_currentImageIndex],
                key: ValueKey<int>(_currentImageIndex),
                fit: BoxFit.cover,
                width: 150,
                height: 150,
              ),
            ),
            const SizedBox(height: 30),

            // Text "Welcome to Notes App!"
            const Text(
              'Welcome to EduNotes!',
                style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Manage your academic notes with EduNotes! \nAn easy way to learn!',
              style: theme.textTheme.bodyMedium?.copyWith(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),

            // Theme Mode Buttons
            const Text(
              "Choose your theme:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => widget.onThemeChanged(ThemeMode.light),
              child: const Text("Light Mode"),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => widget.onThemeChanged(ThemeMode.dark),
              child: const Text("Dark Mode"),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => widget.onThemeChanged(ThemeMode.system),
              child: const Text("System Default"),
            ),
            const SizedBox(height: 30),

            // Show Progress Bar or "Get Started" Button
            if (!_showButton)
              // Progress Bar
              Container(
                width: 250,
                height: 8,
                decoration: BoxDecoration(
                  color: Colors.black26,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Stack(
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: 250 * _progress,
                      height: 8,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 189, 117, 202),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ],
                ),
              ),

              if (_showButton)
              // "Get Started" Button (visible after progress bar finishes)
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const MyAppScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB( 255, 189, 117, 202), 
                  foregroundColor: Colors.white, 
                  padding:
                    const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 5, 
                  shadowColor: Colors.black54, 
                ),
                child: const Text(
                  'Start Take Your Notes',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
