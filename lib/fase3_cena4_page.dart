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
  // NOVOS ESTADOS PARA A REVELAÇÃO ÉPICA
  salaEvidencias,
  analiseDigital,
  revelacaoTestemunho,
  jogoConectarProvas,
  flashbackRevelacao,
  conclusaoDramatica,
  escolhaFinal,
}

class Fase2Cena3Page extends StatefulWidget {
  final String playerName;

  const Fase2Cena3Page({super.key, required this.playerName});

  @override
  State<Fase2Cena3Page> createState() => _Fase2Cena3PageState();
}

class _Fase2Cena3PageState extends State<Fase2Cena3Page> with SingleTickerProviderStateMixin {
  Map<Cena3State, List<String>> get _dialogues => {
    Cena3State.becoChegada: [
      'Você e Adrian encontram um beco sem saída, mas também um morador local, que pode ter visto algo.',
      'Adrian: "O senhor esteve aqui ontem à noite?"',
    ],
    Cena3State.dialogoMorador1: [
      'Morador: "Ontem… sim… estava aqui… houve uma barulheira enorme."',
      'Você: "O que você viu ou ouviu?"',
    ],
    Cena3State.dialogoMorador2: [
      'Morador: "Tinha um homem de estatura média, rosto anguloso, olhos cinza, cabelo grisalho penteado para trás e postura rígida como um homem da lei… ele estava esfaqueando alguém… não consegui ver mais do que isso."',
    ],
    Cena3State.dialogoMorador3: [
      'Adrian: "Entendi… um suspeito surgiu na minha mente. Vamos voltar à minha casa e testar a digital que encontramos."',
    ],
    Cena3State.voltaCasaAdrian: [
      'De volta à casa de Adrian, ele olha para as evidências com uma expressão séria.',
      'Adrian: "Temos todas as peças… vamos montar esse quebra-cabeça."',
    ],
    // NOVOS DIÁLOGOS PARA A REVELAÇÃO
    Cena3State.salaEvidencias: [
      'ADRIAN: "Vamos analisar cada evidência cuidadosamente..."',
      '*Adrian espalha todas as provas sobre a mesa*',
    ],
    Cena3State.analiseDigital: [
      'ADRIAN: "Primeiro, a digital que coletamos no local do crime..."',
      '*Digitando furiosamente no computador*',
      'ADRIAN: "Estou cruzando com o banco de dados do tribunal..."',
      '...',
      'ADRIAN: "INCRÍVEL! A digital pertence ao JUIZ CORDEIRO!"',
    ],
    Cena3State.revelacaoTestemunho: [
      'ADRIAN: "Agora o testemunho do morador..."',
      '"Homem de postura rígida como um homem da lei..."',
      '"Cabelo grisalho penteado para trás..."',
      '"Olhos cinza, rosto anguloso..."',
      'ADRIAN: "Isso descreve PERFEITAMENTE o Juiz Cordeiro!"',
    ],
    Cena3State.conclusaoDramatica: [
      'ADRIAN: "Tudo faz sentido agora!"',
      'O Juiz Cordeiro sempre foi obcecado por casos "perfeitos"...',
      'Ele deve ter armado tudo para encobrir sua corrupção!',
      'ADRIAN: "Mas preciso ter certeza absoluta..."',
    ],
    Cena3State.escolhaFinal: [
      'ADRIAN: "Baseado em TODAS as evidências..."',
      'ADRIAN: "Quem você acha que é o verdadeiro culpado?"',
      'Opção:',
    ],
  };

  final Map<Cena3State, String?> _backgrounds = {
    Cena3State.becoChegada: 'imagens/beco.jpg',
    Cena3State.dialogoMorador1: 'imagens/mendigo1.png',
    Cena3State.dialogoMorador2: 'imagens/mendigo2.png',
    Cena3State.dialogoMorador3: 'imagens/beco2.png',
    Cena3State.voltaCasaAdrian: 'imagens/casaAdrian.png',
    Cena3State.salaEvidencias: 'imagens/sala_evidencias.png',
    Cena3State.analiseDigital: 'imagens/computador_digital.png',
    Cena3State.revelacaoTestemunho: 'imagens/foto_juiz_tribunal.png',
    Cena3State.conclusaoDramatica: 'imagens/juiz_culpado.png',
    Cena3State.escolhaFinal: 'imagens/sala_evidencias.png',
  };

  Cena3State _currentState = Cena3State.becoChegada;
  int _currentTextIndex = 0;
  
