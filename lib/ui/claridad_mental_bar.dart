import 'package:flutter/material.dart';

class ClaridadMentalBar extends StatelessWidget {
  final int interactuadas;
  final int total;

  const ClaridadMentalBar({
    super.key,
    required this.interactuadas,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    final progreso = (interactuadas / total).clamp(0.0, 1.0);
    final pct = (progreso * 100).round();

    return Container(
      width: 148,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.black54,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF7c5cbf), width: 1),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Claridad mental',
                style: TextStyle(
                  color: Color(0xFFc77dff),
                  fontSize: 10,
                  letterSpacing: 0.5,
                ),
              ),
              Text(
                '$pct%',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progreso,
              minHeight: 7,
              backgroundColor: Colors.white12,
              valueColor: const AlwaysStoppedAnimation<Color>(
                Color(0xFF7c5cbf),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
