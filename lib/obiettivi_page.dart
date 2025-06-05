import 'package:flutter/material.dart';

class ObiettiviPage extends StatelessWidget {
  const ObiettiviPage({Key? key}) : super(key: key);

  final List<Achievement> achievements = const [
    Achievement(
      titolo: 'Topo da Biblioteca',
      descrizione: 'Hai studiato per almeno 20h nei luoghi del campus',
    ),
    Achievement(
      titolo: 'Presente, Prof!',
      descrizione: 'Hai partecipato ad almeno 30 lezioni',
    ),
    Achievement(
      titolo: 'Sessione Mode: ON',
      descrizione: 'Hai completato missioni studio per 7 giorni di fila',
    ),
    Achievement(
      titolo: 'Quiz Hunter',
      descrizione: 'Hai completato 10 quiz tematici',
    ),
    Achievement(
      titolo: 'Capitan Riciclo',
      descrizione: 'Hai completato 20 missioni sostenibili',
    ),
    Achievement(
      titolo: 'Login Legend',
      descrizione: 'Hai effettuato il login per 30 giorni',
    ),
    Achievement(
      titolo: '7 su 7, Like a Boss',
      descrizione: 'Hai completato missioni per 7 giorni consecutivi',
    ),
    Achievement(
      titolo: 'Level up: Matricola evoluta',
      descrizione: 'Hai completato il primo semestre',
    ),
    Achievement(
      titolo: 'Affronta i tuoi demoni',
      descrizione: 'Hai chiesto ricevimento a 5 docenti',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Obiettivi'),
        backgroundColor: const Color(0xFF004070),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: achievements.length,
        itemBuilder: (context, index) {
          final achievement = achievements[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              leading: const Icon(
                Icons.emoji_events_rounded,
                color: Colors.amber,
              ),
              title: Text(
                achievement.titolo,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(achievement.descrizione),
              trailing: const Icon(Icons.arrow_forward_ios_rounded),
              onTap: () {
                // Potenziale apertura futura: dettagli dell'obiettivo
              },
            ),
          );
        },
      ),
    );
  }
}

class Achievement {
  final String titolo;
  final String descrizione;

  const Achievement({required this.titolo, required this.descrizione});
}
