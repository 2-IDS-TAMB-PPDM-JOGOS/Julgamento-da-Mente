import 'package:flutter/material.dart';
import 'tela_de_fases.dart';
import 'progress_manager.dart'; // Adicione esta importação

enum CenaState {
  celaInicio,
  cartaLida,
  caminhoAdrian,
  encontroAdrian,
  entregaCarta,
  naoEntregaCarta,
  pistaFinal,
}

class CenaPrisaoAdrianPage extends StatefulWidget {
  final String playerName;

  const CenaPrisaoAdrianPage({super.key, required this.playerName});

  @override
  State<CenaPrisaoAdrianPage> createState() => _CenaPrisaoAdrianPageState();
}

class _CenaPrisaoAdrianPageState extends State<CenaPrisaoAdrianPage> {

  final Map<CenaState, List<String>> _dialogues = {
    CenaState.celaInicio: [
      'De volta à cela, você fala consigo mesmo, tentando organizar seus pensamentos.',
      'Ao explorar o local, você encontra dois itens: uma chave e uma carta lacrada.',
      'Opção:',
    ],
    CenaState.cartaLida: [
      'Você pode não se lembrar, mas não se preocupe, você é inocente.',
      'Para se salvar, encontre Adrian Crowhurst, entregue a ele esta carta e ele o ajudará.',
      'A primeira pista do que realmente aconteceu eu já deixei com ele.',
      'Assinado, K',
    ],
    CenaState.caminhoAdrian: [
      'Você vai até a casa do detetive Adrian Crowhurst.',
    ],
    CenaState.encontroAdrian: [
      'Ele olha atentamente para você antes de falar:',
      'Adrian: "Então… esta é a carta. O que você vai fazer agora?"',
    ],
    CenaState.entregaCarta: [
      'Adrian sorri com gratidão.',
      'Adrian: "Obrigado por confiar em mim. Vou analisar isso imediatamente."',
    ],
    CenaState.naoEntregaCarta: [
      'Adrian cruza os braços, claramente irritado, mas permanece em silêncio.',
      'Adrian: "Então me explique… o que dizia a carta?"',
    ],
    CenaState.pistaFinal: [
      'Adrian: "Sim, recebi a primeira dica. Fica perto deste local…"',
    ],
  };


  final Map<CenaState, String?> _backgrounds = {
    CenaState.celaInicio: 'imagens/cadeia.png',
    CenaState.cartaLida: 'imagens/cadeia.png',
    CenaState.caminhoAdrian: 'imagens/casaAdrian.png',
    CenaState.encontroAdrian: 'imagens/adrian2.jpeg',
    CenaState.entregaCarta: 'imagens/adrian3.jpeg',
    CenaState.naoEntregaCarta: 'imagens/adrian4.jpeg',
    CenaState.pistaFinal: 'imagens/adrian5.png'
  };

  CenaState _currentState = CenaState.celaInicio;
  int _currentTextIndex = 0;

  void _advanceDialogue() {
    setState(() {
      final currentDialogue = _dialogues[_currentState]!;

      if (_currentTextIndex < currentDialogue.length - 1) {
        _currentTextIndex++;
      }

      else if (!_isChoiceState(_currentState)) {
        _goToNextState();
      }
    });
  }

  bool _isChoiceState(CenaState state) {
    return state == CenaState.celaInicio || state == CenaState.encontroAdrian;
  }

  bool _showChoices() {
    final currentDialogue = _dialogues[_currentState]!;
    return _isChoiceState(_currentState) && _currentTextIndex == currentDialogue.length - 1;
  }

  // MÉTODO _goToNextState CORRIGIDO E COMPLETO
  void _goToNextState() {
    setState(() {
      switch (_currentState) {
        case CenaState.celaInicio:
          // A transição para cartaLida é feita pelo botão de escolha
          break;

        case CenaState.cartaLida:
          _currentState = CenaState.caminhoAdrian;
          _currentTextIndex = 0;
          break;

        case CenaState.caminhoAdrian:
          _currentState = CenaState.encontroAdrian;
          _currentTextIndex = 0;
          break;

        case CenaState.entregaCarta:
        case CenaState.naoEntregaCarta:
          _currentState = CenaState.pistaFinal;
          _currentTextIndex = 0;
          break;

        case CenaState.encontroAdrian:
          break;

        case CenaState.pistaFinal:
          _goToNextPhase();
          break;
      }
    });
  }

  void _handleChoice(String choice) {
    setState(() {
      if (_currentState == CenaState.celaInicio) {
        if (choice == 'Ler a carta lacrada') {
          _currentState = CenaState.cartaLida;
          _currentTextIndex = 0;
        }
      } else if (_currentState == CenaState.encontroAdrian) {
        if (choice == 'Entregar a carta') {
          _currentState = CenaState.entregaCarta;
          _currentTextIndex = 0;
        } else if (choice == 'Não entregar a carta') {
          _currentState = CenaState.naoEntregaCarta;
          _currentTextIndex = 0;
        }
      }
    });
  }

  void _goToNextPhase() {
    // DESCOMENTADA: Garante que a Fase 2 será desbloqueada antes de ir para a tela de fases
    ProgressManager().unlockPhase('fase2');

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => TelaDeFases(playerName: widget.playerName),
      ),
    );
  }

  String? _getCurrentBackgroundAsset() {
    return _backgrounds[_currentState];
  }

  Color _getCurrentBackgroundColor() {
    return _getCurrentBackgroundAsset() == null ? Colors.black : Colors.transparent;
  }

  Widget _buildDialogueBox(List<String> currentDialogue) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.8),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        currentDialogue[_currentTextIndex].replaceAll('Você', widget.playerName),
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

    if (_currentState == CenaState.celaInicio) {
      choices.add(_buildChoiceButton(
        text: 'Ler a carta lacrada',
        onPressed: () => _handleChoice('Ler a carta lacrada'),
      ));
    } else if (_currentState == CenaState.encontroAdrian) {
      choices.add(_buildChoiceButton(
        text: 'Entregar a carta',
        onPressed: () => _handleChoice('Entregar a carta'),
      ));
      choices.add(const SizedBox(height: 10));
      choices.add(_buildChoiceButton(
        text: 'Não entregar a carta',
        onPressed: () => _handleChoice('Não entregar a carta'),
        // Cor vermelha sutil para a opção de risco
        buttonTextColor: Colors.redAccent,
      ));
    }

    return Column(children: choices);
  }

  // MÉTODO _buildChoiceButton ESTILIZADO PARA TRANSPARENTE COM BORDA BRANCA
  Widget _buildChoiceButton({
    required String text,
    required VoidCallback onPressed,
    // Cor do texto/splash que pode ser personalizada (padrão branco)
    Color buttonTextColor = Colors.white,
  }) {
    // Estilo que garante transparência no fundo e borda branca
    final ButtonStyle choiceButtonStyle = OutlinedButton.styleFrom(
      foregroundColor: buttonTextColor, // Define a cor do texto e do splash (cores vivas)
      side: const BorderSide(color: Colors.white, width: 2), // Borda branca
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      // Fundo semi-transparente para melhor contraste, mas transparente o suficiente
      backgroundColor: Colors.black.withOpacity(0.4),
    );

    return SizedBox(
      width: double.infinity,
      child: OutlinedButton( // Usando OutlinedButton para o estilo de borda
        onPressed: onPressed,
        style: choiceButtonStyle,
        child: Text(
          text,
          style: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentDialogue = _dialogues[_currentState]!;
    final backgroundAsset = _getCurrentBackgroundAsset();
    final showChoices = _showChoices();

    return Scaffold(
      body: GestureDetector(
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