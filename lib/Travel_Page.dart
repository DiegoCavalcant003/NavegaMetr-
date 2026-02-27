import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'Finished_Page.dart';

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
  bool mostrarBotaoLocalizacao = false;

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

  @override
  void initState() {
    super.initState();
    obterLocalizacao();
  }

  Future<void> obterLocalizacao({bool moverMapa = false}) async {
    Position posicao = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    final novaPosicao =
    LatLng(posicao.latitude, posicao.longitude);

    setState(() {
      minhaLocalizacao = novaPosicao;
      carregando = false;
      mostrarBotaoLocalizacao = false;
    });

    if (moverMapa) {
      _mapController.move(novaPosicao, 16);
    }
  }

  void verificarSeSaiuDaTela() {
    if (minhaLocalizacao == null) return;

    final bounds = _mapController.camera.visibleBounds;

    final dentro =
    bounds.contains(minhaLocalizacao!);

    setState(() {
      mostrarBotaoLocalizacao = !dentro;
    });
  }

  @override
  Widget build(BuildContext context) {
    final centroMapa =
        minhaLocalizacao ?? estacoesMapa[widget.origem];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sua Viagem'),
        centerTitle: true,
      ),
      body: carregando || centroMapa == null
          ? const Center(child: CircularProgressIndicator())
          : Stack(
        children: [

          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: centroMapa,
              initialZoom: 14,
              onPositionChanged: (pos, _) {
                verificarSeSaiuDaTela();
              },
            ),
            children: [
              TileLayer(
                urlTemplate:
                'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName:
                'com.example.meu_primeiro_app',
              ),

              MarkerLayer(
                markers: [
                  if (minhaLocalizacao != null)
                    Marker(
                      point: minhaLocalizacao!,
                      width: 45,
                      height: 45,
                      child: const Icon(
                        FontAwesomeIcons.locationDot,
                        color: Colors.red,
                        size: 40,
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
                borderRadius:
                BorderRadius.circular(12),
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

          if (mostrarBotaoLocalizacao)
            Positioned(
              bottom: 100,
              right: 20,
              child: FloatingActionButton(
                onPressed: () async {
                  await obterLocalizacao(
                      moverMapa: true);
                },
                child: const Icon(
                  FontAwesomeIcons.crosshairs,
                ),
              ),
            ),

          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: ElevatedButton.icon(
              icon: const Icon(
                  FontAwesomeIcons.flagCheckered),
              label:
              const Text("Finalizar Rota"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding:
                const EdgeInsets.symmetric(
                    vertical: 16),
              ),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        FinishedPage(
                          origem: widget.origem,
                          destino: widget.destino,
                        ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}