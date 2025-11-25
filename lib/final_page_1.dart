import 'package:flutter/material.dart';
import 'final_screen_widget.dart'; 

class FinalPage1 extends StatelessWidget {
  final String playerName;

  const FinalPage1({super.key, required this.playerName});

  @override
  Widget build(BuildContext context) {
    final String finalMessage =
        'O juiz era realmente o assassino... Você, $playerName, é considerado inocente...';
    
    const String backgroundAsset = 'imagens/final1.png'; 

    return Scaffold(
      body: buildFinalScreen( 
        context,
        backgroundAsset,
        'FINAL 1: LIBERDADE E HONRA',
        finalMessage,
        Colors.green.shade700,
        this.playerName, 
      ),
    );
  }
}