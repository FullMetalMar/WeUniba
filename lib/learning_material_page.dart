import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';

class LearningMaterialPage extends StatefulWidget {
  const LearningMaterialPage({super.key});

  @override
  State<LearningMaterialPage> createState() => _LearningMaterialPageState();
}

class _LearningMaterialPageState extends State<LearningMaterialPage> {
  final Map<String, Map<String, List<Map<String, String>>>> contenuti = {
    'Prof. Bochicchio': {
      'Programmazione I': [
        {
          'titolo': 'Introduzione al linguaggio C',
          'descrizione': 'Dispensa introduttiva C',
          'asset': 'assets/learning_materials/introduzione_linguaggio_c.pdf',
        },
      ],
      'Programmazione Web': [
        {
          'titolo': 'Introduzione al Web',
          'descrizione': 'Dispensa HTML/CSS base',
          'asset':
              'assets/learning_materials/introduzione_programmazione_web.pdf',
        },
      ],
    },
    'Prof.ssa Rossano': {
      'Progettazione e Produzione Multimediale': [
        {
          'titolo': 'Introduzione a PPM',
          'descrizione': 'Materiale introduttivo al corso',
          'asset': 'assets/learning_materials/introduzione_PPM.pdf',
        },
      ],
    },
  };

  String? selectedDocente;
  String? selectedCorso;

  @override
  Widget build(BuildContext context) {
    List<String> docenti = contenuti.keys.toList();
    List<String> corsi = selectedDocente != null
        ? contenuti[selectedDocente!]!.keys.toList()
        : [];
    List<Map<String, String>> materiali =
        (selectedDocente != null && selectedCorso != null)
        ? contenuti[selectedDocente!]![selectedCorso!]!
        : [];

    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      appBar: AppBar(
        backgroundColor: const Color(0xFF003366),
        centerTitle: true,
        title: const Text(
          'Materiale Didattico',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: selectedDocente,
                  hint: const Text('Seleziona Docente'),
                  isExpanded: true,
                  items: docenti.map((docente) {
                    return DropdownMenuItem(
                      value: docente,
                      child: Text(docente),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedDocente = value;
                      selectedCorso = null;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: selectedCorso,
                  hint: const Text('Seleziona Corso'),
                  isExpanded: true,
                  items: corsi.map((corso) {
                    return DropdownMenuItem(value: corso, child: Text(corso));
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedCorso = value;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: materiali.isEmpty
                  ? const Center(child: Text('Nessun materiale disponibile'))
                  : ListView.builder(
                      itemCount: materiali.length,
                      itemBuilder: (context, index) {
                        final mat = materiali[index];
                        final double progress = 0.4; // Fittizio per ora
                        final int percent = (progress * 100).toInt();

                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ListTile(
                                  title: Text(mat['titolo'] ?? ''),
                                  subtitle: Text(mat['descrizione'] ?? ''),
                                  trailing: const Icon(
                                    Icons.picture_as_pdf,
                                    color: Colors.grey,
                                  ),
                                  enabled: false, // disabilitato
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Expanded(
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: LinearProgressIndicator(
                                          value: progress,
                                          minHeight: 8,
                                          backgroundColor: Colors.grey.shade300,
                                          valueColor:
                                              const AlwaysStoppedAnimation<
                                                Color
                                              >(
                                                Color(
                                                  0xFF4CAF50,
                                                ), // verde progressivo
                                              ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Text(
                                      "$percent%",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF4CAF50),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class PDFAssetViewer extends StatefulWidget {
  final String assetPath;
  const PDFAssetViewer({super.key, required this.assetPath});

  @override
  State<PDFAssetViewer> createState() => _PDFAssetViewerState();
}

class _PDFAssetViewerState extends State<PDFAssetViewer> {
  String? localPath;

  @override
  void initState() {
    super.initState();
    _loadPdfFromAssets();
  }

  Future<void> _loadPdfFromAssets() async {
    final byteData = await rootBundle.load(widget.assetPath);
    final buffer = byteData.buffer;
    final tempDir = await getTemporaryDirectory();
    final file = File("${tempDir.path}/${widget.assetPath.split('/').last}");
    await file.writeAsBytes(
      buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes),
    );
    setState(() {
      localPath = file.path;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("PDF Viewer")),
      body: localPath == null
          ? const Center(child: CircularProgressIndicator())
          : PDFView(
              filePath: localPath!,
              enableSwipe: true,
              swipeHorizontal: false,
              autoSpacing: true,
              pageFling: true,
            ),
    );
  }
}
