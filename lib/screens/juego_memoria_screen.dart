import 'package:flutter/material.dart';

class JuegoMemoriaScreen extends StatefulWidget {
  const JuegoMemoriaScreen({super.key});

  @override
  State<JuegoMemoriaScreen> createState() => _JuegoMemoriaScreenState();
}

class _JuegoMemoriaScreenState extends State<JuegoMemoriaScreen> {
  int _estrellas = 0;
  int _nivelActual = 0;

  // 10 Juegos de memoria diferentes (Cada uno tiene 3 parejas: Emoji - Texto)
  final List<List<Map<String, String>>> _bancoNiveles = [
    [
      {"tipo": "emoji", "valor": "🐱", "id": "gato"},
      {"tipo": "texto", "valor": "GATO", "id": "gato"},
      {"tipo": "emoji", "valor": "🐶", "id": "perro"},
      {"tipo": "texto", "valor": "PERRO", "id": "perro"},
      {"tipo": "emoji", "valor": "🍎", "id": "manzana"},
      {"tipo": "texto", "valor": "MANZANA", "id": "manzana"},
    ],
    [
      {"tipo": "emoji", "valor": "☀️", "id": "sol"},
      {"tipo": "texto", "valor": "SOL", "id": "sol"},
      {"tipo": "emoji", "valor": "🏠", "id": "casa"},
      {"tipo": "texto", "valor": "CASA", "id": "casa"},
      {"tipo": "emoji", "valor": "🦆", "id": "pato"},
      {"tipo": "texto", "valor": "PATO", "id": "pato"},
    ],
    [
      {"tipo": "emoji", "valor": "🐸", "id": "rana"},
      {"tipo": "texto", "valor": "RANA", "id": "rana"},
      {"tipo": "emoji", "valor": "🌙", "id": "luna"},
      {"tipo": "texto", "valor": "LUNA", "id": "luna"},
      {"tipo": "emoji", "valor": "🐮", "id": "vaca"},
      {"tipo": "texto", "valor": "VACA", "id": "vaca"},
    ],
    [
      {"tipo": "emoji", "valor": "🍞", "id": "pan"},
      {"tipo": "texto", "valor": "PAN", "id": "pan"},
      {"tipo": "emoji", "valor": "🌊", "id": "mar"},
      {"tipo": "texto", "valor": "MAR", "id": "mar"},
      {"tipo": "emoji", "valor": "🌳", "id": "arbol"},
      {"tipo": "texto", "valor": "ÁRBOL", "id": "arbol"},
    ],
    [
      {"tipo": "emoji", "valor": "🐀", "id": "raton"},
      {"tipo": "texto", "valor": "RATÓN", "id": "raton"},
      {"tipo": "emoji", "valor": "🐻", "id": "oso"},
      {"tipo": "texto", "valor": "OSO", "id": "oso"},
      {"tipo": "emoji", "valor": "🐺", "id": "lobo"},
      {"tipo": "texto", "valor": "LOBO", "id": "lobo"},
    ],
    [
      {"tipo": "emoji", "valor": "🦁", "id": "leon"},
      {"tipo": "texto", "valor": "LEÓN", "id": "leon"},
      {"tipo": "emoji", "valor": "🐵", "id": "mono"},
      {"tipo": "texto", "valor": "MONO", "id": "mono"},
      {"tipo": "emoji", "valor": "🐟", "id": "pez"},
      {"tipo": "texto", "valor": "PEZ", "id": "pez"},
    ],
    [
      {"tipo": "emoji", "valor": "🚗", "id": "carro"},
      {"tipo": "texto", "valor": "CARRO", "id": "carro"},
      {"tipo": "emoji", "valor": "✈️", "id": "avion"},
      {"tipo": "texto", "valor": "AVIÓN", "id": "avion"},
      {"tipo": "emoji", "valor": "🚂", "id": "tren"},
      {"tipo": "texto", "valor": "TREN", "id": "tren"},
    ],
    [
      {"tipo": "emoji", "valor": "🌽", "id": "elote"},
      {"tipo": "texto", "valor": "ELOTE", "id": "elote"},
      {"tipo": "emoji", "valor": "🍌", "id": "platano"},
      {"tipo": "texto", "valor": "PLÁTANO", "id": "platano"},
      {"tipo": "emoji", "valor": "🍇", "id": "uva"},
      {"tipo": "texto", "valor": "UVA", "id": "uva"},
    ],
    [
      {"tipo": "emoji", "valor": "⚽", "id": "balon"},
      {"tipo": "texto", "valor": "BALÓN", "id": "balon"},
      {"tipo": "emoji", "valor": "🎨", "id": "pintar"},
      {"tipo": "texto", "valor": "PINTAR", "id": "pintar"},
      {"tipo": "emoji", "valor": "🔔", "id": "campana"},
      {"tipo": "texto", "valor": "CAMPANA", "id": "campana"},
    ],
    [
      {"tipo": "emoji", "valor": "🥛", "id": "leche"},
      {"tipo": "texto", "valor": "LECHE", "id": "leche"},
      {"tipo": "emoji", "valor": "🍅", "id": "tomate"},
      {"tipo": "texto", "valor": "TOMATE", "id": "tomate"},
      {"tipo": "emoji", "valor": "🧁", "id": "pastel"},
      {"tipo": "texto", "valor": "PASTEL", "id": "pastel"},
    ]
  ];

