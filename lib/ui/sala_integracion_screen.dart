import 'package:flutter/material.dart';
import '../game/entidades/emocion_data.dart';
import '../game/entidades/emocion_fusionada_data.dart';

// ── Funcion adaptativa de cada emocion primaria ──────────────────────────────
const Map<TipoEmocion, String> _funciones = {
  TipoEmocion.alegria:
      'Reconoce lo que vale la pena en tu vida y te impulsa a buscar mas de ello.',
  TipoEmocion.tristeza:
      'Señala perdidas importantes y te invita a reflexionar o buscar apoyo.',
  TipoEmocion.miedo:
      'Detecta amenazas reales o percibidas y te prepara para protegerte.',
  TipoEmocion.ira:
      'Marca tus limites y te da energia para defenderlos.',
  TipoEmocion.sorpresa:
      'Redirige tu atencion hacia lo nuevo e inesperado para que puedas adaptarte.',
  TipoEmocion.aversion:
      'Te aleja de lo que percibe como dañino o contrario a tus valores.',
  TipoEmocion.anticipacion:
      'Te impulsa a planear y actuar antes de que ocurra algo importante.',
  TipoEmocion.aceptacion:
      'Te permite recibir la realidad con calma y abrirte a lo que viene.',
};

// ── Paleta ────────────────────────────────────────────────────────────────────
const _bgColor = Color(0xFF0d0618);
const _cardColor = Color(0xFF1a0f2e);
const _accentColor = Color(0xFF7c5cbf);
const _accentLight = Color(0xFFb08ee8);
const _textPrimary = Colors.white;
const _textSecondary = Color(0xFFccc0e8);

// ═════════════════════════════════════════════════════════════════════════════
//  PANTALLA PRINCIPAL
// ═════════════════════════════════════════════════════════════════════════════

class SalaIntegracionScreen extends StatelessWidget {
  /// Todas las EmocionData visibles en el HUD al entrar a la sala.
  final List<EmocionData> emociones;

  /// Objetos completos de fusion descubiertos durante la partida.
  final List<EmocionFusionadaData> fusiones;

  const SalaIntegracionScreen({
    super.key,
    required this.emociones,
    required this.fusiones,
  });

  List<EmocionData> get _primarias =>
      emociones.where((e) => e.esPrimaria).toList();

