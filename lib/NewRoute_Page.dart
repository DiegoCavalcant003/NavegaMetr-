import 'package:flutter/material.dart';
import 'Travel_Page.dart';
import 'SelectLineStart_page.dart';

class NewRoutePage extends StatefulWidget {
  final String linhaOrigem;
  final String estacaoOrigem;
  final String linhaDestino;
  final String estacaoDestino;

  const NewRoutePage({
    super.key,
    required this.linhaOrigem,
    required this.estacaoOrigem,
    required this.linhaDestino,
    required this.estacaoDestino,
  });

  @override
  State<NewRoutePage> createState() => _NewRoutePageState();
}

class _NewRoutePageState extends State<NewRoutePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Resumo da Rota'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.alt_route),
            tooltip: "Planejar nova viagem acessível",
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => const SelectLineStart_page(),
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Text(
              "Linha de Origem:",
              style: TextStyle(fontSize: 18),
            ),
            Text(
              widget.linhaOrigem,
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 20),

            Text(
              "Estação de Origem:",
              style: TextStyle(fontSize: 18),
            ),
            Text(
              widget.estacaoOrigem,
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 30),

            Text(
              "Linha de Destino:",
              style: TextStyle(fontSize: 18),
            ),
            Text(
              widget.linhaDestino,
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 20),

            Text(
              "Estação de Destino:",
              style: TextStyle(fontSize: 18),
            ),
            Text(
              widget.estacaoDestino,
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 40),

            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => TravelPage(
                      origem: widget.estacaoOrigem,
                      destino: widget.estacaoDestino,
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 60),
              ),
              child: const Text(
                "Iniciar Viagem",
                style: TextStyle(fontSize: 20),
              ),
            )
          ],
        ),
      ),
    );
  }
}