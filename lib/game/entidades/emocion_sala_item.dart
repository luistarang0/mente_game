import 'package:flutter/painting.dart';
import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import '../entidades/emocion_data.dart';

class EmocionSalaItem extends SpriteAnimationComponent
    with HasGameReference, CollisionCallbacks {
  final EmocionData data;
  final bool recolectada;

  /// Solo se llama si [recolectada] es true.
  final void Function(EmocionData, Vector2 posicionMundo)? onEntrada;
  final VoidCallback? onSalida;

  static const double _tamSprite = 32.0;

  EmocionSalaItem({
    required this.data,
    required Vector2 posicion,
    required this.recolectada,
    this.onEntrada,
    this.onSalida,
  }) : super(
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
        textureSize: data.textureSize ?? Vector2.all(32),
      ),
    );

    // Apagada si no fue recolectada
    if (!recolectada) {
      paint.colorFilter = const ColorFilter.matrix([
        0.2126,
        0.7152,
        0.0722,
        0,
        0,
        0.2126,
        0.7152,
        0.0722,
        0,
        0,
        0.2126,
        0.7152,
        0.0722,
        0,
        0,
        0,
        0,
        0,
        1,
        0,
      ]);
      paint.color = paint.color.withValues(alpha: 0.4);
    }

    // Solo las recolectadas tienen hitbox
    if (recolectada) {
      add(
        CircleHitbox(
          radius: 18,
          anchor: Anchor.center,
          position: size / 2,
          isSolid: true,
        ),
      );
    }
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);
    if (other.runtimeType.toString() == 'Fantasmita') {
      onEntrada?.call(data, position);
    }
  }

  @override
  void onCollisionEnd(PositionComponent other) {
    super.onCollisionEnd(other);
    if (other.runtimeType.toString() == 'Fantasmita') {
      onSalida?.call();
    }
  }
}
