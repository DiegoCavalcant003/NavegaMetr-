import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'SelectLineStart_page.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final FlutterTts flutterTts = FlutterTts();

  List<Map<String, String>> historicoRotas = [
    {
      "origem": "Praça da Sé",
      "destino": "Vila Mariana"
    },
    {
      "origem": "Luz",
      "destino": "Tatuapé"
    },
  ];

  void falarRota(String origem, String destino) async {
    await flutterTts.speak("Rota selecionada de $origem até $destino.");
  }

  void confirmarLimparHistorico() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.white,
        title: const Text(
          "Limpar histórico?",
          style: TextStyle(color: Colors.black),
        ),
        content: const Text(
          "Tem certeza que deseja apagar todas as rotas?",
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          TextButton(
            child: const Text(
              "Cancelar",
              style: TextStyle(color: Colors.black),
            ),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: const Text(
              "Apagar",
              style: TextStyle(color: Colors.red),
            ),
            onPressed: () {
              setState(() {
                historicoRotas.clear();
              });
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  void confirmarRepetirRota(String origem, String destino) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.white,
        title: const Text(
          "Repetir rota?",
          style: TextStyle(color: Colors.black),
        ),
        content: Text(
          "Deseja repetir a rota de $origem até $destino?",
          style: const TextStyle(color: Colors.black),
        ),
        actions: [
          TextButton(
            child: const Text(
              "Cancelar",
              style: TextStyle(color: Colors.black),
            ),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              elevation: 2,
            ),
            child: const Text(
              "Repetir",
              style: TextStyle(color: Colors.black),
            ),
            onPressed: () {
              falarRota(origem, destino);
              Navigator.pop(context);

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => SelectLineStart_page(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: true,
        title: const Text(
          "Histórico",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),

        leading: IconButton(
          icon: const FaIcon(
            FontAwesomeIcons.arrowLeft,
            color: Colors.black,
          ),
          onPressed: () => Navigator.pop(context),
        ),

        actions: [
          IconButton(
            icon: const FaIcon(
              FontAwesomeIcons.trash,
              color: Colors.black,
            ),
            onPressed: confirmarLimparHistorico,
          ),
        ],
      ),

      body: historicoRotas.isEmpty
          ? const Center(
        child: Text(
          "Nenhuma rota salva.",
          style: TextStyle(
            fontSize: 18,
            color: Colors.black,
          ),
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: historicoRotas.length,
        itemBuilder: (context, index) {
          final rota = historicoRotas[index];

          return GestureDetector(
            onTap: () => confirmarRepetirRota(
              rota["origem"]!,
              rota["destino"]!,
            ),
            child: Container(
              margin: const EdgeInsets.only(bottom: 20),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: const [
                  BoxShadow(
                    blurRadius: 6,
                    color: Colors.black12,
                  ),
                ],
              ),
              child: Column(
                children: [
                  const FaIcon(
                    FontAwesomeIcons.route,
                    color: Colors.black,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "${rota["origem"]} → ${rota["destino"]}",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}