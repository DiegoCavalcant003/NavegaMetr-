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
    "Linha 1 - Azul": Colors.blue.shade300,
    "Linha 2 - Verde": Colors.green.shade300,
    "Linha 3 - Vermelha": Colors.red.shade300,
    "Linha 4 - Amarela": Colors.yellow.shade600,
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
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: true,
        title: const Text(
          "Linha de Destino",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: Image.network(
            'https://img.icons8.com/?size=100&id=99857&format=png&color=000000',
            width: 28,
            height: 28,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: linhas.entries.map((linha) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: linha.value,
                    minimumSize: const Size(double.infinity, 75),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                      side: const BorderSide(
                        color: Colors.black26,
                        width: 1.5,
                      ),
                    ),
                    elevation: 4,
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
                  child: Text(
                    linha.key,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}