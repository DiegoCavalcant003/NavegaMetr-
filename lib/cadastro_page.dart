import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/services.dart'; // <- necessário para FilteringTextInputFormatter
import 'package:speech_to_text/speech_to_text.dart' as stt;

class CadastroPage extends StatefulWidget {
  const CadastroPage({super.key});

  @override
  State<CadastroPage> createState() => _CadastroPageState();
}

class _CadastroPageState extends State<CadastroPage> {
  final stt.SpeechToText speech = stt.SpeechToText();

  // Controllers
  final _nomeController = TextEditingController();
  final _cpfController = TextEditingController();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  final _confirmarSenhaController = TextEditingController();
  final _telefoneController = TextEditingController();
  final _contatoEmergenciaController = TextEditingController();

  // FocusNodes
  final _nomeFocus = FocusNode();
  final _cpfFocus = FocusNode();
  final _emailFocus = FocusNode();
  final _senhaFocus = FocusNode();
  final _confirmarSenhaFocus = FocusNode();
  final _telefoneFocus = FocusNode();
  final _contatoEmergenciaFocus = FocusNode();

  bool ouvindo = false;

  // Retorna o controller do campo que está com foco
  TextEditingController? get _controllerAtivo {
    if (_nomeFocus.hasFocus) return _nomeController;
    if (_cpfFocus.hasFocus) return _cpfController;
    if (_emailFocus.hasFocus) return _emailController;
    if (_senhaFocus.hasFocus) return _senhaController;
    if (_confirmarSenhaFocus.hasFocus) return _confirmarSenhaController;
    if (_telefoneFocus.hasFocus) return _telefoneController;
    if (_contatoEmergenciaFocus.hasFocus) return _contatoEmergenciaController;
    return null;
  }

  void _ouvir() async {
    final controller = _controllerAtivo;
    if (controller == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecione um campo para falar')),
      );
      return;
    }

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

  void _cadastrar() {
    if (_nomeController.text.isEmpty ||
        _cpfController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _senhaController.text.isEmpty ||
        _confirmarSenhaController.text.isEmpty ||
        _telefoneController.text.isEmpty ||
        _contatoEmergenciaController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha todos os campos')),
      );
      return;
    }

    if (_senhaController.text != _confirmarSenhaController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('As senhas não conferem')),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Cadastro realizado com sucesso!')),
    );
  }

  @override
  void dispose() {
    // Descartar focusNodes e controllers
    _nomeFocus.dispose();
    _cpfFocus.dispose();
    _emailFocus.dispose();
    _senhaFocus.dispose();
    _confirmarSenhaFocus.dispose();
    _telefoneFocus.dispose();
    _contatoEmergenciaFocus.dispose();

    _nomeController.dispose();
    _cpfController.dispose();
    _emailController.dispose();
    _senhaController.dispose();
    _confirmarSenhaController.dispose();
    _telefoneController.dispose();
    _contatoEmergenciaController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: true,
        title: const Text(
          'Cadastro',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: const BackButton(color: Colors.black),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  _campo(_nomeController, 'Nome completo', focusNode: _nomeFocus),
                  _campo(_cpfController, 'CPF', tipo: TextInputType.number, focusNode: _cpfFocus, somenteNumeros: true),
                  _campo(_emailController, 'Email', focusNode: _emailFocus),
                  _campo(_senhaController, 'Senha', senha: true, focusNode: _senhaFocus),
                  _campo(_confirmarSenhaController, 'Confirmar senha', senha: true, focusNode: _confirmarSenhaFocus),
                  _campo(_telefoneController, 'Telefone', tipo: TextInputType.number, focusNode: _telefoneFocus, somenteNumeros: true),
                  _campo(_contatoEmergenciaController, 'Contato de Emergência', tipo: TextInputType.number, focusNode: _contatoEmergenciaFocus, somenteNumeros: true),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),

          // Botão de áudio que preenche o campo selecionado
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 6),
            child: SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton.icon(
                onPressed: _ouvir,
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
                  'Usar Microfone',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ),
          ),

          // Botão Cadastrar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            color: Colors.white,
            child: SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: _cadastrar,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                  elevation: 4,
                ),
                child: const Text(
                  'Cadastrar',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _campo(
      TextEditingController controller,
      String label, {
        bool senha = false,
        TextInputType tipo = TextInputType.text,
        required FocusNode focusNode,
        bool somenteNumeros = false,
      }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        obscureText: senha,
        keyboardType: tipo,
        inputFormatters: somenteNumeros ? [FilteringTextInputFormatter.digitsOnly] : null,
        style: const TextStyle(color: Colors.black),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.black),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: const BorderSide(color: Colors.black),
          ),
        ),
      ),
    );
  }
}