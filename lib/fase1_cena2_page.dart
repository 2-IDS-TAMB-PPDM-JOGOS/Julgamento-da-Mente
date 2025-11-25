import 'package:flutter/material.dart';
import 'tela_de_fases.dart';
import 'progress_manager.dart'; 

enum CenaState {
  celaInicio,
  cartaLida,
  caminhoAdrian,
  encontroAdrian,
  entregaCarta,
  naoEntregaCarta,
  pistaFinal,
  jogoMemoria, // Novo estado para o jogo de memória
}

class CenaPrisaoAdrianPage extends StatefulWidget {
  final String playerName;

  const CenaPrisaoAdrianPage({super.key, required this.playerName});

  @override
  State<CenaPrisaoAdrianPage> createState() => _CenaPrisaoAdrianPageState();
}

class _CenaPrisaoAdrianPageState extends State<CenaPrisaoAdrianPage> with TickerProviderStateMixin {
  final Map<CenaState, List<String>> _dialogues = {
    CenaState.celaInicio: [
      'De volta à cela, você fala consigo mesmo, tentando organizar seus pensamentos.',
      'Ao explorar o local, você encontra uma carta lacrada.',
      'Opção:',
    ],
    CenaState.cartaLida: [
      'Você pode não se lembrar, mas não se preocupe, você é inocente.',
      'Para se salvar, encontre Adrian Crowhurst, entregue a ele esta carta e ele o ajudará.',
      'A primeira pista do que realmente aconteceu eu já deixei com ele, o homem que prega justiça não é tão justo quanto parece',
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
    CenaState.jogoMemoria: [ // Diálogo para o jogo de memória
      'Tente se lembrar... Concentre-se!',
    ],
  };

  final Map<CenaState, String?> _backgrounds = {
    CenaState.celaInicio: 'imagens/cadeia.png',
    CenaState.cartaLida: 'imagens/cadeia.png',
    CenaState.caminhoAdrian: 'imagens/casaAdrian.png',
    CenaState.encontroAdrian: 'imagens/adrian2.jpeg',
    CenaState.entregaCarta: 'imagens/adrian3.jpeg',
    CenaState.naoEntregaCarta: 'imagens/adrian4.jpeg',
    CenaState.pistaFinal: 'imagens/adrian5.png',
    CenaState.jogoMemoria: 'imagens/cadeia.png', // Usando a mesma imagem da cela
  };

  CenaState _currentState = CenaState.celaInicio;
  int _currentTextIndex = 0;
  
  // Variáveis para o jogo de memória
  late AnimationController _progressController;
  bool _isHoldingButton = false;
  bool _cartaDesbloqueada = false;
  double _holdDuration = 3.0; // 3 segundos para segurar

  @override
  void initState() {
    super.initState();
    
    // Inicializar o controlador de animação para a barra de progresso
    _progressController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: (_holdDuration * 1000).round()),
    );
  }

  @override
  void dispose() {
    _progressController.dispose();
    super.dispose();
  }

  void _startHold() {
    if (_cartaDesbloqueada) return; // Se já desbloqueou, não faz nada
    
    setState(() {
      _isHoldingButton = true;
    });
    
    _progressController.forward().then((_) {
      // Quando a animação terminar (usuário segurou por tempo suficiente)
      if (_isHoldingButton) {
        _completeMemoryGame();
      }
    });
  }

  void _cancelHold() {
    if (_isHoldingButton) {
      setState(() {
        _isHoldingButton = false;
      });
      _progressController.reset();
    }
  }

  void _completeMemoryGame() {
    setState(() {
      _cartaDesbloqueada = true;
      _isHoldingButton = false;
      // Volta para o estado inicial após completar o jogo
      _currentState = CenaState.celaInicio;
      _currentTextIndex = 0;
    });
    
    // Mostra mensagem de sucesso
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Memória recuperada! Agora você pode ler a carta.'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _showMemoryGameRequiredDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Memória Bloqueada'),
          content: Text('Você precisa recuperar suas memórias antes de ler a carta. Concentre-se e tente se lembrar do que aconteceu.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Vai para o jogo de memória
                setState(() {
                  _currentState = CenaState.jogoMemoria;
                  _currentTextIndex = 0;
                });
              },
              child: Text('Tentar Lembrar'),
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
    return state == CenaState.celaInicio || state == CenaState.encontroAdrian;
  }

  bool _showChoices() {
    final currentDialogue = _dialogues[_currentState]!;
    return _isChoiceState(_currentState) && _currentTextIndex == currentDialogue.length - 1;
  }

  void _goToNextState() {
    setState(() {
      switch (_currentState) {
        case CenaState.celaInicio:
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
          
        case CenaState.jogoMemoria:
          // Volta para a cela após o jogo (já tratado no _completeMemoryGame)
          break;
      }
    });
  }

  void _handleChoice(String choice) {
    setState(() {
      if (_currentState == CenaState.celaInicio) {
        if (choice == 'Ler a carta lacrada') {
          if (_cartaDesbloqueada) {
            _currentState = CenaState.cartaLida;
            _currentTextIndex = 0;
          } else {
            _showMemoryGameRequiredDialog();
          }
        } else if (choice == 'Tentar lembrar') {
          _currentState = CenaState.jogoMemoria;
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

  Widget _buildMemoryGame() {
    return Column(
      children: [
        SizedBox(height: 20),
        Text(
          'Tente se lembrar...',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 30),
        
        // Barra de progresso
        Container(
          width: 300,
          height: 20,
          decoration: BoxDecoration(
            color: Colors.grey[800],
            borderRadius: BorderRadius.circular(10),
          ),
          child: AnimatedBuilder(
            animation: _progressController,
            builder: (context, child) {
              return Stack(
                children: [
                  // Fundo da barra
                  Container(
                    width: 300,
                    height: 20,
                    decoration: BoxDecoration(
                      color: Colors.grey[800],
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  // Progresso
                  Container(
                    width: 300 * _progressController.value,
                    height: 20,
                    decoration: BoxDecoration(
                      color: _isHoldingButton ? Colors.blue : Colors.grey,
                      borderRadius: BorderRadius.circular(10),
                      gradient: _isHoldingButton 
                          ? LinearGradient(
                              colors: [Colors.blue, Colors.lightBlue],
                            )
                          : null,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        
        SizedBox(height: 30),
        
        // Botão para segurar
        GestureDetector(
          onTapDown: (_) => _startHold(),
          onTapUp: (_) => _cancelHold(),
          onTapCancel: _cancelHold,
          child: AnimatedContainer(
            duration: Duration(milliseconds: 200),
            width: 150,
            height: 150,
            decoration: BoxDecoration(
              color: _isHoldingButton ? Colors.blue[800] : Colors.blue,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: _isHoldingButton ? Colors.blue.withOpacity(0.5) : Colors.transparent,
                  blurRadius: 10,
                  spreadRadius: 5,
                )
              ],
            ),
            child: Icon(
              Icons.lightbulb_outline,
              color: Colors.white,
              size: 60,
            ),
          ),
        ),
        
        SizedBox(height: 20),
        Text(
          _isHoldingButton 
              ? 'Mantenha pressionado... ${(_holdDuration * _progressController.value).toStringAsFixed(1)}s'
              : 'Pressione e segure para lembrar',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  Widget _buildChoices() {
    List<Widget> choices = [];

    if (_currentState == CenaState.celaInicio) {
      choices.add(_buildChoiceButton(
        text: 'Ler a carta lacrada',
        onPressed: () => _handleChoice('Ler a carta lacrada'),
        // Se a carta não está desbloqueada, o botão fica com aparência diferente
        buttonTextColor: _cartaDesbloqueada ? Colors.white : Colors.grey,
      ));
      
      if (!_cartaDesbloqueada) {
        choices.add(const SizedBox(height: 10));
        choices.add(_buildChoiceButton(
          text: 'Tentar lembrar',
          onPressed: () => _handleChoice('Tentar lembrar'),
          buttonTextColor: Colors.amber,
        ));
      }
    } else if (_currentState == CenaState.encontroAdrian) {
      choices.add(_buildChoiceButton(
        text: 'Entregar a carta',
        onPressed: () => _handleChoice('Entregar a carta'),
      ));
      choices.add(const SizedBox(height: 10));
      choices.add(_buildChoiceButton(
        text: 'Não entregar a carta',
        onPressed: () => _handleChoice('Não entregar a carta'),
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

    return Scaffold(
      body: GestureDetector(
        onTap: (showChoices || _currentState == CenaState.jogoMemoria) ? null : _advanceDialogue,
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
              // Conteúdo principal
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Se estiver no jogo de memória, mostra o jogo em vez do diálogo
                      if (_currentState == CenaState.jogoMemoria)
                        _buildMemoryGame()
                      else
                        _buildDialogueBox(currentDialogue),
                      
                      const SizedBox(height: 10),

                      if (!showChoices && _currentState != CenaState.jogoMemoria)
                        const Icon(
                          Icons.arrow_drop_down,
                          color: Colors.white70,
                          size: 40,
                        )
                      else if (_currentState != CenaState.jogoMemoria)
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