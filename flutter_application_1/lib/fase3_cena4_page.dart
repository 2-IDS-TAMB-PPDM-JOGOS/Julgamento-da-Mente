import 'package:flutter/material.dart';
import 'tela_de_fases.dart';
import 'progress_manager.dart';

import 'final_page_1.dart';
import 'final_page_2.dart';
import 'final_page_3.dart';

enum Cena3State {
  becoChegada,
  dialogoMorador1,
  dialogoMorador2,
  dialogoMorador3,
  voltaCasaAdrian,
  escolhaFinal,
}

class Fase2Cena3Page extends StatefulWidget {
  final String playerName;

  const Fase2Cena3Page({super.key, required this.playerName});

  @override
  State<Fase2Cena3Page> createState() => _Fase2Cena3PageState();
}

class _Fase2Cena3PageState extends State<Fase2Cena3Page> {
  Map<Cena3State, List<String>> get _dialogues => {
    Cena3State.becoChegada: [
      'Você e Adrian encontram um beco sem saída, mas também um morador local, que pode ter visto algo.',
      'Adrian: “O senhor esteve aqui ontem à noite?”',
    ],
    Cena3State.dialogoMorador1: [
      'Morador: “Ontem… sim… estava aqui… houve uma barulheira enorme.”',
      'Você: “O que você viu ou ouviu?”',
    ],
    Cena3State.dialogoMorador2: [
      'Morador: “Tinha um homem de estatura média, rosto anguloso, olhos cinza, cabelo grisalho penteado para trás e postura rígida… ele estava esfaqueando alguém… não consegui ver mais do que isso.”',
    ],
    Cena3State.dialogoMorador3: [
      'Adrian: “Entendi… um suspeito surgiu na minha mente. Vamos voltar à minha casa e testar a digital que encontramos.”',
    ],
    Cena3State.voltaCasaAdrian: [
      'De volta à casa de Adrian, ele verifica a digital que vocês encontraram no local do crime.',
      'Adrian: “O resultado saiu. Quem você acha que é?”',
      'Opção:',
    ],
    Cena3State.escolhaFinal: [
      'Adrian: “O resultado saiu. Quem você acha que é?”',
      'Opção:',
    ],
  };

  final Map<Cena3State, String?> _backgrounds = {
    Cena3State.becoChegada: 'imagens/beco.jpg',
    Cena3State.dialogoMorador1: 'imagens/mendigo1.png',
    Cena3State.dialogoMorador2: 'imagens/mendigo2.png',
    Cena3State.dialogoMorador3: 'imagens/beco2.png',
    Cena3State.voltaCasaAdrian: 'imagens/casaAdrian.png',
    Cena3State.escolhaFinal: 'imagens/casaAdrian.png',
  };

  Cena3State _currentState = Cena3State.becoChegada;
  int _currentTextIndex = 0;

  // --- Funções de Controle de Estado ---

  void _advanceDialogue() {
    setState(() {
      final currentDialogue = _dialogues[_currentState]!;

      if (_currentTextIndex < currentDialogue.length - 1) {
        _currentTextIndex++;
      } else if (!_isChoiceState(_currentState)) {
        _goToNextState();
      }
    });
  }

  bool _isChoiceState(Cena3State state) {
    return state == Cena3State.escolhaFinal || state == Cena3State.voltaCasaAdrian;
  }

  bool _showChoices() {
    final currentDialogue = _dialogues[_currentState]!;
    return _isChoiceState(_currentState) &&
        _currentTextIndex == currentDialogue.length - 1;
  }

  void _goToNextState() {
    setState(() {
      switch (_currentState) {
        case Cena3State.becoChegada:
          _currentState = Cena3State.dialogoMorador1;
          _currentTextIndex = 0;
          break;

        case Cena3State.dialogoMorador1:
          _currentState = Cena3State.dialogoMorador2;
          _currentTextIndex = 0;
          break;

        case Cena3State.dialogoMorador2:
          _currentState = Cena3State.dialogoMorador3;
          _currentTextIndex = 0;
          break;

        case Cena3State.dialogoMorador3:
          _currentState = Cena3State.voltaCasaAdrian;
          _currentTextIndex = 0;
          break;

        case Cena3State.voltaCasaAdrian:
          // Transiciona para o estado que efetivamente mostra as escolhas
          _currentState = Cena3State.escolhaFinal;
          _currentTextIndex = 0;
          break;

        case Cena3State.escolhaFinal:
          // Espera pelo input do jogador (_handleChoice)
          break;
      }
    });
  }