  bool get _sinEmociones => emociones.isEmpty;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: _bgColor,
      child: SafeArea(
        child: _sinEmociones ? _buildVacio() : _buildConEmociones(),
      ),
    );
  }

  // ── 9.1 Jugador CON emociones ────────────────────────────────────────────

  Widget _buildConEmociones() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _Encabezado(
            icono: Icons.auto_awesome,
            titulo: 'Tu Mapa Emocional',
            subtitulo:
                'Este es el registro de tu experiencia emocional durante la sesion.',
          ),
          const SizedBox(height: 24),
          _SeccionCard(
            titulo: 'EMOCIONES PRESENTES',
            child: _MapaVisual(emociones: emociones),
          ),
          const SizedBox(height: 16),
          _SeccionCard(
            titulo: 'TU RELACION CON EL ESTRES',
            child: _NarrativaEstres(
              primarias: _primarias,
              fusiones: fusiones,
            ),
          ),
          const SizedBox(height: 16),
          _SeccionCard(
            titulo: 'PARA QUE SIRVEN ESTAS EMOCIONES',
            child: _ListaFunciones(emociones: emociones),
          ),
          const SizedBox(height: 20),
          const _MensajeCierre(),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  // ── 9.2 Jugador SIN emociones ────────────────────────────────────────────

  Widget _buildVacio() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const _Encabezado(
            icono: Icons.cloud_outlined,
            titulo: 'Un momento de silencio',
            subtitulo:
                'Ninguna emocion fue reconocida esta vez, y eso tambien es informacion.',
          ),
          const SizedBox(height: 24),
          const _SiluetasVacias(),
          const SizedBox(height: 20),
          const _SeccionCard(
            titulo: 'NO ES FACIL IDENTIFICAR EMOCIONES BAJO ESTRES',
            child: Text(
              'Cuando el estres se vuelve cronico, el sistema emocional puede '
              'entrar en modo de bloqueo, evitacion o desconexion. '
              'Las emociones siguen activas, pero se vuelven dificiles de '
              'nombrar o de sentir con claridad. No identificar una emocion '
              'no significa que no estes sintiendo: puede significar que tu '
              'sistema esta protegiendote de una sobrecarga.',
              style: TextStyle(
                color: _textSecondary,
                fontSize: 13,
                height: 1.6,
              ),
            ),
          ),
          const SizedBox(height: 16),
          const _SeccionCard(
            titulo: 'ESTRES CRONICO Y DESCONEXION EMOCIONAL',
            child: Text(
              'El estres sostenido puede llevar a tres patrones comunes: '
              'bloqueo (dificultad para sentir cualquier emocion), '
              'evitacion (moverse rapido para no detenerse a sentir) '
              'y desconexion (sentirse en piloto automatico, sin registro '
              'emocional claro). Reconocer en cual de estos estas es ya '
              'un primer paso importante.',
              style: TextStyle(
                color: _textSecondary,
                fontSize: 13,
                height: 1.6,
              ),
            ),
          ),
          const SizedBox(height: 16),
          const _SeccionCard(
            titulo: 'EL PRIMER PASO',
            acento: true,
            child: Text(
              'No necesitas identificar con precision lo que sientes. '
              'Basta con prestar atencion: hay tension en el cuerpo? '
              'Hay algo que te cuesta sostener? Hay algo que preferirías '
              'no pensar? Esas señales tambien son emociones esperando '
              'ser reconocidas.',
              style: TextStyle(
                color: _textSecondary,
                fontSize: 13,
                height: 1.6,
              ),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

// ═════════════════════════════════════════════════════════════════════════════
//  ENCABEZADO
// ═════════════════════════════════════════════════════════════════════════════

class _Encabezado extends StatelessWidget {
  final IconData icono;
  final String titulo;
  final String subtitulo;

  const _Encabezado({
    required this.icono,
    required this.titulo,
    required this.subtitulo,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icono, color: _accentLight, size: 36),
        const SizedBox(height: 10),
        Text(
          titulo,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: _textPrimary,
            fontSize: 22,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          subtitulo,
          textAlign: TextAlign.center,
          style: const TextStyle(color: _textSecondary, fontSize: 13),
        ),
      ],
    );
  }
}

// ═════════════════════════════════════════════════════════════════════════════
//  SECCION CARD
// ═════════════════════════════════════════════════════════════════════════════

class _SeccionCard extends StatelessWidget {
  final String titulo;
  final Widget child;
  final bool acento;

  const _SeccionCard({
    required this.titulo,
    required this.child,
    this.acento = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: acento ? const Color(0xFF2d1a52) : _cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _accentColor.withValues(alpha: 0.35),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            titulo,
            style: const TextStyle(
              color: _accentLight,
              fontSize: 11,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

// ═════════════════════════════════════════════════════════════════════════════
//  MAPA VISUAL
// ═════════════════════════════════════════════════════════════════════════════

class _MapaVisual extends StatelessWidget {
  final List<EmocionData> emociones;

  const _MapaVisual({required this.emociones});

  @override
  Widget build(BuildContext context) {
    if (emociones.isEmpty) {
      return const Text('—', style: TextStyle(color: _textSecondary));
    }
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: emociones.map((e) => _EmocionChip(data: e)).toList(),
    );
  }
}

class _EmocionChip extends StatelessWidget {
  final EmocionData data;
  static const double _iconSize = 48;

  const _EmocionChip({required this.data});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: _iconSize,
          height: _iconSize,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white10,
            border: Border.all(
              color: _accentColor.withValues(alpha: 0.5),
              width: 1,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(9),
            child: _buildIcono(),
          ),
        ),
        const SizedBox(height: 4),
        SizedBox(
          width: 60,
          child: Text(
            data.nombre,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            style: const TextStyle(color: _textSecondary, fontSize: 9),
          ),
        ),
      ],
    );
  }

  Widget _buildIcono() {
    if (data.esPrimaria) {
      return Image.asset(
        'assets/images/${data.imagen}',
        filterQuality: FilterQuality.none,
        fit: BoxFit.contain,
      );
    }
    return const Icon(Icons.auto_awesome, color: _accentLight, size: 22);
  }
}

