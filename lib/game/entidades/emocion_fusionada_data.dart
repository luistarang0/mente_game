import 'package:mapa_emocional/game/entidades/emocion_data.dart';

class EmocionFusionadaData {
  final String nombre;
  final String descripcion;
  final String pregunta;
  final TipoEmocion componente1;
  final TipoEmocion componente2;

  /// Posición en el spritesheet EMO_COMB.png (columna, fila), cada celda 32×32.
  /// -1 indica que esta fusión no tiene sprite en el spritesheet.
  final int spritesheetCol;
  final int spritesheetRow;

  const EmocionFusionadaData({
    required this.nombre,
    required this.descripcion,
    required this.pregunta,
    required this.componente1,
    required this.componente2,
    this.spritesheetCol = -1,
    this.spritesheetRow = -1,
  });

  bool get tieneSprite => spritesheetCol >= 0;

  /// Devuelve true si las dos emociones primarias (en cualquier orden)
  /// producen esta fusión.
  bool coincideCon(TipoEmocion a, TipoEmocion b) {
    return (a == componente1 && b == componente2) ||
        (a == componente2 && b == componente1);
  }

  /// Convierte esta fusión en un [EmocionData] para el HUD y la sala.
  EmocionData toEmocionData() => EmocionData(
        tipo: componente1,
        nombre: nombre,
        descripcion: descripcion,
        pregunta: pregunta,
        imagen: '',
        hojaSprite:
            tieneSprite ? 'EMO_COMB.png:$spritesheetCol:$spritesheetRow' : '',
        iniciales: tieneSprite
            ? ''
            : nombre.substring(0, nombre.length.clamp(0, 3)).toUpperCase(),
      );
}

