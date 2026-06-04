import 'package:flutter/material.dart';

class JuegoSilabasScreen extends StatefulWidget {
  const JuegoSilabasScreen({super.key});

  @override
  State<JuegoSilabasScreen> createState() => _JuegoSilabasScreenState();
}

class _JuegoSilabasScreenState extends State<JuegoSilabasScreen> {
  int _nivelActual = 0;
  int _estrellas = 0;

  // Lista pedagógica de 10 niveles con sílabas iniciales faltantes
  final List<Map<String, dynamic>> _niveles = [
    {"emoji": "🏠", "silabaCorrecta": "CA", "restoPalabra": "SA", "opciones": ["MA", "CA", "PA"]},
    {"emoji": "🐱", "silabaCorrecta": "GA", "restoPalabra": "TO", "opciones": ["GA", "JA", "MA"]},
    {"emoji": "🦆", "silabaCorrecta": "PA", "restoPalabra": "TO", "opciones": ["LA", "SA", "PA"]},
    {"emoji": "🐒", "silabaCorrecta": "MO", "restoPalabra": "NO", "opciones": ["LO", "MO", "TO"]},
    {"emoji": "🧸", "silabaCorrecta": "PE", "restoPalabra": "LUCHE", "opciones": ["TE", "ME", "PE"]},
    {"emoji": "🥛", "silabaCorrecta": "LE", "restoPalabra": "CHE", "opciones": ["LE", "DE", "RE"]},
    {"emoji": "🍎", "silabaCorrecta": "MAN", "restoPalabra": "ZANA", "opciones": ["PAN", "MAN", "SAN"]},
    {"emoji": "🐋", "silabaCorrecta": "BA", "restoPalabra": "LLENA", "opciones": ["VA", "DA", "BA"]},
    {"emoji": "🍅", "silabaCorrecta": "TO", "restoPalabra": "MATE", "opciones": ["BO", "TO", "CO"]},
    {"emoji": "🌙", "silabaCorrecta": "LU", "restoPalabra": "NA", "opciones": ["RU", "SU", "LU"]},
  ];

  void _verificarRespuesta(String silabaSeleccionada) {
    String correcta = _niveles[_nivelActual]["silabaCorrecta"];
    
    if (silabaSeleccionada == correcta) {
      setState(() {
        _estrellas += 10;
        _nivelActual = (_nivelActual + 1) % _niveles.length;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.green,
          content: Text('¡Eso es! 🎉 ¡Completaste la palabra correctamente! 🌟'),
          duration: Duration(seconds: 1),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text('¡Casi! Prueba con otra sílaba 🤔'),
          duration: Duration(seconds: 1),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final nivel = _niveles[_nivelActual];

    return Scaffold(
      backgroundColor: Colors.teal[50], // Fondo fresco verde azulado pastel
      appBar: AppBar(
        title: const Text('Juego: Sílabas Perdidas 🧩'),
        backgroundColor: Colors.teal,
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
              // 1. Mostrar Emoji del Objeto
              Text(nivel["emoji"], style: const TextStyle(fontSize: 110)),
              const SizedBox(height: 15),
              
              Text(
                '¡Encuentra la sílaba que falta para completar la palabra!',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.teal[700]), // 👈 ¡Corregido aquí!
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 35),

              // 2. Visualización de la palabra incompleta con guiones
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.teal, width: 3),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: const Text(
                      '¿ ?',
                      style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.redAccent),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    nivel["restoPalabra"],
                    style: const TextStyle(fontSize: 42, fontWeight: FontWeight.bold, color: Colors.black87, letterSpacing: 2),
                  ),
                ],
              ),
              const SizedBox(height: 45),

              // 3. Botones grandes con las opciones de sílabas
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: (nivel["opciones"] as List<String>).map((silaba) {
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6.0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orangeAccent,
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          elevation: 4,
                        ),
                        onPressed: () => _verificarRespuesta(silaba),
                        child: Text(
                          silaba,
                          style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}