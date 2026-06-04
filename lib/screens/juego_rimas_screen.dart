import 'package:flutter/material.dart';

class JuegoRimasScreen extends StatefulWidget {
  const JuegoRimasScreen({super.key});

  @override
  State<JuegoRimasScreen> createState() => _JuegoRimasScreenState();
}

class _JuegoRimasScreenState extends State<JuegoRimasScreen> {
  int _nivelActual = 0;
  int _estrellas = 0;

  // 10 Niveles de rimas infantiles con sus respectivas opciones
  final List<Map<String, dynamic>> _niveles = [
    {
      "palabraPrincipal": "GATO 🐱",
      "rimaCorrecta": "🦆 PATO",
      "opciones": ["🍎 MANZANA", "🦆 PATO", "🏠 CASA"]
    },
    {
      "palabraPrincipal": "LUNA 🌙",
      "rimaCorrecta": "🧸 CUNA",
      "opciones": ["🧸 CUNA", "☀️ SOL", "🐱 GATO"]
    },
    {
      "palabraPrincipal": "BOTÓN 🔘",
      "rimaCorrecta": "🐀 RATÓN",
      "opciones": ["🐶 PERRO", "🍌 PLÁTANO", "🐀 RATÓN"]
    },
    {
      "palabraPrincipal": "CASA 🏠",
      "rimaCorrecta": "🍇 MASA",
      "opciones": ["🍇 MASA", "🚗 CARRO", "🌲 ÁRBOL"]
    },
    {
      "palabraPrincipal": "SOL ☀️",
      "rimaCorrecta": "🌻 GIRASOL",
      "opciones": ["🐟 PEZ", "🌻 GIRASOL", "🥛 LECHE"]
    },
    {
      "palabraPrincipal": "FUEGO 🔥",
      "rimaCorrecta": "🎮 JUEGO",
      "opciones": ["🎨 PINTAR", "🧱 CUBO", "🎮 JUEGO"]
    },
    {
      "palabraPrincipal": "BALLENA 🐋",
      "rimaCorrecta": "🌙 LLENA",
      "opciones": ["🌙 LLENA", "🍅 TOMATE", "🎒 MOCHILA"]
    },
    {
      "palabraPrincipal": "VENTANA 🪟",
      "rimaCorrecta": "🐸 RANA",
      "opciones": ["🦁 LEÓN", "🐸 RANA", "🍩 DONA"]
    },
    {
      "palabraPrincipal": "ESPEJO 🪞",
      "rimaCorrecta": "🐰 CONEJO",
      "opciones": ["🐰 CONEJO", "🐵 MONO", "🥛 VASO"]
    },
    {
      "palabraPrincipal": "HELADO 🍦",
      "rimaCorrecta": "🎲 DADO",
      "opciones": ["🚂 TREN", "🚀 COHETE", "🎲 DADO"]
    }
  ];

  void _verificarRespuesta(String opcionSeleccionada) {
    String correcta = _niveles[_nivelActual]["rimaCorrecta"];

    if (opcionSeleccionada == correcta) {
      setState(() {
        _estrellas += 10;
        _nivelActual = (_nivelActual + 1) % _niveles.length;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.green,
          content: Text('¡Excelente! 🎉 ¡Esas palabras riman hermoso! 🎶🌟'),
          duration: Duration(seconds: 1),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text('¡Casi! Escucha cómo suenan y busca la rima 🤔'),
          duration: Duration(seconds: 1),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final nivel = _niveles[_nivelActual];

    return Scaffold(
      backgroundColor: Colors.indigo[50], // Fondo azul índigo pastel muy bonito
      appBar: AppBar(
        title: const Text('Juego: Rimas Mágicas 🎶'),
        backgroundColor: Colors.indigo,
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
                '¿Qué palabra rima con...?',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.indigo),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),

              // Tarjeta principal con la palabra a rimar
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(30),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(color: Colors.indigo, width: 3),
                  boxShadow: [
                    BoxShadow(color: Colors.indigo.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 4))
                  ],
                ),
                child: Text(
                  nivel["palabraPrincipal"],
                  style: const TextStyle(fontSize: 45, fontWeight: FontWeight.bold, color: Colors.black87),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 40),

              // Opciones verticales para que las palabras largas se lean perfectamente
              Expanded(
                child: ListView.builder(
                  itemCount: (nivel["opciones"] as List<String>).length,
                  itemBuilder: (context, index) {
                    String opcion = nivel["opciones"][index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.indigo,
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          side: const BorderSide(color: Colors.indigoAccent, width: 2),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          elevation: 3,
                        ),
                        onPressed: () => _verificarRespuesta(opcion),
                        child: Text(
                          opcion,
                          style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                        ),
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