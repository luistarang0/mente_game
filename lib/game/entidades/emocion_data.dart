enum TipoEmocion {
  alegria,
  tristeza,
  miedo,
  ira,
  sorpresa,
  aversion,
  anticipacion,
  aceptacion,
}

class EmocionData {
  final TipoEmocion tipo;
  final String nombre;
  final String descripcion;
  final String pregunta;
  /// Nombre del archivo en assets/images/ (vacío si no aplica).
  final String imagen;
  /// Para fusiones que usan el spritesheet: 'EMO_COMB.png:col:row'.
  /// Vacío para emociones primarias y fusiones sin imagen individual.
  final String hojaSprite;
  /// Abreviatura de 3 letras para fusiones sin imagen. Vacío en primarias.
  final String iniciales;

  const EmocionData({
    required this.tipo,
    required this.nombre,
    required this.descripcion,
    required this.pregunta,
    required this.imagen,
    this.hojaSprite = '',
    this.iniciales = '',
  });
}

const List<EmocionData> catalogoEmociones = [
  EmocionData(
    tipo: TipoEmocion.alegria,
    nombre: 'Alegría',
    descripcion:
        'Una sensación de bienestar y satisfacción. Nos impulsa a conectar con otros y a repetir experiencias positivas.',
    pregunta: '¿Has sentido alegría o satisfacción recientemente?',
    imagen: 'alegria.png',
  ),
  EmocionData(
    tipo: TipoEmocion.tristeza,
    nombre: 'Tristeza',
    descripcion:
        'Una respuesta natural ante la pérdida o la decepción. Nos invita a reflexionar y buscar apoyo.',
    pregunta: '¿Has sentido tristeza o melancolía últimamente?',
    imagen: 'tristeza.png',
  ),
  EmocionData(
    tipo: TipoEmocion.miedo,
    nombre: 'Miedo',
    descripcion:
        'Una señal de alerta ante algo percibido como amenaza. Nos prepara para protegernos.',
    pregunta: '¿Has sentido miedo o inseguridad recientemente?',
    imagen: 'miedo.png',
  ),
  EmocionData(
    tipo: TipoEmocion.ira,
    nombre: 'Ira',
    descripcion:
        'Una reacción ante lo que percibimos como injusto o frustrante. Nos da energía para defendernos.',
    pregunta: '¿Has sentido enojo o irritación últimamente?',
    imagen: 'ira.png',
  ),
  EmocionData(
    tipo: TipoEmocion.sorpresa,
    nombre: 'Sorpresa',
    descripcion:
        'Una reacción breve ante algo inesperado. Nos ayuda a redirigir la atención rápidamente.',
    pregunta: '¿Algo te ha sorprendido o tomado por sorpresa recientemente?',
    imagen: 'sorpresa.png',
  ),
  EmocionData(
    tipo: TipoEmocion.aversion,
    nombre: 'Aversión',
    descripcion:
        'Un rechazo hacia algo que percibimos como dañino o desagradable. Nos protege de experiencias negativas.',
    pregunta: '¿Has sentido rechazo o aversión hacia algo o alguien?',
    imagen: 'aversion.png',
  ),
  EmocionData(
    tipo: TipoEmocion.anticipacion,
    nombre: 'Anticipación',
    descripcion:
        'La energía que sentimos al esperar algo. Nos ayuda a prepararnos y planear hacia adelante.',
    pregunta: '¿Has sentido expectativa o anticipación por algo próximo?',
    imagen: 'anticipacion.png',
  ),
  EmocionData(
    tipo: TipoEmocion.aceptacion,
    nombre: 'Aceptación',
    descripcion:
        'La capacidad de recibir la realidad tal como es. Nos da calma y apertura hacia los demás.',
    pregunta: '¿Has sentido calma o aceptación ante algo difícil?',
    imagen: 'aceptacion.png',
  ),
];
