import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'SelectStationDestination_Page.dart';

class SelectLineDestination_Page extends StatefulWidget {
  final String linhaOrigem;
  final String estacaoOrigem;

  const SelectLineDestination_Page({
    super.key,
    required this.linhaOrigem,
    required this.estacaoOrigem,
  });

  @override
  State<SelectLineDestination_Page> createState() =>
      _SelectLineDestination_PageState();
}

class _SelectLineDestination_PageState
    extends State<SelectLineDestination_Page> {

  final FlutterTts tts = FlutterTts();

  final Map<String, Color> linhas = {
    "Linha 1 - Azul": Colors.blue,
    "Linha 2 - Verde": Colors.green,
    "Linha 3 - Vermelha": Colors.red,
  };

  @override
  void initState() {
    super.initState();
    falar("Escolha a linha de destino");
  }

  void falar(String texto) async {
    await tts.speak(texto);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Linha de Destino")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: linhas.entries.map((linha) {
            return Padding(
              padding: const EdgeInsets.all(12),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: linha.value,
                  minimumSize: const Size(300, 80),
                  textStyle: const TextStyle(fontSize: 22),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => SelectStationDestination_Page(
                        linhaOrigem: widget.linhaOrigem,
                        estacaoOrigem: widget.estacaoOrigem,
                        linhaDestino: linha.key,
                      ),
                    ),
                  );
                },
                child: Text(linha.key),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}