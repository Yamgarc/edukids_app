import 'package:flutter/material.dart';

class JuegoArticulosScreen extends StatefulWidget {
  const JuegoArticulosScreen({super.key});

  @override
  State<JuegoArticulosScreen> createState() => _JuegoArticulosScreenState();
}

class _JuegoArticulosScreenState extends State<JuegoArticulosScreen> {
  int _nivelActual = 0;
  int _estrellas = 0;

  // 10 Niveles educativos con artículos definidos
  final List<Map<String, dynamic>> _niveles = [
    {"objeto": "PERRO 🐶", "correcto": "EL"},
    {"objeto": "CASA 🏠", "correcto": "LA"},
    {"objeto": "GATOS 🐱🐱", "correcto": "LOS"},
    {"objeto": "MANZANAS 🍎🍎", "correcto": "LAS"},
    {"objeto": "SOL ☀️", "correcto": "EL"},
    {"objeto": "FLOR 🌸", "correcto": "LA"},
    {"objeto": "COHETES 🚀🚀", "correcto": "LOS"},
    {"objeto": "ESTRELLAS ⭐⭐", "correcto": "LAS"},
    {"objeto": "ÁRBOL 🌲", "correcto": "EL"},
    {"objeto": "BICICLETA 🚲", "correcto": "LA"},
  ];

  final List<String> _articulos = ["EL", "LA", "LOS", "LAS"];

  void _verificarRespuesta(String articuloSeleccionado) {
    String correcto = _niveles[_nivelActual]["correcto"];

    if (articuloSeleccionado == correcto) {
      setState(() {
        _estrellas += 10;
        _nivelActual = (_nivelActual + 1) % _niveles.length;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.green,
          content: Text('¡Excelente! 🎉 ¡Suena perfectamente bien! 🗣️🌟'),
          duration: Duration(seconds: 1),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text('¡Ups! Intenta leerlo en voz alta a ver cómo suena mejor... 🤔'),
          duration: Duration(seconds: 1),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final nivel = _niveles[_nivelActual];

    return Scaffold(
      backgroundColor: Colors.cyan[50], // Fondo azul cian pastel muy fresco
      appBar: AppBar(
        title: const Text('Juego: Cazador de Artículos 🏹'),
        backgroundColor: Colors.cyan[700],
        foregroundColor: Colors.white,
        actions: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                const Icon(Icons.star, color: Colors.yellow, size: 30),
                const SizedBox(width: 5),
                Text('$_estrellas', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ],
            ),
          )
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                '¿Cuál artículo acompaña mejor a la palabra?',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.cyan),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),

              // Burbuja gigante con el objeto/palabra objetivo
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Colors.cyan, width: 3),
                  boxShadow: [
                    BoxShadow(color: Colors.cyan.withOpacity(0.1), blurRadius: 12, offset: const Offset(0, 5))
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      nivel["objeto"],
                      style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.black87),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 50),

              // Matriz de 2x2 para seleccionar los artículos de forma cómoda y grande
              Expanded(
                child: GridView.builder(
                  itemCount: _articulos.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                    childAspectRatio: 1.3,
                  ),
                  itemBuilder: (context, index) {
                    String art = _articulos[index];
                    return ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.cyan[400],
                        foregroundColor: Colors.white,
                        elevation: 4,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      ),
                      onPressed: () => _verificarRespuesta(art),
                      child: Text(
                        art,
                        style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}