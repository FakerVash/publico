import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:provider/provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'dart:io' show Platform;
import 'providers/lugares_provider.dart';
import 'screens/lista_lugares_screen.dart';

void main() {
  // Inicializar sqflite_common_ffi para plataformas desktop
  if (!kIsWeb && (Platform.isLinux || Platform.isWindows || Platform.isMacOS)) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LugaresProvider(),
      child: MaterialApp(
        title: 'Lugares UIDE',
        theme: ThemeData(primarySwatch: Colors.indigo, useMaterial3: true),
        home: const ListaLugaresScreen(),
      ),
    );
  }
}
