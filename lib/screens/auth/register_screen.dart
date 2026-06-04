import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../home_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  bool _isLoading = false;

  void _registrarUsuario() async {
    if (_emailController.text.trim().isEmpty || _passwordController.text.trim().isEmpty) {
      _mostrarAlerta('Por favor, rellena todos los campos');
      return;
    }

    if (_passwordController.text.trim().length < 6) {
      _mostrarAlerta('La contraseña debe tener al menos 6 caracteres');
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Registro en Firebase Authentication
      await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(backgroundColor: Colors.green, content: Text('¡Cuenta creada con éxito! 🎉')),
        );
        // Redirige directo a la aplicación
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      }
    } on FirebaseAuthException catch (e) {
      String mensajeError = 'Error al registrar usuario';
      if (e.code == 'email-already-in-use') {
        mensajeError = 'Este correo ya está registrado en otra cuenta.';
      } else if (e.code == 'invalid-email') {
        mensajeError = 'El formato del correo electrónico no sirve.';
      } else if (e.code == 'weak-password') {
        mensajeError = 'La contraseña elegida es muy débil.';
      }
      _mostrarAlerta(mensajeError);
    } catch (e) {
      _mostrarAlerta('Error: $e');
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
      backgroundColor: Colors.deepPurple[50],
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0, iconTheme: const IconThemeData(color: Colors.deepPurple)),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('📝 Crear Cuenta', style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.deepPurple)),
              const SizedBox(height: 10),
              const Text('¡Únete a la aventura de EduKids!', style: TextStyle(fontSize: 16, color: Colors.grey)),
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
                  labelText: 'Contraseña (mínimo 6 letras/números)',
                  prefixIcon: const Icon(Icons.lock),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                  fillColor: Colors.white,
                  filled: true,
                ),
              ),
              const SizedBox(height: 35),
              
              _isLoading
                  ? const CircularProgressIndicator(color: Colors.deepPurple)
                  : SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        ),
                        onPressed: _registrarUsuario,
                        child: const Text('Registrarme e Iniciar ✨', style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}