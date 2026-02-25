import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'home_page.dart';

class PermissionPage extends StatefulWidget {
  const PermissionPage({Key? key}) : super(key: key);

  @override
  State<PermissionPage> createState() => _PermissionPageState();
}

class _PermissionPageState extends State<PermissionPage> {
  bool carregando = false;
  String mensagem = '';

  Future<void> solicitarLocalizacao() async {
    setState(() {
      carregando = true;
      mensagem = '';
    });

    // 1️⃣ Verifica se o GPS está ligado
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        carregando = false;
        mensagem = 'Ative o GPS do celular para continuar.';
      });
      return;
    }

    // 2️⃣ Verifica permissão
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied) {
      setState(() {
        carregando = false;
        mensagem = 'A permissão de localização é obrigatória.';
      });
      return;
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() {
        carregando = false;
        mensagem =
        'Permissão negada permanentemente. Ative nas configurações.';
      });
      return;
    }

    // 3️⃣ Pega localização (real)
    await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    // 4️⃣ Vai para Home
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomePage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.location_on, size: 80),
            const SizedBox(height: 20),
            const Text(
              'Permissão de Localização',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            const Text(
              'O NavegaMêtro precisa da sua localização para calcular rotas entre estações.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),

            if (mensagem.isNotEmpty)
              Text(
                mensagem,
                style: const TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              ),

            const SizedBox(height: 20),

            carregando
                ? const CircularProgressIndicator()
                : SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: solicitarLocalizacao,
                child: const Text('PERMITIR LOCALIZAÇÃO'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}