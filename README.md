# Edukids 🦝📱

**Edukids** es una aplicación móvil pedagógica y gamificada desarrollada con **Flutter** y **Dart**, diseñada para apoyar el proceso de alfabetización inicial en niños de 4 a 7 años. La aplicación combina estímulos visuales, mecánicos y auditivos para facilitar el aprendizaje de manera autónoma y divertida.

## 🚀 Funciones Principales

1. **Pantalla de Autenticación (Login):** Registro e inicio de sesión seguro integrado en tiempo real con **Firebase Authentication** para resguardar el perfil de cada usuario.
2. **Lienzo de Trazado de Letras (Trazado):** Pizarra digital interactiva donde el menor dibuja las letras del abecedario sobre una silueta guía en color gris, optimizada gráficamente con `RepaintBoundary` para evitar retrasos (*lag*).
3. **Síntesis de Voz Interactiva (Text to Speech):** Motor auditivo (`flutter_tts`) que dicta instrucciones automáticas y pronuncia cada letra utilizando una voz femenina en español (es-MX) configurada a un ritmo pausado e infantil.
4. **Música Ambiental Integrada:** Reproducción automática de una pista musical de fondo (`musica_fondo.mp3`) mediante `audioplayers` para hacer el entorno de aprendizaje más envolvente y agradable.
5. **Configuración de Línea Gráfica (Modo Oscuro):** Switch interactivo en el menú principal que permite alternar entre la interfaz clásica diurna y un diseño temático oscuro espacial para descansar la vista.
6. **Temporizador de Seguridad (Timer):** Panel de Control Parental protegido por una contraseña de 4 dígitos para limitar el tiempo de pantalla diario del menor de forma saludable.

## 🛠️ Tecnologías y Paquetes Utilizados

* **Framework:** Flutter & Dart
* **Backend:** Firebase Core & Firebase Auth
* **Plugins:** `flutter_tts`, `audioplayers`, `flutter_launcher_icons`

## 📦 Instalación (Android)
El archivo ejecutable optimizado para dispositivos de 64 bits se encuentra compilado bajo el nombre de **`app-arm64-v8a-release.apk`** dentro de las rutas de distribución del proyecto.git add README.md