import 'dart:ui' as ui;
import 'package:flutter/foundation.dart';
import 'package:flame/components.dart';
import 'package:flame/collisions.dart';

/// Puerta de la sala de integración emocional.
/// Se compone de dos sprites (arriba/abajo) y hace fade-in al aparecer.
/// Emite [onContacto] cuando el fantasmita la toca.
class PuertaIntegracion extends PositionComponent
    with HasGameReference, CollisionCallbacks {
  final VoidCallback onContacto;

  double _opacidad = 0.0;
  bool _apareciendo = true;
  bool _contactoEmitido = false;

  static const double _velocidadFade = 0.8; // segundos para llegar a opaco
  static const double _anchoTile = 32.0;
  static const double _altoTotal = _anchoTile * 2; // 2 tiles de alto

  late final ui.Image _imgArriba;
  late final ui.Image _imgAbajo;

  PuertaIntegracion({
    required Vector2 posicion,
    required this.onContacto,
  }) {
    // La posición es el tile superior de la puerta
    position = posicion;
    size = Vector2(_anchoTile, _altoTotal);
    anchor = Anchor.topCenter;
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    final spriteArriba = await game.loadSprite('puertaArriba.png');
    final spriteAbajo = await game.loadSprite('puertaAbajo.png');
    _imgArriba = spriteArriba.image;
    _imgAbajo = spriteAbajo.image;

    add(RectangleHitbox(
      size: Vector2(_anchoTile, _altoTotal),
      anchor: Anchor.topLeft,
    ));
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (_apareciendo) {
      _opacidad = (_opacidad + dt * _velocidadFade).clamp(0.0, 1.0);
      if (_opacidad >= 1.0) _apareciendo = false;
    }
  }

  @override
  void render(ui.Canvas canvas) {
    final alpha = (_opacidad * 255).round().clamp(0, 255);
    final paint = ui.Paint()..color = ui.Color.fromARGB(alpha, 255, 255, 255);

    final srcArriba = ui.Rect.fromLTWH(
      0, 0,
      _imgArriba.width.toDouble(),
      _imgArriba.height.toDouble(),
    );
    final srcAbajo = ui.Rect.fromLTWH(
      0, 0,
      _imgAbajo.width.toDouble(),
      _imgAbajo.height.toDouble(),
    );

    canvas.drawImageRect(
      _imgArriba,
      srcArriba,
      ui.Rect.fromLTWH(0, 0, _anchoTile, _anchoTile),
      paint,
    );
    canvas.drawImageRect(
      _imgAbajo,
      srcAbajo,
      ui.Rect.fromLTWH(0, _anchoTile, _anchoTile, _anchoTile),
      paint,
    );
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);
    if (!_contactoEmitido &&
        other.runtimeType.toString() == 'Fantasmita') {
      _contactoEmitido = true;
      onContacto();
    }
  }
}
