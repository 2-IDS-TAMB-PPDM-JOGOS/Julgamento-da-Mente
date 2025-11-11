import 'package:flutter/material.dart';

import 'tela_de_fases.dart';

class EndGameGuiltyScreen extends StatelessWidget {
  const EndGameGuiltyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('imagens/prisao.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: const Center(
          child: Padding(
            padding: EdgeInsets.all(32.0),
            child: Text(
              'Fim do jogo. Você foi condenado e preso.',
              style: TextStyle(fontSize: 24, color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}

const String _imagePath = 'imagens/tribunal.png';

class Fase0Cena1Page extends StatefulWidget {
  final String playerName;

  const Fase0Cena1Page({super.key, required this.playerName});

  @override
  State<Fase0Cena1Page> createState() => _Fase0Cena1PageState();
}

class _Fase0Cena1PageState extends State<Fase0Cena1Page> {

  final List<String> _dialogue = [
    'Você desperta no tribunal sem memória alguma. O juiz, sério e imponente, o acusa de um crime que você não se lembra de ter cometido.',
    'Quando você questiona qual crime cometeu, ninguém revela, apenas o juiz responde:',
    'Juiz: “Não cabe a mim dizer. Cabe a você descobrir.”',
  ];

  int _currentTextIndex = 0;
  bool _showChoices = false;

  void _advanceDialogue() {
    setState(() {
      if (_currentTextIndex < _dialogue.length - 1) {
        _currentTextIndex++;
      } else {
        _showChoices = true;
      }
    });
  }

  void _endGameGuilty() {
    // Navega para a tela de fim de jogo por culpa
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const EndGameGuiltyScreen()),
    );
  }

  void _continueGame() {
    // Navega para a próxima fase
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => TelaDeFases(playerName: widget.playerName)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: _showChoices ? null : _advanceDialogue,
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(_imagePath),
              fit: BoxFit.cover,
            ),
          ),
          child: Stack(
            children: [

              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [

                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          _dialogue[_currentTextIndex].replaceAll('Você', widget.playerName),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            height: 1.5,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Seta ou Opções de Escolha
                      if (!_showChoices)

                        const Icon(
                          Icons.arrow_drop_down,
                          color: Colors.white70,
                          size: 40,
                        )
                      else

                        _buildChoices(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChoices() {
    final ButtonStyle choiceButtonStyle = OutlinedButton.styleFrom(
      foregroundColor: Colors.white, 
      side: const BorderSide(color: Colors.white, width: 2), 
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      backgroundColor: Colors.black.withOpacity(0.4), 
    );

    return Column(
      children: [

        SizedBox(
          width: double.infinity,
          child: OutlinedButton( 
            onPressed: _continueGame,
            style: choiceButtonStyle,
            child: const Text(
              'Procurar pistas do seu crime',
              style: TextStyle(fontSize: 16),
            ),
          ),
        ),
        const SizedBox(height: 10),

        SizedBox(
          width: double.infinity,
          child: OutlinedButton( // Usando OutlinedButton para o estilo de borda
            onPressed: _endGameGuilty,
            style: choiceButtonStyle.copyWith(
              // Cor do texto de "Culpado" em vermelho,
              // mas a borda e o fundo continuam brancos/transparentes
              foregroundColor: MaterialStateProperty.all<Color>(Colors.redAccent),
            ),
            child: const Text(
              'Se considerar culpado',
              style: TextStyle(fontSize: 16),
            ),
          ),
        ),
      ],
    );
  }
}