import 'package:flutter/material.dart';
import 'session_data.dart';

class AvatarPage extends StatefulWidget {
  const AvatarPage({super.key});

  @override
  State<AvatarPage> createState() => _AvatarPageState();
}

class _AvatarPageState extends State<AvatarPage> {
  String avatarScelto = SessionData.avatarPath.contains("female")
      ? "female"
      : SessionData.avatarPath.contains("male")
      ? "male"
      : "";

  void _modificaSesso() {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) => AlertDialog(
            title: const Text("Scegli il sesso dell'avatar"),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    setStateDialog(() {
                      avatarScelto = "female";
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: avatarScelto == "female"
                            ? Colors.blue
                            : Colors.transparent,
                        width: 3,
                      ),
                    ),
                    child: const CircleAvatar(
                      backgroundImage: AssetImage(
                        "assets/avatar/avatar_mezzo_female.png",
                      ),
                      radius: 40,
                      backgroundColor: Colors.transparent,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setStateDialog(() {
                      avatarScelto = "male";
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: avatarScelto == "male"
                            ? Colors.blue
                            : Colors.transparent,
                        width: 3,
                      ),
                    ),
                    child: const CircleAvatar(
                      backgroundImage: AssetImage(
                        "assets/avatar/avatar_mezzo_male.png",
                      ),
                      radius: 40,
                      backgroundColor: Colors.transparent,
                    ),
                  ),
                ),
              ],
            ),
            actions: [
              ElevatedButton(
                onPressed: avatarScelto.isNotEmpty
                    ? () {
                        setState(() {
                          SessionData.avatarPath = avatarScelto == "female"
                              ? "assets/avatar/avatar_female.png"
                              : "assets/avatar/avatar_male.png";
                        });
                        Navigator.pop(context);
                      }
                    : null,
                child: const Text("Conferma scelta"),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Personalizza Avatar",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF003366),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Anteprima Avatar",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                if (SessionData.avatarPath.isNotEmpty)
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 12),
                    height: 160,
                    child: Image.asset(
                      SessionData.avatarPath,
                      fit: BoxFit.contain,
                    ),
                  )
                else
                  CircleAvatar(
                    backgroundColor: Colors.blue[100],
                    radius: 80,
                    child: const Icon(
                      Icons.person,
                      size: 48,
                      color: Colors.white,
                    ),
                  ),
                const SizedBox(height: 32),
                const Text(
                  "Personalizza tratti:",
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 16),

                // Pulsanti
                _buildButton("Modifica sesso", _modificaSesso),
                _buildButton(
                  "Modifica carnagione",
                  () => _showSnack("Modifica carnagione"),
                ),
                _buildButton(
                  "Modifica occhi",
                  () => _showSnack("Modifica occhi"),
                ),
                _buildButton(
                  "Modifica capelli",
                  () => _showSnack("Modifica capelli"),
                ),
                _buildButton(
                  "Modifica accessori",
                  () => _showSnack("Modifica accessori"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showSnack(String label) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text("$label in arrivo")));
  }

  Widget _buildButton(String label, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: const Color(0xFF003366),
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          minimumSize: const Size(220, 48),
        ),
        child: Text(label),
      ),
    );
  }
}
