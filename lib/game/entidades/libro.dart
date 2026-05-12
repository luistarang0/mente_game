import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/collisions.dart';

class Libro extends SpriteAnimationComponent
    with HasGameReference, CollisionCallbacks {
  final VoidCallback onContacto;

  static const double _tam = 32.0;

  Libro({required Vector2 posicion, required this.onContacto})
    : super(position: posicion, size: Vector2.all(_tam), anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    final sheet = await game.images.load('libro.png');
    animation = SpriteAnimation.fromFrameData(
      sheet,
      SpriteAnimationData.sequenced(
        amount: 2,
        stepTime: 0.5,
        textureSize: Vector2.all(32),
      ),
    );
  }
}
