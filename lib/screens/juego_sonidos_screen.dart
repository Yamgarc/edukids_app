import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart'; // 👈 ¡Importamos el paquete de voz!

class JuegoSonidosScreen extends StatefulWidget {
  const JuegoSonidosScreen({super.key});

  @override
  State<JuegoSonidosScreen> createState() => _JuegoSonidosScreenState();
}

class _JuegoSonidosScreenState extends State<JuegoSonidosScreen> {
  int _nivelActual = 0;
  int _estrellas = 0;
  
  // Instancia para controlar el motor de voz
  final FlutterTts _flutterTts = FlutterTts();

  // Banco de 10 niveles pedagógicos
  final List<Map<String, dynamic>> _niveles = [
    {"pista": "Muuu. ¿Quién hace este sonido?", "correcto": "🐮", "opciones": ["🐷", "🐮", "🐱"]},
    {"pista": "Guau guau. ¿Quién ladra así?", "correcto": "🐶", "opciones": ["🐶", "🦁", "🐭"]},
    {"pista": "Miau. ¿Quién toma leche y hace este sonido?", "correcto": "🐱", "opciones": ["🦆", "🐰", "🐱"]},
    {"pista": "Kikirikí. ¿Quién nos despierta por la mañana?", "correcto": "🐓", "opciones": ["🐓", "🦉", "🐸"]},
    {"pista": "Cuac cuac. ¿A quién le gusta nadar en el agua?", "correcto": "🦆", "opciones": ["🐵", "🦆", "🐟"]},
    {"pista": "Cri cri. ¿Quién canta escondido en las noches?", "correcto": "🦗", "opciones": ["🦋", "🐝", "🦗"]},
    {"pista": "Piií piií. ¿Quién suena su bocina en la calle?", "correcto": "🚗", "opciones": ["🚗", "✈️", "🚲"]},
    {"pista": "Chu cu chu cu. ¿Qué transporte va por las vías?", "correcto": "🚂", "opciones": ["🚀", "🚂", "⛵"]},
    {"pista": "Ring ring. ¿Qué objeto suena para despertar?", "correcto": "⏰", "opciones": ["⏰", "🎸", "📺"]},
    {"pista": "Oinc oinc. ¿A qué animalito le gusta el lodo?", "correcto": "🐷", "opciones": ["🐑", "🐴", "🐷"]},
  ];

  @override
  void initState() {
    super.initState();
    _configurarVoz();
  }

  // Configura el idioma en español y la velocidad de la voz
  void _configurarVoz() async {
    await _flutterTts.setLanguage("es-MX"); // Configura español Latino / Mexicano
    await _flutterTts.setSpeechRate(0.45);  // Voz un poco más lenta y clara para los niños
    await _flutterTts.setVolume(1.0);       // Volumen al máximo
    
    // Hablar automáticamente la primera pista al entrar al juego
    _hablarPista(_niveles[_nivelActual]["pista"]);
  }

  // Función para reproducir el sonido/texto de forma auditiva
  void _hablarPista(String texto) async {
    await _flutterTts.speak(texto);
  }

  @override
  void dispose() {
    _flutterTts.stop(); // Detiene la voz si el niño sale de la pantalla
    super.dispose();
  }

  void _verificarRespuesta(String opcionSeleccionada) {
    String correcta = _niveles[_nivelActual]["correcto"];

    if (opcionSeleccionada == correcta) {
      setState(() {
        _estrellas += 10;
        _nivelActual = (_nivelActual + 1) % _niveles.length;
      });
      
      _hablarPista("¡Excelente! ¡Adivinaste!"); // 👈 Feedback hablado
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.green,
          content: Text('¡Excelente! 🎉 ¡Escuchaste y adivinaste muy bien! 🌟'),
          duration: Duration(seconds: 1),
        ),
      );

      // Reproduce automáticamente la pista del siguiente nivel tras una pequeña pausa
      Future.delayed(const Duration(milliseconds: 1500), () {
        if (mounted) _hablarPista(_niveles[_nivelActual]["pista"]);
      });

    } else {
      _hablarPista("Inténtalo de nuevo"); // 👈 Feedback hablado si falla
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text('¡Casi! Intenta escuchar la pista otra vez 🤔'),
          duration: Duration(seconds: 1),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final nivel = _niveles[_nivelActual];

    return Scaffold(
      backgroundColor: Colors.amber[50],
      appBar: AppBar(
        title: const Text('Juego: Sonidos Mágicos 🔊'),
        backgroundColor: Colors.amber[700],
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
                '¡Toca el botón para escuchar la pista!',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),

              // 1. Botón gigante de Sonido/Bocina interactivo
              GestureDetector(
                onTap: () => _hablarPista(nivel["pista"]), // 👈 ¡Al tocarlo, el teléfono habla!
                child: Container(
                  padding: const EdgeInsets.all(30),
                  decoration: BoxDecoration(
                    color: Colors.amber,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(color: Colors.amber.withOpacity(0.4), blurRadius: 15, offset: const Offset(0, 5))
                    ],
                  ),
                  child: const Icon(Icons.volume_up, size: 90, color: Colors.white),
                ),
              ),
              const SizedBox(height: 40),

              // 2. Cuadro de texto de apoyo visual
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.amber, width: 2),
                ),
                child: Text(
                  nivel["pista"],
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.brown),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 50),

              // 3. Opciones de respuesta con los emojis
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: (nivel["opciones"] as List<String>).map((opcion) {
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          side: const BorderSide(color: Colors.amber, width: 3),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                          elevation: 4,
                        ),
                        onPressed: () => _verificarRespuesta(opcion),
                        child: Text(
                          opcion,
                          style: const TextStyle(fontSize: 45),
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