// ═════════════════════════════════════════════════════════════════════════════
//  NARRATIVA DE ESTRES
// ═════════════════════════════════════════════════════════════════════════════

class _NarrativaEstres extends StatelessWidget {
  final List<EmocionData> primarias;
  final List<EmocionFusionadaData> fusiones;

  const _NarrativaEstres({required this.primarias, required this.fusiones});

  @override
  Widget build(BuildContext context) {
    return Text(
      _generar(),
      style: const TextStyle(
        color: _textSecondary,
        fontSize: 13,
        height: 1.7,
      ),
    );
  }

  String _generar() {
    final tipos = primarias.map((e) => e.tipo).toSet();

    const alertantes = {
      TipoEmocion.miedo,
      TipoEmocion.ira,
      TipoEmocion.anticipacion,
      TipoEmocion.sorpresa,
    };
    const retirada = {TipoEmocion.tristeza, TipoEmocion.aversion};
    const apertura = {TipoEmocion.alegria, TipoEmocion.aceptacion};

    final nAl = tipos.intersection(alertantes).length;
    final nRet = tipos.intersection(retirada).length;
    final nAp = tipos.intersection(apertura).length;

    String base;

    if (nAl >= 2 && nAl > nRet + nAp) {
      base = 'Tu sistema emocional estuvo muy activo durante esta experiencia, '
          'principalmente en modo de alerta y defensa. Emociones como estas '
          'son respuestas naturales ante situaciones que percibimos como '
          'desafiantes o amenazantes. Bajo estres cronico, este estado de '
          'activacion puede mantenerse incluso cuando la amenaza ya paso, '
          'generando un desgaste acumulado que el cuerpo y la mente registran.';
    } else if (nRet >= 2 && nRet > nAl + nAp) {
      base = 'Tu mapa emocional refleja un proceso de retiro y procesamiento '
          'interno. Las emociones que surgieron apuntan a experiencias de '
          'perdida, rechazo o cansancio acumulado. Bajo estres prolongado, '
          'el sistema puede entrar en un modo de retiro como forma de '
          'conservar energia o crear distancia de los estimulos que lo superan.';
    } else if (nAp >= 2 && nAp > nAl + nRet) {
      base = 'Tu experiencia emocional incluyo apertura y conexion. A pesar '
          'del estres, tu sistema encontro momentos de bienestar y '
          'receptividad. Estas emociones de apertura son recursos importantes: '
          'indican que existen fuentes de alivio o soporte que pueden sostener '
          'el equilibrio emocional ante la presion.';
    } else if (tipos.isEmpty) {
      base = 'No se registraron emociones primarias en esta sesion. '
          'Recuerda que la dificultad para identificar emociones tambien '
          'es una señal valiosa sobre el estado del sistema emocional.';
    } else {
      base = 'Tu mapa emocional muestra diversidad: una combinacion de '
          'alertas, momentos de retiro y espacios de apertura. Esta '
          'variedad es caracteristica de experiencias complejas donde '
          'el estres coexiste con recursos de afrontamiento activos. '
          'Cada emocion que emergio tiene algo que decirte.';
    }

    if (fusiones.isNotEmpty) {
      final n = fusiones.length;
      final extra = n == 1
          ? ' La combinacion emocional que descubriste '
              '(${fusiones[0].nombre}) revela capas mas profundas del '
              'procesamiento emocional, algo frecuente bajo estres sostenido.'
          : ' Las $n combinaciones emocionales que descubriste revelan '
              'capas mas profundas del procesamiento, algo frecuente bajo '
              'estres sostenido.';
      base += extra;
    }

    return base;
  }
}

