import 'package:flutter/material.dart';
import 'session_data.dart';

class InventoryPage extends StatelessWidget {
  const InventoryPage({super.key});

  void _showEquipDialog(BuildContext context, String title, String imagePath) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        contentPadding: const EdgeInsets.all(20),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(imagePath, height: 100),
            const SizedBox(height: 16),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF003366),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                SessionData.badgePath = imagePath;
                SessionData.titolo = title;
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

  Widget _buildSection(String title, Widget content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        content,
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildBadgeRow(BuildContext context, String title, String imagePath) {
    return GestureDetector(
      onTap: () => _showEquipDialog(context, title, imagePath),
      child: Row(
        children: [
          Container(
            margin: const EdgeInsets.only(right: 12),
            height: 64,
            width: 64,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.white,
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Image.asset(imagePath, fit: BoxFit.contain),
            ),
          ),
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildAccessoryImage(
    BuildContext context,
    String imagePath,
    String title,
  ) {
    return GestureDetector(
      onTap: () => _showEquipDialog(context, title, imagePath),
      child: Container(
        margin: const EdgeInsets.only(right: 12),
        height: 64,
        width: 64,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Image.asset(imagePath, fit: BoxFit.contain),
        ),
      ),
    );
  }

  Widget _buildLuckyCharmCard(
    BuildContext context,
    String imagePath,
    String title,
  ) {
    return GestureDetector(
      onTap: () => _showEquipDialog(context, title, imagePath),
      child: Container(
        margin: const EdgeInsets.only(right: 16),
        height: 180,
        width: 120,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.asset(imagePath, fit: BoxFit.cover),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: SessionData.badgeInventario.map((badge) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _buildBadgeRow(
                        context,
                        badge['titolo']!,
                        badge['path']!,
                      ),
                    );
                  }).toList(),
                ),
              ),
              _buildSection(
                'Accessori',
                SizedBox(
                  height: 80,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: SessionData.accessoriInventario.map((accessorio) {
                      return _buildAccessoryImage(
                        context,
                        accessorio['path']!,
                        accessorio['nome']!,
                      );
                    }).toList(),
                  ),
                ),
              ),
              _buildSection(
                'Portafortuna',
                Row(
                  children: SessionData.portafortunaInventario.map((
                    portafortuna,
                  ) {
                    return _buildLuckyCharmCard(
                      context,
                      portafortuna['path']!,
                      portafortuna['nome']!,
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
