import '../entidades/emocion_data.dart';
import '../entidades/emocion_fusionada_data.dart';

String generarNarrativaEstres({
  required List<EmocionData> emociones,
  required List<EmocionFusionadaData> fusiones,
}) {
  final primarias = emociones.where((e) => e.esPrimaria).toList();
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

  if (tipos.isEmpty) {
    base =
        'En esta sesion no emergieron emociones reconocibles. '
        'Eso también es información: cuando el estrés se vuelve crónico, '
        'el sistema emocional puede entrar en modo de bloqueo o desconexion. '
        'Las emociones siguen activas por debajo, pero se vuelven dificiles '
        'de nombrar o de sentir con claridad.';
  } else if (nAl >= 2 && nAl > nRet + nAp) {
    base =
        'Tu sistema emocional estuvo muy activo durante esta experiencia, '
        'principalmente en modo de alerta y defensa. Emociones como estas '
        'son respuestas naturales ante situaciones que percibimos como '
        'desafiantes o amenazantes. Bajo estres cronico, este estado de '
        'activacion puede mantenerse incluso cuando la amenaza ya paso, '
        'generando un desgaste acumulado que el cuerpo y la mente registran.';
  } else if (nRet >= 2 && nRet > nAl + nAp) {
    base =
        'Tu mapa emocional refleja un proceso de retiro y procesamiento '
        'interno. Las emociones que surgieron apuntan a experiencias de '
        'perdida, rechazo o cansancio acumulado. Bajo estres prolongado, '
        'el sistema puede entrar en un modo de retiro como forma de '
        'conservar energia o crear distancia de los estimulos que lo superan.';
  } else if (nAp >= 2 && nAp > nAl + nRet) {
    base =
        'Tu experiencia emocional incluyo apertura y conexion. A pesar '
        'del estres, tu sistema encontro momentos de bienestar y '
        'receptividad. Estas emociones de apertura son recursos importantes: '
        'indican que existen fuentes de alivio o soporte que pueden sostener '
        'el equilibrio emocional ante la presion.';
  } else {
    base =
        'Tu mapa emocional muestra diversidad: una combinacion de '
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