// ═════════════════════════════════════════════════════════════════════════════
//  FUNCIONES ADAPTATIVAS
// ═════════════════════════════════════════════════════════════════════════════

class _ListaFunciones extends StatelessWidget {
  final List<EmocionData> emociones;

  const _ListaFunciones({required this.emociones});

  @override
  Widget build(BuildContext context) {
    if (emociones.isEmpty) {
      return const Text('—', style: TextStyle(color: _textSecondary));
    }
    return Column(
      children: [
        for (final e in emociones)
          Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: _FuncionItem(data: e),
          ),
      ],
    );
  }
}

class _FuncionItem extends StatelessWidget {
  final EmocionData data;

  const _FuncionItem({required this.data});

  @override
  Widget build(BuildContext context) {
    final esPrimaria = data.esPrimaria;
    final funcion = esPrimaria
        ? (_funciones[data.tipo] ?? data.descripcion)
        : data.descripcion;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 36,
          height: 36,
          margin: const EdgeInsets.only(top: 2, right: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.white10,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: _buildMiniIcono(),
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                data.nombre,
                style: const TextStyle(
                  color: _textPrimary,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                funcion,
                style: const TextStyle(
                  color: _textSecondary,
                  fontSize: 12,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMiniIcono() {
    if (data.esPrimaria) {
      return Image.asset(
        'assets/images/${data.imagen}',
        filterQuality: FilterQuality.none,
        fit: BoxFit.contain,
      );
    }
    return const Icon(Icons.auto_awesome, color: _accentLight, size: 18);
  }
}

// ═════════════════════════════════════════════════════════════════════════════
//  MENSAJE DE CIERRE
// ═════════════════════════════════════════════════════════════════════════════

class _MensajeCierre extends StatelessWidget {
  const _MensajeCierre();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF3b1f6e), Color(0xFF1e0f40)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: _accentLight.withValues(alpha: 0.4),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          const Icon(Icons.lightbulb_outline, color: _accentLight, size: 28),
          const SizedBox(height: 10),
          const Text(
            'Las emociones son señales,\nno obstaculos.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: _textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.bold,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Cada emocion que reconociste tiene una razon de ser. '
            'Nombrarlas no las elimina, pero si reduce su poder '
            'sobre ti. Este mapa es un punto de partida para conocerte '
            'mejor y relacionarte con mas conciencia con lo que sientes.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.75),
              fontSize: 12,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}

// ═════════════════════════════════════════════════════════════════════════════
//  SILUETAS VACIAS (caso 9.2)
// ═════════════════════════════════════════════════════════════════════════════

class _SiluetasVacias extends StatelessWidget {
  const _SiluetasVacias();

  static const _nombres = [
    'Alegria', 'Tristeza', 'Miedo', 'Ira',
    'Sorpresa', 'Aversion', 'Anticipacion', 'Aceptacion',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _accentColor.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Wrap(
            spacing: 10,
            runSpacing: 10,
            alignment: WrapAlignment.center,
            children: List.generate(
              8,
              (i) => Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.white24, width: 1.5),
                    ),
                    child: const Icon(
                      Icons.help_outline,
                      color: Colors.white24,
                      size: 20,
                    ),
                  ),
                  const SizedBox(height: 4),
                  SizedBox(
                    width: 52,
                    child: Text(
                      _nombres[i],
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white30,
                        fontSize: 8,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Ninguna emocion fue reconocida en esta sesion.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white38, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