  late List<Map<String, dynamic>> _cartasDeEsteNivel;
  List<int> _indicesSeleccionados = [];
  bool _bloquearTablero = false;

  @override
  void initState() {
    super.initState();
    _cargarNivel();
  }

  void _cargarNivel() {
    // Tomamos las 6 cartas del nivel actual
    var cartasBase = _bancoNiveles[_nivelActual];
    
    // Las convertimos a una lista mutable y agregamos estados de control
    _cartasDeEsteNivel = cartasBase.map((c) => {
      "tipo": c["tipo"],
      "valor": c["valor"],
      "id": c["id"],
      "volteada": false,
      "adivinada": false,
    }).toList();

    // Las mezclamos al azar para que no salgan en el mismo orden
    _cartasDeEsteNivel.shuffle();
    _indicesSeleccionados.clear();
    _bloquearTablero = false;
  }

  void _voltearCarta(int index) {
    if (_bloquearTablero || _cartasDeEsteNivel[index]["volteada"] || _cartasDeEsteNivel[index]["adivinada"]) {
      return;
    }

    setState(() {
      _cartasDeEsteNivel[index]["volteada"] = true;
      _indicesSeleccionados.add(index);
    });

    if (_indicesSeleccionados.length == 2) {
      _bloquearTablero = true;
      _verificarPareja();
    }
  }

  void _verificarPareja() {
    int primero = _indicesSeleccionados[0];
    int segundo = _indicesSeleccionados[1];

    if (_cartasDeEsteNivel[primero]["id"] == _cartasDeEsteNivel[segundo]["id"]) {
      // ¡Encontró una pareja correcta!
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          setState(() {
            _cartasDeEsteNivel[primero]["adivinada"] = true;
            _cartasDeEsteNivel[segundo]["adivinada"] = true;
            _indicesSeleccionados.clear();
            _bloquearTablero = false;

            // Verificar si terminó el tablero completo
            bool nivelTerminado = _cartasDeEsteNivel.every((carta) => carta["adivinada"] == true);
            if (nivelTerminado) {
              _estrellas += 20;
              _nivelActual = (_nivelActual + 1) % _bancoNiveles.length;
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(backgroundColor: Colors.green, content: Text('¡Excelente memoria! 🎉 ¡Nivel superado! 🌟'), duration: Duration(seconds: 2)),
              );
              _cargarNivel();
            }
          });
        }
      });
    } else {
      // No son iguales, se vuelven a voltear hacia abajo
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) {
          setState(() {
            _cartasDeEsteNivel[primero]["volteada"] = false;
            _cartasDeEsteNivel[segundo]["volteada"] = false;
            _indicesSeleccionados.clear();
            _bloquearTablero = false;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink[50],
      appBar: AppBar(
        title: const Text('Juego: Memorama de Palabras 🧠'),
        backgroundColor: Colors.pinkAccent,
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
              Text(
                'Nivel ${_nivelActual + 1} de 10',
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.pink),
              ),
              const SizedBox(height: 10),
              const Text(
                '¡Encuentra el emoji con su palabra correspondiente!',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.black54),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 25),
              Expanded(
                child: GridView.builder(
                  itemCount: _cartasDeEsteNivel.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                    childAspectRatio: 1.1,
                  ),
                  itemBuilder: (context, index) {
                    var carta = _cartasDeEsteNivel[index];
                    bool estaVisible = carta["volteada"] || carta["adivinada"];

                    return InkWell(
                      onTap: () => _voltearCarta(index),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        decoration: BoxDecoration(
                          color: estaVisible ? Colors.white : Colors.pinkAccent,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.pink, width: 3),
                          boxShadow: [
                            BoxShadow(color: Colors.pink.withOpacity(0.2), blurRadius: 5, offset: const Offset(0, 3))
                          ],
                        ),
                        alignment: Alignment.center,
                        child: estaVisible
                            ? Text(
                                carta["valor"],
                                style: TextStyle(
                                  fontSize: carta["tipo"] == "emoji" ? 55 : 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.deepPurple,
                                ),
                                textAlign: TextAlign.center,
                              )
                            : const Icon(Icons.help_outline, size: 50, color: Colors.white),
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