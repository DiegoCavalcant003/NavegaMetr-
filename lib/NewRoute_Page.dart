import 'package:flutter/material.dart';
import 'Travel_Page.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class NewRoutePage extends StatefulWidget {
  const NewRoutePage({super.key});

  @override
  State<NewRoutePage> createState() => _NewRoutePageState();
}

class _NewRoutePageState extends State<NewRoutePage> {
  String? origemLinha;
  String? origem;
  String? destinoLinha;
  String? destino;

  final TextEditingController origemController = TextEditingController();
  final TextEditingController destinoController = TextEditingController();

  late stt.SpeechToText _speech;
  bool _isListening = false;

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  final Map<String, Map<String, dynamic>> linhas = {
    'Linha 1 - Azul': {
      'color': Colors.blue,
      'icon': Icons.directions_train,
      'estacoes': [
        'Tucuruvi', 'Parada Inglesa', 'Jardim São Paulo-Ayrton Senna', 'Santana',
        'Carandiru', 'Portuguesa-Tietê', 'Armênia', 'Tiradentes', 'Luz', 'São Bento',
        'Sé', 'São Joaquim', 'Vergueiro', 'Paraíso', 'Ana Rosa', 'Vila Mariana',
        'Santa Cruz', 'Praça da Árvore', 'Saúde', 'São Judas', 'Conceição', 'Jabaquara',
      ],
    },
    'Linha 2 - Verde': {
      'color': Colors.green,
      'icon': Icons.directions_subway,
      'estacoes': [
        'Vila Madalena', 'Santuário Nossa Senhora de Fátima-Sumaré', 'Clínicas',
        'Consolação', 'Trianon-Masp', 'Brigadeiro', 'Paraíso', 'Ana Rosa',
        'Chácara Klabin', 'Santos-Imigrantes', 'Alto do Ipiranga', 'Sacomã', 'Vila Prudente'
      ],
    },
    'Linha 3 - Vermelha': {
      'color': Colors.red,
      'icon': Icons.directions_bus,
      'estacoes': [
        'Corinthians-Itaquera', 'Artur Alvim', 'Patriarca-Vila Ré', 'Guilhermina-Esperança',
        'Vila Matilde', 'Penha', 'Carrão', 'Tatuapé', 'Belém', 'Bresser-Mooca',
        'Brás', 'Pedro II', 'Sé', 'Anhangabaú', 'República', 'Santa Cecília',
        'Marechal Deodoro', 'Palmeiras-Barra Funda'
      ],
    },
  };

  List<String> get origemEstacoes {
    if (origemLinha == null) return [];
    final estacoes = linhas[origemLinha]?['estacoes'] as List<dynamic>?;
    if (estacoes == null) return [];
    return estacoes
        .map((e) => e.toString())
        .where((e) => e.toLowerCase().contains(origemController.text.toLowerCase()))
        .toList();
  }

  List<String> get destinoEstacoes {
    if (destinoLinha == null) return [];
    final estacoes = linhas[destinoLinha]?['estacoes'] as List<dynamic>?;
    if (estacoes == null) return [];
    return estacoes
        .map((e) => e.toString())
        .where((e) => e.toLowerCase().contains(destinoController.text.toLowerCase()))
        .toList();
  }

  void startListening() async {
    bool available = await _speech.initialize();
    if (available) {
      setState(() => _isListening = true);
      _speech.listen(onResult: (val) {
        setState(() {
          String texto = val.recognizedWords.toLowerCase();
          if (origemLinha != null) origemController.text = texto;
          if (destinoLinha != null) destinoController.text = texto;
        });
      });
    }
  }

  void stopListening() {
    _speech.stop();
    setState(() => _isListening = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nova Rota'),
        centerTitle: true,
        leading: IconButton(
          icon: Image.network(
            'https://img.icons8.com/?size=100&id=99857&format=png&color=000000',
            width: 28,
            height: 28,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Linha de Partida'),
                items: linhas.keys
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (v) {
                  setState(() {
                    origemLinha = v;
                    origem = null;
                    origemController.clear();
                  });
                },
                initialValue: origemLinha,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Estação de Partida'),
                items: origemEstacoes
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (v) => setState(() => origem = v),
                initialValue: origem,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Linha de Destino'),
                items: linhas.keys
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (v) {
                  setState(() {
                    destinoLinha = v;
                    destino = null;
                    destinoController.clear();
                  });
                },
                initialValue: destinoLinha,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Estação de Destino'),
                items: destinoEstacoes
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (v) => setState(() => destino = v),
                initialValue: destino,
              ),
              const SizedBox(height: 24),
              FloatingActionButton(
                backgroundColor: Colors.deepPurple,
                onPressed: _isListening ? stopListening : startListening,
                child: Icon(_isListening ? Icons.mic : Icons.mic_none),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: origem != null && destino != null && origem != destino
                    ? () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => TravelPage(
                        origem: origem!,
                        destino: destino!,
                      ),
                    ),
                  );
                }
                    : null,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 60),
                  textStyle: const TextStyle(fontSize: 20),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Iniciar Viagem'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}