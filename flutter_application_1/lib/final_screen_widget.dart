// final_screen_widget.dart

import 'package:flutter/material.dart';
import 'tela_de_fases.dart'; 

Widget buildFinalScreen(BuildContext context, String backgroundAsset, String title, String message, Color titleColor, String playerName) {
  return Container(
    decoration: backgroundAsset.isNotEmpty
        ? BoxDecoration(
            image: DecorationImage(
              image: AssetImage(backgroundAsset),
              fit: BoxFit.cover,
            ),
          )
        : const BoxDecoration(color: Colors.black),
    child: Stack(
      children: [
        // Sombra para o título e mensagem
        Container(color: Colors.black.withOpacity(0.6)),
        
        Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: titleColor,
                    shadows: const [Shadow(blurRadius: 10, color: Colors.black)],
                  ),
                ),
                const SizedBox(height: 30),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.75),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: titleColor, width: 3),
                  ),
                  child: Text(
                    message,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      height: 1.5,
                    ),
                  ),
                ),
                const SizedBox(height: 50),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TelaDeFases(playerName: playerName), 
                      ),
                      (Route<dynamic> route) => false,
                    );
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text('Voltar à Seleção de Fases'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: titleColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}