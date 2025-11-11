import 'package:flutter/material.dart';
import 'tela_de_fases.dart';
import 'progress_manager.dart'; // Adicione esta importação

enum CenaState {
  chegadaLocal,
  encontraArma,
  escolhaInvestigar,
  encontraPista,
  voltaCasaAdrian,
  pistaFinal,
}

class CenaLocalCrimePage extends StatefulWidget {
  final String playerName;

  const CenaLocalCrimePage({super.key, required this.playerName});

  @override
  State<CenaLocalCrimePage> createState() => _CenaLocalCrimePageState();
}

class _CenaLocalCrimePageState extends State<CenaLocalCrimePage> {

  Map<CenaState, List<String>> get _dialogues => {
    CenaState.chegadaLocal: [
      'Você e Adrian chegam ao local do crime. A cena é sombria e repleta de lembranças confusas.',
      'Adrian: “Precisamos encontrar algo que a polícia possa ter deixado passar.”',
    ],
    CenaState.encontraArma: [
      'Vocês reviram o local por um tempo. Eventualmente, Adrian encontra algo escondido.',
      'Adrian: “Encontrei isto. Parece ser a arma do crime, mas não foi registrada.”',
    ],
    CenaState.escolhaInvestigar: [
      'Adrian: “Quer investigar mais a fundo, ou isso é o suficiente por enquanto?”',
      'Opção:',
    ],
    CenaState.encontraPista: [
      'Você concorda em continuar a busca. Adrian foca no chão e encontra um pequeno objeto.',
      'Adrian: “Parece que temos uma digital parcial. Isso pode ser crucial.”',
      'Adrian: “Encontramos o que precisávamos. Agora vamos analisar isso em casa.”',
    ],
    CenaState.voltaCasaAdrian: [
      'Você decide que é o suficiente. O caminho de volta para a casa de Adrian é silencioso.',
      'Adrian: “Sinto que perdemos algo importante ali, mas entendo. Vamos para casa.”',
      'Você precisa voltar para o local do crime e investigar mais para avançar.',
    ],
    CenaState.pistaFinal: [
      'Adrian: “Esta digital é nossa melhor chance de provar sua inocência, ' + widget.playerName + '. Vamos para a próxima fase da investigação.”',
    ],
  };

  // Imagens de fundo para cada estado
  final Map<CenaState, String?> _backgrounds = {
    CenaState.chegadaLocal: 'imagens/cena_crime.png',
    CenaState.encontraArma: 'imagens/faca_escondida.png',
    CenaState.escolhaInvestigar: 'imagens/adrian_faca.png',
    CenaState.encontraPista: 'imagens/digital.png',
    CenaState.voltaCasaAdrian: 'imagens/casaAdrian.png',
    CenaState.pistaFinal: 'imagens/casaAdrian.png',
  };

  CenaState _currentState = CenaState.chegadaLocal;
  int _currentTextIndex = 0;

  // --- Funções de Controle de Estado ---

  void _advanceDialogue() {
    setState(() {
      final currentDialogue = _dialogues[_currentState]!;

      if (_currentTextIndex < currentDialogue.length - 1) {
        _currentTextIndex++;
      } else if (!_isChoiceState(_currentState)) {
        // Só avança para o próximo estado se não for um estado de escolha
        _goToNextState();
      }
      // Se for um estado de escolha e estiver no último diálogo, espera o input do jogador
    });
  }

  // Define quais estados são pontos de escolha
  bool _isChoiceState(CenaState state) {
    return state == CenaState.escolhaInvestigar;
  }

  // Verifica se as opções de escolha devem ser exibidas
  bool _showChoices() {
    final currentDialogue = _dialogues[_currentState]!;
    return _isChoiceState(_currentState) &&
        _currentTextIndex == currentDialogue.length - 1;
  }

  void _goToNextState() {
    switch (_currentState) {
      case CenaState.chegadaLocal:
        _currentState = CenaState.encontraArma;
        _currentTextIndex = 0;
        break;

      case CenaState.encontraArma:
        _currentState = CenaState.escolhaInvestigar;
        _currentTextIndex = 0;
        break;

      case CenaState.encontraPista:
        _currentState = CenaState.pistaFinal;
        _currentTextIndex = 0;
        break;

      case CenaState.pistaFinal:
        _goToNextPhase(); // Vai para a Fase 3
        break;

      case CenaState.voltaCasaAdrian:
        // **Regra de Bloqueio**: Volta para o ponto de escolha forçando o jogador a encontrar a pista.
        _currentState = CenaState.escolhaInvestigar;
        _currentTextIndex = _dialogues[CenaState.escolhaInvestigar]!.length - 1;
        break;

      case CenaState.escolhaInvestigar:
        // Espera pelo input do jogador (handleChoice)
        break;
    }
  }

  void _handleChoice(String choice) {
    setState(() {
      if (_currentState == CenaState.escolhaInvestigar) {
        if (choice == 'Sim: Investigar mais') {
          _currentState = CenaState.encontraPista; // Segue o caminho correto
          _currentTextIndex = 0;
        } else if (choice == 'Não: Voltar para casa') {
          _currentState = CenaState.voltaCasaAdrian; // Segue o caminho de bloqueio
          _currentTextIndex = 0;
        }
      }
    });
  }

  void _goToNextPhase() {
    final progressManager = ProgressManager();

    progressManager.unlockPhase('fase3');

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
    return _getCurrentBackgroundAsset() == null
        ? Colors.black
        : Colors.transparent;
  }

  Widget _buildDialogueBox(List<String> currentDialogue) {
    // Substitui 'Você' pelo nome do jogador, como no modelo
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

  // Retorna o Widget com as opções de escolha.
  Widget _buildChoices() {
    List<Widget> choices = [];

    if (_currentState == CenaState.escolhaInvestigar) {
      choices.add(_buildChoiceButton(
        text: 'Sim: Investigar mais',
        onPressed: () => _handleChoice('Sim: Investigar mais'),
        // Cor padrão branca/azul (como você usou antes, mas agora para o texto)
        buttonTextColor: Colors.lightBlueAccent,
      ));
      choices.add(const SizedBox(height: 10));
      choices.add(_buildChoiceButton(
        text: 'Não: Voltar para casa',
        onPressed: () => _handleChoice('Não: Voltar para casa'),
        // Usando o tom de vermelho para o texto/splash, como você usou para o background antes
        buttonTextColor: Colors.redAccent,
      ));
    }

    return Column(children: choices);
  }

  // MÉTODO _buildChoiceButton REVISADO PARA OUTLINEDBUTTON (Borda Branca/Transparente)
  Widget _buildChoiceButton(
      {required String text,
      required VoidCallback onPressed,
      // O argumento 'color' agora é 'buttonTextColor' e define a cor do texto e do splash
      Color buttonTextColor = Colors.white}) {
    
    final ButtonStyle choiceButtonStyle = OutlinedButton.styleFrom(
      foregroundColor: buttonTextColor, // Cor do texto e do splash
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