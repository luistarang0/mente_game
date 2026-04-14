import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';

class Fantasmita extends SpriteAnimationComponent
    with HasGameRef, CollisionCallbacks {
  // Velocidad de movimiento en píxeles por segundo
  static const double velocidad = 60.0;

  // Dirección actual del joystick (Vector2.zero = quieto)
  Vector2 direccion = Vector2.zero();

  late SpriteAnimation _animacionCaminar;
  late SpriteAnimation _animacionIdle;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // Cargar el spritesheet
    final spriteSheet = await gameRef.images.load('fantasmita.png');

    // Definir la animación: 2 frames de 32x32, a 6 fps
    _animacionCaminar = SpriteAnimation.fromFrameData(
      spriteSheet,
      SpriteAnimationData.sequenced(
        amount: 2, // cantidad de frames
        stepTime: 0.1, // segundos por frame (ajustá a tu gusto)
        textureSize: Vector2(32, 32),
      ),
    );

    _animacionIdle = SpriteAnimation.fromFrameData(
      spriteSheet,
      SpriteAnimationData.sequenced(
        amount: 2,
        stepTime: 0.4,
        textureSize: Vector2(32, 32),
      ),
    );

    animation = _animacionIdle;
    size = Vector2(32, 32);
    anchor = Anchor.center;

    add(CircleHitbox(radius: 12, anchor: Anchor.center, position: size / 2));
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (direccion.isZero()) {
      if (animation != _animacionIdle) {
        animation = _animacionIdle;
      }
      return;
    }

    if (animation != _animacionCaminar) {
      animation = _animacionCaminar;
    }

    // Espejear sprite según dirección horizontal
    if (direccion.x < 0) {
      // Va a la izquierda — espejear horizontalmente
      scale.x = -1.0;
    } else if (direccion.x > 0) {
      // Va a la derecha — orientación normal
      scale.x = 1.0;
    }
    // Si x == 0 (solo arriba/abajo) mantiene la última dirección

    // Mover el fantasmita
    position += direccion.normalized() * velocidad * dt;
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);
    if (other is RectangleHitbox &&
        other.parent.runtimeType.toString() == 'NubeComponent') {
      position -= direccion.normalized() * 4;
    }
  }

  // Llamado desde el game cuando el joystick cambia
  void actualizarDireccion(Vector2 nuevaDireccion) {
    direccion = nuevaDireccion;
  }
}
