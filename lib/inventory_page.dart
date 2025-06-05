import 'package:flutter/material.dart';

class InventoryPage extends StatelessWidget {
  const InventoryPage({super.key});

  void _onBadgeTap(BuildContext context, String title) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Hai selezionato: $title')));
  }

  Widget _buildBadge(BuildContext context, String title) {
    return InkWell(
      onTap: () => _onBadgeTap(context, title),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 16, color: Colors.black87),
            ),
            const SizedBox(height: 6),
            const Divider(height: 1, thickness: 0.5, color: Colors.grey),
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

  Widget _buildLuckyCharmCard(BuildContext context, String imagePath) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (_) => Dialog(
            backgroundColor: Colors.transparent,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: InteractiveViewer(child: Image.asset(imagePath)),
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(right: 16),
        height: 180,
        width: 120,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
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
                  children: [
                    _buildBadge(context, 'Topo da biblioteca'),
                    _buildBadge(context, 'Ancora in vita, a maggio'),
                    _buildBadge(context, 'Master in procrastinazione'),
                    _buildBadge(context, 'Lunedì, bestia nera'),
                  ],
                ),
              ),

              _buildSection(
                'Accessori',
                Container(
                  height: 80,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 6,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Text(
                      'Nessun accessorio disponibile',
                      style: TextStyle(color: Colors.black54),
                    ),
                  ),
                ),
              ),

              _buildSection(
                'Portafortuna',
                Row(
                  children: [
                    _buildLuckyCharmCard(
                      context,
                      'assets/lucky_charms/santino_fake_man.png',
                    ),
                    _buildLuckyCharmCard(
                      context,
                      'assets/lucky_charms/santino_fake_woman.png',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
