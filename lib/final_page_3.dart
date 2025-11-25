import 'package:flutter/material.dart';
import 'final_screen_widget.dart'; 

class FinalPage3 extends StatelessWidget {
  final String playerName;

  const FinalPage3({super.key, required this.playerName});

  @override
  Widget build(BuildContext context) {
    final String finalMessage =
        'O juiz confirma que você não é o assassino, mas ao se apontar como culpado, o tribunal considera que você está em estado de colapso mental. Você, $playerName, é enviado para um hospital psiquiátrico.';

    const String backgroundAsset = 'imagens/final3.png'; 

    return Scaffold(
      body: buildFinalScreen( 
        context,
        backgroundAsset,
        'FINAL 3: INTERNAMENTO',
        finalMessage,
        Colors.red.shade700,
        this.playerName, 
      ),
    );
  }
}