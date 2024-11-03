// import 'package:flutter/material.dart';
// import 'package:twitter_login/twitter_login.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import '../services/auth_service.dart';
// import 'home_page.dart';
// import 'register_page.dart';

// class LoginPage extends StatefulWidget {
//   const LoginPage({super.key});

//   @override
//   _LoginPageState createState() => _LoginPageState();
// }

// class _LoginPageState extends State<LoginPage> {
//   final AuthService _authService = AuthService();
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();

//   void _login() async {
//     if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
//       _showError('Por favor, ingresa tu correo y contraseña');
//       return;
//     }

//     var user = await _authService.loginWithEmail(
//       _emailController.text,
//       _passwordController.text,
//     );

//     if (user != null) {
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) => HomePage()),
//       );
//     } else {
//       _showError('Error al iniciar sesión');
//     }
//   }

//   Future<void> _loginWithTwitter() async {
//     final twitterLogin = TwitterLogin(
//       apiKey: '09iHxfkbpaMbJil2o3qJAHGNL',
//       apiSecretKey: '0NWBPEiczvkMRDRnfgUAtK5fiDUhQ0WC0H1vyK9057371gOSpe',
//       redirectURI: 'https://miapp-fc288.firebaseapp.com/__/auth/handler',
//     );

//     final authResult = await twitterLogin.login();

//     if (authResult.status == null) {
//       _showError('Error desconocido de inicio de sesión con Twitter');
//       return;
//     }

//     switch (authResult.status) {
//       case TwitterLoginStatus.loggedIn:
//         final credential = TwitterAuthProvider.credential(
//           accessToken: authResult.authToken!,
//           secret: authResult.authTokenSecret!,
//         );
//         UserCredential userCredential =
//             await FirebaseAuth.instance.signInWithCredential(credential);

//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (context) => HomePage()),
//         );
//         break;

//       case TwitterLoginStatus.cancelledByUser:
//         _showError('Inicio de sesión cancelado por el usuario');
//         break;

//       case TwitterLoginStatus.error:
//         _showError('Error de inicio de sesión con Twitter');
//         break;

//       default:
//         _showError('Error desconocido de inicio de sesión con Twitter');
//         break;
//     }
//   }

//   void _showError(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text(message)),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Iniciar Sesión')),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             TextField(
//               controller: _emailController,
//               decoration: const InputDecoration(labelText: 'Correo'),
//             ),
//             TextField(
//               controller: _passwordController,
//               decoration: const InputDecoration(labelText: 'Contraseña'),
//               obscureText: true,
//             ),
//             ElevatedButton(
//               onPressed: _login,
//               child: const Text('Iniciar Sesión'),
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: _loginWithTwitter,
//               child: const Text('Iniciar Sesión con Twitter'),
//             ),
//             const SizedBox(height: 20),
//             TextButton(
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => const RegisterPage()),
//                 );
//               },
//               child: const Text('¿No tienes una cuenta? Regístrate'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:twitter_login/twitter_login.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

  // Método de autenticación por correo y contraseña
  void _login() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      _showError('Por favor, ingresa tu correo y contraseña');
      return;
    }

    try {
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
        _showError('Error al iniciar sesión');
      }
    } catch (e) {
      _showError('Error de inicio de sesión: $e');
    }
  }

  // Método de autenticación con Twitter
  Future<void> _loginWithTwitter() async {
    final twitterLogin = TwitterLogin(
      apiKey: '09iHxfkbpaMbJil2o3qJAHGNL',
      apiSecretKey: '0NWBPEiczvkMRDRnfgUAtK5fiDUhQ0WC0H1vyK9057371gOSpe',
      redirectURI: 'https://miapp-fc288.firebaseapp.com/__/auth/handler',
    );

    try {
      final authResult = await twitterLogin.login();

      if (authResult.status == null) {
        _showError('Error desconocido de inicio de sesión con Twitter');
        return;
      }

      switch (authResult.status) {
        case TwitterLoginStatus.loggedIn:
          final credential = TwitterAuthProvider.credential(
            accessToken: authResult.authToken!,
            secret: authResult.authTokenSecret!,
          );

          // Intento de inicio de sesión en Firebase con las credenciales de Twitter
          UserCredential userCredential =
              await FirebaseAuth.instance.signInWithCredential(credential);

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomePage()),
          );
          break;

        case TwitterLoginStatus.cancelledByUser:
          _showError('Inicio de sesión cancelado por el usuario');
          break;

        case TwitterLoginStatus.error:
          _showError(
              'Error de inicio de sesión con Twitter: ${authResult.errorMessage}');
          break;

        default:
          _showError('Error desconocido de inicio de sesión con Twitter');
          break;
      }
    } catch (e) {
      _showError('Error de autenticación con Twitter: $e');
    }
  }

  // Método para mostrar errores en pantalla
  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Iniciar Sesión')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Correo'),
              keyboardType: TextInputType.emailAddress,
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Contraseña'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _login,
              child: const Text('Iniciar Sesión'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _loginWithTwitter,
              child: const Text('Iniciar Sesión con Twitter'),
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const RegisterPage()),
                );
              },
              child: const Text('¿No tienes una cuenta? Regístrate'),
            ),
          ],
        ),
      ),
    );
  }
}
