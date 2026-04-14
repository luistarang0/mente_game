import 'package:flutter/widgets.dart';

/// Recorta y muestra una celda de un spritesheet.
/// [hoja] tiene el formato 'archivo.png:col:row'.
/// El spritesheet EMO_COMB.png tiene 5 columnas × 2 filas de 32×32 px.
class SpritesheetCell extends StatelessWidget {
  final String hoja;
  final double size;

  static const int _totalCols = 5;
  static const int _totalRows = 2;

  const SpritesheetCell({super.key, required this.hoja, required this.size});

  @override
  Widget build(BuildContext context) {
    final parts = hoja.split(':');
    final asset = 'assets/images/${parts[0]}';
    final col = int.parse(parts[1]);
    final row = int.parse(parts[2]);

    return SizedBox(
      width: size,
      height: size,
      child: ClipRect(
        child: Transform.translate(
          offset: Offset(-col * size, -row * size),
          child: Image.asset(
            asset,
            width: _totalCols * size,
            height: _totalRows * size,
            filterQuality: FilterQuality.none,
            fit: BoxFit.none,
          ),
        ),
      ),
    );
  }
}
