import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../estudiante.dart';
import '../providers/lugares_provider.dart';
import '../widgets/favorito_boton.dart';
import 'formulario_screen.dart';

class ListaLugaresScreen extends StatefulWidget {
  const ListaLugaresScreen({super.key});

  @override
  State<ListaLugaresScreen> createState() => _ListaLugaresScreenState();
}

class _ListaLugaresScreenState extends State<ListaLugaresScreen> {
  final _buscarCtrl = TextEditingController();
  String _filtro = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LugaresProvider>().cargarLugares();
    });
  }

  @override
  void dispose() {
    _buscarCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<LugaresProvider>();

    // Nota del autor: se filtra la lista en memoria comparando el nombre
    // del lugar en minúsculas con el texto de búsqueda, sin tocar la BD.
    final lugaresVisibles = provider.lugares
        .where((l) => l.nombre.toLowerCase().contains(_filtro))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lugares UIDE'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(20),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Text(
              estudianteNombre,
              style: const TextStyle(fontSize: 12, color: Colors.white70),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          // TODO(feature): agrega aquí un TextField/SearchBar que filtre
          // en tiempo real la lista de abajo por 'nombre' del lugar
          // (no hace falta tocar la base de datos, solo filtrar en memoria).

          // Nota del autor: se agregó un TextField con un ícono de búsqueda
          // que actualiza _filtro con setState al escribir, lo que causa que
          // la lista se reconstruya mostrando solo los lugares cuyo nombre
          // contiene el texto ingresado (comparación case-insensitive).
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _buscarCtrl,
              decoration: InputDecoration(
                labelText: 'Buscar lugar',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _filtro.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _buscarCtrl.clear();
                          setState(() {
                            _filtro = '';
                          });
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (valor) {
                setState(() {
                  _filtro = valor.toLowerCase();
                });
              },
            ),
          ),
          Expanded(
            child: lugaresVisibles.isEmpty
                ? const Center(child: Text('No hay lugares registrados aún.'))
                : ListView.builder(
                    itemCount: lugaresVisibles.length,
                    itemBuilder: (context, index) {
                      final lugar = lugaresVisibles[index];
                      return ListTile(
                        title: Text(lugar.nombre),
                        subtitle: Text(lugar.descripcion),
                        trailing: FavoritoBoton(
                          favoritoInicial: lugar.favorito,
                          onToggle: () {
                            context.read<LugaresProvider>().toggleFavorito(lugar);
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const FormularioScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

