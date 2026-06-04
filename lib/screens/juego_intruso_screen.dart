import 'package:flutter/material.dart';

class JuegoIntrusoScreen extends StatefulWidget {
  const JuegoIntrusoScreen({super.key});

  @override
  State<JuegoIntrusoScreen> createState() => _JuegoIntrusoScreenState();
}

class _JuegoIntrusoScreenState extends State<JuegoIntrusoScreen> {
  int _nivelActual = 0;
  int _estrellas = 0;

  // 10 Niveles con categorías y un intruso bien definido
  final List<Map<String, dynamic>> _niveles = [
    {
      "categoria": "¡Frutas deliciosas!",
      "intruso": "🚗", // Un carro no se come
      "opciones": ["🍎", "🍌", "🚗", "🍓"]
    },
    {
      "categoria": "¡Animales de la granja o selva!",
      "intruso": "🍕", // La pizza no es un animal
      "opciones": ["🦁", "🍕", "🐷", "🐵"]
    },
    {
      "categoria": "¡Cosas para viajar y transportarse!",
      "intruso": "🥦", // El brócoli no es un transporte
      "opciones": ["✈️", "🚗", "🥦", "🚂"]
    },
    {
      "categoria": "¡Cosas flotantes del espacio!",
      "intruso": "🐟", // Un pez no flota en el espacio
      "opciones": ["🚀", "🌙", "☀️", "🐟"]
    },
    {
      "categoria": "¡Instrumentos para hacer música!",
      "intruso": "🍦", // El helado no suena
      "opciones": ["🎸", "🍦", "🎺", "🥁"]
    },
    {
      "categoria": "¡Animales que viven bajo el mar!",
      "intruso": "🦁", // El león no sabe nadar ahí abajo
      "opciones": ["🐟", "🐋", "🐙", "🦁"]
    },
    {
      "categoria": "¡Útiles para ir a la escuela!",
      "intruso": "🍔", // La hamburguesa va en la panza, no en la mochila
      "opciones": ["🎒", "✏️", "🍔", "📚"]
    },
    {
      "categoria": "¡Ropa para vestirse bien lindo!",
      "intruso": "🚲", // No te puedes poner una bicicleta
      "opciones": ["👕", "🚲", "👗", "👟"]
    },
    {
      "categoria": "¡Postres dulces y ricos!",
      "intruso": "🌵", // El cactus tiene espinas, ¡no se come!
      "opciones": ["🍦", "🍰", "🧁", "🌵"]
    },
    {
      "categoria": "¡Deportes para jugar con balones!",
      "intruso": "📱", // El celular no es un deporte
      "opciones": ["⚽", "🏀", "📱", "🏈"]
    }
  ];

  void _verificarRespuesta(String opcionSeleccionada) {
    String intrusoCorrecto = _niveles[_nivelActual]["intruso"];

    if (opcionSeleccionada == intrusoCorrecto) {
      setState(() {
        _estrellas += 10;
        _nivelActual = (_nivelActual + 1) % _niveles.length;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.green,
          content: Text('¡Excelente vista! 🎉 ¡Encontraste al intruso! 🕵️‍♂️🌟'),
          duration: Duration(seconds: 1),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text('¡Ese sí pertenece al grupo! Sigue buscando al intruso... 🤔'),
          duration: Duration(seconds: 1),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final nivel = _niveles[_nivelActual];

    return Scaffold(
      backgroundColor: Colors.purple[50], // Fondo morado pastel
      appBar: AppBar(
        title: const Text('Juego: El Intruso Loco 🕵️‍♂️'),
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
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                '¿Quién no pertenece al grupo? 🤔',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.purple),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                'Aquí todos son: ${nivel["categoria"]}',
                style: const TextStyle(fontSize: 18, color: Colors.black54, fontWeight: FontWeight.w500),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),

              // Tablero de 2x2 para las 4 opciones de emojis gigantes
              Expanded(
                child: GridView.builder(
                  itemCount: (nivel["opciones"] as List<String>).length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                    childAspectRatio: 1.0,
                  ),
                  itemBuilder: (context, index) {
                    String opcion = nivel["opciones"][index];
                    return InkWell(
                      onTap: () => _verificarRespuesta(opcion),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(25),
                          border: Border.all(color: Colors.purple.shade200, width: 3),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.purple.withOpacity(0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            )
                          ],
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          opcion,
                          style: const TextStyle(fontSize: 70),
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