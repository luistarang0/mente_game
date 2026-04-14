import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';

class NubeComponent extends SpriteComponent with HasGameRef {
  // Opacidad actual — se usará para el fade out
  double _opacidad = 1.0;
  bool _desvaneciendose = false;

  NubeComponent({required Vector2 posicion}) {
    position = posicion;
    anchor = Anchor.center;
    size = Vector2(96, 54); // 32x18 escalado x3
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    sprite = await gameRef.loadSprite('nube.png');
    paint.color = paint.color.withOpacity(_opacidad);
    add(RectangleHitbox());
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (_desvaneciendose) {
      _opacidad -= dt * 0.5; // velocidad del fade (0.5 = 2 segundos aprox)
      if (_opacidad <= 0) {
        _opacidad = 0;
        removeFromParent();
      }
      paint.color = paint.color.withOpacity(_opacidad);
    }
  }

  void iniciarFade() {
    _desvaneciendose = true;
  }
}
