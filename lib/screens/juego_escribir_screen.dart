import 'package:flutter/material.dart';

class JuegoEscribirScreen extends StatefulWidget {
  const JuegoEscribirScreen({super.key});

  @override
  State<JuegoEscribirScreen> createState() => _JuegoEscribirScreenState();
}

class _JuegoEscribirScreenState extends State<JuegoEscribirScreen> {
  List<Offset?> _puntos = [];
  int _letraIndex = 0;
  int _estrellasGanadas = 0;

  // Lista con todo el abecedario escolar completo
  final List<String> _abecedario = [
    "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", 
    "N", "Ñ", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber[50],
      appBar: AppBar(
        title: Text('Traza la Letra: ${_abecedario[_letraIndex]} 📝'),
        backgroundColor: Colors.orange,
        actions: [
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
                  onPressed: _letraIndex > 0 ? () => setState(() { _letraIndex--; _puntos.clear(); }) : null,
                ),
                Text('Letra ${_letraIndex + 1} de ${_abecedario.length}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                IconButton(
                  icon: const Icon(Icons.arrow_forward_ios, size: 30, color: Colors.orange),
                  onPressed: _letraIndex < _abecedario.length - 1 ? () => setState(() { _letraIndex++; _puntos.clear(); }) : null,
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
                child: GestureDetector(
                  onPanUpdate: (details) {
                    setState(() {
                      RenderBox renderBox = context.findRenderObject() as RenderBox;
                      _puntos.add(renderBox.globalToLocal(details.globalPosition));
                    });
                  },
                  onPanEnd: (details) => _puntos.add(null),
                  child: Stack(
                    children: [
                      Center(
                        child: Text(
                          _abecedario[_letraIndex],
                          style: TextStyle(fontSize: 260, fontWeight: FontWeight.w100, color: Colors.grey.withOpacity(0.2)),
                        ),
                      ),
                      CustomPaint(painter: PizarraPainter(puntos: _puntos), size: Size.infinite),
                    ],
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
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent, padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 15), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
                  onPressed: () => setState(() => _puntos.clear()),
                  icon: const Icon(Icons.delete, color: Colors.white),
                  label: const Text('Borrar', style: TextStyle(fontSize: 18, color: Colors.white)),
                ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green, padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 15), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
                  onPressed: () {
                    setState(() {
                      _puntos.clear();
                      _estrellasGanadas += 10;
                      _letraIndex = (_letraIndex + 1) % _abecedario.length;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(backgroundColor: Colors.green, content: Text('¡Excelente trazo! ¡Ganaste 10 estrellas! 🌟 🎉'), duration: Duration(seconds: 1)),
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
    Paint paint = Paint()..color = Colors.blue..strokeCap = StrokeCap.round..strokeWidth = 10.0;
    for (int i = 0; i < puntos.length - 1; i++) {
      if (puntos[i] != null && puntos[i + 1] != null) {
        canvas.drawLine(puntos[i]!, puntos[i + 1]!, paint);
      }
    }
  }
  @override
  bool shouldRepaint(covariant PizarraPainter oldDelegate) => oldDelegate.puntos != puntos;
}