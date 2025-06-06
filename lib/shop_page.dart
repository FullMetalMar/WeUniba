import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'session_data.dart';

class ShopPage extends StatefulWidget {
  const ShopPage({super.key});

  @override
  State<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage>
    with SingleTickerProviderStateMixin {
  String? selectedCategory;
  int cfuBalance = 42;
  final AudioPlayer _audioPlayer = AudioPlayer();
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  final Map<String, List<Map<String, dynamic>>> categoryItems = {
    'Badge': [
      {
        'nome': 'Il Calcolatore',
        'descrizione': 'Badge celebrativo per menti logiche',
        'prezzo': 5,
        'immagine': 'assets/badges/badge_calcolatore.png',
      },
      {
        'nome': 'Il Nerd Sigillato',
        'descrizione': 'Spilla esclusiva per nerd certificati',
        'prezzo': 5,
        'immagine': 'assets/badges/badge_il_nerd_sigillato.png',
      },
      {
        'nome': 'Il Pensatore Digitale',
        'descrizione': 'Badge per un cervello veramente digitale',
        'prezzo': 5,
        'immagine': 'assets/badges/badge_il_pensatore_digitale.png',
      },
    ],
    'Accessori': [
      {
        'nome': 'Auricolare',
        'descrizione': 'Auricolare elegante per le sessioni di studio',
        'prezzo': 4,
        'immagine': 'assets/avatar/accessories/accessorio_auricolare.png',
      },
      {
        'nome': 'Cuffie',
        'descrizione': 'Cuffie over-ear per massimo focus',
        'prezzo': 6,
        'immagine': 'assets/avatar/accessories/accessorio_cuffie.png',
      },
      {
        'nome': 'Zainetto',
        'descrizione': 'Zaino pratico per i tuoi spostamenti universitari',
        'prezzo': 8,
        'immagine': 'assets/avatar/accessories/accessorio_zainetto.png',
      },
    ],
    'Portafortuna': [
      {
        'nome': 'Santino Fake Uomo',
        'descrizione': 'Santino scaramantico del prof. Someone',
        'prezzo': 3,
        'immagine': 'assets/lucky_charms/santino_fake_man.png',
      },
      {
        'nome': 'Santino Fake Donna',
        'descrizione': 'Santino scaramantico della prof.ssa Someone',
        'prezzo': 3,
        'immagine': 'assets/lucky_charms/santino_fake_woman.png',
      },
    ],
  };

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  void mostraAnimazioneAcquisto() async {
    await _audioPlayer.play(AssetSource('audio/purchase.mp3'));

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => ScaleTransition(
        scale: _scaleAnimation,
        child: AlertDialog(
          backgroundColor: Colors.green.shade100,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.check_circle, color: Colors.green, size: 60),
              const SizedBox(height: 16),
              const Text(
                "Acquisto completato!",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );

    _controller.forward(from: 0).then((_) {
      Future.delayed(const Duration(seconds: 1), () {
        Navigator.of(context).pop();
      });
    });
  }

  void aggiungiAllInventario(String categoria, Map<String, dynamic> item) {
    switch (categoria) {
      case 'Badge':
        if (!SessionData.badgeInventario.any(
          (b) => b['path'] == item['immagine'],
        )) {
          SessionData.badgeInventario.add({
            "titolo": item['nome'],
            "path": item['immagine'],
          });
        }
        break;
      case 'Accessori':
        if (!SessionData.accessoriInventario.any(
          (a) => a['path'] == item['immagine'],
        )) {
          SessionData.accessoriInventario.add({
            "nome": item['nome'],
            "path": item['immagine'],
          });
        }
        break;
      case 'Portafortuna':
        if (!SessionData.portafortunaInventario.any(
          (p) => p['path'] == item['immagine'],
        )) {
          SessionData.portafortunaInventario.add({
            "nome": item['nome'],
            "path": item['immagine'],
          });
        }
        break;
    }
  }

  bool isItemAcquistato(String categoria, String imagePath) {
    switch (categoria) {
      case 'Badge':
        return SessionData.badgeInventario.any((b) => b['path'] == imagePath);
      case 'Accessori':
        return SessionData.accessoriInventario.any(
          (a) => a['path'] == imagePath,
        );
      case 'Portafortuna':
        return SessionData.portafortunaInventario.any(
          (p) => p['path'] == imagePath,
        );
      default:
        return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF003366),
        centerTitle: true,
        title: const Text('Shop', style: TextStyle(color: Colors.white)),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Row(
              children: [
                Text(
                  '$cfuBalance',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 4),
                Image.asset('assets/coin/CFU2.png', width: 36, height: 36),
              ],
            ),
          ),
        ],
        iconTheme: const IconThemeData(color: Colors.white),
        leading: selectedCategory != null
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => setState(() => selectedCategory = null),
              )
            : null,
      ),
      backgroundColor: const Color(0xFFF2F2F2),
      body: selectedCategory == null
          ? Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 48),
                      backgroundColor: const Color(0xFF003366),
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () => setState(() => selectedCategory = 'Badge'),
                    child: const Text('Badge'),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 48),
                      backgroundColor: const Color(0xFF003366),
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () =>
                        setState(() => selectedCategory = 'Accessori'),
                    child: const Text('Accessori'),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 48),
                      backgroundColor: const Color(0xFF003366),
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () =>
                        setState(() => selectedCategory = 'Portafortuna'),
                    child: const Text('Portafortuna'),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: categoryItems[selectedCategory]!.length,
              itemBuilder: (context, index) {
                final item = categoryItems[selectedCategory]![index];
                final alreadyBought = isItemAcquistato(
                  selectedCategory!,
                  item['immagine'],
                );
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    leading: Image.asset(
                      item['immagine'],
                      width: 40,
                      height: 40,
                    ),
                    title: Text(item['nome']),
                    subtitle: Text(item['descrizione']),
                    trailing: alreadyBought
                        ? const Icon(Icons.check, color: Colors.green)
                        : Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '${item['prezzo']}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Image.asset(
                                'assets/coin/CFU2.png',
                                width: 36,
                                height: 36,
                              ),
                            ],
                          ),
                    onTap: alreadyBought
                        ? null
                        : () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text('Acquisto ${item['nome']}'),
                                content: Row(
                                  children: [
                                    Text(
                                      'Vuoi acquistare questo oggetto per ${item['prezzo']} ',
                                    ),
                                    Image.asset(
                                      'assets/coin/CFU2.png',
                                      width: 36,
                                      height: 36,
                                    ),
                                    const Text('?'),
                                  ],
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text('Annulla'),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        aggiungiAllInventario(
                                          selectedCategory!,
                                          item,
                                        );
                                      });
                                      Navigator.pop(context);
                                      mostraAnimazioneAcquisto();
                                    },
                                    child: const Text('Acquista'),
                                  ),
                                ],
                              ),
                            );
                          },
                  ),
                );
              },
            ),
    );
  }
}
