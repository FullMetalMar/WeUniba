import 'package:flutter/material.dart';
import 'avatar_page.dart';
import 'session_data.dart';

class AccountPage extends StatefulWidget {
  final String username;

  const AccountPage({super.key, required this.username});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  String avatarScelto = "";
  bool avatarSelezionato = false;

  @override
  void initState() {
    super.initState();

    if (!SessionData.isAvatarPopupShown) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _mostraPopupSceltaAvatar();
        SessionData.isAvatarPopupShown = true;
      });
    }
  }

  void _mostraPopupSceltaAvatar() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: const Text(
              "Scegli il tuo avatar",
              style: TextStyle(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text("Tocca un avatar per selezionarlo"),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildAvatarOption("female", setStateDialog),
                    _buildAvatarOption("male", setStateDialog),
                  ],
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  avatarSelezionato = true;
                  Navigator.pop(context);
                },
                child: const Text("Non ora"),
              ),
              ElevatedButton(
                onPressed: avatarScelto.isNotEmpty
                    ? () {
                        setState(() {
                          SessionData.avatarPath = avatarScelto == "female"
                              ? "assets/avatar/avatar_female.png"
                              : "assets/avatar/avatar_male.png";
                          avatarSelezionato = true;
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

  Widget _buildAvatarOption(
    String gender,
    void Function(void Function()) setStateDialog,
  ) {
    return GestureDetector(
      onTap: () {
        setStateDialog(() {
          avatarScelto = gender;
        });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: avatarScelto == gender ? Colors.blue : Colors.transparent,
            width: 3,
          ),
        ),
        child: CircleAvatar(
          backgroundImage: AssetImage("assets/avatar/avatar_mezzo_$gender.png"),
          radius: 50,
          backgroundColor: Colors.transparent,
        ),
      ),
    );
  }

  void _modificaNome() async {
    final controller = TextEditingController(text: SessionData.nome);
    final nuovoNome = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Modifica Nome"),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: "Inserisci nuovo nome"),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Annulla"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, controller.text),
            child: const Text("Salva"),
          ),
        ],
      ),
    );

    if (nuovoNome != null && nuovoNome.isNotEmpty) {
      setState(() {
        SessionData.nome = nuovoNome;
      });
    }
  }

  void _modificaBadge() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 16,
              runSpacing: 16,
              children: SessionData.badgeInventario.map((badge) {
                return GestureDetector(
                  onTap: () =>
                      _selezionaBadge(badge["titolo"]!, badge["path"]!),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(badge["path"]!, height: 64),
                      const SizedBox(height: 4),
                      Text(badge["titolo"]!),
                    ],
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () {
                setState(() {
                  SessionData.badgePath = "";
                  SessionData.titolo = "";
                });
                Navigator.pop(context);
              },
              child: const Text("Rimuovi badge"),
            ),
          ],
        ),
      ),
    );
  }

  void _cambiaPortafortuna() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 16,
              runSpacing: 16,
              children: [
                _buildPortafortunaItem(
                  "assets/lucky_charms/santino_prof_mare.png",
                  "Mare",
                ),
                _buildPortafortunaItem(
                  "assets/lucky_charms/santino_prof_cyberpunk.png",
                  "Cyberpunk",
                ),
                _buildPortafortunaItem(
                  "assets/lucky_charms/santino_prof_agraria.png",
                  "Agraria",
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () {
                setState(() {
                  SessionData.portafortunaPath = "";
                });
                Navigator.pop(context);
              },
              child: const Text("Rimuovi portafortuna"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPortafortunaItem(String path, String title) {
    return GestureDetector(
      onTap: () => _selezionaPortafortuna(path),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(path, height: 100),
          const SizedBox(height: 4),
          Text(title),
        ],
      ),
    );
  }

  void _selezionaBadge(String titolo, String path) {
    setState(() {
      SessionData.titolo = titolo;
      SessionData.badgePath = path;
    });
    Navigator.pop(context);
  }

  void _selezionaPortafortuna(String path) {
    setState(() {
      SessionData.portafortunaPath = path;
    });
    Navigator.pop(context);
  }

  void _vaiAAvatarPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AvatarPage()),
    ).then((_) => setState(() {}));
  }

  Widget _buildBadgeCard() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: Image.asset(SessionData.badgePath, height: 100),
    );
  }

  Widget _buildPortafortunaCard() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: Image.asset(SessionData.portafortunaPath, height: 100),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      appBar: AppBar(
        backgroundColor: const Color(0xFF003366),
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text("Utente", style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              SessionData.nome.isNotEmpty
                  ? SessionData.nome
                  : "Nome non impostato",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            Text(widget.username, style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 12),
            if (SessionData.avatarPath.isNotEmpty)
              Container(
                margin: const EdgeInsets.symmetric(vertical: 12),
                height: 160,
                child: Image.asset(SessionData.avatarPath, fit: BoxFit.contain),
              ),
            if (SessionData.badgePath.isNotEmpty &&
                SessionData.portafortunaPath.isNotEmpty)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(child: _buildBadgeCard()),
                  const SizedBox(width: 16),
                  Expanded(child: _buildPortafortunaCard()),
                ],
              )
            else if (SessionData.badgePath.isNotEmpty)
              _buildBadgeCard()
            else if (SessionData.portafortunaPath.isNotEmpty)
              _buildPortafortunaCard()
            else
              const Text("Nessun badge o portafortuna impostato"),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _modificaNome,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
              ),
              child: const Text("Modifica nome"),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _vaiAAvatarPage,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
              ),
              child: const Text("Modifica avatar"),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _modificaBadge,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
              ),
              child: const Text("Modifica badge"),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _cambiaPortafortuna,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
              ),
              child: const Text("Modifica portafortuna"),
            ),
          ],
        ),
      ),
    );
  }
}
