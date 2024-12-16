import 'package:flutter/material.dart';
import 'package:fp_tekber_kel4_notes/pomodoro_service.dart';
import 'package:fp_tekber_kel4_notes/widget/timer_progress.dart';
import 'package:fp_tekber_kel4_notes/widget/timer_card.dart';
import 'package:fp_tekber_kel4_notes/widget/timer_opt.dart';
import 'package:fp_tekber_kel4_notes/widget/timer_controller.dart';
import 'package:provider/provider.dart';

class PomodoroScreen extends StatelessWidget {
  const PomodoroScreen({super.key});

  // Function to determine the background color based on the current state
  Color _getBackgroundColor(String currentState) {
    return currentState == "FOCUS"
        ? Colors.grey.shade800
        : const Color.fromARGB(255, 171, 68, 68);
  }

  @override
  Widget build(BuildContext context) {
    final timerService = Provider.of<TimerService>(context);
    final backgroundColor = _getBackgroundColor(timerService.currentState);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor:
            const Color.fromARGB(255, 255, 243, 132), // Warna kuning terang
        elevation: 0,
        centerTitle: true, // Membuat teks judul di tengah
        title: const Text(
          'Pomodoro Timer',
          style: TextStyle(
            color: Colors.black,
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black), // Ikon hitam
          onPressed: () {
            Navigator.pop(context); // Kembali ke halaman sebelumnya
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            iconSize: 40,
            color: Colors.black,
            onPressed: () =>
                Provider.of<TimerService>(context, listen: false).reset(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(vertical: 40),
          child: Column(
            children: [
              const TimerCard(),
              const SizedBox(height: 50),
              TimerOptions(),
              const SizedBox(height: 50),
              const TimeController(),
              const SizedBox(height: 30),
              const Progress(),
            ],
          ),
        ),
      ),
    );
  }
}
