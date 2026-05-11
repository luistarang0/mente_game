import 'package:flame/collisions.dart';
import 'package:flutter/painting.dart';
import 'package:flame/components.dart';
import '../entidades/emocion_data.dart';

/// Elemento visual de la sala de integración.
/// Muestra el sprite de la emoción (o placeholder según el tipo)
/// y su nombre centrado debajo. Sin colisión.
class EmocionSalaItem extends SpriteAnimationComponent with HasGameReference, CollisionCallbacks {
  final EmocionData data;
  final void Function(EmocionData, Vector2 posicionMundo) onContacto;

  bool _contactoEmitido = false;

  static const double _tamSprite = 32.0;

  EmocionSalaItem({required this.data, required Vector2 posicion, required this.onContacto})
      : super(
          position: posicion,
          size: Vector2.all(_tamSprite),
          anchor: Anchor.center,
        );

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    final sheet = await game.images.load(data.imagen);
    animation = SpriteAnimation.fromFrameData(
        sheet,
        SpriteAnimationData.sequenced(
            amount: data.frameCount,
            stepTime: data.stepTime,
            textureSize: data.textureSize ?? Vector2.all(32)
        ),
    );

    add (CircleHitbox(radius: 14, anchor: Anchor.center, position: size / 2));
  }

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);
    if (!_contactoEmitido && other.runtimeType.toString() == 'Fantasmita') {
      _contactoEmitido = true;
      onContacto(data, position);
    }
  }

  void resetearContacto() {
    _contactoEmitido = false;
  }
}
