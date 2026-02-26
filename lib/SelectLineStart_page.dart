import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'SelectStationStart_page.dart';

class SelectLineStart_page extends StatefulWidget {
  const SelectLineStart_page({super.key});

  @override
  State<SelectLineStart_page> createState() =>
      _SelectLineStart_pageState();
}

class _SelectLineStart_pageState
    extends State<SelectLineStart_page> {

  final FlutterTts tts = FlutterTts();

  final Map<String, Color> linhas = {
    "Linha 1 - Azul": Colors.blue,
    "Linha 2 - Verde": Colors.green,
    "Linha 3 - Vermelha": Colors.red,
  };

  @override
  void initState() {
    super.initState();
    tts.speak("Selecione a linha de partida");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Linha de Partida")),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: linhas.entries.map((linha) {
              return Padding(
                padding:
                const EdgeInsets.symmetric(vertical: 15),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: linha.value,
                    minimumSize:
                    const Size(double.infinity, 80),
                    textStyle: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            SelectStationStart_page(
                              linha: linha.key,
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
      ),
    );
  }
}