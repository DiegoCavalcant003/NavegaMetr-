import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'NewRoute_Page.dart';

class SelectStationDestination_Page extends StatefulWidget {
  final String linhaOrigem;
  final String estacaoOrigem;
  final String linhaDestino;

  const SelectStationDestination_Page({
    super.key,
    required this.linhaOrigem,
    required this.estacaoOrigem,
    required this.linhaDestino,
  });

  @override
  State<SelectStationDestination_Page> createState() =>
      _SelectStationDestination_PageState();
}

class _SelectStationDestination_PageState
    extends State<SelectStationDestination_Page> {

  final FlutterTts tts = FlutterTts();
  final stt.SpeechToText speech = stt.SpeechToText();
  final TextEditingController controller = TextEditingController();

  bool ouvindo = false;
  String erro = "";

  final Map<String, List<String>> estacoes = {

    "Linha 1 - Azul": [
      "Tucuruvi",
      "Parada Inglesa",
      "Jardim São Paulo-Ayrton Senna",
      "Santana",
      "Carandiru",
      "Portuguesa-Tietê",
      "Armênia",
      "Tiradentes",
      "Luz",
      "São Bento",
      "Sé",
      "Liberdade",
      "São Joaquim",
      "Vergueiro",
      "Paraíso",
      "Ana Rosa",
      "Vila Mariana",
      "Santa Cruz",
      "Praça da Árvore",
      "Saúde",
      "São Judas",
      "Conceição",
      "Jabaquara"
    ],

    "Linha 2 - Verde": [
      "Vila Madalena",
      "Santuário Nossa Senhora de Fátima-Sumaré",
      "Clínicas",
      "Consolação",
      "Trianon-Masp",
      "Brigadeiro",
      "Paraíso",
      "Ana Rosa",
      "Chácara Klabin",
      "Santos-Imigrantes",
      "Alto do Ipiranga",
      "Sacoma",
      "Tamanduateí",
      "Vila Prudente"
    ],

    "Linha 3 - Vermelha": [
      "Palmeiras-Barra Funda",
      "Marechal Deodoro",
      "Santa Cecília",
      "República",
      "Anhangabaú",
      "Sé",
      "Pedro II",
      "Brás",
      "Bresser-Mooca",
      "Belém",
      "Tatuapé",
      "Carrão-Assaí Atacadista",
      "Penha",
      "Vila Matilde",
      "Guilhermina-Esperança",
      "Patriarca-Vila Ré",
      "Artur Alvim",
      "Corinthians-Itaquera"
    ],
  };

  @override
  void initState() {
    super.initState();
    tts.speak("Diga ou escreva a estação de destino");
  }

  void ouvir() async {
    bool available = await speech.initialize();
    if (available) {
      setState(() => ouvindo = true);
      speech.listen(onResult: (result) {
        setState(() {
          controller.text = result.recognizedWords;
        });
      });
    }
  }

  void validar() {
    String texto = controller.text.trim().toLowerCase();
    List<String> lista = estacoes[widget.linhaDestino] ?? [];

    bool existe =
    lista.any((e) => e.toLowerCase() == texto);

    if (!existe) {
      setState(() {
        erro = "Estação inválida na linha selecionada.";
      });
      tts.speak("Estação inválida");
      return;
    }

    if (texto == widget.estacaoOrigem.toLowerCase()) {
      setState(() {
        erro = "Destino não pode ser igual à origem.";
      });
      tts.speak("Destino não pode ser igual à origem");
      return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => NewRoutePage(
          linhaOrigem: widget.linhaOrigem,
          estacaoOrigem: widget.estacaoOrigem,
          linhaDestino: widget.linhaDestino,
          estacaoDestino: controller.text.trim(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Estação Destino")),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              Text(widget.linhaDestino,
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold)),

              const SizedBox(height: 30),

              TextField(
                controller: controller,
                textAlign: TextAlign.center,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Digite ou fale a estação",
                ),
              ),

              const SizedBox(height: 20),

              if (erro.isNotEmpty)
                Text(erro,
                    style: const TextStyle(color: Colors.red)),

              const SizedBox(height: 25),

              FloatingActionButton(
                onPressed: ouvir,
                child: const Icon(Icons.mic),
              ),

              const SizedBox(height: 35),

              ElevatedButton(
                onPressed: validar,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 65),
                ),
                child: const Text("Confirmar Destino"),
              )
            ],
          ),
        ),
      ),
    );
  }
}