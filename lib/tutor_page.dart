import 'package:flutter/material.dart';

class TutorPage extends StatefulWidget {
  const TutorPage({super.key});

  @override
  State<TutorPage> createState() => _TutorPageState();
}

class _TutorPageState extends State<TutorPage> {
  String? materiaSelezionata;

  final List<String> materie = [
    'Programmazione I',
    'Progettazione e Produzione Multimediale',
    'Ingegneria del Software',
    'Architettura degli Elaboratori e Sistemi Operativi',
    'Reti di Calcolatori',
  ];

  final Map<String, List<Tutor>> tutorPerMateria = {
    'Programmazione I': [
      Tutor(nome: 'Silvia Rossi', email: 'silvia.rossi@uniba.it'),
      Tutor(nome: 'Marco Lotti', email: 'marco.lotti@uniba.it'),
    ],
    'Progettazione e Produzione Multimediale': [
      Tutor(nome: 'Luigi Conte', email: 'luigi.conte@uniba.it'),
    ],
    'Ingegneria del Software': [
      Tutor(nome: 'Anna Greco', email: 'anna.greco@uniba.it'),
    ],
    'Architettura degli Elaboratori e Sistemi Operativi': [
      Tutor(nome: 'Federico Bianchi', email: 'federico.bianchi@uniba.it'),
    ],
    'Reti di Calcolatori': [
      Tutor(nome: 'Giulia Neri', email: 'giulia.neri@uniba.it'),
    ],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF003366),
        centerTitle: true,
        title: const Text('Tutoraggio', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      backgroundColor: const Color(0xFFF2F2F2),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Seleziona la materia in cui hai bisogno di aiuto:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                isExpanded: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                ),
                value: materiaSelezionata,
                hint: const Text('Scegli una materia'),
                items: materie.map((materia) {
                  return DropdownMenuItem(
                    value: materia,
                    child: Text(materia, overflow: TextOverflow.ellipsis),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    materiaSelezionata = value;
                  });
                },
              ),
              const SizedBox(height: 24),
              if (materiaSelezionata != null &&
                  tutorPerMateria[materiaSelezionata] != null)
                ...tutorPerMateria[materiaSelezionata]!.map((tutor) {
                  return Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      leading: const Icon(
                        Icons.school_rounded,
                        color: Colors.indigo,
                      ),
                      title: Text(tutor.nome),
                      subtitle: Text(tutor.email),
                      trailing: const Icon(Icons.email_rounded),
                      onTap: () {
                        // Futuro: apertura email o chat
                      },
                    ),
                  );
                }),
              if (materiaSelezionata == null)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.only(top: 16),
                    child: Text(
                      'Seleziona una materia per vedere i tutor disponibili.',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class Tutor {
  final String nome;
  final String email;

  const Tutor({required this.nome, required this.email});
}
