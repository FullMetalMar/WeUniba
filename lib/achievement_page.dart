import 'package:flutter/material.dart';

class AchievementPage extends StatelessWidget {
  const AchievementPage({Key? key}) : super(key: key);

  final List<Achievement> achievements = const [
    Achievement(
      titolo: 'Topo da Biblioteca',
      descrizione: 'Hai studiato per almeno 20h nei luoghi del campus',
      icona: Icons.menu_book_rounded,
      completato: true,
    ),
    Achievement(
      titolo: 'Presente, Prof!',
      descrizione: 'Hai partecipato ad almeno 30 lezioni',
      icona: Icons.school_rounded,
      completato: true,
    ),
    Achievement(
      titolo: 'Sessione Mode: ON',
      descrizione: 'Hai completato missioni studio per 7 giorni di fila',
      icona: Icons.bolt_rounded,
      completato: false,
    ),
    Achievement(
      titolo: 'Quiz Hunter',
      descrizione: 'Hai completato 10 quiz tematici',
      icona: Icons.quiz_rounded,
      completato: true,
    ),
    Achievement(
      titolo: 'Capitan Riciclo',
      descrizione: 'Hai completato 20 missioni sostenibili',
      icona: Icons.recycling_rounded,
      completato: false,
    ),
    Achievement(
      titolo: 'Login Legend',
      descrizione: 'Hai effettuato il login per 30 giorni',
      icona: Icons.login_rounded,
      completato: true,
    ),
    Achievement(
      titolo: '7 su 7, Like a Boss',
      descrizione: 'Hai completato missioni per 7 giorni consecutivi',
      icona: Icons.star_rounded,
      completato: false,
    ),
    Achievement(
      titolo: 'Level up: Matricola evoluta',
      descrizione: 'Hai completato il primo semestre',
      icona: Icons.trending_up_rounded,
      completato: true,
    ),
    Achievement(
      titolo: 'Affronta i tuoi demoni',
      descrizione: 'Hai chiesto ricevimento a 5 docenti',
      icona: Icons.email_rounded,
      completato: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      appBar: AppBar(
        title: const Text('Obiettivi', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF003366),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: achievements.length,
        itemBuilder: (context, index) {
          final achievement = achievements[index];
          return Opacity(
            opacity: achievement.completato ? 1.0 : 0.5,
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 16,
                ),
                leading: Icon(
                  achievement.icona,
                  size: 36,
                  color: achievement.completato ? Colors.green : Colors.grey,
                ),
                title: Text(
                  achievement.titolo,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Text(
                    achievement.descrizione,
                    style: const TextStyle(fontSize: 13),
                  ),
                ),
                trailing: achievement.completato
                    ? const Icon(
                        Icons.check_circle_rounded,
                        color: Colors.green,
                      )
                    : null,
                onTap: () {
                  // Dettagli futuro
                },
              ),
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
  final IconData icona;
  final bool completato;

  const Achievement({
    required this.titolo,
    required this.descrizione,
    required this.icona,
    required this.completato,
  });
}
