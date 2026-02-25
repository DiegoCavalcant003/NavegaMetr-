import 'package:flutter/material.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Histórico'),
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
      body: const Center(
        child: Text('Histórico de viagens ainda não implementado'),
      ),
    );
  }
}