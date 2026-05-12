import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../game/entidades/emocion_data.dart';
import '../game/entidades/emocion_fusionada_data.dart';
import '../game/utilidades/narrativa_estres.dart';

const _bgColor = Color(0xFF1a0f2e);
const _accentColor = Color(0xFF7c5cbf);
const _accentLight = Color(0xFFb08ee8);
const _textSecondary = Color(0xFFccc0e8);

class LibroPopup extends StatefulWidget {
  final List<EmocionData> emociones;
  final List<EmocionFusionadaData> fusiones;
  final VoidCallback onCerrar;

  const LibroPopup({
    super.key,
    required this.emociones,
    required this.fusiones,
    required this.onCerrar,
  });

  @override
  State<LibroPopup> createState() => _LibroPopupState();
}

class _LibroPopupState extends State<LibroPopup>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _fade;
  late final List<Widget> _paginas;
  int _paginaActual = 0;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _ctrl.forward();
    _paginas = _construirPaginas();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  List<Widget> _construirPaginas() {
    final tieneEmociones = widget.emociones.any((e) => e.esPrimaria);

    if (!tieneEmociones) {
      return [
        _PaginaTexto(
          titulo: 'Un momento de silencio',
          contenido:
              'Ninguna emocion fue reconocida esta vez, y eso tambien '
              'es informacion.\n\nCuando el estres se vuelve cronico, el '
              'sistema emocional puede entrar en modo de bloqueo, evitacion '
              'o desconexion. Las emociones siguen activas, pero se vuelven '
              'dificiles de nombrar o de sentir con claridad.',
        ),
        _PaginaTexto(
          titulo: 'Estres cronico y desconexion',
          contenido:
              'El estres sostenido puede llevar a tres patrones comunes:\n\n'
              'Bloqueo: dificultad para sentir cualquier emocion.\n\n'
              'Evitacion: moverse rapido para no detenerse a sentir.\n\n'
              'Desconexion: sentirse en piloto automatico, sin registro '
              'emocional claro.\n\nReconocer en cual de estos estas es ya '
              'un primer paso importante.',
        ),
        _PaginaTexto(
          titulo: 'El primer paso',
          contenido:
              'No necesitas identificar con precision lo que sientes. '
              'Basta con prestar atencion:\n\n'
              '¿Hay tension en el cuerpo?\n'
              '¿Hay algo que te cuesta sostener?\n'
              '¿Hay algo que preferirías no pensar?\n\n'
              'Esas señales tambien son emociones esperando ser reconocidas.',
        ),
      ];
    }

    final paginas = <Widget>[];

    // Página 1 — narrativa de estrés
    paginas.add(
      _PaginaTexto(
        titulo: 'Tu relacion con el estres',
        contenido: generarNarrativaEstres(
          emociones: widget.emociones,
          fusiones: widget.fusiones,
        ),
      ),
    );

    // Página por cada fusión descubierta
    for (final fusion in widget.fusiones) {
      paginas.add(_PaginaFusion(fusion: fusion));
    }

    // Última página — mensaje de cierre
    paginas.add(
      const _PaginaTexto(
        titulo: 'Las emociones son señales,\nno obstaculos.',
        contenido:
            'Cada emocion que reconociste tiene una razon de ser. '
            'Nombrarlas no las elimina, pero si reduce su poder sobre ti.\n\n'
            'Este mapa es un punto de partida para conocerte mejor y '
            'relacionarte con mas conciencia con lo que sientes.',
      ),
    );

    return paginas;
  }

  void _irA(int index) {
    if (index < 0 || index >= _paginas.length) return;
    setState(() => _paginaActual = index);
  }

  Future<void> _cerrar() async {
    await _ctrl.reverse();
    widget.onCerrar();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FadeTransition(
        opacity: _fade,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 28, vertical: 60),
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
          decoration: BoxDecoration(
            color: _bgColor,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: _accentColor, width: 2),
            boxShadow: const [
              BoxShadow(
                color: Colors.black54,
                blurRadius: 12,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Barra superior con indicador y botón cerrar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${_paginaActual + 1} / ${_paginas.length}',
                    style: GoogleFonts.pixelifySans(
                      color: _accentLight.withValues(alpha: 0.9),
                      fontSize: 14,
                      letterSpacing: 1,
                    ),
                  ),
                  GestureDetector(
                    onTap: _cerrar,
                    child: Icon(
                      Icons.close,
                      color: _accentLight.withValues(alpha: 0.6),
                      size: 18,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Contenido de la página actual
              _paginas[_paginaActual],

              const SizedBox(height: 20),

              // Navegación
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _BotonPagina(
                    icono: Icons.chevron_left,
                    activo: _paginaActual > 0,
                    onTap: () => _irA(_paginaActual - 1),
                  ),
                  Text(
                    _paginaActual == _paginas.length - 1
                        ? 'Fin del registro'
                        : 'Siguiente pagina',
                    style: GoogleFonts.pixelifySans(
                      color: _accentLight.withValues(alpha: 0.5),
                      fontSize: 11,
                    ),
                  ),
                  _BotonPagina(
                    icono: Icons.chevron_right,
                    activo: _paginaActual < _paginas.length - 1,
                    onTap: () => _irA(_paginaActual + 1),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Página de texto genérica ──────────────────────────────────────────────────

class _PaginaTexto extends StatelessWidget {
  final String titulo;
  final String contenido;

  const _PaginaTexto({required this.titulo, required this.contenido});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          titulo,
          textAlign: TextAlign.center,
          style: GoogleFonts.pixelifySans(
            color: _accentLight,
            fontSize: 18,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 14),
        ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 240),
          child: SingleChildScrollView(
            child: Text(
              contenido,
              style: GoogleFonts.pixelifySans(
                color: _textSecondary,
                fontSize: 15,
                height: 1.7,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ── Página de fusión con imagen ───────────────────────────────────────────────

class _PaginaFusion extends StatelessWidget {
  final EmocionFusionadaData fusion;

  const _PaginaFusion({required this.fusion});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Encabezado: imagen + nombre
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.white10,
                border: Border.all(
                  color: _accentColor.withValues(alpha: 0.5),
                  width: 1,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(7),
                child: Image.asset(
                  'assets/images/${fusion.imagen}',
                  filterQuality: FilterQuality.none,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Flexible(
              child: Text(
                fusion.nombre,
                style: GoogleFonts.pixelifySans(
                  color: _accentLight,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),

        // Componentes de la fusión
        Text(
          '${fusion.componente1.name} + ${fusion.componente2.name}',
          style: GoogleFonts.pixelifySans(
            color: _accentLight.withValues(alpha: 0.5),
            fontSize: 13,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 14),

        // Descripción
        ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 200),
          child: SingleChildScrollView(
            child: Text(
              fusion.descripcion,
              style: GoogleFonts.pixelifySans(
                color: _textSecondary,
                fontSize: 15,
                height: 1.7,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ── Botón de navegación ───────────────────────────────────────────────────────

class _BotonPagina extends StatelessWidget {
  final IconData icono;
  final bool activo;
  final VoidCallback onTap;

  const _BotonPagina({
    required this.icono,
    required this.activo,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: activo ? onTap : null,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: activo
              ? _accentColor.withValues(alpha: 0.3)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: activo ? _accentColor : _accentColor.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        child: Icon(
          icono,
          color: activo ? _accentLight : _accentLight.withValues(alpha: 0.2),
          size: 20,
        ),
      ),
    );
  }
}
