import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart'; // 👈 Importamos la librería de voz

class JuegoEscribirScreen extends StatefulWidget {
  const JuegoEscribirScreen({super.key});

  @override
  State<JuegoEscribirScreen> createState() => _JuegoEscribirScreenState();
}

class _JuegoEscribirScreenState extends State<JuegoEscribirScreen> {
  List<Offset?> _puntos = [];
  int _letraIndex = 0;
  int _estrellasGanadas = 0;

  // Instancia para la voz de la app
  final FlutterTts _flutterTts = FlutterTts();

  // Lista con todo el abecedario escolar completo
  final List<String> _abecedario = [
    "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", 
    "N", "Ñ", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"
  ];

  @override
  void initState() {
    super.initState();
    _configurarVozFemenina();
  }

  // Configura el idioma español y busca una voz femenina del sistema
  void _configurarVozFemenina() async {
    await _flutterTts.setLanguage("es-MX"); // Configura español latino
    await _flutterTts.setSpeechRate(0.45);  // Velocidad lenta y clara para niños
    await _flutterTts.setPitch(1.2);       // Tono un poco más agudo para que suene más dulce/femenina
    
    // Intentar forzar voz femenina si el sistema la tiene disponible
    try {
      var voices = await _flutterTts.getVoices;
      for (var voice in voices) {
        if (voice["name"].toString().toLowerCase().contains("female") || 
            voice["name"].toString().toLowerCase().contains("zira") ||
            voice["name"].toString().toLowerCase().contains("pablo")) { // Filtros comunes
          await _flutterTts.setVoice({"name": voice["name"], "locale": voice["locale"]});
          break;
        }
      }
    } catch (e) {
      debugPrint("Usando voz predeterminada del sistema");
    }

    // Decir la primera letra al entrar al juego
    _pronunciarLetra();
  }

  // Función mágica para que la app hable
  void _pronunciarLetra() async {
    String letra = _abecedario[_letraIndex];
    await _flutterTts.speak("Traza la letra, $letra");
  }

  @override
  void dispose() {
    _flutterTts.stop(); // Detiene la voz si el niño se sale del juego
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber[50],
      appBar: AppBar(
        title: Text('Traza la Letra: ${_abecedario[_letraIndex]} 📝'),
        backgroundColor: Colors.orange,
        actions: [
          // Botón para volver a escuchar la letra
          IconButton(
            icon: const Icon(Icons.volume_up, color: Colors.white, size: 28),
            onPressed: _pronunciarLetra,
            tooltip: 'Escuchar letra',
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                const Icon(Icons.star, color: Colors.yellow, size: 30),
                const SizedBox(width: 5),
                Text('$_estrellasGanadas', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black)),
              ],
            ),
          )
        ],
      ),
      body: Column(
        children: [
          // Selector manual de letras para navegar por el abecedario
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios, size: 30, color: Colors.orange),
                  onPressed: _letraIndex > 0 ? () => setState(() { 
                    _letraIndex--; 
                    _puntos.clear(); 
                    _pronunciarLetra();
                  }) : null,
                ),
                Text('Letra ${_letraIndex + 1} de ${_abecedario.length}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                IconButton(
                  icon: const Icon(Icons.arrow_forward_ios, size: 30, color: Colors.orange),
                  onPressed: _letraIndex < _abecedario.length - 1 ? () => setState(() { 
                    _letraIndex++; 
                    _puntos.clear(); 
                    _pronunciarLetra();
                  }) : null,
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Card(
                elevation: 10,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                child: RepaintBoundary( // Aísla el dibujo para rendimiento Pro
                  child: GestureDetector(
                    // 💥 SOLUCIÓN DEL TRAZO: Captura el inicio del toque/click usando localPosition
                    onPanStart: (details) {
                      setState(() {
                        _puntos.add(details.localPosition);
                      });
                    },
                    // Captura el movimiento continuo del dedo/mouse de forma ultra precisa
                    onPanUpdate: (details) {
                      setState(() {
                        _puntos.add(details.localPosition);
                      });
                    },
                    onPanEnd: (details) => _puntos.add(null),
                    child: Stack(
                      children: [
                        Center(
                          child: SelectionContainer.disabled(
                            child: Text(
                              _abecedario[_letraIndex],
                              style: TextStyle(
                                fontSize: 260, 
                                fontWeight: FontWeight.w100, 
                                color: Colors.grey.withOpacity(0.2),
                              ),
                            ),
                          ),
                        ),
                        CustomPaint(
                          painter: PizarraPainter(puntos: _puntos), 
                          size: Size.infinite,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 25.0, left: 20, right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent, 
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 15), 
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))
                  ),
                  onPressed: () => setState(() => _puntos.clear()),
                  icon: const Icon(Icons.delete, color: Colors.white),
                  label: const Text('Borrar', style: TextStyle(fontSize: 18, color: Colors.white)),
                ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green, 
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 15), 
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))
                  ),
                  onPressed: () {
                    setState(() {
                      _puntos.clear();
                      _estrellasGanadas += 10;
                      _letraIndex = (_letraIndex + 1) % _abecedario.length;
                    });
                    _pronunciarLetra(); // Dice la nueva letra automáticamente
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        backgroundColor: Colors.green, 
                        content: Text('¡Excelente trazo! ¡Ganaste 10 estrellas! 🌟 🎉'), 
                        duration: Duration(seconds: 1)
                      ),
                    );
                  },
                  icon: const Icon(Icons.check_circle, color: Colors.white),
                  label: const Text('¡Terminé!', style: TextStyle(fontSize: 18, color: Colors.white)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PizarraPainter extends CustomPainter {
  final List<Offset?> puntos;
  PizarraPainter({required this.puntos});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.blue
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 10.0;
      
    for (int i = 0; i < puntos.length - 1; i++) {
      if (puntos[i] != null && puntos[i + 1] != null) {
        canvas.drawLine(puntos[i]!, puntos[i + 1]!, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant PizarraPainter oldDelegate) {
    return oldDelegate.puntos.length != puntos.length;
  }
}