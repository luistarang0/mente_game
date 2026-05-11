import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flame/game.dart';
import 'package:mapa_emocional/ui/hud.dart';
import 'package:mapa_emocional/ui/info_burbuja.dart';
import 'game/entidades/emocion_data.dart';
import 'game/entidades/emocion_fusionada_data.dart';
import 'game/mente_game.dart';
import 'ui/emocion_popup.dart';
import 'ui/fusion_popup.dart';
import 'ui/claridad_mental_bar.dart';
import 'ui/sala_integracion_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const MenteApp());
}

class MenteApp extends StatefulWidget {
  const MenteApp({super.key});

  @override
  State<MenteApp> createState() => _MenteAppState();
}

class _MenteAppState extends State<MenteApp> {
  late final MenteGame _game;

  EmocionData? _emocionActiva;
  EmocionFusionadaData? _fusionActiva;
  EmocionData? _emocionSalaActiva;
  Offset? _posicionBurbuja;

  // HUD: lista de EmocionData visible (primarias + secundarias)
  final List<EmocionData> _hudEmociones = [];

  // Sala de integración
  final List<EmocionFusionadaData> _fusionesDescubiertas = [];

  @override
  void initState() {
    super.initState();
    _game = MenteGame(
      onEmocionContacto: _mostrarPopupEmocion,
      onFusionDescubierta: _mostrarPopupFusion,
      onPuertaContacto: _entrarASala,
      onEmocionSalaContacto: _mostrarInfoSala,
    );
  }

  void _mostrarInfoSala(EmocionData data, Vector2 posicionMundo) {
    // Convierte coordenadas mundo → pantalla
    final posPantalla = _game.camera.localToGlobal(posicionMundo);
    setState(() {
      _emocionSalaActiva = data;
      _posicionBurbuja = Offset(posPantalla.x, posPantalla.y);
    });
  }

  void _cerrarInfoSala() {
    setState(() {
      _emocionSalaActiva = null;
      _posicionBurbuja = null;
    });
  }

  // ── Popup de emoción primaria ─────────────────────────────────

  void _mostrarPopupEmocion(EmocionData data) {
    setState(() => _emocionActiva = data);
  }

  void _cerrarPopupEmocion(bool recolectada) {
    final data = _emocionActiva;
    setState(() => _emocionActiva = null);

    if (recolectada && data != null) {
      // recolectarEmocionActiva puede disparar onFusionDescubierta
      // si se forma un par; en ese caso el juego sigue pausado y
      // _fusionActiva se setea vía callback antes de que setState termine.
      _game.recolectarEmocionActiva();
      if (_fusionActiva == null) {
        // No hubo fusión: añadir al HUD normalmente
        setState(() => _hudEmociones.add(data));
      }
      // Si hubo fusión, _mostrarPopupFusion ya llama setState
    } else {
      _game.reanudarJuego();
    }
  }

  // ── Popup de fusión ───────────────────────────────────────────

  void _mostrarPopupFusion(
    EmocionFusionadaData fusion,
    List<TipoEmocion> fuentesTipos,
  ) {
    setState(() {
      for (final tipo in fuentesTipos) {
        final idx = _hudEmociones.lastIndexWhere((e) => e.tipo == tipo);
        if (idx != -1) _hudEmociones.removeAt(idx);
      }
      _hudEmociones.add(fusion.toEmocionData());
      _fusionesDescubiertas.add(fusion);
      _fusionActiva = fusion;
    });
  }

  void _cerrarPopupFusion() {
    setState(() => _fusionActiva = null);
    _game.cerrarFusionPopup();
  }

  void _entrarASala() {
    setState(() {
      _emocionActiva = null;
      _fusionActiva = null;
    });
    _game.irASala();
  }

  // ── Build ─────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Stack(
          children: [
            GameWidget(game: _game),
            Positioned(
              left: 10,
              top: 10,
              bottom: 10,
              child: HudEmociones(emociones: _hudEmociones),
            ),
            if (_emocionSalaActiva != null && _posicionBurbuja != null)
              InfoBurbuja(
                data: _emocionSalaActiva!,
                posicion: _posicionBurbuja!,
                onCerrar: _cerrarInfoSala,
              ),
            Positioned(
              right: 10,
              bottom: 10,
              child: ClaridadMentalBar(
                interactuadas: _game.emocionesInteractuadas,
                total: MenteGame.totalEmociones,
              ),
            ),
            if (_emocionActiva != null)
              EmocionPopup(
                data: _emocionActiva!,
                onRespuesta: _cerrarPopupEmocion,
              ),
            if (_fusionActiva != null)
              FusionPopup(
                fusion: _fusionActiva!,
                onEntendido: _cerrarPopupFusion,
              ),
          ],
        ),
      ),
    );
  }
}
