import 'package:flutter/material.dart';

/// Botón de favorito. Al tocarlo debería alternar el ícono
/// (corazón lleno / corazón vacío) inmediatamente.
class FavoritoBoton extends StatefulWidget {
  final bool favoritoInicial;
  final VoidCallback onToggle;

  const FavoritoBoton({
    super.key,
    required this.favoritoInicial,
    required this.onToggle,
  });

  @override
  State<FavoritoBoton> createState() => _FavoritoBotonState();
}

class _FavoritoBotonState extends State<FavoritoBoton> {
  late bool _favorito;

  @override
  void initState() {
    super.initState();
    _favorito = widget.favoritoInicial;
  }

  @override
  void didUpdateWidget(covariant FavoritoBoton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.favoritoInicial != widget.favoritoInicial) {
      _favorito = widget.favoritoInicial;
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        _favorito ? Icons.favorite : Icons.favorite_border,
        color: _favorito ? Colors.red : null,
      ),
      onPressed: () {
        // TODO(diagnóstico): al tocar el botón, la lógica se ejecuta
        // (pruébalo con un print) pero el ícono en pantalla no cambia
        // de corazón vacío a lleno. ¿Qué le falta a este onPressed?

        // Nota del autor: fallaba porque al cambiar _favorito no se llamaba
        // setState(), entonces Flutter no reconstruía el widget y el ícono
        // nunca se redibujaba. Se envolvió la mutación en setState().
        setState(() {
          _favorito = !_favorito;
        });
        widget.onToggle();
      },
    );
  }
}
