import 'package:flutter/material.dart';
import 'session_data.dart';

class InventoryPage extends StatelessWidget {
  const InventoryPage({super.key});

  void _showEquipDialog(
    BuildContext context,
    String title,
    String imagePath,
    String tipo,
  ) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        contentPadding: const EdgeInsets.all(24),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.grey[100],
              ),
              child: Image.asset(imagePath, height: 180, fit: BoxFit.contain),
            ),
            const SizedBox(height: 20),
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF003366),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF003366),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                minimumSize: const Size(double.infinity, 48),
              ),
              onPressed: () {
                switch (tipo) {
                  case "badge":
                    SessionData.badgePath = imagePath;
                    SessionData.titolo = title;
                    break;
                  case "portafortuna":
                    SessionData.portafortunaPath = imagePath;
                    break;
                }
                Navigator.pop(context);
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text('$title equipaggiato!')));
              },
              child: const Text('Equipaggia'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Column(children: items),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildItemRow(
    BuildContext context,
    String title,
    String imagePath,
    String tipo,
  ) {
    return GestureDetector(
      onTap: () => _showEquipDialog(context, title, imagePath, tipo),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              margin: const EdgeInsets.only(right: 12),
              height: 64,
              width: 64,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Image.asset(imagePath, fit: BoxFit.contain),
            ),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Filtra solo i 3 portafortuna ammessi
    final validCharms = SessionData.portafortunaInventario.where((charm) {
      final path = charm['path'] ?? '';
      return path.contains("santino_prof_mare") ||
          path.contains("santino_prof_cyberpunk") ||
          path.contains("santino_prof_agraria");
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      appBar: AppBar(
        backgroundColor: const Color(0xFF003366),
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text('Inventario', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        elevation: 2,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Il tuo Inventario',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF003366),
                ),
              ),
              const SizedBox(height: 24),

              _buildSection(
                'Badge',
                SessionData.badgeInventario.map((badge) {
                  return _buildItemRow(
                    context,
                    badge['titolo']!,
                    badge['path']!,
                    "badge",
                  );
                }).toList(),
              ),

              _buildSection(
                'Accessori',
                SessionData.accessoriInventario.map((accessorio) {
                  return _buildItemRow(
                    context,
                    accessorio['nome']!,
                    accessorio['path']!,
                    "accessorio",
                  );
                }).toList(),
              ),

              _buildSection(
                'Portafortuna',
                validCharms.map((charm) {
                  return _buildItemRow(
                    context,
                    charm['nome']!,
                    charm['path']!,
                    "portafortuna",
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
