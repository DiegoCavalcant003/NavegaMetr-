import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'SelectLineDestination_Page.dart';

class SelectStationStart_page extends StatefulWidget {
  final String linha;

  const SelectStationStart_page({super.key, required this.linha});

  @override
  State<SelectStationStart_page> createState() =>
      _SelectStationStart_pageState();
}

class _SelectStationStart_pageState extends State<SelectStationStart_page> {
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
    tts.speak("Diga ou escreva a estação de partida");
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
    List<String> lista = estacoes[widget.linha] ?? [];

    bool existe = lista.any((e) => e.toLowerCase() == texto);

    if (existe) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => SelectLineDestination_Page(
            linhaOrigem: widget.linha,
            estacaoOrigem: controller.text.trim(),
          ),
        ),
      );
    } else {
      setState(() {
        erro = "Estação inválida na linha selecionada.";
      });
      tts.speak("Estação inválida");
    }
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
          "Estação Partida",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: const BackButton(color: Colors.black),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                widget.linha,
                style: const TextStyle(
                    fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
              ),
              const SizedBox(height: 30),
              TextField(
                controller: controller,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                  hintText: "Digite ou fale a estação",
                  hintStyle: const TextStyle(color: Colors.black54),
                ),
                style: const TextStyle(color: Colors.black),
              ),
              const SizedBox(height: 20),
              if (erro.isNotEmpty)
                Text(
                  erro,
                  style: const TextStyle(color: Colors.red),
                ),
              const SizedBox(height: 25),

              // Botão de áudio estilo padronizado
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton.icon(
                  onPressed: ouvir,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    elevation: 4,
                  ),
                  icon: const FaIcon(
                    FontAwesomeIcons.microphone,
                    color: Colors.white,
                  ),
                  label: const Text(
                    'Falar estação',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
              ),

              const SizedBox(height: 35),

              ElevatedButton(
                onPressed: validar,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 65),
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                  elevation: 4,
                ),
                child: const Text(
                  "Confirmar",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}