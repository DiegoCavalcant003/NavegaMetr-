import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_page.dart';

class PermissionPage extends StatefulWidget {
  const PermissionPage({Key? key}) : super(key: key);

  @override
  State<PermissionPage> createState() => _PermissionPageState();
}

class _PermissionPageState extends State<PermissionPage> {
  bool carregando = false;
  String mensagem = '';
  String statusConexao = '';

  @override
  void initState() {
    super.initState();
    verificarPrimeiroAcesso();
  }

  Future<void> verificarPrimeiroAcesso() async {
    final prefs = await SharedPreferences.getInstance();
    bool? jaViu = prefs.getBool("jaPassouPermissao");

    if (jaViu == true) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomePage()),
      );
    }
  }

  Future<void> solicitarLocalizacao() async {
    setState(() {
      carregando = true;
      mensagem = '';
      statusConexao = "Conectando à sua localização...";
    });

    await Future.delayed(const Duration(seconds: 1));

    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        carregando = false;
        statusConexao = '';
        mensagem = 'Ative o GPS do celular para continuar.';
      });
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied) {
      setState(() {
        carregando = false;
        statusConexao = '';
        mensagem = 'A permissão de localização é obrigatória.';
      });
      return;
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() {
        carregando = false;
        statusConexao = '';
        mensagem =
        'Permissão negada permanentemente. Ative nas configurações.';
      });
      return;
    }

    await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("jaPassouPermissao", true);

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

            Image.network(
              'https://img.icons8.com/?size=100&id=37292&format=png&color=000000',
              width: 100,
              height: 100,
            ),

            const SizedBox(height: 30),

            const Text(
              'Permissão de Localização',
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 15),

            const Text(
              'O NavegaMêtro utiliza sua localização atual para identificar a estação mais próxima de você e sugerir rotas mais rápidas e eficientes.',
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 10),

            const Text(
              'Sua localização é usada apenas para melhorar sua experiência dentro do aplicativo.',
              style: TextStyle(fontSize: 13, color: Colors.grey),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 30),

            if (statusConexao.isNotEmpty)
              Column(
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 12),
                  Text(statusConexao),
                ],
              ),

            if (mensagem.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 15),
                child: Text(
                  mensagem,
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              ),

            const SizedBox(height: 30),

            if (!carregando)
              SizedBox(
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