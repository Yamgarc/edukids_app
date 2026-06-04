import 'package:flutter/material.dart';

class JuegoLeerScreen extends StatefulWidget {
  const JuegoLeerScreen({super.key});

  @override
  State<JuegoLeerScreen> createState() => _JuegoLeerScreenState();
}

class _JuegoLeerScreenState extends State<JuegoLeerScreen> {
  int _indexActual = 0;
  int _estrellas = 0;

  // Lista escolar de 10 palabras con sus respectivos desafíos
  final List<Map<String, dynamic>> _datosPalabras = [
    {"emoji": "🍎", "nombre": "manzana", "opciones": ["P", "M"], "correcta": "M"},
    {"emoji": "🐱", "nombre": "gato", "opciones": ["G", "T"], "correcta": "G"},
    {"emoji": "🐶", "nombre": "perro", "opciones": ["B", "P"], "correcta": "P"},
    {"emoji": "🏠", "nombre": "casa", "opciones": ["C", "S"], "correcta": "C"},
    {"emoji": "☀️", "nombre": "sol", "opciones": ["L", "S"], "correcta": "S"},
    {"emoji": "🌙", "nombre": "luna", "opciones": ["M", "L"], "correcta": "L"},
    {"emoji": "🦆", "nombre": "pato", "opciones": ["P", "D"], "correcta": "P"},
    {"emoji": "🐸", "nombre": "rana", "opciones": ["R", "F"], "correcta": "R"},
    {"emoji": "🐀", "nombre": "ratón", "opciones": ["M", "R"], "correcta": "R"},
    {"emoji": "🐻", "nombre": "oso", "opciones": ["O", "U"], "correcta": "O"},
  ];

  void _verificarRespuesta(String letra) {
    String respuestaCorrecta = _datosPalabras[_indexActual]["correcta"];
    if (letra == respuestaCorrecta) {
      setState(() {
        _estrellas += 10;
        // Avanza al siguiente elemento de la lista de forma circular
        _indexActual = (_indexActual + 1) % _datosPalabras.length;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(backgroundColor: Colors.green, content: Text('¡Excelente! 🌟 ¡Letra correcta! 🎉'), duration: Duration(seconds: 1)),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(backgroundColor: Colors.red, content: Text('¡Inténtalo de nuevo! 🤔'), duration: Duration(seconds: 1)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final actual = _datosPalabras[_indexActual];

    return Scaffold(
      backgroundColor: Colors.purple[50],
      appBar: AppBar(
        title: const Text('Juego: ¿Con qué letra empieza?'),
        backgroundColor: Colors.purple,
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
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const SizedBox(height: 10),
              // Emoji Gigante adaptativo
              Text(actual["emoji"], style: const TextStyle(fontSize: 100)),
              const SizedBox(height: 10),
              Text(
                '¡Toca la letra con la que empieza la palabra ${actual["nombre"]}!',
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              // El Expanded soluciona el problema de las barras amarillas/negras
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () => _verificarRespuesta(actual["opciones"][0]),
                        child: Container(
                          margin: const EdgeInsets.all(8),
                          decoration: BoxDecoration(color: Colors.deepPurple, borderRadius: BorderRadius.circular(20)),
                          alignment: Alignment.center,
                          child: Text(actual["opciones"][0], style: const TextStyle(fontSize: 70, color: Colors.white, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () => _verificarRespuesta(actual["opciones"][1]),
                        child: Container(
                          margin: const EdgeInsets.all(8),
                          decoration: BoxDecoration(color: Colors.deepPurple, borderRadius: BorderRadius.circular(20)),
                          alignment: Alignment.center,
                          child: Text(actual["opciones"][1], style: const TextStyle(fontSize: 70, color: Colors.white, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}