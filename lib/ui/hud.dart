import 'package:flutter/material.dart';
import '../game/entidades/emocion_data.dart';

class HudEmociones extends StatelessWidget {
  final List<EmocionData> emociones;

  const HudEmociones({super.key, required this.emociones});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 56,
      decoration: BoxDecoration(
        color: Colors.grey.withValues(alpha: 0.25),
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(12),
          bottomRight: Radius.circular(12),
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Icon(Icons.favorite_border, color: Colors.white54, size: 18),
          const SizedBox(height: 8),
          const Divider(
            color: Colors.white24,
            thickness: 1,
            indent: 8,
            endIndent: 8,
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.separated(
              itemCount: emociones.length,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              separatorBuilder: (_, _) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                return _EmocionIcono(data: emociones[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _EmocionIcono extends StatelessWidget {
  final EmocionData data;
  static const double _size = 36;

  const _EmocionIcono({required this.data});

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: data.nombre,
      child: Container(
        width: _size,
        height: _size,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          color: Colors.white10,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: _buildIcono(),
        ),
      ),
    );
  }

  Widget _buildIcono() {
    if (data.esPrimaria) {
      return ClipRect(
        child: Align(
          alignment: Alignment.centerLeft,
          widthFactor: 0.5,
          child: Image.asset(
            'assets/images/${data.imagen}',
            filterQuality: FilterQuality.none,
            fit: BoxFit.fitHeight,
          ),
        ),
      );
    }

    return Image.asset(
      'assets/images/${data.imagen}',
      filterQuality: FilterQuality.none,
      fit: BoxFit.contain,
    );
  }
}
