import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'home_page.dart';

class FinishedPage extends StatelessWidget {
  final String origem;
  final String destino;

  const FinishedPage({
    super.key,
    required this.origem,
    required this.destino,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Rota Finalizada"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            const Icon(
              FontAwesomeIcons.circleCheck,
              size: 100,
              color: Colors.green,
            ),

            const SizedBox(height: 30),

            const Text(
              "Você chegou ao destino!",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 20),

            Text(
              "$origem ➜ $destino",
              style: const TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 40),

            ElevatedButton.icon(
              icon: const Icon(FontAwesomeIcons.house),
              label: const Text("Voltar para Home"),
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const HomePage()),
                      (route) => false,
                );
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 60),
              ),
            )
          ],
        ),
      ),
    );
  }
}