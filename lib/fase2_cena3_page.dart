import 'package:flutter/material.dart';
import 'tela_de_fases.dart';
import 'progress_manager.dart'; 

enum CenaState {
  chegadaLocal,
  encontraArma,
  escolhaInvestigar,
  encontraPista,
  voltaCasaAdrian,
  pistaFinal,
  jogoEncontrarObjetos, // Novo estado para o jogo
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
      'Adrian: "Precisamos encontrar algo que a polícia possa ter deixado passar."',
    ],
    CenaState.encontraArma: [
      'Vocês reviram o local por um tempo. Eventualmente, Adrian encontra algo escondido.',
      'Adrian: "Encontrei isto. Parece ser a arma do crime, mas não foi registrada."',
    ],
    CenaState.escolhaInvestigar: [
      'Adrian: "Quer investigar mais a fundo, ou isso é o suficiente por enquanto?"',
      'Opção:',
    ],
    CenaState.encontraPista: [
      'Você concorda em continuar a busca. Adrian foca na parede e encontra um pequeno objeto.',
      'Adrian: "Parece que temos uma digital parcial. Isso pode ser crucial."',
      'Adrian: "Encontramos o que precisávamos. Agora vamos analisar isso em casa."',
    ],
    CenaState.voltaCasaAdrian: [
      'Você decide que é o suficiente. O caminho de volta para a casa de Adrian é silencioso.',
      'Adrian: "Sinto que perdemos algo importante ali, mas entendo. Vamos para casa."',
      'Você precisa voltar para o local do crime e investigar mais para avançar.',
    ],
    CenaState.pistaFinal: [
      'Adrian: "Esta digital é nossa melhor chance de provar sua inocência, ' + widget.playerName + '. Vamos para a próxima fase da investigação."',
    ],
    CenaState.jogoEncontrarObjetos: [
      'Procure cuidadosamente por pistas escondidas no local do crime...',
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
    CenaState.jogoEncontrarObjetos: 'imagens/cena_crime.png',
  };

  CenaState _currentState = CenaState.chegadaLocal;
  int _currentTextIndex = 0;
  
  bool _pistasDesbloqueadas = false;
  List<bool> _objetosEncontrados = [false, false, false];
  List<Offset> _objetosPosicoes = [
    Offset(0.2, 0.3), 
    Offset(0.7, 0.6),  
    Offset(0.85, 0.2),  
  ];
  List<String> _objetosNomes = [
    'Pedaço de tecido',
    'Cartão suspeito',
    'Chave misteriosa'
  ];

  void _showInvestigationRequiredDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Investigação Necessária'),
          content: Text('Antes de investigar mais a fundo, você precisa examinar cuidadosamente o local do crime para encontrar pistas escondidas.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Vai para o jogo de encontrar objetos
                setState(() {
                  _currentState = CenaState.jogoEncontrarObjetos;
                  _currentTextIndex = 0;
                });
              },
              child: Text('Examinar Local'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancelar'),
            ),
          ],
        );
      },
    );
  }

  void _onObjectFound(int index) {
    setState(() {
      _objetosEncontrados[index] = true;
    });
    
    // Verifica se todos os objetos foram encontrados
    if (_objetosEncontrados.every((encontrado) => encontrado)) {
      _completeInvestigationGame();
    }
  }

  void _completeInvestigationGame() {
    setState(() {
      _pistasDesbloqueadas = true;
      // Volta para o estado de escolha após completar o jogo
      _currentState = CenaState.escolhaInvestigar;
      _currentTextIndex = _dialogues[CenaState.escolhaInvestigar]!.length - 1;
    });
    
    // Mostra mensagem de sucesso
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Excelente! Você encontrou todas as pistas. Agora pode investigar mais a fundo.'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 3),
      ),
    );
  }

  Widget _buildInvestigationGame() {
    final screenSize = MediaQuery.of(context).size;
    
    return Stack(
      children: [
        // Fundo do local do crime
        Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('imagens/cena_crime.png'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        
        // Instruções
        Positioned(
          top: 50,
          left: 0,
          right: 0,
          child: Container(
            padding: EdgeInsets.all(16),
            margin: EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.8),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                Text(
                  'Encontre 3 pistas escondidas',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Toque nos objetos suspeitos para coletar as pistas',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
        
        // Contador de progresso
        Positioned(
          top: 150,
          left: 0,
          right: 0,
          child: Container(
            padding: EdgeInsets.all(12),
            margin: EdgeInsets.symmetric(horizontal: 50),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.7),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.search,
                  color: Colors.white,
                ),
                SizedBox(width: 10),
                Text(
                  'Pistas encontradas: ${_objetosEncontrados.where((e) => e).length}/3',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
        
        // Objetos interativos
        for (int i = 0; i < _objetosPosicoes.length; i++)
          if (!_objetosEncontrados[i])
            Positioned(
              left: _objetosPosicoes[i].dx * screenSize.width - 30,
              top: _objetosPosicoes[i].dy * screenSize.height - 30,
              child: GestureDetector(
                onTap: () => _onObjectFound(i),
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.yellow.withOpacity(0.8),
                      width: 3,
                    ),
                  ),
                  child: Icon(
                    Icons.question_mark,
                    color: Colors.yellow,
                    size: 30,
                  ),
                ),
              ),
            ),
        
        // Lista de objetos encontrados
        Positioned(
          bottom: 100,
          left: 0,
          right: 0,
          child: Container(
            padding: EdgeInsets.all(16),
            margin: EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.8),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Pistas Coletadas:',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                for (int i = 0; i < _objetosEncontrados.length; i++)
                  Row(
                    children: [
                      Icon(
                        _objetosEncontrados[i] ? Icons.check_circle : Icons.radio_button_unchecked,
                        color: _objetosEncontrados[i] ? Colors.green : Colors.grey,
                      ),
                      SizedBox(width: 8),
                      Text(
                        _objetosNomes[i],
                        style: TextStyle(
                          color: _objetosEncontrados[i] ? Colors.white : Colors.grey,
                          fontSize: 16,
                          decoration: _objetosEncontrados[i] ? TextDecoration.lineThrough : null,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
        
        // Botão de ajuda
        Positioned(
          bottom: 30,
          right: 20,
          child: FloatingActionButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Dica'),
                  content: Text('Procure por áreas que pareçam fora do comum. As pistas estão marcadas com "?" amarelos. Toque neles para coletar!'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text('Entendi'),
                    ),
                  ],
                ),
              );
            },
            child: Icon(Icons.help),
            backgroundColor: Colors.blue,
          ),
        ),
      ],
    );
  }

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

  bool _isChoiceState(CenaState state) {
    return state == CenaState.escolhaInvestigar;
  }

  bool _showChoices() {
    final currentDialogue = _dialogues[_currentState]!;
    return _isChoiceState(_currentState) &&
        _currentTextIndex == currentDialogue.length - 1;
  }

  void _goToNextState() {
    setState(() {
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
          _goToNextPhase();
          break;

        case CenaState.voltaCasaAdrian:
          _currentState = CenaState.escolhaInvestigar;
          _currentTextIndex = _dialogues[CenaState.escolhaInvestigar]!.length - 1;
          break;

        case CenaState.escolhaInvestigar:
          break;
          
        case CenaState.jogoEncontrarObjetos:
          break;
      }
    });
  }

  void _handleChoice(String choice) {
    setState(() {
      if (_currentState == CenaState.escolhaInvestigar) {
        if (choice == 'Sim: Investigar mais') {
          if (_pistasDesbloqueadas) {
            _currentState = CenaState.encontraPista;
            _currentTextIndex = 0;
          } else {
            _showInvestigationRequiredDialog();
          }
        } else if (choice == 'Não: Voltar para casa') {
          _currentState = CenaState.voltaCasaAdrian;
          _currentTextIndex = 0;
        } else if (choice == 'Procurar pistas') {
          _currentState = CenaState.jogoEncontrarObjetos;
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

    if (_currentState == CenaState.escolhaInvestigar) {
      // Opção principal - Investigar mais (bloqueada até completar o jogo)
      choices.add(_buildChoiceButton(
        text: 'Sim: Investigar mais',
        onPressed: () => _handleChoice('Sim: Investigar mais'),
        buttonTextColor: _pistasDesbloqueadas ? Colors.lightBlueAccent : Colors.grey,
      ));
      
      // Opção para procurar pistas (sempre disponível)
      /*if (!_pistasDesbloqueadas) {
        choices.add(const SizedBox(height: 10));
        choices.add(_buildChoiceButton(
          text: 'Procurar pistas',
          onPressed: () => _handleChoice('Procurar pistas'),
          buttonTextColor: Colors.amber,
        ));
      }*/
      
      choices.add(const SizedBox(height: 10));
      choices.add(_buildChoiceButton(
        text: 'Não: Voltar para casa',
        onPressed: () => _handleChoice('Não: Voltar para casa'),
        buttonTextColor: Colors.redAccent,
      ));
    }

    return Column(children: choices);
  }

  Widget _buildChoiceButton({
    required String text,
    required VoidCallback onPressed,
    Color buttonTextColor = Colors.white,
  }) {
    final ButtonStyle choiceButtonStyle = OutlinedButton.styleFrom(
      foregroundColor: buttonTextColor,
      side: BorderSide(
        color: buttonTextColor == Colors.grey ? Colors.grey : Colors.white, 
        width: 2
      ),
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      backgroundColor: Colors.black.withOpacity(0.4),
    );

    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
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

    // Se estiver no jogo, mostra a interface do jogo
    if (_currentState == CenaState.jogoEncontrarObjetos) {
      return Scaffold(
        body: _buildInvestigationGame(),
      );
    }

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