/// Catálogo completo de 28 fusiones emocionales (Rueda de Plutchik).
///
/// Spritesheet EMO_COMB.png (5 columnas × 2 filas, 32×32 px):
///   Fila 0: Ansiedad · Quedarse Helado · Mal Humor · Orgullo · Catarsis
///   Fila 1: Vergüenza · Culpabilidad · Agresividad · Pesimismo · Optimismo
const List<EmocionFusionadaData> catalogoFusiones = [
  // ── Con sprite (fila 0) ──────────────────────────────────────
  EmocionFusionadaData(
    nombre: 'Ansiedad',
    descripcion:
        'La mezcla de miedo y anticipación. Aparece cuando esperamos algo '
        'que percibimos como amenazante.',
    pregunta: '¿Has sentido ansiedad o nerviosismo recientemente?',
    componente1: TipoEmocion.miedo,
    componente2: TipoEmocion.anticipacion,
    spritesheetCol: 0,
    spritesheetRow: 0,
  ),
  EmocionFusionadaData(
    nombre: 'Quedarse Helado',
    descripcion:
        'La parálisis que surge cuando la ira choca con el miedo. '
        'Nos sentimos atrapados sin poder actuar.',
    pregunta: '¿Te has sentido paralizado o bloqueado ante alguna situación?',
    componente1: TipoEmocion.ira,
    componente2: TipoEmocion.miedo,
    spritesheetCol: 1,
    spritesheetRow: 0,
  ),
  EmocionFusionadaData(
    nombre: 'Mal Humor',
    descripcion:
        'La combinación de tristeza e ira. Un estado de irritabilidad '
        'profunda donde todo parece ir mal.',
    pregunta: '¿Has tenido episodios de mal humor o irritabilidad profunda?',
    componente1: TipoEmocion.tristeza,
    componente2: TipoEmocion.ira,
    spritesheetCol: 2,
    spritesheetRow: 0,
  ),
  EmocionFusionadaData(
    nombre: 'Orgullo',
    descripcion:
        'La fusión de ira y alegría. Una energía de satisfacción que '
        'nos impulsa a defender lo que valoramos.',
    pregunta: '¿Has sentido orgullo por algo que hiciste o lograste?',
    componente1: TipoEmocion.ira,
    componente2: TipoEmocion.alegria,
    spritesheetCol: 3,
    spritesheetRow: 0,
  ),
  EmocionFusionadaData(
    nombre: 'Catarsis',
    descripcion:
        'La mezcla de alegría y tristeza. Una liberación emocional donde '
        'reír y llorar se encuentran.',
    pregunta: '¿Has experimentado una liberación emocional intensa?',
    componente1: TipoEmocion.alegria,
    componente2: TipoEmocion.tristeza,
    spritesheetCol: 4,
    spritesheetRow: 0,
  ),

  // ── Con sprite (fila 1) ──────────────────────────────────────
  EmocionFusionadaData(
    nombre: 'Vergüenza',
    descripcion:
        'La combinación de miedo y tristeza. Una sensación de vulnerabilidad '
        'ante la mirada de los demás.',
    pregunta: '¿Has sentido vergüenza o timidez recientemente?',
    componente1: TipoEmocion.miedo,
    componente2: TipoEmocion.tristeza,
    spritesheetCol: 0,
    spritesheetRow: 1,
  ),
  EmocionFusionadaData(
    nombre: 'Culpabilidad',
    descripcion:
        'La fusión de miedo y alegría. Surge cuando algo nos alegra pero '
        'sentimos que no deberíamos disfrutarlo.',
    pregunta: '¿Has sentido culpa por algo que hiciste o dejaste de hacer?',
    componente1: TipoEmocion.miedo,
    componente2: TipoEmocion.alegria,
    spritesheetCol: 1,
    spritesheetRow: 1,
  ),
  EmocionFusionadaData(
    nombre: 'Agresividad',
    descripcion:
        'La mezcla de ira y anticipación. Una energía intensa orientada '
        'a la acción impulsiva.',
    pregunta: '¿Has sentido impulsos agresivos o ganas de reaccionar con fuerza?',
    componente1: TipoEmocion.ira,
    componente2: TipoEmocion.anticipacion,
    spritesheetCol: 2,
    spritesheetRow: 1,
  ),
  EmocionFusionadaData(
    nombre: 'Pesimismo',
    descripcion:
        'La combinación de anticipación y tristeza. Esperar el futuro '
        'con la certeza de que no mejorará.',
    pregunta: '¿Has tenido pensamientos pesimistas sobre el futuro?',
    componente1: TipoEmocion.anticipacion,
    componente2: TipoEmocion.tristeza,
    spritesheetCol: 3,
    spritesheetRow: 1,
  ),
  EmocionFusionadaData(
    nombre: 'Optimismo',
    descripcion:
        'La fusión de anticipación y alegría. La expectativa positiva '
        'de que algo bueno está por venir.',
    pregunta: '¿Has sentido optimismo o esperanza por algo que viene?',
    componente1: TipoEmocion.anticipacion,
    componente2: TipoEmocion.alegria,
    spritesheetCol: 4,
    spritesheetRow: 1,
  ),

  // ── Sin sprite (18 nuevas) ───────────────────────────────────
  EmocionFusionadaData(
    nombre: 'Alarma',
    descripcion:
        'La combinación de miedo y sorpresa. Una reacción intensa ante '
        'una amenaza que llega de improviso.',
    pregunta: '¿Has sentido alarma o susto repentino ante algo inesperado?',
    componente1: TipoEmocion.miedo,
    componente2: TipoEmocion.sorpresa,
  ),
  EmocionFusionadaData(
    nombre: 'Amor',
    descripcion:
        'La mezcla de alegría y aceptación. Un vínculo cálido que nos '
        'conecta profundamente con los demás.',
    pregunta: '¿Has sentido amor o afecto profundo por alguien recientemente?',
    componente1: TipoEmocion.alegria,
    componente2: TipoEmocion.aceptacion,
  ),
  EmocionFusionadaData(
    nombre: 'Desprecio',
    descripcion:
        'La fusión de ira y aversión. Una desestimación hacia algo o '
        'alguien que percibimos como inferior o negativo.',
    pregunta: '¿Has sentido desprecio o desdén hacia algo o alguien?',
    componente1: TipoEmocion.ira,
    componente2: TipoEmocion.aversion,
  ),
  EmocionFusionadaData(
    nombre: 'Decepción',
    descripcion:
        'La tristeza ante algo que no salió como esperábamos. '
        'Una sorpresa que resultó negativa.',
    pregunta: '¿Te has sentido decepcionado/a por algo o alguien recientemente?',
    componente1: TipoEmocion.tristeza,
    componente2: TipoEmocion.sorpresa,
  ),
  EmocionFusionadaData(
    nombre: 'Miseria',
    descripcion:
        'La mezcla de tristeza y aversión. Un estado de profundo malestar '
        'emocional ante lo que nos resulta insoportable.',
    pregunta: '¿Has sentido una incomodidad o malestar emocional muy intenso?',
    componente1: TipoEmocion.tristeza,
    componente2: TipoEmocion.aversion,
  ),
  EmocionFusionadaData(
    nombre: 'Curiosidad',
    descripcion:
        'La apertura ante lo nuevo mezclada con sorpresa. Un impulso '
        'natural de explorar y conocer lo desconocido.',
    pregunta: '¿Has sentido curiosidad o ganas de explorar algo nuevo?',
    componente1: TipoEmocion.aceptacion,
    componente2: TipoEmocion.sorpresa,
  ),
  EmocionFusionadaData(
    nombre: 'Cinismo',
    descripcion:
        'La anticipación teñida de rechazo. Una actitud de desconfianza '
        'hacia las intenciones ajenas.',
    pregunta: '¿Has tenido pensamientos cínicos o de desconfianza recientemente?',
    componente1: TipoEmocion.anticipacion,
    componente2: TipoEmocion.aversion,
  ),
  EmocionFusionadaData(
    nombre: 'Dominancia',
    descripcion:
        'La seguridad que surge de aceptar nuestra propia fuerza. '
        'Un sentido de autoridad o control en la situación.',
    pregunta: '¿Has sentido la necesidad o el impulso de tomar el control?',
    componente1: TipoEmocion.aceptacion,
    componente2: TipoEmocion.ira,
  ),
  EmocionFusionadaData(
    nombre: 'Sumisión',
    descripcion:
        'La aceptación mezclada con temor. Una tendencia a ceder ante '
        'los demás para evitar conflictos.',
    pregunta: '¿Te has sentido sumiso/a o has cedido por miedo en alguna situación?',
    componente1: TipoEmocion.aceptacion,
    componente2: TipoEmocion.miedo,
  ),
  EmocionFusionadaData(
    nombre: 'Deleite',
    descripcion:
        'Una alegría inesperada. La sensación de placer intenso ante '
        'algo que nos tomó por sorpresa positivamente.',
    pregunta: '¿Has sentido deleite o una alegría inesperada recientemente?',
    componente1: TipoEmocion.sorpresa,
    componente2: TipoEmocion.alegria,
  ),
  EmocionFusionadaData(
    nombre: 'Repugnancia',
    descripcion:
        'El miedo combinado con aversión. Una reacción visceral de '
        'rechazo y temor ante algo que nos resulta amenazante.',
    pregunta: '¿Has sentido repugnancia o rechazo intenso ante algo?',
    componente1: TipoEmocion.aversion,
    componente2: TipoEmocion.miedo,
  ),
  EmocionFusionadaData(
    nombre: 'Sagacidad',
    descripcion:
        'La apertura combinada con previsión. La capacidad de leer '
        'situaciones y anticiparse con claridad.',
    pregunta: '¿Has sentido que comprendes bien una situación y sabes cómo actuar?',
    componente1: TipoEmocion.aceptacion,
    componente2: TipoEmocion.anticipacion,
  ),
  EmocionFusionadaData(
    nombre: 'Susto',
    descripcion:
        'Un rechazo inesperado. Una reacción de alarma ante algo '
        'sorpresivo y desagradable al mismo tiempo.',
    pregunta: '¿Has tenido un susto o sobresalto recientemente?',
    componente1: TipoEmocion.aversion,
    componente2: TipoEmocion.sorpresa,
  ),
  EmocionFusionadaData(
    nombre: 'Melancolía',
    descripcion:
        'La dulce tristeza. Un estado donde recuerdos felices se '
        'mezclan con la pérdida o el rechazo.',
    pregunta: '¿Has sentido melancolía o nostalgia recientemente?',
    componente1: TipoEmocion.alegria,
    componente2: TipoEmocion.aversion,
  ),
  EmocionFusionadaData(
    nombre: 'Resignación',
    descripcion:
        'La tristeza aceptada. Una paz difícil que surge de asumir '
        'que algo no va a cambiar.',
    pregunta: '¿Te has resignado ante algo que no podías cambiar?',
    componente1: TipoEmocion.tristeza,
    componente2: TipoEmocion.aceptacion,
  ),
  EmocionFusionadaData(
    nombre: 'Rabia',
    descripcion:
        'La ira desencadenada de manera inesperada. Una reacción '
        'explosiva ante una sorpresa que nos molesta profundamente.',
    pregunta: '¿Has sentido rabia o enojo intenso de forma repentina?',
    componente1: TipoEmocion.sorpresa,
    componente2: TipoEmocion.ira,
  ),
  EmocionFusionadaData(
    nombre: 'Ambivalencia',
    descripcion:
        'La coexistencia de aceptación y rechazo. Sentir atracción '
        'y repulsión hacia algo o alguien al mismo tiempo.',
    pregunta: '¿Has sentido sentimientos contradictorios sobre algo o alguien?',
    componente1: TipoEmocion.aceptacion,
    componente2: TipoEmocion.aversion,
  ),
  EmocionFusionadaData(
    nombre: 'Confusión',
    descripcion:
        'La expectativa chocando con lo inesperado. Una sensación de '
        'no saber cómo interpretar lo que sucede.',
    pregunta: '¿Te has sentido confundido/a o desorientado/a recientemente?',
    componente1: TipoEmocion.anticipacion,
    componente2: TipoEmocion.sorpresa,
  ),
];

/// Busca la fusión que resulta de combinar [a] y [b].
/// Retorna null si no existe combinación válida.
EmocionFusionadaData? buscarFusion(TipoEmocion a, TipoEmocion b) {
  for (final fusion in catalogoFusiones) {
    if (fusion.coincideCon(a, b)) return fusion;
  }
  return null;
}
