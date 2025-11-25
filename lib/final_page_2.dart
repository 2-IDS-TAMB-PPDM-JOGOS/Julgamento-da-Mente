import 'package:flutter/material.dart';
import 'final_screen_widget.dart';

class FinalPage2 extends StatelessWidget {
  final String playerName;

  const FinalPage2({super.key, required this.playerName});

  @override
  Widget build(BuildContext context) {
    final String finalMessage =
        'O morador de rua não era o assassino. Por ter acusado alguém inocente sem provas concretas, a investigação falha. Você, $playerName, é preso injustamente pelo crime.';

    const String backgroundAsset = 'imagens/final2.png'; 

    return Scaffold(
      body: buildFinalScreen( 
        context,
        backgroundAsset,
        'FINAL 2: PRISÃO INJUSTA',
        finalMessage,
        Colors.orange.shade700,
        this.playerName,
      ),
    );
  }
}