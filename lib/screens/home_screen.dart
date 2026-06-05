import 'dart:async';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'juego_leer_screen.dart';
import 'juego_escribir_screen.dart';
import 'juego_palabras_screen.dart'; 
import 'juego_silabas_screen.dart';
import 'juego_memoria_screen.dart';
import 'juego_sonidos_screen.dart';
import 'juego_intruso_screen.dart';
import 'juego_rimas_screen.dart';
import 'juego_articulos_screen.dart';
import 'juego_comprension_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // --- Lógica de Música ---
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  double _volume = 0.5;

  // --- Lógica de Tema ---
  bool _isDarkMode = false;

  // --- Lógica del Timer (Control Parental) ---
  Timer? _timer;
  int _segundosRestantes = 0;
  bool _tiempoAgotado = false;
  
  // 🔐 CONTRASEÑA PARA PAPÁS (Puedes cambiarla aquí)
  final String _pinCorrecto = "1234"; 
  final TextEditingController _customTimeController = TextEditingController();

  // --- Lógica de Estrellitas Acumuladas ---
  int _estrellasTotales = 12; 

  @override
  void initState() {
    super.initState();
    _prepararMusica();
  }

  void _prepararMusica() async {
    _audioPlayer.setReleaseMode(ReleaseMode.loop);
    await _audioPlayer.setSource(AssetSource('audio/musica_fondo.mp3'));
  }

  void _toggleMusica() async {
    if (_isPlaying) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer.resume();
    }
    setState(() {
      _isPlaying = !_isPlaying;
    });
  }

  void _cambiarVolumen(double nuevoVolumen) async {
    await _audioPlayer.setVolume(nuevoVolumen);
    setState(() {
      _volume = nuevoVolumen;
    });
  }

  void _toggleTema() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  void _iniciarTemporizador(int minutos) {
    _timer?.cancel();
    setState(() {
      _segundosRestantes = minutos * 60;
      _tiempoAgotado = false;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_segundosRestantes > 0) {
        setState(() {
          _segundosRestantes--;
        });
      } else {
        _timer?.cancel();
        _bloquearAppPorTiempo();
      }
    });
  }

  void _bloquearAppPorTiempo() async {
    if (_isPlaying) {
      await _audioPlayer.pause();
      setState(() {
        _isPlaying = false;
      });
    }
    setState(() {
      _tiempoAgotado = true;
    });
  }

  // 🛠️ MOSTRAR AJUSTES: Con opción de tiempo personalizado
  void _mostrarAjustesParentales() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: _isDarkMode ? const Color(0xFF1E293B) : Colors.white,
          title: Text('👨‍👩‍👦 Control Parental', 
            style: TextStyle(color: _isDarkMode ? Colors.cyanAccent : Colors.deepPurple, fontWeight: FontWeight.bold)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Selecciona un tiempo predeterminado o escribe los minutos:',
                  style: TextStyle(color: _isDarkMode ? Colors.white : Colors.black87)),
                const SizedBox(height: 10),
                
                // Campo personalizado
                TextField(
                  controller: _customTimeController,
                  keyboardType: TextInputType.number,
                  style: TextStyle(color: _isDarkMode ? Colors.white : Colors.black),
                  decoration: InputDecoration(
                    labelText: 'Minutos personalizados',
                    labelStyle: TextStyle(color: _isDarkMode ? Colors.cyanAccent : Colors.deepPurple),
                    hintText: 'Ej. 45',
                    hintStyle: const TextStyle(color: Colors.grey),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.play_circle_fill, color: Colors.green),
                      onPressed: () {
                        int? minutos = int.tryParse(_customTimeController.text);
                        if (minutos != null && minutos > 0) {
                          _iniciarTemporizador(minutos);
                          _customTimeController.clear();
                          Navigator.pop(context);
                        }
                      },
                    ),
                  ),
                ),
                const Divider(height: 25),
                ListTile(
                  leading: const Icon(Icons.timer_10, color: Colors.blue),
                  title: Text('Probar rápido (10 Segundos)', style: TextStyle(color: _isDarkMode ? Colors.white : Colors.black)),
                  onTap: () {
                    _timer?.cancel();
                    setState(() { _segundosRestantes = 10; _tiempoAgotado = false; });
                    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
                      if (_segundosRestantes > 0) { setState(() { _segundosRestantes--; }); } 
                      else { _timer?.cancel(); _bloquearAppPorTiempo(); }
                    });
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.av_timer, color: Colors.orange),
                  title: Text('5 Minutos', style: TextStyle(color: _isDarkMode ? Colors.white : Colors.black)),
                  onTap: () { _iniciarTemporizador(5); Navigator.pop(context); },
                ),
                ListTile(
                  leading: const Icon(Icons.timer, color: Colors.red),
                  title: Text('15 Minutos', style: TextStyle(color: _isDarkMode ? Colors.white : Colors.black)),
                  onTap: () { _iniciarTemporizador(15); Navigator.pop(context); },
                ),
                ListTile(
                  leading: const Icon(Icons.not_interested, color: Colors.grey),
                  title: Text('Desactivar límite', style: TextStyle(color: _isDarkMode ? Colors.white : Colors.black)),
                  onTap: () {
                    _timer?.cancel();
                    setState(() { _segundosRestantes = 0; });
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // 🔐 ALERTA DE DESBLOQUEO CON CONTRASEÑA
  void _solicitarContrasenaDesbloqueo() {
    final TextEditingController pinController = TextEditingController();
    showDialog(
      context: context,
      barrierDismissible: false, 
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1E293B),
          title: const Text('🔒 Control de Padres', style: TextStyle(color: Colors.amberAccent, fontWeight: FontWeight.bold)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Ingresa la contraseña para desbloquear el juego:', style: TextStyle(color: Colors.white70)),
              const SizedBox(height: 15),
              TextField(
                controller: pinController,
                obscureText: true,
                keyboardType: TextInputType.number,
                maxLength: 4,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white, fontSize: 24, letterSpacing: 10),
                decoration: const InputDecoration(
                  hintText: '••••',
                  hintStyle: TextStyle(color: Colors.grey),
                  enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white54)),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: const Text('Cancelar', style: TextStyle(color: Colors.white54)),
              onPressed: () => Navigator.pop(context),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
              child: const Text('Validar', style: TextStyle(color: Colors.white)),
              onPressed: () {
                if (pinController.text == _pinCorrecto) {
                  Navigator.pop(context); // Cierra el diálogo
                  setState(() {
                    _tiempoAgotado = false;
                    _segundosRestantes = 0; // Resetea el tiempo
                  });
                } else {
                  // Animación o aviso de PIN incorrecto
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('❌ Contraseña incorrecta. ¡Solo para adultos!')),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  String _formatearTiempo() {
    int minutos = _segundosRestantes ~/ 60;
    int segundos = _segundosRestantes % 60;
    return '${minutos.toString().padLeft(2, '0')}:${segundos.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _timer?.cancel();
    _customTimeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor = _isDarkMode ? const Color(0xFF0F172A) : Colors.green[50]; 
    final appBarColor = _isDarkMode ? const Color(0xFF1E1B4B) : Colors.orange;
    final textColor = _isDarkMode ? Colors.cyanAccent : Colors.deepPurple; 
    final containerVolumeColor = _isDarkMode ? const Color(0xFF1E293B) : Colors.white.withOpacity(0.9);

    if (_tiempoAgotado) {
      return Scaffold(
        backgroundColor: const Color(0xFF1E1B4B),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.hotel, size: 100, color: Colors.amberAccent),
                const SizedBox(height: 20),
                const Text(
                  '¡Hora de descansar!',
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 15),
                const Text(
                  'El tiempo de juego programado por tus papás ha terminado. ¡Buen trabajo hoy! 🦝✨',
                  style: TextStyle(fontSize: 18, color: Colors.white70),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  ),
                  icon: const Icon(Icons.lock, color: Colors.white),
                  label: const Text('Desbloquear (Solo Papás)', style: TextStyle(fontSize: 18, color: Colors.white)),
                  onPressed: _solicitarContrasenaDesbloqueo, // 👈 ¡Ahora pide contraseña de verdad!
                )
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text(_isDarkMode ? '🌌 ZONA ESPACIAL' : '🎯 ¡Edukids!', 
          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: appBarColor,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.security, color: Colors.white, size: 28),
            onPressed: _mostrarAjustesParentales,
            tooltip: 'Control Parental',
          ),
          IconButton(
            icon: Icon(_isDarkMode ? Icons.wb_sunny : Icons.brightness_3, 
              color: _isDarkMode ? Colors.amber : Colors.white, size: 28),
            onPressed: _toggleTema,
          ),
          IconButton(
            icon: Icon(_isPlaying ? Icons.music_note : Icons.music_off, 
              color: Colors.white, size: 28),
            onPressed: _toggleMusica,
          ),
        ],
      ),
      body: Stack(
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // ⭐ CONTADOR DE ESTRELLAS ⭐
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      decoration: BoxDecoration(
                        color: _isDarkMode ? const Color(0xFF1E293B) : Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(color: Colors.amber, width: 3),
                        boxShadow: [
                          BoxShadow(color: Colors.amber.withOpacity(0.3), blurRadius: 10, spreadRadius: 2)
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 36),
                          const SizedBox(width: 10),
                          Text(
                            '$_estrellasTotales Estrellas',
                            style: TextStyle(
                              fontSize: 24, 
                              fontWeight: FontWeight.bold, 
                              color: _isDarkMode ? Colors.white : Colors.deepPurple
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 25),

                    if (_segundosRestantes > 0)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        margin: const EdgeInsets.only(bottom: 20),
                        decoration: BoxDecoration(
                          color: Colors.redAccent,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.hourglass_top, color: Colors.white),
                            const SizedBox(width: 8),
                            Text(
                              'Tiempo restante: ${_formatearTiempo()}',
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    
                    Text(
                      '¿Qué quieres aprender hoy?',
                      style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: textColor),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 30),
                    
                    _buildMenuButton(context, '¡Quiero Leer!', Colors.blue, Icons.menu_book, const JuegoLeerScreen()),
                    const SizedBox(height: 20),
                    _buildMenuButton(context, '¡Quiero Escribir!', Colors.orange, Icons.edit, const JuegoEscribirScreen()),
                    const SizedBox(height: 20),
                    _buildMenuButton(context, '¡Armar Palabras!', Colors.deepPurple, Icons.extension, const JuegoPalabrasScreen()),
                    const SizedBox(height: 20),
                    _buildMenuButton(context, 'Sílabas Perdidas', Colors.teal, Icons.extension, const JuegoSilabasScreen()),
                    const SizedBox(height: 20),
                    _buildMenuButton(context, 'Memorama Mágico', Colors.pinkAccent, Icons.style, const JuegoMemoriaScreen()),
                    const SizedBox(height: 20),
                    _buildMenuButton(context, 'Sonidos Mágicos', Colors.amber[700]!, Icons.volume_up, const JuegoSonidosScreen()),
                    const SizedBox(height: 20),
                    _buildMenuButton(context, 'El Intruso Loco', Colors.purple, Icons.search, const JuegoIntrusoScreen()),
                    const SizedBox(height: 20),
                    _buildMenuButton(context, 'Rimas Mágicas', Colors.indigo, Icons.music_note, const JuegoRimasScreen()),
                    const SizedBox(height: 20),
                    _buildMenuButton(context, 'Cazador de Artículos', Colors.cyan[700]!, Icons.catching_pokemon, const JuegoArticulosScreen()),
                    const SizedBox(height: 20),
                    _buildMenuButton(context, 'Historias Mágicas', Colors.teal, Icons.auto_stories, const JuegoComprensionScreen()),
                    const SizedBox(height: 120), 
                  ],
                ),
              ),
            ),
          ),
          
          // Slider de Volumen
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
              decoration: BoxDecoration(
                color: containerVolumeColor,
                borderRadius: BorderRadius.circular(30),
                border: _isDarkMode ? Border.all(color: Colors.cyanAccent.withOpacity(0.5), width: 1.5) : null,
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 10),
                ],
              ),
              child: Row(
                children: [
                  Icon(_volume == 0 ? Icons.volume_mute : Icons.volume_up, color: _isDarkMode ? Colors.cyanAccent : Colors.orange),
                  Expanded(
                    child: Slider(
                      value: _volume,
                      min: 0.0,
                      max: 1.0,
                      activeColor: _isDarkMode ? Colors.cyanAccent : Colors.orange,
                      onChanged: _cambiarVolumen,
                    ),
                  ),
                  Text('${(_volume * 100).toInt()}%', 
                    style: TextStyle(fontWeight: FontWeight.bold, color: _isDarkMode ? Colors.white : Colors.black)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuButton(BuildContext context, String text, Color colorOriginal, IconData icon, Widget screen) {
    return GestureDetector(
      onTap: () async {
        await Navigator.push(context, MaterialPageRoute(builder: (context) => screen));
        setState(() {
          _estrellasTotales += 3; 
        });
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: _isDarkMode ? const Color(0xFF1E293B) : colorOriginal,
          borderRadius: BorderRadius.circular(25),
          border: _isDarkMode ? Border.all(color: colorOriginal, width: 2.5) : null,
          boxShadow: [
            BoxShadow(
              color: _isDarkMode ? colorOriginal.withOpacity(0.4) : colorOriginal.withOpacity(0.3), 
              blurRadius: _isDarkMode ? 12 : 8, 
              offset: const Offset(0, 4)
            )
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: _isDarkMode ? colorOriginal : Colors.white),
            const SizedBox(width: 15),
            Text(text, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
          ],
        ),
      ),
    );
  }
}