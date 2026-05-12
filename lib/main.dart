import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flame/game.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mapa_emocional/ui/hud.dart';
import 'package:mapa_emocional/ui/info_burbuja.dart';
import 'package:mapa_emocional/ui/libro_popup.dart';
import 'game/entidades/emocion_data.dart';
import 'game/entidades/emocion_fusionada_data.dart';
import 'game/mente_game.dart';
import 'ui/emocion_popup.dart';
import 'ui/fusion_popup.dart';
import 'ui/claridad_mental_bar.dart';

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
  late MenteGame _game;

  Key _gameKey = UniqueKey();

  EmocionData? _emocionActiva;
  EmocionFusionadaData? _fusionActiva;
  EmocionData? _emocionSalaActiva;
  Offset? _posicionBurbuja;

  // HUD: lista de EmocionData visible (primarias + secundarias)
  final List<EmocionData> _hudEmociones = [];

  // Sala de integración
  final List<EmocionFusionadaData> _fusionesDescubiertas = [];

  int _burbujaKey = 0;

  bool _libroAbierto = false;

  @override
  void initState() {
    super.initState();
    _game = _crearJuego();
  }

  MenteGame _crearJuego() {
    return MenteGame(
      onEmocionContacto: _mostrarPopupEmocion,
      onFusionDescubierta: _mostrarPopupFusion,
      onPuertaContacto: _entrarASala,
      onEmocionSalaContacto: _mostrarInfoSala,
      onEmocionSalaSalida: _cerrarInfoSala,
      onLibroContacto: _abrirLibro,
    );
  }

  void _mostrarInfoSala(EmocionData data, Vector2 posicionMundo) {
    // Convierte coordenadas mundo → pantalla
    final posPantalla = _game.camera.localToGlobal(posicionMundo);
    setState(() {
      _emocionSalaActiva = data;
      _posicionBurbuja = Offset(posPantalla.x, posPantalla.y);
      _burbujaKey++;
    });
  }

  void _cerrarInfoSala() {
    setState(() {
      _emocionSalaActiva = null;
      _posicionBurbuja = null;
    });
  }

  void _abrirLibro() {
    setState(() => _libroAbierto = true);
  }

  void _cerrarLibro() {
    setState(() => _libroAbierto = false);
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
      home: Builder(
        builder: (ctx) => Scaffold(
          body: Stack(
            children: [
              GameWidget(
                key: _gameKey, // ← fuerza recreación completa
                game: _game,
              ),
              // Positioned(
              //   left: 10,
              //   top: 10,
              //   bottom: 10,
              //   child: HudEmociones(emociones: _hudEmociones),
              // ),
              if (_emocionSalaActiva != null && _posicionBurbuja != null)
                InfoBurbuja(
                  key: ValueKey(_burbujaKey),
                  data: _emocionSalaActiva!,
                  posicion: _posicionBurbuja!,
                ),
              if (_libroAbierto)
                LibroPopup(
                  emociones: _game.emocionesRecolectadas,
                  fusiones: _fusionesDescubiertas,
                  onCerrar: _cerrarLibro,
                ),
              Positioned(
                right: 10,
                bottom: 10,
                child: ClaridadMentalBar(
                  interactuadas: _game.emocionesInteractuadas,
                  total: MenteGame.totalEmociones,
                ),
              ),
              // ── Botón reinicio ──────────────────────────────────
              Positioned(
                top: 30,
                right: 12,
                child: Builder(
                  builder: (ctx) => GestureDetector(
                    onTap: () => _reiniciar(ctx), // ← pasa el contexto local
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.black38,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.white24, width: 1),
                      ),
                      child: const Icon(
                        Icons.refresh,
                        color: Colors.white54,
                        size: 18,
                      ),
                    ),
                  ),
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
      ),
    );
  }

  Future<void> _reiniciar(BuildContext context) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1a0f2e),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: Color(0xFF7c5cbf), width: 2),
        ),
        title: Text(
          '¿Reiniciar sesion?',
          textAlign: TextAlign.center,
          style: GoogleFonts.pixelifySans(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          'Se perdera todo el progreso actual.',
          textAlign: TextAlign.center,
          style: GoogleFonts.pixelifySans(
            color: const Color(0xFFccc0e8),
            fontSize: 12,
          ),
        ),
        actionsAlignment: MainAxisAlignment.spaceEvenly,
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(
              'No',
              style: GoogleFonts.pixelifySans(
                color: const Color(0xFFccc0e8),
                fontSize: 14,
              ),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(
              'Si',
              style: GoogleFonts.pixelifySans(
                color: const Color(0xFFe0aaff),
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );

    if (confirmar != true) return;

    setState(() {
      // Recrear juego
      _game = _crearJuego();
      _gameKey = UniqueKey();

      // Limpiar todo el estado Flutter
      _emocionActiva = null;
      _fusionActiva = null;
      _hudEmociones.clear();
      _fusionesDescubiertas.clear();
      _libroAbierto = false;
      _emocionSalaActiva = null;
      _posicionBurbuja = null;
      _burbujaKey = 0;
    });
  }
}
