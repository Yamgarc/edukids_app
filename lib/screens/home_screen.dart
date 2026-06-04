import 'package:flutter/material.dart';
import 'juego_leer_screen.dart';
import 'juego_escribir_screen.dart';
import 'juego_palabras_screen.dart'; 
import 'juego_silabas_screen.dart';
import 'juego_memoria_screen.dart';
import 'juego_sonidos_screen.dart';
import 'juego_intruso_screen.dart';
import 'juego_rimas_screen.dart';
import 'juego_articulos_screen.dart';
import 'juego_comprension_screen.dart'; // 👈 ¡Última importación añadida con éxito!

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[50],
      appBar: AppBar(
        title: const Text('🎯 ¡Mi Zona de Juegos!', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.orange,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.stars, color: Colors.yellow, size: 30),
            onPressed: () {}, 
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  '¿Qué quieres aprender hoy?',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.deepPurple),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                
                // 1️⃣ JUGAR A LEER
                _buildMenuButton(context, '¡Quiero Leer!', Colors.blue, Icons.menu_book, const JuegoLeerScreen()),
                const SizedBox(height: 20),
                
                // 2️⃣ JUGAR A ESCRIBIR
                _buildMenuButton(context, '¡Quiero Escribir!', Colors.orange, Icons.edit, const JuegoEscribirScreen()),
                const SizedBox(height: 20),
                
                // 3️⃣ JUGAR A ARMAR PALABRAS
                _buildMenuButton(context, '¡Armar Palabras!', Colors.deepPurple, Icons.extension, const JuegoPalabrasScreen()),
                const SizedBox(height: 20),
                
                // 4️⃣ JUGAR A SÍLABAS PERDIDAS
                _buildMenuButton(context, 'Sílabas Perdidas', Colors.teal, Icons.extension, const JuegoSilabasScreen()),
                const SizedBox(height: 20),
                
                // 5️⃣ JUGAR AL MEMORAMA
                _buildMenuButton(context, 'Memorama Mágico', Colors.pinkAccent, Icons.style, const JuegoMemoriaScreen()),
                const SizedBox(height: 20),
                
                // 6️⃣ JUGAR A SONIDOS MÁGICOS
                _buildMenuButton(context, 'Sonidos Mágicos', Colors.amber[700]!, Icons.volume_up, const JuegoSonidosScreen()),
                const SizedBox(height: 20),
                
                // 7️⃣ JUGAR AL INTRUSO LOCO
                _buildMenuButton(context, 'El Intruso Loco', Colors.purple, Icons.search, const JuegoIntrusoScreen()),
                const SizedBox(height: 20),
                
                // 8️⃣ JUGAR A RIMAS MÁGICAS
                _buildMenuButton(context, 'Rimas Mágicas', Colors.indigo, Icons.music_note, const JuegoRimasScreen()),
                const SizedBox(height: 20),

                // 9️⃣ JUGAR A CAZADOR DE ARTÍCULOS
                _buildMenuButton(context, 'Cazador de Artículos', Colors.cyan[700]!, Icons.catching_pokemon, const JuegoArticulosScreen()),
                const SizedBox(height: 20),

                // 🔟 JUGAR A HISTORIAS MÁGICAS (¡El juego número 10!)
                _buildMenuButton(context, 'Historias Mágicas', Colors.teal, Icons.auto_stories, const JuegoComprensionScreen()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMenuButton(BuildContext context, String text, Color color, IconData icon, Widget screen) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => screen));
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [BoxShadow(color: color.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 4))],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: Colors.white),
            const SizedBox(width: 15),
            Text(text, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
          ],
        ),
      ),
    );
  }
}