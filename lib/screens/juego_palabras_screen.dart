import 'package:flutter/material.dart';

class JuegoPalabrasScreen extends StatefulWidget {
  const JuegoPalabrasScreen({super.key});

  @override
  State<JuegoPalabrasScreen> createState() => _JuegoPalabrasScreenState();
}

class _JuegoPalabrasScreenState extends State<JuegoPalabrasScreen> {
  int _nivelActual = 0;
  int _estrellasGanadas = 0;
  List<String> _letrasSeleccionadas = [];
  String _mensajeFeedback = "¡Ordena las letras para formar la palabra!";
  Color _colorFeedback = Colors.blueGrey;

  // Colección pedagógica de 10 palabras diferentes para armar
  final List<Map<String, dynamic>> _listaPalabras = [
    {"emoji": "☀️", "correcta": "SOL", "letras": ["O", "L", "S"]},
    {"emoji": "🍞", "correcta": "PAN", "letras": ["N", "P", "A"]},
    {"emoji": "🌊", "correcta": "MAR", "letras": ["R", "M", "A"]},
    {"emoji": "🐱", "correcta": "GATO", "letras": ["T", "A", "G", "O"]},
    {"emoji": "🐸", "correcta": "RANA", "letras": ["A", "N", "R", "A"]},
    {"emoji": "🦆", "correcta": "PATO", "letras": ["T", "O", "P", "A"]},
    {"emoji": " Luna", "correcta": "LUNA", "letras": ["N", "U", "L", "A"]},
    {"emoji": "🐮", "correcta": "VACA", "letras": ["C", "A", "V", "A"]},
    {"emoji": "🐺", "correcta": "LOBO", "letras": ["O", "B", "L", "O"]},
    {"emoji": "🌳", "correcta": "ARBOL", "letras": ["L", "R", "A", "B", "O"]},
  ];

  void _seleccionarLetra(String letra) {
    final nivel = _listaPalabras[_nivelActual];
    String palabraCorrecta = nivel["correcta"];

    setState(() {
      _letrasSeleccionadas.add(letra);
      
      if (_letrasSeleccionadas.length == palabraCorrecta.length) {
        String palabraIntento = _letrasSeleccionadas.join();
        
        if (palabraIntento == palabraCorrecta) {
          _mensajeFeedback = "¡Excelente! 🎉 ¡Siguiente Palabra!";
          _colorFeedback = Colors.green;
          _estrellasGanadas += 15;
          
          Future.delayed(const Duration(seconds: 2), () {
            if (mounted) {
              setState(() {
                _nivelActual = (_nivelActual + 1) % _listaPalabras.length;
                _letrasSeleccionadas.clear();
                _mensajeFeedback = "¡Ordena las letras para formar la palabra!";
                _colorFeedback = Colors.blueGrey;
              });
            }
          });
        } else {
          _mensajeFeedback = "¡Casi! Inténtalo de nuevo 🤔";
          _colorFeedback = Colors.red;
          _letrasSeleccionadas.clear();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final nivel = _listaPalabras[_nivelActual];

    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        title: const Text('Juego: Arma la Palabra 🧩'),
        backgroundColor: Colors.blueAccent,
        actions: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                const Icon(Icons.star, color: Colors.yellow, size: 30),
                const SizedBox(width: 5),
                Text('$_estrellasGanadas', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ],
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(nivel["emoji"], style: const TextStyle(fontSize: 100)),
            const SizedBox(height: 15),
            Text(_mensajeFeedback, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: _colorFeedback), textAlign: TextAlign.center),
            const SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(nivel["correcta"].length, (index) {
                String letraMostrar = index < _letrasSeleccionadas.length ? _letrasSeleccionadas[index] : "";
                return Container(
                  margin: const EdgeInsets.all(6),
                  width: 55,
                  height: 55,
                  decoration: BoxDecoration(color: Colors.white, border: Border.all(color: Colors.blueAccent, width: 3), borderRadius: BorderRadius.circular(15)),
                  alignment: Alignment.center,
                  child: Text(letraMostrar, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.blueAccent)),
                );
              }),
            ),
            const SizedBox(height: 35),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              alignment: WrapAlignment.center,
              children: (nivel["letras"] as List<String>).map((letra) {
                bool yaUsada = _letrasSeleccionadas.contains(letra);
                return ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: yaUsada ? Colors.grey[300] : Colors.orange,
                    padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  ),
                  onPressed: yaUsada ? null : () => _seleccionarLetra(letra),
                  child: Text(letra, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white)),
                );
              }).toList(),
            ),
            const SizedBox(height: 30),
            if (_letrasSeleccionadas.isNotEmpty && _colorFeedback != Colors.green)
              TextButton.icon(
                onPressed: () => setState(() { _letrasSeleccionadas.clear(); _colorFeedback = Colors.blueGrey; _mensajeFeedback = "¡Ordena las letras!"; }),
                icon: const Icon(Icons.refresh, color: Colors.red),
                label: const Text('Reiniciar', style: TextStyle(fontSize: 18, color: Colors.red)),
              ),
          ],
        ),
      ),
    );
  }
}