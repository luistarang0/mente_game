import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:mapa_emocional/game/entidades/fantasmita.dart';
import 'package:mapa_emocional/game/entidades/emocion.dart';
import 'package:mapa_emocional/game/entidades/emocion_data.dart';
import 'package:mapa_emocional/game/entidades/emocion_fusionada_data.dart';
import 'package:mapa_emocional/game/mapa/capa_nubes.dart';
import 'package:mapa_emocional/game/entidades/puerta_integracion.dart';
import 'package:mapa_emocional/game/entidades/emocion_sala_item.dart';

/// Entrada del historial de emociones primarias recolectadas.
/// [usadoEnFusion] se activa cuando esta instancia concreta participa
/// en una fusión; no impide que el mismo tipo aparezca de nuevo.
class _PrimarioRecolectado {
  final TipoEmocion tipo;
  bool usadoEnFusion = false;
  _PrimarioRecolectado(this.tipo);
}

///
/// El jugador empieza en el centro de la Zona 1 y va avanzando
/// hacia arriba (Y decreciente) a medida que desbloquea zonas.
class MenteGame extends FlameGame with DragCallbacks, HasCollisionDetection {
  final void Function(EmocionData) onEmocionContacto;

  /// Llamado cuando dos primarias forman una fusión al ser recolectadas.
  final void Function(EmocionFusionadaData, List<TipoEmocion>) onFusionDescubierta;
  final void Function(EmocionData data, Vector2 posicionMundo) onEmocionSalaContacto;

  /// Llamado cuando el jugador toca la puerta de integración.
  final VoidCallback onPuertaContacto;

  MenteGame({
    required this.onEmocionContacto,
    required this.onFusionDescubierta,
    required this.onPuertaContacto,
    required this.onEmocionSalaContacto,
  });

  // ── Entidades ────────────────────────────────────────────────
  late Fantasmita _fantasmita;
  late TiledComponent _mapa;
  late TileLayer _capaAgua;
  Emocion? _emocionActiva;
  EmocionData? _ultimaEmocionContacto;

  // ── Control ──────────────────────────────────────────────────
  Vector2? _joystickOrigen;
  bool _pausado = false;
  late Vector2 _posicionAnterior;

  // ── Progresión por zonas ─────────────────────────────────────
  int _zonaActual = 1;
  final Map<int, CapaNubes> _capasNubes = {};

  static const int _margenTiles = 7;
  static const int _alturaZonaTiles = 15;
  static const int _emocionsPorZona = 3;
  static const int _totalZonas = 4;
  static const int totalEmociones = 12; // 3 por zona × 4 zonas

  // ── Colección ────────────────────────────────────────────────
  final List<EmocionData> emocionesRecolectadas = [];
  /// Interacciones totales (Sí + No). Base del % de claridad mental.
  int emocionesInteractuadas = 0;

  // ── Fusión en tiempo real ────────────────────────────────────
  /// Historial de emociones primarias recolectadas.
  /// Cada entrada se marca como [usada] cuando participa en una fusión,
  /// pero la emoción sigue en el historial y puede combinarse con otras.
  final List<_PrimarioRecolectado> _historialPrimarias = [];
  /// Pares ya fusionados: clave canónica "a-b". Evita repetir la misma fusión.
  final Set<String> _fusionesRealizadas = {};
  /// Flag: popup de fusión abierto. Mantiene el juego pausado.
  bool _fusionPendiente = false;

  // ── Spawn de Zona 1 ──────────────────────────────────────────
  /// Registra qué tipos se spawnearon en Zona 1 para garantizar
  /// el faltante en Zona 2.
  final Set<TipoEmocion> _tiposSpawneadosEnZona1 = {};

  // ── Puerta de integración ─────────────────────────────────────
  bool _puertaMostrada = false;
  /// True cuando ya se cargó la sala final. Desactiva toda la lógica del mapa principal.
  bool _enSala = false;

  // ════════════════════════════════════════════════════════════
  //  CICLO DE VIDA
  // ════════════════════════════════════════════════════════════

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    _mapa = await TiledComponent.load('Tapiz base.tmx', Vector2.all(32));
    world.add(_mapa);

