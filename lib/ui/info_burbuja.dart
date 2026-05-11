import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mapa_emocional/game/entidades/emocion_data.dart';

class InfoBurbuja extends StatefulWidget{
  final EmocionData data;
  final Offset posicion;
  final VoidCallback onCerrar;

  const InfoBurbuja ({
    super.key,
    required this.data,
    required this.posicion,
    required this.onCerrar,
  });

  @override
  State<InfoBurbuja> createState() => _InfoBurbujaState();
}

class _InfoBurbujaState extends State<InfoBurbuja> with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _fade = CurvedAnimation(
        parent: _ctrl,
        curve: Curves.easeOut
    );
    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Future<void> _cerrar() async {
    await _ctrl.reverse();
    widget.onCerrar();
  }

  @override
  Widget build(BuildContext context) {
    const double anchoCard = 200;
    const double altoEstimado = 110;

    double left = widget.posicion.dx - anchoCard / 2;
    double top = widget.posicion.dy - altoEstimado - 48;
    
    final screenW = MediaQuery.of(context).size.width;
    left = left.clamp(8.0, screenW - anchoCard - 8);
    top = top.clamp(8.0, double.infinity);
    
    return Positioned(
        left: left,
      top: top,
      child: FadeTransition(
          opacity: _fade,
        child: GestureDetector(
          onTap: _cerrar,
          child: Container(
            width: anchoCard,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF1a0f2e),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: const Color(0xFF7c5cbf),
                width: 1.5,
              ),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black54,
                  blurRadius: 8,
                  offset: Offset(0, 3)
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.data.nombre,
                      style: GoogleFonts.pixelifySans(
                        color: const Color(0xFFe0aaff),
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                    GestureDetector(
                      onTap: _cerrar,
                      child: const Icon(
                        Icons.close,
                        color: Colors.white38,
                        size:14,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                    widget.data.descripcion,
                  style: GoogleFonts.pixelifySans(
                    color: const Color(0xFFccc0e8),
                    fontSize: 10,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}