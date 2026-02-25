import 'package:flutter/material.dart';
import 'cadastro_page.dart';
import 'Permission_Page.dart'; // <- Importa a página de permissões

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();

  void _login() {
    if (_emailController.text.isEmpty || _senhaController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha login e senha')),
      );
      return;
    }

    // Aqui, navega para a PermissionPage
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const PermissionPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(
              'https://img.icons8.com/?size=100&id=118880&format=png&color=000000',
              height: 80,
            ),
            const SizedBox(height: 16),
            const Text(
              'NavegaMetrô',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 32),

            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Login',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 16),

            TextField(
              controller: _senhaController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Senha',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 24),

            ElevatedButton(
              onPressed: _login,
              child: const Text('Entrar'),
            ),

            const SizedBox(height: 16),

            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CadastroPage()),
                );
              },
              child: const Text('Fazer Cadastro'),
            ),
          ],
        ),
      ),
    );
  }
}