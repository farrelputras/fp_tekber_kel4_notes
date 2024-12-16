import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fp_tekber_kel4_notes/pomodoro_service.dart';

class TimerCard extends StatelessWidget {
  const TimerCard({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TimerService>(context);
    return Column(
      children: [
        Text(
          provider.currentState,
          style: const TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildTimeContainer(
              context,
              (provider.currentduration ~/ 60).toString(),
              renderColor(provider.currentState),
            ),
            const SizedBox(width: 15),
            const Text(
              ':',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 15),
            _buildTimeContainer(
              context,
              (provider.currentduration % 60).toString().padLeft(2, '0'),
              renderColor(provider.currentState),
            ),
          ],
        )
      ],
    );
  }

  Widget _buildTimeContainer(BuildContext context, String value, Color color) {
    return Container(
      width: MediaQuery.of(context).size.width / 3.2,
      height: 170,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            blurRadius: 10,
            color: Colors.white.withOpacity(0.8),
            spreadRadius: 3,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 70,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

Color renderColor(String currentState) {
  return currentState == "FOCUS" ? Colors.redAccent : Colors.black;
}
