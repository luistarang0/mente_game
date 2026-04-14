import 'dart:ui' as ui;
import 'package:flame/components.dart';
import 'package:flame/game.dart';

/// Capa de nubes que cubre una zona completa del mapa
/// usando el sprite nubeC.png (32×32) repetido en cada tile.
/// Soporta fade-out y llama a [onDesvanecido] al terminar.
class CapaNubes extends PositionComponent with HasGameRef {
  double _opacidad;
  bool _desvaneciendose = false;
  final void Function()? onDesvanecido;

  late final ui.Image _nubeImage;
  static const double _tileSize = 32.0;

  CapaNubes({
    required Vector2 posicion,
    required Vector2 tamanio,
    this.onDesvanecido,
    double opacidadInicial = 1.0,
  }) : _opacidad = opacidadInicial {
    position = posicion;
    size = tamanio;
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    final sprite = await gameRef.loadSprite('nubeC.png');
    _nubeImage = sprite.image;
  }

  @override
  void render(ui.Canvas canvas) {
    final int cols = (size.x / _tileSize).ceil();
    final int rows = (size.y / _tileSize).ceil();

    final alpha = (_opacidad * 255).clamp(0, 255).round();
    final paint = ui.Paint()
      ..color = ui.Color.fromARGB(alpha, 255, 255, 255);

    final src = ui.Rect.fromLTWH(
      0,
      0,
      _nubeImage.width.toDouble(),
      _nubeImage.height.toDouble(),
    );

    for (int row = 0; row < rows; row++) {
      for (int col = 0; col < cols; col++) {
        final dst = ui.Rect.fromLTWH(
          col * _tileSize,
          row * _tileSize,
          _tileSize,
          _tileSize,
        );
        canvas.drawImageRect(_nubeImage, src, dst, paint);
      }
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (_desvaneciendose) {
      _opacidad -= dt * 0.5; // ~2 segundos para desvanecerse
      if (_opacidad <= 0) {
        _opacidad = 0;
        onDesvanecido?.call();
        removeFromParent();
      }
    }
  }

  bool get desvaneciendose => _desvaneciendose;

  /// Inicia la animación de desvanecimiento (idempotente).
  void iniciarFade() {
    _desvaneciendose = true;
  }
}
