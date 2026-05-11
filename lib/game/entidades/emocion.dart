import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/collisions.dart';
import 'package:flame/game.dart';
import 'emocion_data.dart';

class Emocion extends SpriteAnimationComponent with HasGameRef, CollisionCallbacks {
  final EmocionData data;
  final bool esFusion;
  bool recolectada = false;
  bool explorada = false;

  final SpriteAnimation? animatioOverride;

  // Callback que se dispara cuando el jugador toca la emoción
  final void Function(EmocionData, Emocion) onContacto;

  Emocion({
    required this.data,
    required Vector2 posicion,
    required this.onContacto,
    this.animatioOverride,
    this.esFusion = false,
  }) {
    position = posicion;
    anchor = Anchor.center;
    size = Vector2(32, 32);
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    if (animatioOverride != null) {
      animation = animatioOverride;
    } else if (data.esPrimaria){
      final sheet = await gameRef.images.load(data.imagen);
      animation = SpriteAnimation.fromFrameData(
        sheet,
        SpriteAnimationData.sequenced(
            amount: data.frameCount,
            stepTime: data.stepTime,
            textureSize: data.textureSize ?? Vector2(32, 32),
        ),
      );
    } else {
      final sheet = await gameRef.images.load(data.imagen);
      animation = SpriteAnimation.fromFrameData(
        sheet,
        SpriteAnimationData.sequenced(
            amount: 1,
            stepTime: 1.0,
            textureSize: data.textureSize ?? Vector2.all(32),
        ),
      );
    }

    add(CircleHitbox(radius: 16, anchor: Anchor.center, position: size / 2));
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);

    if (other.runtimeType.toString() == 'Fantasmita' && !explorada) {
      explorada = true;
      onContacto(data, this);
    }
  }

  // Llamado cuando el jugador confirma que sí sintió la emoción
  void marcarRecolectada() {
    recolectada = true;
    // Efecto visual simple: reducir opacidad para indicar que fue recogida
    paint.color = paint.color.withOpacity(0.4);
  }

  void desaparecer() {
    removeFromParent();
  }
}