    _capaAgua = _mapa.tileMap.getLayer<TileLayer>('Agua')!;

    _crearCapasNubes();
    _spawnEmocionesEnZona(1);

    _fantasmita = Fantasmita();
    _fantasmita.position = Vector2(
      _mapa.tileMap.map.width * 32 / 2,
      (_mapa.tileMap.map.height - _margenTiles - _alturaZonaTiles / 2) * 32,
    );
    world.add(_fantasmita);
    _posicionAnterior = _fantasmita.position.clone();

    camera.viewfinder.zoom = 2.0;
    camera.follow(_fantasmita);
  }

  @override
  void update(double dt) {
    super.update(dt);

    _aplicarBarreras();
    _verificarColisionAgua();

    if (!_enSala) {
      _verificarProximidadEmociones();
    }

    final pos = camera.viewfinder.position;
    camera.viewfinder.position = Vector2(
      pos.x.roundToDouble(),
      pos.y.roundToDouble(),
    );
  }

  // ════════════════════════════════════════════════════════════
  //  ZONAS Y NUBES
  // ════════════════════════════════════════════════════════════

  int _filaInicioZona(int zona) {
    final H = _mapa.tileMap.map.height;
    return H - _margenTiles - zona * _alturaZonaTiles;
  }

  void _crearCapasNubes() {
    final mapWidth = _mapa.tileMap.map.width * 32.0;
    for (int zona = 2; zona <= _totalZonas; zona++) {
      final fila = _filaInicioZona(zona);
      final capa = CapaNubes(
        posicion: Vector2(0, fila * 32.0),
        tamanio: Vector2(mapWidth, _alturaZonaTiles * 32.0),
        onDesvanecido: () => _alDesvanecerCapa(zona),
      );
      _capasNubes[zona] = capa;
      world.add(capa);
    }
  }

  void _desbloquearSiguienteZona() {
    final siguienteZona = _zonaActual + 1;
    final capa = _capasNubes[siguienteZona];
    if (capa != null && !capa.desvaneciendose) {
      capa.iniciarFade();
    }
  }

  void _alDesvanecerCapa(int zona) {
    _zonaActual = zona;
    _spawnEmocionesEnZona(zona);
  }

  void _aplicarBarreras() {
    final H = _mapa.tileMap.map.height;
    final W = _mapa.tileMap.map.width;

    final double minY;
    final double maxY;

    if (_enSala) {
      // En la sala usamos los límites completos del mapa
      minY = 0.0;
      maxY = H * 32.0;
    } else {
      minY = _filaInicioZona(_zonaActual) * 32.0;
      maxY = (H - _margenTiles) * 32.0;
    }

    _fantasmita.position = Vector2(
      _fantasmita.position.x.clamp(0.0, W * 32.0),
      _fantasmita.position.y.clamp(minY, maxY),
    );
  }

  // ════════════════════════════════════════════════════════════
  //  COLISIÓN CON AGUA
  // ════════════════════════════════════════════════════════════

  bool _esAgua(int tileX, int tileY) {
    final H = _mapa.tileMap.map.height;
    final W = _mapa.tileMap.map.width;
    if (tileY < 0 || tileY >= H || tileX < 0 || tileX >= W) return true;
    final tile = _capaAgua.tileData![tileY][tileX];
    return tile.tile != 0;
  }

  bool _hayAguaCerca(double x, double y) {
    const margen = 10.0;
    const ts = 32.0;
    return _esAgua(((x - margen) / ts).floor(), ((y - margen) / ts).floor()) ||
        _esAgua(((x + margen) / ts).floor(), ((y - margen) / ts).floor()) ||
        _esAgua(((x - margen) / ts).floor(), ((y + margen) / ts).floor()) ||
        _esAgua(((x + margen) / ts).floor(), ((y + margen) / ts).floor());
  }

  void _verificarColisionAgua() {
    final pos = _fantasmita.position;
    if (_hayAguaCerca(pos.x, _posicionAnterior.y)) {
      _fantasmita.position.x = _posicionAnterior.x;
    }
    if (_hayAguaCerca(_fantasmita.position.x, pos.y)) {
      _fantasmita.position.y = _posicionAnterior.y;
    }
    _posicionAnterior = _fantasmita.position.clone();
  }

  // ════════════════════════════════════════════════════════════
  //  EMOCIONES — SPAWN
  // ════════════════════════════════════════════════════════════

  /// Las 4 primarias de Zona 1. Se eligen 3 al azar al inicio.
  static const _tiposZona1 = [
    TipoEmocion.miedo,
    TipoEmocion.ira,
    TipoEmocion.tristeza,
    TipoEmocion.anticipacion,
  ];

  /// Spawna 3 emociones primarias en [zona]. Las fusiones ya NO se
  /// colocan en el mundo; se descubren al momento de recolectar.
  ///
  /// Zona 1 : 3 al azar de las 4 primarias.
  /// Zona 2 : la primaria faltante de Zona 1 (slot 1) + 2 más de las 4.
  /// Zona 3 : alegría (slot 1) + 2 primarias de las 4.
  /// Zona 4 : 3 al azar de las 4 primarias.
  void _spawnEmocionesEnZona(int zona) {
    final random = Random();
    final H = _mapa.tileMap.map.height;
    final W = _mapa.tileMap.map.width;

    if (zona == 1) {
      final pool = catalogoEmociones
          .where((e) => _tiposZona1.contains(e.tipo))
          .toList()
        ..shuffle(random);
      for (final data in pool.sublist(0, _emocionsPorZona)) {
        _tiposSpawneadosEnZona1.add(data.tipo);
        world.add(Emocion(
          data: data,
          posicion: _posicionAleatEnZona(zona, random, H, W),
          onContacto: _alTocarEmocion,
        ));
      }
      return;
    }

    var slotsRestantes = _emocionsPorZona;

    if (zona == 2) {
      // Garantizar la primaria que no apareció en Zona 1
      final faltante = _tiposZona1.firstWhere(
        (t) => !_tiposSpawneadosEnZona1.contains(t),
        orElse: () => _tiposZona1[random.nextInt(_tiposZona1.length)],
      );
      final data = catalogoEmociones.firstWhere((e) => e.tipo == faltante);
      world.add(Emocion(
        data: data,
        posicion: _posicionAleatEnZona(zona, random, H, W),
        onContacto: _alTocarEmocion,
      ));
      slotsRestantes--;
    }

    if (zona == 3) {
      // Alegría garantizada en slot 1
      final alegria =
          catalogoEmociones.firstWhere((e) => e.tipo == TipoEmocion.alegria);
      world.add(Emocion(
        data: alegria,
        posicion: _posicionAleatEnZona(zona, random, H, W),
        onContacto: _alTocarEmocion,
      ));
      slotsRestantes--;
    }

    // Slots restantes: cualquier primaria del catálogo al azar
    final pool = List<EmocionData>.from(catalogoEmociones)..shuffle(random);
    for (final data in pool.take(slotsRestantes)) {
      world.add(Emocion(
        data: data,
        posicion: _posicionAleatEnZona(zona, random, H, W),
        onContacto: _alTocarEmocion,
      ));
    }
  }

  Vector2 _posicionAleatEnZona(int zona, Random random, int H, int W) {
    const margen = 3;
    final fila = _filaInicioZona(zona);
    final minY = (fila + margen) * 32.0;
    final maxY = (fila + _alturaZonaTiles - margen) * 32.0;
    final minX = margen * 32.0;
    final maxX = (W - margen) * 32.0;

    Vector2 pos;
    int intentos = 0;
    do {
      pos = Vector2(
        minX + random.nextDouble() * (maxX - minX),
        minY + random.nextDouble() * (maxY - minY),
      );
      intentos++;
    } while (
        _esAgua((pos.x / 32).floor(), (pos.y / 32).floor()) &&
        intentos < 100);
    return pos;
  }

  // ════════════════════════════════════════════════════════════
  //  EMOCIONES — INTERACCIÓN Y FUSIÓN
  // ════════════════════════════════════════════════════════════

  void _verificarProximidadEmociones() {
    for (final child in world.children) {
      if (child is Emocion && !child.explorada) {
        if (_fantasmita.position.distanceTo(child.position) < 24) {
          child.explorada = true;
          _alTocarEmocion(child.data, child);
          break;
        }
      }
    }
  }

  void _alTocarEmocion(EmocionData data, Emocion emocion) {
    _emocionActiva = emocion;
    _ultimaEmocionContacto = data;
    _pausado = true;
    _fantasmita.actualizarDireccion(Vector2.zero());
    onEmocionContacto(data);
  }

  /// Clave canónica de un par de tipos (orden alfabético, evita duplicados A-B / B-A).
  String _clavePar(TipoEmocion a, TipoEmocion b) {
    final sorted = [a.name, b.name]..sort();
    return '${sorted[0]}-${sorted[1]}';
  }

  void _verificarDesbloqueo() {
    if (_zonaActual >= _totalZonas) return;
    final umbral = _zonaActual * _emocionsPorZona; // 3 → 6 → 9
    if (emocionesInteractuadas >= umbral) {
      _desbloquearSiguienteZona();
    }
  }

  /// Condición RF08: todas las emociones interactuadas O entre 6 y 8 recolectadas.
  bool get _debeMostrarPuerta =>
      !_puertaMostrada &&
      (emocionesInteractuadas >= totalEmociones ||
          (emocionesRecolectadas.length >= 6 &&
              emocionesRecolectadas.length <= 8));

  void _verificarPuerta() {
    if (!_debeMostrarPuerta) return;
    _puertaMostrada = true;
    _mostrarPuerta();
  }

  /// Coloca la puerta 2 tiles por encima de la posición actual del jugador.
  void _mostrarPuerta() {
    const tileSize = 32.0;
    final px = _fantasmita.position.x;
    final py = _fantasmita.position.y - 5 * tileSize;
    world.add(PuertaIntegracion(
      posicion: Vector2(px, py),
      onContacto: onPuertaContacto,
    ));
  }

  // ════════════════════════════════════════════════════════════
  //  API PÚBLICA
  // ════════════════════════════════════════════════════════════

  /// Llamado cuando el jugador responde "Sí" al popup de emoción.
  /// Registra la emoción, comprueba fusiones y, si hay una nueva,
  /// llama a [onFusionDescubierta] y mantiene el juego pausado.
  void recolectarEmocionActiva() {
    if (_ultimaEmocionContacto == null) {
      _pausado = false;
      return;
    }

    final data = _ultimaEmocionContacto!;
    emocionesRecolectadas.add(data);
    _emocionActiva?.desaparecer();
    _emocionActiva = null;
    _ultimaEmocionContacto = null;
    emocionesInteractuadas++;
    _verificarDesbloqueo();
    _verificarPuerta();

    // ── Comprobar fusión con cualquier primaria recolectada ──────
    // Busca la entrada más reciente del historial que:
    //   1. No haya sido ya usada en una fusión.
    //   2. No sea del mismo tipo que la recién recolectada.
    //   3. Forme un par que aún no se haya fusionado.
    EmocionFusionadaData? fusionDescubierta;
    _PrimarioRecolectado? entradaPareja;

    for (int i = _historialPrimarias.length - 1; i >= 0; i--) {
      final entrada = _historialPrimarias[i];
      if (entrada.usadoEnFusion) continue;
      if (entrada.tipo == data.tipo) continue;

      final clave = _clavePar(entrada.tipo, data.tipo);
      if (_fusionesRealizadas.contains(clave)) continue;

      final f = buscarFusion(entrada.tipo, data.tipo);
      if (f != null) {
        fusionDescubierta = f;
        entradaPareja = entrada;
        break;
      }
    }

    // Añadir la nueva al historial (después de buscar para no compararse consigo)
    _historialPrimarias.add(_PrimarioRecolectado(data.tipo));

    if (fusionDescubierta != null) {
      // Marcar ambas entradas como usadas
      entradaPareja!.usadoEnFusion = true;
      _historialPrimarias.last.usadoEnFusion = true;
      _fusionesRealizadas.add(_clavePar(entradaPareja.tipo, data.tipo));

      _fusionPendiente = true;
      onFusionDescubierta(fusionDescubierta, [entradaPareja.tipo, data.tipo]);
      return;
    }

    _pausado = false;
  }

  /// Llamado cuando el jugador responde "No" al popup de emoción.
  /// Si hay una fusión pendiente (popup de fusión abierto), no hace nada.
  void reanudarJuego() {
    if (_fusionPendiente) return;
    if (_ultimaEmocionContacto != null) {
      _emocionActiva?.desaparecer();
      _emocionActiva = null;
      _ultimaEmocionContacto = null;
      emocionesInteractuadas++;
      _verificarDesbloqueo();
      _verificarPuerta();
    }
    _pausado = false;
  }

  /// Llamado cuando el jugador cierra el popup de fusión.
  void cerrarFusionPopup() {
    _fusionPendiente = false;
    _pausado = false;
  }

  // ════════════════════════════════════════════════════════════
  //  SALA DE INTEGRACIÓN
  // ════════════════════════════════════════════════════════════

  /// Llamado desde main.dart al tocar la puerta.
  /// Carga la sala, coloca al jugador y muestra las emociones recolectadas.
  Future<void> irASala() async {
    _enSala = true;
    _pausado = true;

    // Limpiar todo el mundo (mapa viejo, nubes, emociones, fantasmita anterior)
    world.children.toList().forEach((c) => c.removeFromParent());

    // Cargar nuevo mapa y actualizar referencia para barreras y colisión de agua
    final sala = await TiledComponent.load('Sala.tmx', Vector2.all(32));
    _mapa = sala;
    _capaAgua = sala.tileMap.getLayer<TileLayer>('Agua')!;
    world.add(sala);

    // Crear fantasmita nuevo en el centro de la sala
    _fantasmita = Fantasmita();
    _fantasmita.position = Vector2(
      sala.tileMap.map.width * 32 / 2.0,
      sala.tileMap.map.height * 32 / 2.0,
    );
    world.add(_fantasmita);
    _posicionAnterior = _fantasmita.position.clone();

    // Mostrar emociones recolectadas en fila horizontal
    _spawnEmocionesEnSala(sala, emocionesRecolectadas);

    camera.viewfinder.zoom = 2.0;
    camera.follow(_fantasmita);
    _pausado = false;
  }

  /// Coloca los items de emoción en una fila horizontal centrada en la sala.
  void _spawnEmocionesEnSala(TiledComponent sala, List<EmocionData> emociones) {
    final vistas = <TipoEmocion> {};
    final primarias = emociones.where((e) {
      if (!e.esPrimaria) return false;
      if (vistas.contains(e.tipo)) return false;
      vistas.add(e.tipo);
      return true;
    }).toList();

    if (primarias.isEmpty) return;

    const itemAncho = 48.0;
    final salaAncho = sala.tileMap.map.width * 32.0;
    final salaAlto = sala.tileMap.map.height * 32.0;

    final filaTotal = primarias.length * itemAncho;
    final startX = (salaAncho - filaTotal) / 2 + itemAncho / 2;
    final posY = salaAlto * 0.35;

    for (int i=0; i<primarias.length; i++) {
      world.add(EmocionSalaItem(
          data: primarias[i],
          posicion: Vector2(startX + i * itemAncho, posY),
          onContacto: onEmocionSalaContacto,
      ));
    }
  }

  // ════════════════════════════════════════════════════════════
  //  CONTROLES (drag = joystick virtual)
  // ════════════════════════════════════════════════════════════

  @override
  void onDragStart(DragStartEvent event) {
    super.onDragStart(event);
    if (_pausado) return;
    _joystickOrigen = event.canvasPosition.clone();
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    super.onDragUpdate(event);
    if (_pausado || _joystickOrigen == null) return;
    final delta = event.canvasStartPosition - _joystickOrigen!;
    if (delta.length > 10) {
      _fantasmita.actualizarDireccion(delta);
    } else {
      _fantasmita.actualizarDireccion(Vector2.zero());
    }
  }

  @override
  void onDragEnd(DragEndEvent event) {
    super.onDragEnd(event);
    _joystickOrigen = null;
    if (!_pausado) _fantasmita.actualizarDireccion(Vector2.zero());
  }

  @override
  void onDragCancel(DragCancelEvent event) {
    super.onDragCancel(event);
    _joystickOrigen = null;
    if (!_pausado) _fantasmita.actualizarDireccion(Vector2.zero());
  }
}
