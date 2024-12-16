import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fp_tekber_kel4_notes/pomodoro_service.dart';
import 'package:fp_tekber_kel4_notes/widget/timer_card.dart';

class TimerOptions extends StatelessWidget {
  final List<String> selectableTimes = [
    "600", "900", "1200", "1500", "1800", "2700",
  ];

  TimerOptions({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TimerService>(context);
    return SingleChildScrollView(
      controller: ScrollController(initialScrollOffset: 155),
      scrollDirection: Axis.horizontal,
      child: Row(
        children: selectableTimes.map((time) {
          final isSelected = int.parse(time) == provider.selectedTime;
          return InkWell(
            onTap: () => provider.selectTime(double.parse(time)),
            child: Container(
              margin: const EdgeInsets.only(left: 10),
              width: 70,
              height: 50,
              decoration: BoxDecoration(
                color: isSelected ? Colors.white : Colors.transparent,
                border: isSelected
                    ? null
                    : Border.all(width: 3, color: Colors.white30),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Center(
                child: Text(
                  (int.parse(time) ~/ 60).toString(),
                  style: TextStyle(
                    fontSize: 20,
                    color: isSelected
                        ? renderColor(provider.currentState)
                        : Colors.white,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
