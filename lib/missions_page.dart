import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'session_data.dart'; // Assicurati che il percorso sia corretto

class MissionsPage extends StatefulWidget {
  const MissionsPage({super.key});

  @override
  State<MissionsPage> createState() => _MissionsPageState();
}

class _MissionsPageState extends State<MissionsPage> {
  final List<Map<String, String>> _missions = [
    {
      'categoria': 'Studio',
      'missione': 'Studia per 3h in aula studio',
      'validazione': 'QR code in aula',
    },
    {
      'categoria': 'Studio',
      'missione': 'Partecipa ad (almeno) una lezione',
      'validazione': 'QR code in aula',
    },
    {
      'categoria': 'Studio',
      'missione': 'Completa dei minigiochi per due volte',
      'validazione': 'In-App',
    },
    {
      'categoria': 'Sostenibilità',
      'missione': 'Riempi la bottiglietta d’acqua nelle fontane del campus',
      'validazione': 'QR code vicino al dispenser',
    },
    {
      'categoria': 'Sostenibilità',
      'missione': 'Scegli le scale al posto dell’ascensore',
      'validazione': 'QR code sulle scale',
    },
    {
      'categoria': 'Socialità',
      'missione': 'Parla con almeno 2 colleghi',
      'validazione': 'Id collega',
    },
    {
      'categoria': 'Socialità',
      'missione': 'Presentati ad un nuovo collega',
      'validazione': 'Peer List',
    },
    {
      'categoria': 'Socialità',
      'missione': 'Invita un collega a fare pausa caffè',
      'validazione': 'Id collega',
    },
    {
      'categoria': 'Socialità',
      'missione': 'Personalizza il tuo avatar o profilo',
      'validazione': 'In-App',
    },
    {
      'categoria': 'Socialità',
      'missione': 'Consuma un pasto a mensa',
      'validazione': 'QR code',
    },
  ];

  final Set<int> _completedMissions = {};
  final AudioPlayer _audioPlayer = AudioPlayer();

  Future<void> _playSuccessSound() async {
    await _audioPlayer.play(AssetSource('audio/success.mp3'));
  }

  Future<void> _scanQRCodeAndComplete(int index) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const QRScannerPage()),
    );
    if (result != null && result is String && result.isNotEmpty) {
      setState(() {
        _completedMissions.add(index);
      });
      SessionData.aggiungiXP(context, 15); // aggiungi XP
      await _playSuccessSound();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'QR validato! Hai completato: ${_missions[index]['missione']} (+15 XP)',
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      appBar: AppBar(
        backgroundColor: const Color(0xFF003366),
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Missioni Giornaliere',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _missions.length,
        itemBuilder: (context, index) {
          final mission = _missions[index];
          final isCompleted = _completedMissions.contains(index);
          final requiresQR = mission['validazione']!.toLowerCase().contains(
            'qr code',
          );

          return AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
            decoration: BoxDecoration(
              color: isCompleted ? Colors.green[100] : Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            margin: const EdgeInsets.symmetric(vertical: 8),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  mission['categoria']!,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF003366),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  mission['missione']!,
                  style: const TextStyle(fontSize: 15),
                ),
                const SizedBox(height: 8),
                Text(
                  'Validazione: ${mission['validazione']}',
                  style: const TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerRight,
                  child: isCompleted
                      ? Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(Icons.check_circle, color: Colors.green),
                            SizedBox(width: 8),
                            Text(
                              'Completata',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        )
                      : ElevatedButton(
                          onPressed: () async {
                            if (requiresQR) {
                              await _scanQRCodeAndComplete(index);
                            } else {
                              setState(() {
                                _completedMissions.add(index);
                              });
                              SessionData.aggiungiXP(
                                context,
                                15,
                              ); // aggiungi XP
                              await _playSuccessSound();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Hai completato: ${mission['missione']} (+15 XP)',
                                  ),
                                ),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF003366),
                          ),
                          child: const Text(
                            'Completa',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class QRScannerPage extends StatelessWidget {
  const QRScannerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scannerizza QR Code')),
      body: MobileScanner(
        onDetect: (capture) {
          final barcode = capture.barcodes.first;
          if (barcode.rawValue != null) {
            Navigator.pop(context, barcode.rawValue);
          }
        },
      ),
    );
  }
}
