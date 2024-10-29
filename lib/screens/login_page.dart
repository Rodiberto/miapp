import 'package:flutter/material.dart';
import 'package:flutter_web_auth/flutter_web_auth.dart';
import '../services/auth_service.dart';
import 'home_page.dart';
import 'register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final AuthService _authService = AuthService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Método de inicio de sesión con correo y contraseña
  void _login() async {
    var user = await _authService.loginWithEmail(
      _emailController.text,
      _passwordController.text,
    );

    if (user != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al iniciar sesión')),
      );
    }
  }

  // Método para iniciar sesión con Instagram
  Future<void> _loginWithInstagram() async {
    const clientId = '431032116699928';
    const redirectUri = 'https://localhost';
    const responseType = 'token';

    final authUrl = Uri.https(
      'api.instagram.com',
      '/oauth/authorize',
      {
        'client_id': clientId,
        'redirect_uri': redirectUri,
        'scope': 'user_profile',
        'response_type': responseType,
      },
    );

    try {
      // Inicia la autenticación y recibe la URL de redirección con el token
      final result = await FlutterWebAuth.authenticate(
          url: authUrl.toString(), callbackUrlScheme: "https");

      // Extrae el token de acceso desde la URL de redirección
      final accessToken = Uri.parse(result).fragment.split("=")[1];

      // Ahora puedes usar el token para obtener datos del perfil o redirigir a otra página
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al iniciar sesión con Instagram')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Iniciar Sesión')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Correo'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Contraseña'),
              obscureText: true,
            ),
            ElevatedButton(
              onPressed: _login,
              child: Text('Iniciar Sesión'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _loginWithInstagram,
              child: Text('Iniciar Sesión con Instagram'),
            ),
            SizedBox(height: 20),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegisterPage()),
                );
              },
              child: Text('¿No tienes una cuenta? Regístrate'),
            ),
          ],
        ),
      ),
    );
  }
}
