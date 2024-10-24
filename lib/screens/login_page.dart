import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'home_page.dart';
import 'register_page.dart';
import 'package:twitter_login/twitter_login.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final AuthService _authService = AuthService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void _login() async {
    var user = await _authService.loginWithEmail(
      _emailController.text,
      _passwordController.text,
    );

    if (user != null) {
      // Si el login es exitoso, redirige a la página de inicio
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } else {
      // Maneja el error, por ejemplo, mostrando un Snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al iniciar sesión')),
      );
    }
  }

  // Método para iniciar sesión con Twitter
  Future<void> _loginWithTwitter() async {
    final twitterLogin = TwitterLogin(
      apiKey: 'LTZ3bFoxQ0FqWXVsRDdPUDlYUlc6MTpjaQ', // Sustituye con tu API Key
      apiSecretKey:
          '3rFHiQ_m0qmJkikpjRYZLBoTIXylJ21hSlY8wgbQm4olHhon74', // Sustituye con tu API Secret
      redirectURI: 'https://miapp-fc288.firebaseapp.com/__/auth/handler',
    );

    final authResult = await twitterLogin.login();

    if (authResult.status == TwitterLoginStatus.loggedIn) {
      final twitterAuthCredential = TwitterAuthProvider.credential(
        accessToken: authResult.authToken!,
        secret: authResult.authTokenSecret!,
      );

      UserCredential userCredential =
          await _auth.signInWithCredential(twitterAuthCredential);

      if (userCredential.user != null) {
        // Redirige a la página principal si el login es exitoso
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      }
    } else {
      // Manejo del error si el login no es exitoso
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al iniciar sesión con Twitter')),
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
            SizedBox(height: 20), // Espacio entre botones
            ElevatedButton(
              onPressed: _loginWithTwitter,
              child: Text('Iniciar Sesión con Twitter'),
            ),
            SizedBox(
                height: 20), // Espacio entre el botón de login y el registro
            TextButton(
              onPressed: () {
                // Redirige al usuario a la página de registro
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
