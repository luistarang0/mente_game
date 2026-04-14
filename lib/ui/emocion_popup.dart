import 'package:flutter/material.dart';
import '../game/entidades/emocion_data.dart';

class EmocionPopup extends StatelessWidget {
  final EmocionData data;
  final void Function(bool recolectada) onRespuesta;

  const EmocionPopup({
    super.key,
    required this.data,
    required this.onRespuesta,
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
            border: Border.all(color: const Color(0xFF7c5cbf), width: 2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Nombre de la emoción
              Text(
                data.nombre,
                style: const TextStyle(
                  color: Color(0xFFe0aaff),
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 16),

              // Descripción
              Text(
                data.descripcion,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 24),

              // Pregunta
              Text(
                data.pregunta,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Color(0xFFc77dff),
                  fontSize: 15,
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 28),

              // Botones
              Row(
                children: [
                  Expanded(
                    child: _BotonRespuesta(
                      texto: 'No',
                      color: const Color(0xFF3d3d5c),
                      onTap: () => onRespuesta(false),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _BotonRespuesta(
                      texto: 'Sí',
                      color: const Color(0xFF7c5cbf),
                      onTap: () => onRespuesta(true),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BotonRespuesta extends StatelessWidget {
  final String texto;
  final Color color;
  final VoidCallback onTap;

  const _BotonRespuesta({
    required this.texto,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          texto,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          ),
        ),
      ),
    );
  }
}
