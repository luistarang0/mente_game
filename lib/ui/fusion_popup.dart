import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../game/entidades/emocion_fusionada_data.dart';

class FusionPopup extends StatelessWidget {
  final EmocionFusionadaData fusion;
  final VoidCallback onEntendido;

  const FusionPopup({
    super.key,
    required this.fusion,
    required this.onEntendido,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black54,
      child: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 32),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: const Color(0xFF1a1a2e),
            border: Border.all(color: const Color(0xFFc77dff), width: 2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '¡Fusión emocional!',
                style: GoogleFonts.pixelifySans(
                  color: const Color(0xFFe0aaff),
                  fontSize: 12,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                fusion.nombre,
                style: GoogleFonts.pixelifySans(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                fusion.descripcion,
                textAlign: TextAlign.center,
                style: GoogleFonts.pixelifySans(
                  color: Colors.white70,
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 28),
              GestureDetector(
                onTap: onEntendido,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    color: const Color(0xFF7c5cbf),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      'Entendido',
                      style: GoogleFonts.pixelifySans(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
