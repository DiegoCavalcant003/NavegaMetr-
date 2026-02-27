import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Travel_Page.dart';
import 'SelectLineStart_page.dart';
import 'route_model.dart';

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

  Future<void> salvarNoHistorico() async {
    final prefs = await SharedPreferences.getInstance();

    List<String> lista = prefs.getStringList("historicoRotas") ?? [];

    final novaRota = RouteModel(
      origem: widget.estacaoOrigem,
      destino: widget.estacaoDestino,
      dataHora: DateTime.now().toString(),
    );

    lista.add(jsonEncode(novaRota.toJson()));

    await prefs.setStringList("historicoRotas", lista);
  }

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

            const Text(
              "Linha de Origem:",
              style: TextStyle(fontSize: 18),
            ),
            Text(
              widget.linhaOrigem,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              "Estação de Origem:",
              style: TextStyle(fontSize: 18),
            ),
            Text(
              widget.estacaoOrigem,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 30),

            const Text(
              "Linha de Destino:",
              style: TextStyle(fontSize: 18),
            ),
            Text(
              widget.linhaDestino,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              "Estação de Destino:",
              style: TextStyle(fontSize: 18),
            ),
            Text(
              widget.estacaoDestino,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 40),

            ElevatedButton(
              onPressed: () async {

                await salvarNoHistorico();

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
            ),
          ],
        ),
      ),
    );
  }
}