import 'package:flutter/material.dart';

class JuegoComprensionScreen extends StatefulWidget {
  const JuegoComprensionScreen({super.key});

  @override
  State<JuegoComprensionScreen> createState() => _JuegoComprensionScreenState();
}

class _JuegoComprensionScreenState extends State<JuegoComprensionScreen> {
  int _nivelActual = 0;
  int _estrellas = 0;

  // 5 Lecturas cortas con preguntas de comprensión
  final List<Map<String, dynamic>> _niveles = [
    {
      "historia": "El oso Tito encontró un panal lleno de miel dulce en el bosque. ¡Se la comió toda con una cuchara!",
      "pregunta": "¿Qué encontró el oso Tito?",
      "correcta": "🍯 Un panal de miel",
      "opciones": ["🍎 Una manzana", "🍯 Un panal de miel", "🐟 Un pez"]
    },
    {
      "historia": "La gatita Mimí usa un sombrero rosa brillante para protegerse del sol cuando sale a jugar al jardín.",
      "pregunta": "¿De qué color es el sombrero de Mimí?",
      "correcta": "💗 Rosa",
      "opciones": ["💙 Azul", "💛 Amarillo", "💗 Rosa"]
    },
    {
      "historia": "El coche azul de papá corre muy rápido por la pista para llegar temprano a la playa.",
      "pregunta": "¿A dónde va el coche de papá?",
      "correcta": "🏖️ A la playa",
      "opciones": ["🏖️ A la playa", "🏫 A la escuela", "🌲 Al bosque"]
    },
    {
      "historia": "Luna es una perrita blanca que esconde sus juguetes favoritos debajo de la cama para que nadie se los quite.",
      "pregunta": "¿Dónde esconde Luna sus juguetes?",
      "correcta": "🛏️ Debajo de la cama",
      "opciones": ["🌳 En el jardín", "🛏️ Debajo de la cama", "📦 En una caja"]
    },
    {
      "historia": "El chef Luis horneó un pastel de chocolate gigante con diez velas de colores para el cumpleaños de Ana.",
      "pregunta": "¿De qué sabor es el pastel?",
      "correcta": "🍫 De chocolate",
      "opciones": ["🍓 De fresa", "🍋 De limón", "🍫 De chocolate"]
    }
  ];

  void _verificarRespuesta(String opcionSeleccionada) {
    String correcta = _niveles[_nivelActual]["correcta"];

    if (opcionSeleccionada == correcta) {
      setState(() {
        _estrellas += 20; // Da más puntos por ser comprensión lectora
        _nivelActual = (_nivelActual + 1) % _niveles.length;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.green,
          content: Text('¡Increíble! 🎉 ¡Entendiste la historia a la perfección! 📚🌟'),
          duration: Duration(seconds: 2),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text('¡Casi! Lee la historia una vez más con atención 🧐'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final nivel = _niveles[_nivelActual];

    return Scaffold(
      backgroundColor: Colors.teal[50], // Fondo verde azulado pastel
      appBar: AppBar(
        title: const Text('Juego: Historias Mágicas 📚'),
        backgroundColor: Colors.teal,
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
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              // Cuadro de la historia animada
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(color: Colors.teal.shade300, width: 3),
                  boxShadow: [
                    BoxShadow(color: Colors.teal.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 4))
                  ],
                ),
                child: Column(
                  children: [
                    const Icon(Icons.auto_stories, size: 40, color: Colors.teal),
                    const SizedBox(height: 10),
                    Text(
                      nivel["historia"],
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Colors.black87, height: 1.4),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 25),

              // Pregunta
              Text(
                nivel["pregunta"],
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.teal),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 15),

              // Opciones de respuesta verticales
              Expanded(
                child: ListView.builder(
                  itemCount: (nivel["opciones"] as List<String>).length,
                  itemBuilder: (context, index) {
                    String opcion = nivel["opciones"][index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6.0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.teal,
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          side: BorderSide(color: Colors.teal.shade200, width: 2),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          elevation: 3,
                        ),
                        onPressed: () => _verificarRespuesta(opcion),
                        child: Text(
                          opcion,
                          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
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