  // Variáveis para o jogo de conectar provas - CORRIGIDAS
  List<bool> _conexoesCorretas = [false, false, false, false];
  int _provaAtual = 0; // Controla qual prova está sendo conectada
  late AnimationController _animationController;
  bool _showFlashback = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _advanceDialogue() {
    setState(() {
      final currentDialogue = _dialogues[_currentState]!;

      if (_currentTextIndex < currentDialogue.length - 1) {
        _currentTextIndex++;
      } else if (!_isChoiceState(_currentState) && _currentState != Cena3State.jogoConectarProvas) {
        _goToNextState();
      }
    });
  }

  bool _isChoiceState(Cena3State state) {
    return state == Cena3State.escolhaFinal;
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
          _currentState = Cena3State.salaEvidencias;
          _currentTextIndex = 0;
          break;

        case Cena3State.salaEvidencias:
          _currentState = Cena3State.analiseDigital;
          _currentTextIndex = 0;
          break;

        case Cena3State.analiseDigital:
          _currentState = Cena3State.revelacaoTestemunho;
          _currentTextIndex = 0;
          break;

        case Cena3State.revelacaoTestemunho:
          _currentState = Cena3State.jogoConectarProvas;
          // Reseta o jogo quando entra
          _conexoesCorretas = [false, false, false, false];
          _provaAtual = 0;
          break;

        case Cena3State.jogoConectarProvas:
          _currentState = Cena3State.conclusaoDramatica;
          _currentTextIndex = 0;
          break;

        case Cena3State.conclusaoDramatica:
          _currentState = Cena3State.escolhaFinal;
          _currentTextIndex = 0;
          break;

        case Cena3State.escolhaFinal:
          break;
        case Cena3State.flashbackRevelacao:
          // Já tratado separadamente
          break;
      }
    });
  }

  // JOGO DE CONECTAR AS PROVAS - CORRIGIDO
  Widget _buildProvaLinkingGame() {
    return Stack(
      children: [
        // Fundo da sala de evidências
        Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('imagens/sala_evidencias.png'),
              fit: BoxFit.cover,
            ),
          ),
        ),

        // Título
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
                  'Conecte as provas ao suspeito correto:',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8),
                Text(
                  'Prova atual: ${_getProvaAtualTexto()}',
                  style: TextStyle(
                    color: Colors.yellow,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),

        // Container principal com as provas e suspeitos
        Positioned(
          top: 140,
          left: 20,
          right: 20,
          bottom: 100,
          child: Row(
            children: [
              // COLUNA DAS PROVAS (esquerda)
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildProvaItem(
                        'Digital no local do crime',
                        Icons.fingerprint,
                        _conexoesCorretas[0],
                        isAtual: _provaAtual == 0,
                      ),
                      _buildProvaItem(
                        'Testemunho: "Homem da lei"',
                        Icons.record_voice_over,
                        _conexoesCorretas[1],
                        isAtual: _provaAtual == 1,
                      ),
                      _buildProvaItem(
                        'Postura rígida e formal',
                        Icons.psychology,
                        _conexoesCorretas[2],
                        isAtual: _provaAtual == 2,
                      ),
                      _buildProvaItem(
                        'Cabelo grisalho penteado',
                        Icons.face_retouching_natural,
                        _conexoesCorretas[3],
                        isAtual: _provaAtual == 3,
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(width: 20),

              // COLUNA DOS SUSPEITOS (direita)
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildSuspeitoItem(
                        'Juiz Cordeiro',
                        Icons.gavel,
                        Colors.red,
                        onTap: () => _onProvaConnected('juiz'),
                      ),
                      _buildSuspeitoItem(
                        'Morador de Rua',
                        Icons.person,
                        Colors.blue,
                        onTap: () => _onProvaConnected('morador'),
                      ),
                      _buildSuspeitoItem(
                        'Você',
                        Icons.person_outline,
                        Colors.green,
                        onTap: () => _onProvaConnected('voce'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        // Instruções
        Positioned(
          bottom: 30,
          left: 0,
          right: 0,
          child: Container(
            padding: EdgeInsets.all(12),
            margin: EdgeInsets.symmetric(horizontal: 50),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.7),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              _provaAtual < 4 
                  ? 'Toque no JUIZ CORDEIRO para conectar: ${_getProvaAtualTexto()}'
                  : 'Todas as provas conectadas!',
              style: TextStyle(
                color: Colors.yellow,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProvaItem(String texto, IconData icone, bool conectada, {bool isAtual = false}) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: conectada 
            ? Colors.green.withOpacity(0.3) 
            : isAtual 
              ? Colors.yellow.withOpacity(0.2)
              : Colors.transparent,
        border: Border.all(
          color: conectada 
              ? Colors.green 
              : isAtual
                ? Colors.yellow
                : Colors.white,
          width: isAtual ? 3 : 2,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            icone, 
            color: conectada ? Colors.green : isAtual ? Colors.yellow : Colors.white, 
            size: 20
          ),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              texto,
              style: TextStyle(
                color: conectada ? Colors.green : isAtual ? Colors.yellow : Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          if (conectada)
            Icon(Icons.check, color: Colors.green, size: 20),
          if (isAtual && !conectada)
            Icon(Icons.arrow_forward, color: Colors.yellow, size: 20),
        ],
      ),
    );
  }

  Widget _buildSuspeitoItem(String nome, IconData icone, Color cor, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 16),
        decoration: BoxDecoration(
          color: cor.withOpacity(0.2),
          border: Border.all(color: cor, width: 2),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(icone, color: cor, size: 24),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                nome,
                style: TextStyle(
                  color: cor,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // MÉTODO CORRIGIDO para conectar provas
  void _onProvaConnected(String suspeito) {
    // Só aceita se for o Juiz Cordeiro (resposta correta) e ainda tiver provas para conectar
    if (suspeito == 'juiz' && _provaAtual < 4) {
      setState(() {
        _conexoesCorretas[_provaAtual] = true;
        _provaAtual++; // Vai para a próxima prova
      });

      // Verifica se todas as provas foram conectadas
      if (_provaAtual >= 4) {
        _showFlashbackRevelacao();
      }
    } else if (suspeito != 'juiz' && _provaAtual < 4) {
      // Feedback visual para resposta errada
      _showRespostaErrada();
    }
  }

  // Método auxiliar para mostrar qual prova está ativa
  String _getProvaAtualTexto() {
    switch (_provaAtual) {
      case 0: return 'Digital no local do crime';
      case 1: return 'Testemunho: "Homem da lei"';
      case 2: return 'Postura rígida e formal';
      case 3: return 'Cabelo grisalho penteado';
      default: return 'Completo!';
    }
  }

  // Método para mostrar resposta errada
  void _showRespostaErrada() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Essa prova não corresponde a este suspeito! Toque no JUIZ CORDEIRO.'),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _showFlashbackRevelacao() {
    setState(() {
      _showFlashback = true;
    });

    _animationController.forward().then((_) {
      Future.delayed(Duration(seconds: 3), () {
        setState(() {
          _showFlashback = false;
        });
        _goToNextState();
      });
    });
  }

  Widget _buildFlashbackScene() {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Stack(
          children: [
            // Fundo do flashback
            Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('imagens/flashback_crime.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),

            // Overlay escuro com animação
            Container(
              color: Colors.black.withOpacity(0.7 * _animationController.value),
            ),

            // Texto revelador
            Positioned(
              top: 100,
              left: 0,
              right: 0,
              child: Opacity(
                opacity: _animationController.value,
                child: Container(
                  padding: EdgeInsets.all(20),
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    'REVELAÇÃO: O JUIZ CORDEIRO ERA O VERDADEIRO CULPADO!\n\nEle armou você para encobrir sua própria corrupção!',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),

            // Efeito de brilho
            if (_animationController.value > 0.5)
              Container(
                color: Colors.white.withOpacity(0.1 * (_animationController.value - 0.5) * 2),
              ),
          ],
        );
      },
    );
  }

  void _handleChoice(String choice) {
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

    if (_currentState == Cena3State.escolhaFinal) {
      choices.add(_buildChoiceButton(
        text: 'Juiz Cordeiro ',
        onPressed: () => _handleChoice('Juiz'),
        buttonTextColor: Colors.lightGreenAccent,
      ));
      choices.add(const SizedBox(height: 10));
      choices.add(_buildChoiceButton(
        text: 'Morador de rua ',
        onPressed: () => _handleChoice('Morador de rua'),
        buttonTextColor: Colors.blueAccent,
      ));
      choices.add(const SizedBox(height: 10));
      choices.add(_buildChoiceButton(
        text: 'Você mesmo',
        onPressed: () => _handleChoice('Você mesmo'),
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
      side: const BorderSide(color: Colors.white, width: 2),
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
    // Se estiver no flashback, mostra a cena especial
    if (_showFlashback) {
      return Scaffold(
        body: _buildFlashbackScene(),
      );
    }

    // Se estiver no jogo de conectar provas, mostra o jogo
    if (_currentState == Cena3State.jogoConectarProvas) {
      return Scaffold(
        body: _buildProvaLinkingGame(),
      );
    }

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