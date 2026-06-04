import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // 👈 ¡Paquete de autenticación!
import '../home_screen.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  bool _isLoading = false;

  void _iniciarSesion() async {
    if (_emailController.text.trim().isEmpty || _passwordController.text.trim().isEmpty) {
      _mostrarAlerta('Por favor, llena todos los campos');
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Intento de inicio de sesión en Firebase
      await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      if (mounted) {
        // Redirigir a la Zona de Juegos si todo sale bien
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      }
    } on FirebaseAuthException catch (e) {
      String mensajeError = 'Ocurrió un error al iniciar sesión';
      if (e.code == 'user-not-found') {
        mensajeError = 'No encontramos ninguna cuenta con ese correo.';
      } else if (e.code == 'wrong-password') {
        mensajeError = 'Contraseña incorrecta. Inténtalo de nuevo.';
      } else if (e.code == 'invalid-email') {
        mensajeError = 'El formato del correo electrónico no es válido.';
      }
      _mostrarAlerta(mensajeError);
    } catch (e) {
      _mostrarAlerta('Error inesperado: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _mostrarAlerta(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(backgroundColor: Colors.redAccent, content: Text(mensaje)),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange[50],
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('✨ EduKids ✨', style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.orange)),
              const SizedBox(height: 10),
              const Text('¡Aprende jugando!', style: TextStyle(fontSize: 18, color: Colors.grey)),
              const SizedBox(height: 40),
              
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Correo Electrónico',
                  prefixIcon: const Icon(Icons.email),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                  fillColor: Colors.white,
                  filled: true,
                ),
              ),
              const SizedBox(height: 20),
              
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Contraseña',
                  prefixIcon: const Icon(Icons.lock),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                  fillColor: Colors.white,
                  filled: true,
                ),
              ),
              const SizedBox(height: 30),
              
              _isLoading
                  ? const CircularProgressIndicator(color: Colors.orange)
                  : SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        ),
                        onPressed: _iniciarSesion,
                        child: const Text('Entrar a Jugar 🚀', style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                    ),
              const SizedBox(height: 20),
              
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const RegisterScreen()),
                  );
                },
                child: const Text('¿No tienes cuenta? ¡Regístrate aquí!', style: TextStyle(color: Colors.deepPurple, fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}