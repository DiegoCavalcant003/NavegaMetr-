// lib/Travel_Page.dart
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

class TravelPage extends StatefulWidget {
  final String origem;
  final String destino;

  const TravelPage({
    super.key,
    required this.origem,
    required this.destino,
  });

  @override
  State<TravelPage> createState() => _TravelPageState();
}

class _TravelPageState extends State<TravelPage> {
  LatLng? minhaLocalizacao;
  bool carregando = true;

  bool chegouNaOrigem = false;
  int indiceEstacaoAtual = 0;
  String instrucaoAtual = 'Siga até a estação de origem';

  final MapController _mapController = MapController();

  final Map<String, LatLng> estacoesMapa = {
    'Tucuruvi': LatLng(-23.4783, -46.5796),
    'Parada Inglesa': LatLng(-23.4665, -46.5828),
    'Luz': LatLng(-23.5337, -46.6253),
    'São Bento': LatLng(-23.5505, -46.6340),
    'Sé': LatLng(-23.5505, -46.6333),
    'Paraíso': LatLng(-23.5825, -46.6391),
    'Ana Rosa': LatLng(-23.5913, -46.6398),
    'Vila Mariana': LatLng(-23.5975, -46.6419),
    'Jabaquara': LatLng(-23.6952, -46.6438),
  };

  List<LatLng> pontosRota() {
    LatLng? inicio = estacoesMapa[widget.origem];
    LatLng? fim = estacoesMapa[widget.destino];
    if (inicio == null || fim == null) return [];
    return [inicio, fim];
  }

  @override
  void initState() {
    super.initState();
    obterLocalizacao();
  }

  Future<void> obterLocalizacao({bool moverMapa = false}) async {
    Position posicao = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    final novaPosicao = LatLng(posicao.latitude, posicao.longitude);

    setState(() {
      minhaLocalizacao = novaPosicao;
      carregando = false;
    });

    if (moverMapa) {
      _mapController.move(novaPosicao, 16);
    }
  }

  @override
  Widget build(BuildContext context) {
    final centroMapa = minhaLocalizacao ?? estacoesMapa[widget.origem];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sua Viagem'),
        leading: IconButton(
          icon: Image.network(
            'https://img.icons8.com/?size=100&id=99857&format=png&color=000000',
            width: 28,
            height: 28,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: carregando || centroMapa == null
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(12),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black54),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Stack(
            children: [
              FlutterMap(
                mapController: _mapController,
                options: MapOptions(
                  initialCenter: centroMapa,
                  initialZoom: 14,
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                    'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName:
                    'com.example.meu_primeiro_app',
                  ),
                  PolylineLayer(
                    polylines: [
                      Polyline(
                        points: pontosRota(),
                        strokeWidth: 6,
                        color: Colors.red,
                      ),
                    ],
                  ),
                  MarkerLayer(
                    markers: [
                      if (minhaLocalizacao != null)
                        Marker(
                          point: minhaLocalizacao!,
                          width: 45,
                          height: 45,
                          child: Image.network(
                            'https://img.icons8.com/?size=100&id=113070&format=png&color=FF0000',
                            width: 45,
                            height: 45,
                          ),
                        ),
                      if (estacoesMapa[widget.origem] != null)
                        Marker(
                          point: estacoesMapa[widget.origem]!,
                          width: 35,
                          height: 35,
                          child: Image.network(
                            'https://img.icons8.com/?size=100&id=99857&format=png&color=0000FF',
                            width: 35,
                            height: 35,
                          ),
                        ),
                      if (estacoesMapa[widget.destino] != null)
                        Marker(
                          point: estacoesMapa[widget.destino]!,
                          width: 35,
                          height: 35,
                          child: Image.network(
                            'https://img.icons8.com/?size=100&id=99857&format=png&color=00FF00',
                            width: 35,
                            height: 35,
                          ),
                        ),
                    ],
                  ),
                ],
              ),

              Positioned(
                top: 16,
                left: 16,
                right: 16,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${widget.origem} ➜ ${widget.destino}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),

              Positioned(
                bottom: 20,
                left: 20,
                right: 20,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    await obterLocalizacao(moverMapa: true);
                  },
                  icon: Image.network(
                    'https://img.icons8.com/?size=100&id=113070&format=png&color=000000',
                    width: 24,
                    height: 24,
                  ),
                  label: const Text('Minha localização'),
                  style: ElevatedButton.styleFrom(
                    padding:
                    const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}