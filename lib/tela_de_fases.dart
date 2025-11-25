import 'package:flutter/material.dart';
import 'fase1_cena2_page.dart';
import 'fase2_cena3_page.dart'; 
import 'fase3_cena4_page.dart'; 
import 'progress_manager.dart';
import 'main.dart';

class TelaDeFases extends StatefulWidget {
  final String playerName;

  const TelaDeFases({Key? key, required this.playerName}) : super(key: key);

  @override
  State<TelaDeFases> createState() => _TelaDeFasesState();
}

class _TelaDeFasesState extends State<TelaDeFases> {
  final ProgressManager _progressManager = ProgressManager();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: const Text('Fases do Jogo'),
        backgroundColor: Colors.blueGrey[800],
      ),
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Bem-vindo à tela de fases, ${widget.playerName}!',
              style: const TextStyle(
                fontSize: 24,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildPhaseCard(
                  context,
                  phaseNumber: 1,
                  phaseId: 'fase1',
                  title: 'FASE 1',
                  subtitle: 'O Tribunal',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                      
                        builder: (context) => CenaPrisaoAdrianPage(playerName: widget.playerName),
                      ),
                    ).then((_) {
                      
                      setState(() {});
                    });
                  },
                ), 

                _buildPhaseCard(
                  context,
                  phaseNumber: 2,
                  phaseId: 'fase2',
                  title: 'FASE 2',
                  subtitle: 'Investigação',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        // Assumindo que CenaLocalCrimePage é a primeira cena da Fase 2
                        builder: (context) => CenaLocalCrimePage(playerName: widget.playerName),
                      ),
                    );
                  },
                ),
                
                _buildPhaseCard(
                  context,
                  phaseNumber: 3,
                  phaseId: 'fase3',
                  title: 'FASE 3',
                  subtitle: 'O Desfecho',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Fase2Cena3Page(playerName: widget.playerName), 
                      ),
                    );
                  },
                ),
              ],
            ),

            const SizedBox(height: 40),
          ElevatedButton(
            onPressed: () {
              // Importe a HomePage se ainda não estiver importada
              // import 'caminho/para/HomePage.dart'; 
              
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => const MyApp(), 
                ),
                
                (Route<dynamic> route) => false, 
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueGrey,
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
            ),
            child: const Text(
              'VOLTAR',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhaseCard(
    BuildContext context, {
    required int phaseNumber,
    required String phaseId,
    required String title,
    required String subtitle,
    required VoidCallback? onTap,
  }) {
    bool isLocked = !_progressManager.isPhaseUnlocked(phaseId);
    
    return GestureDetector(
      onTap: isLocked ? null : onTap,
      child: Container(
        width: 100,
        height: 140,
        decoration: BoxDecoration(
          color: isLocked ? Colors.grey[800] : Colors.blueGrey[700],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isLocked ? Colors.grey[600]! : Colors.blueGrey[400]!,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isLocked)
              Icon(
                Icons.lock_outline,
                color: Colors.grey[400],
                size: 32,
              )
            else
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.blueGrey[500],
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '$phaseNumber',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: isLocked ? Colors.grey[400] : Colors.white70,
                fontSize: 12,
              ),
            ),
            if (!isLocked)
              Container(
                margin: const EdgeInsets.only(top: 8),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.green[700],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'DISPONÍVEL',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 8,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}