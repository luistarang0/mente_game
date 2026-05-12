import 'package:flame/components.dart';

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
  final bool esPrimaria;
  final String funcion;

  final int frameCount;
  final double stepTime;
  final Vector2? textureSize;

  const EmocionData({
    required this.tipo,
    required this.nombre,
    required this.descripcion,
    required this.pregunta,
    required this.imagen,
    this.esPrimaria = false,
    required this.funcion,
    this.frameCount = 2,
    this.stepTime = 0.4,
    this.textureSize,
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
    esPrimaria: true,
    funcion:
        'Reconoce lo que vale la pena en tu vida y te impulsa a buscar mas de ello.',
  ),
  EmocionData(
    tipo: TipoEmocion.tristeza,
    nombre: 'Tristeza',
    descripcion:
        'Una respuesta natural ante la pérdida o la decepción. Nos invita a reflexionar y buscar apoyo.',
    pregunta: '¿Has sentido tristeza o melancolía últimamente?',
    imagen: 'tristeza.png',
    esPrimaria: true,
    funcion:
        'Señala perdidas importantes y te invita a reflexionar o buscar apoyo.',
  ),
  EmocionData(
    tipo: TipoEmocion.miedo,
    nombre: 'Miedo',
    descripcion:
        'Una señal de alerta ante algo percibido como amenaza. Nos prepara para protegernos.',
    pregunta: '¿Has sentido miedo o inseguridad recientemente?',
    imagen: 'miedo.png',
    esPrimaria: true,
    funcion:
        'Detecta amenazas reales o percibidas y te prepara para protegerte.',
  ),
  EmocionData(
    tipo: TipoEmocion.ira,
    nombre: 'Ira',
    descripcion:
        'Una reacción ante lo que percibimos como injusto o frustrante. Nos da energía para defendernos.',
    pregunta: '¿Has sentido enojo o irritación últimamente?',
    imagen: 'ira.png',
    esPrimaria: true,
    funcion: 'Marca tus limites y te da energia para defenderlos.',
  ),
  EmocionData(
    tipo: TipoEmocion.sorpresa,
    nombre: 'Sorpresa',
    descripcion:
        'Una reacción breve ante algo inesperado. Nos ayuda a redirigir la atención rápidamente.',
    pregunta: '¿Algo te ha sorprendido o tomado por sorpresa recientemente?',
    imagen: 'sorpresa.png',
    esPrimaria: true,
    funcion:
        'Redirige tu atencion hacia lo nuevo e inesperado para que puedas adaptarte.',
  ),
  EmocionData(
    tipo: TipoEmocion.aversion,
    nombre: 'Aversión',
    descripcion:
        'Un rechazo hacia algo que percibimos como dañino o desagradable. Nos protege de experiencias negativas.',
    pregunta: '¿Has sentido rechazo o aversión hacia algo o alguien?',
    imagen: 'aversion.png',
    esPrimaria: true,
    funcion:
        'Te aleja de lo que percibe como dañino o contrario a tus valores.',
  ),
  EmocionData(
    tipo: TipoEmocion.anticipacion,
    nombre: 'Anticipación',
    descripcion:
        'La energía que sentimos al esperar algo. Nos ayuda a prepararnos y planear hacia adelante.',
    pregunta: '¿Has sentido expectativa o anticipación por algo próximo?',
    imagen: 'anticipacion.png',
    esPrimaria: true,
    funcion:
        'Te impulsa a planear y actuar antes de que ocurra algo importante.',
  ),
  EmocionData(
    tipo: TipoEmocion.aceptacion,
    nombre: 'Aceptación',
    descripcion:
        'La capacidad de recibir la realidad tal como es. Nos da calma y apertura hacia los demás.',
    pregunta: '¿Has sentido calma o aceptación ante algo difícil?',
    imagen: 'aceptacion.png',
    esPrimaria: true,
    funcion:
        'Te permite recibir la realidad con calma y abrirte a lo que viene.',
  ),
];
