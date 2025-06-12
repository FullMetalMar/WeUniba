import 'package:flutter/material.dart';
import 'session_data.dart';
import 'package:audioplayers/audioplayers.dart';

class EventPage extends StatefulWidget {
  const EventPage({super.key});

  @override
  State<EventPage> createState() => _EventPageState();
}

enum EventoFiltro { tutti, futuri, passati }

class _EventPageState extends State<EventPage> {
  EventoFiltro filtroCorrente = EventoFiltro.tutti;
  final AudioPlayer _audioPlayer = AudioPlayer();

  final List<Evento> eventi = [
    Evento(
      titolo: 'Lezione di Programmazione I',
      descrizione: 'Aula 3, Edificio Centrale - Ore 10:00',
      data: '10-06-2025',
      tipo: EventoTipo.lezione,
      domanda: 'Qual è il tipo di ciclo in C che termina con while?',
      rispostaCorretta: 'do-while',
    ),
    Evento(
      titolo: 'Workshop Flutter',
      descrizione: 'Lab Multimediale - Ore 14:30',
      data: '12-06-2025',
      tipo: EventoTipo.workshop,
      domanda: 'Come si chiama il widget per layout verticale in Flutter?',
      rispostaCorretta: 'column',
    ),
    Evento(
      titolo: 'Seminario su IA',
      descrizione: 'Aula Magna - Ore 16:00',
      data: '01-06-2025',
      tipo: EventoTipo.conferenza,
      isPassato: true,
      domanda: 'Cos\'è il machine learning?',
      rispostaCorretta: 'una tecnica per l\'apprendimento automatico',
    ),
  ];

  IconData _iconForTipo(EventoTipo tipo) {
    switch (tipo) {
      case EventoTipo.lezione:
        return Icons.menu_book_rounded;
      case EventoTipo.conferenza:
        return Icons.mic_rounded;
      case EventoTipo.workshop:
        return Icons.laptop_rounded;
      case EventoTipo.tutorato:
        return Icons.group_rounded;
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  void _confermaPartecipazione(Evento evento) {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Conferma presenza'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(evento.domanda),
            const SizedBox(height: 12),
            TextField(
              controller: controller,
              decoration: const InputDecoration(
                hintText: 'Risposta...',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Annulla'),
          ),
          ElevatedButton(
            onPressed: () {
              final rispostaUtente = controller.text.trim().toLowerCase();
              final corretta = evento.rispostaCorretta.toLowerCase();
              Navigator.pop(context);
              if (rispostaUtente == corretta) {
                setState(() => evento.confermato = true);

                // ✅ Ricompensa XP + CFU
                SessionData.aggiungiXP(context, 30);
                SessionData.aggiungiCFU(5);

                _audioPlayer.play(AssetSource('audio/success.mp3'));

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Presenza confermata a "${evento.titolo}" — +30 XP, +5 CFU!',
                    ),
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Risposta errata. Riprova.')),
                );
              }
            },
            child: const Text('Verifica'),
          ),
        ],
      ),
    );
  }

  List<Evento> get eventiFiltrati {
    switch (filtroCorrente) {
      case EventoFiltro.passati:
        return eventi.where((e) => e.isPassato).toList();
      case EventoFiltro.futuri:
        return eventi.where((e) => !e.isPassato).toList();
      case EventoFiltro.tutti:
        return eventi;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      appBar: AppBar(
        title: const Text('Eventi', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: const Color(0xFF003366),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            child: DropdownButton<EventoFiltro>(
              isExpanded: true,
              value: filtroCorrente,
              items: const [
                DropdownMenuItem(
                  value: EventoFiltro.tutti,
                  child: Text('Tutti gli eventi'),
                ),
                DropdownMenuItem(
                  value: EventoFiltro.futuri,
                  child: Text('Eventi futuri'),
                ),
                DropdownMenuItem(
                  value: EventoFiltro.passati,
                  child: Text('Eventi passati'),
                ),
              ],
              onChanged: (filtro) {
                if (filtro != null) {
                  setState(() => filtroCorrente = filtro);
                }
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: eventiFiltrati.length,
              itemBuilder: (context, index) {
                final evento = eventiFiltrati[index];
                final isPassato = evento.isPassato;

                return Opacity(
                  opacity: isPassato ? 0.5 : 1.0,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: isPassato ? Colors.grey[100] : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: Icon(
                              _iconForTipo(evento.tipo),
                              color: isPassato ? Colors.grey : Colors.blueAccent,
                              size: 36,
                            ),
                            title: Text(
                              evento.titolo,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                decoration:
                                    isPassato ? TextDecoration.lineThrough : null,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(evento.descrizione),
                                Text(
                                  '📅 ${evento.data}',
                                  style: const TextStyle(fontSize: 13),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                          if (!isPassato) ...[
                            if (!evento.iscritto)
                              ElevatedButton.icon(
                                onPressed: () {
                                  setState(() => evento.iscritto = true);
                                },
                                icon: const Icon(Icons.how_to_reg_rounded),
                                label: const Text('Iscriviti'),
                              )
                            else if (!evento.confermato)
                              Row(
                                children: [
                                  const Icon(
                                    Icons.check_circle,
                                    color: Colors.green,
                                  ),
                                  const SizedBox(width: 6),
                                  const Text('Iscritto'),
                                  const Spacer(),
                                  OutlinedButton(
                                    onPressed: () =>
                                        _confermaPartecipazione(evento),
                                    child: const Text('Conferma presenza'),
                                  ),
                                ],
                              )
                            else
                              Row(
                                children: const [
                                  Icon(
                                    Icons.verified_rounded,
                                    color: Colors.green,
                                  ),
                                  SizedBox(width: 6),
                                  Text('Presenza confermata'),
                                ],
                              ),
                          ] else
                            const Text(
                              'Evento concluso',
                              style: TextStyle(
                                fontStyle: FontStyle.italic,
                                fontSize: 13,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

enum EventoTipo { lezione, conferenza, workshop, tutorato }

class Evento {
  final String titolo;
  final String descrizione;
  final String data;
  final EventoTipo tipo;
  final String domanda;
  final String rispostaCorretta;
  final bool isPassato;
  bool iscritto;
  bool confermato;

  Evento({
    required this.titolo,
    required this.descrizione,
    required this.data,
    required this.tipo,
    required this.domanda,
    required this.rispostaCorretta,
    this.isPassato = false,
    this.iscritto = false,
    this.confermato = false,
  });
}
