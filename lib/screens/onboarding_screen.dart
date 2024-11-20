import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fp_tekber_kel4_notes/screens/myapp_screen.dart';
import 'quicknotes_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  double _progress = 0; // Progress value
  bool _showButton = false; // Control visibility of the button
  int _currentImageIndex = 0; // Current image index
  late Timer _timer;

  final List<String> _imagePaths = [
    'assets/gambar1.png',
    'assets/gambar2.png',
    'assets/gambar3.png',
  ];

  @override
  void initState() {
    super.initState();
    _startLoading(); // Start progress bar animation
    _startImageRotation(); // Start image rotation animation
  }

  @override
  void dispose() {
    _timer.cancel(); // Cancel timer when screen is disposed
    super.dispose();
  }

  void _startLoading() async {
    // Simulate the progress bar filling up
    for (int i = 1; i <= 10; i++) {
      await Future.delayed(const Duration(milliseconds: 300)); // Delay per step
      setState(() {
        _progress = i / 10; // Update progress
      });
    }

    // Show the "Get Started" button
    setState(() {
      _showButton = true;
    });
  }

  void _startImageRotation() {
    // Timer to change images every 1.5 seconds
    _timer = Timer.periodic(const Duration(milliseconds: 1500), (timer) {
      setState(() {
        _currentImageIndex = (_currentImageIndex + 1) % _imagePaths.length;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.yellow.shade100,
              Colors.yellow.shade300,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Rotating Image
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 800), // Smooth transition
              child: Image.asset(
                _imagePaths[_currentImageIndex],
                key: ValueKey<int>(_currentImageIndex),
                fit: BoxFit.cover,
                width: 150, // Adjusted size to fit the layout
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
            const Text(
              'Manage ur academics note with EduNotes!: an easy way to learn!',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black54,
              ),
              textAlign: TextAlign.center,
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
                      width: 250 * _progress, // Animate width based on progress
                      height: 8,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(
                            255, 189, 117, 202), // Progress bar color changed
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
                  backgroundColor: const Color.fromARGB(
                      255, 189, 117, 202), // Button color changed
                  foregroundColor: Colors.white, // Font color remains white
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 5, // Add shadow effect
                  shadowColor: Colors.black54, // Shadow hint color
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
