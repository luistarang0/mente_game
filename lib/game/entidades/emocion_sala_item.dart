import 'package:flutter/painting.dart';
import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import '../entidades/emocion_data.dart';

/// Elemento visual de la sala de integración.
/// Muestra el sprite de la emoción (o placeholder según el tipo)
/// y su nombre centrado debajo. Sin colisión.
class EmocionSalaItem extends PositionComponent with HasGameReference {
  final EmocionData data;

  static const double _tamSprite = 32.0;
  static const double _altTexto = 14.0;

  EmocionSalaItem({required this.data, required Vector2 posicion})
      : super(
          position: posicion,
          size: Vector2(_tamSprite, _tamSprite + _altTexto),
          anchor: Anchor.topCenter,
        );

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // ── Sprite ───────────────────────────────────────────────────
    if (data.imagen.isNotEmpty) {
      // Emoción primaria: imagen individual
      final sprite = await game.loadSprite(data.imagen);
      add(SpriteComponent(
        sprite: sprite,
        size: Vector2.all(_tamSprite),
        anchor: Anchor.topLeft,
        position: Vector2.zero(),
      ));
    } else if (data.hojaSprite.isNotEmpty) {
      // Fusión con sprite en el spritesheet EMO_COMB.png
      final parts = data.hojaSprite.split(':');
      final col = int.parse(parts[1]);
      final row = int.parse(parts[2]);
      final sheet = SpriteSheet(
        image: await game.images.load(parts[0]),
        srcSize: Vector2.all(32.0),
      );
      add(SpriteComponent(
        sprite: sheet.getSprite(row, col),
        size: Vector2.all(_tamSprite),
        anchor: Anchor.topLeft,
        position: Vector2.zero(),
      ));
    } else {
      // Fusión sin imagen: rectángulo con iniciales
      add(RectangleComponent(
        size: Vector2.all(_tamSprite),
        paint: Paint()..color = const Color(0xFF5a3d8a),
        position: Vector2.zero(),
      ));
      if (data.iniciales.isNotEmpty) {
        add(TextComponent(
          text: data.iniciales,
          textRenderer: TextPaint(
            style: const TextStyle(
              color: Color(0xFFFFFFFF),
              fontSize: 9,
              fontWeight: FontWeight.bold,
            ),
          ),
          position: Vector2(_tamSprite / 2, _tamSprite / 2),
          anchor: Anchor.center,
        ));
      }
    }

    // ── Nombre ───────────────────────────────────────────────────
    add(TextComponent(
      text: data.nombre,
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Color.fromARGB(255, 0, 0, 0),
          fontSize: 7,
        ),
      ),
      position: Vector2(_tamSprite / 2, _tamSprite + 2),
      anchor: Anchor.topCenter,
    ));
  }
}