  void _handleChoice(String choice) {
    // Desbloqueia a Fase 3 (apenas como precaução, mas a escolha leva ao final)
    // Supondo que ProgressManager esteja implementado
    // ProgressManager().unlockPhase('fase3');

    // Navega para o final correspondente
    if (choice == 'Juiz') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => FinalPage1(playerName: widget.playerName),
        ),
      );
    } else if (choice == 'Morador de rua') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => FinalPage2(playerName: widget.playerName),
        ),
      );
    } else if (choice == 'Você mesmo') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => FinalPage3(playerName: widget.playerName),
        ),
      );
    }
  }

  String? _getCurrentBackgroundAsset() {
    return _backgrounds[_currentState];
  }

  Color _getCurrentBackgroundColor() {
    return _getCurrentBackgroundAsset() == null
        ? Colors.black
        : Colors.transparent;
  }

  Widget _buildDialogueBox(List<String> currentDialogue) {
    String dialogueText = currentDialogue[_currentTextIndex]
        .replaceAll('Você', widget.playerName)
        .replaceAll('Personagem', widget.playerName);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.8),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        dialogueText,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          height: 1.5,
        ),
      ),
    );
  }

  Widget _buildChoices() {
    List<Widget> choices = [];

    if (_currentState == Cena3State.escolhaFinal || _currentState == Cena3State.voltaCasaAdrian) {
      choices.add(_buildChoiceButton(
        text: 'Juiz (Final 1)',
        onPressed: () => _handleChoice('Juiz'),
        // Usando cores mais vivas para o texto, que é a parte que muda
        buttonTextColor: Colors.lightGreenAccent,
      ));
      choices.add(const SizedBox(height: 10));
      choices.add(_buildChoiceButton(
        text: 'Morador de rua (Final 2)',
        onPressed: () => _handleChoice('Morador de rua'),
        buttonTextColor: Colors.blueAccent,
      ));
      choices.add(const SizedBox(height: 10));
      choices.add(_buildChoiceButton(
        text: 'Você mesmo (Final 3)',
        onPressed: () => _handleChoice('Você mesmo'),
        buttonTextColor: Colors.redAccent,
      ));
    }

    return Column(children: choices);
  }

  // NOVO WIDGET DE BOTÃO COM ESTILO OUTLINED (TRANSPARENTE COM BORDA BRANCA)
  Widget _buildChoiceButton({
    required String text,
    required VoidCallback onPressed,
    Color buttonTextColor = Colors.white,
  }) {
    // Estilo comum para os botões de escolha: transparente, borda branca, fundo escuro
    final ButtonStyle choiceButtonStyle = OutlinedButton.styleFrom(
      foregroundColor: buttonTextColor, // Define a cor do texto e do splash
      side: const BorderSide(color: Colors.white, width: 2), // Borda branca
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      backgroundColor: Colors.black.withOpacity(0.4), // Fundo semi-transparente
    );

    return SizedBox(
      width: double.infinity,
      child: OutlinedButton( // Usando OutlinedButton para o estilo desejado
        onPressed: onPressed,
        style: choiceButtonStyle,
        child: Text(
          text,
          style: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }
  // FIM DO NOVO WIDGET DE BOTÃO

  @override
  Widget build(BuildContext context) {
    final currentDialogue = _dialogues[_currentState]!;
    final backgroundAsset = _getCurrentBackgroundAsset();
    final showChoices = _showChoices();

    return Scaffold(
      body: GestureDetector(
        // Desativa o onTap se as opções de escolha estiverem visíveis
        onTap: showChoices ? null : _advanceDialogue,
        child: Container(
          decoration: backgroundAsset != null
              ? BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(backgroundAsset),
                    fit: BoxFit.cover,
                  ),
                )
              : BoxDecoration(
                  color: _getCurrentBackgroundColor(),
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
                      _buildDialogueBox(currentDialogue),
                      const SizedBox(height: 10),

                      // Indicador de toque ou Escolhas
                      if (!showChoices)
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
}