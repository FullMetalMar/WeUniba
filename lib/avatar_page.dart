import 'package:flutter/material.dart';
import 'session_data.dart';

class AvatarPage extends StatefulWidget {
  const AvatarPage({super.key});

  @override
  State<AvatarPage> createState() => _AvatarPageState();
}

class _AvatarPageState extends State<AvatarPage> {
  String avatarScelto = SessionData.avatarPath.contains("_f.")
      ? "female"
      : SessionData.avatarPath.contains("_m.")
      ? "male"
      : "female"; // default

  String carnagioneScelta = SessionData.avatarPath.contains("bla")
      ? "bla"
      : "wh";
  String capelliScelti = SessionData.avatarPath.contains("bio")
      ? "bio"
      : SessionData.avatarPath.contains("ros")
      ? "ros"
      : "bru";

  void _aggiornaAvatar() {
    final folder = carnagioneScelta == "bla" ? "black" : "white";
    final gender = avatarScelto == "male" ? "m" : "f";

    // Verifica se gli occhiali sono equipaggiati
    final occhialiEquipaggiati =
        SessionData.accessorioEquipaggiato ==
        "assets/avatar/accessories/accessorio_occhiali.png";

    if (occhialiEquipaggiati) {
      SessionData.avatarPath =
          "assets/avatar/accessories/avatar_with_occhiali/Avatar_${carnagioneScelta}_${capelliScelti}_${gender}_occhiali.png";
    } else {
      SessionData.avatarPath =
          "assets/avatar/complexion/$folder/Avatar_${carnagioneScelta}_${capelliScelti}_${gender}.png";
    }

    setState(() {}); // Aggiorna l'interfaccia
  }

  void _modificaSesso() {
    String sessoTemp = avatarScelto;
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              insetPadding: const EdgeInsets.symmetric(
                horizontal: 40,
                vertical: 120,
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "Scegli il sesso dell'avatar",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _genderButton(
                          setStateDialog,
                          sessoTemp,
                          "female",
                          "Femmina",
                          (val) => sessoTemp = val,
                        ),
                        _genderButton(
                          setStateDialog,
                          sessoTemp,
                          "male",
                          "Maschio",
                          (val) => sessoTemp = val,
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          setState(() {
                            avatarScelto = sessoTemp;
                          });
                          _aggiornaAvatar();
                          Navigator.pop(context);
                        },
                        child: const Text("Conferma"),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _genderButton(
    void Function(void Function()) setStateDialog,
    String sessoSelezionato,
    String value,
    String label,
    void Function(String) aggiornaTemp,
  ) {
    final isSelected = sessoSelezionato == value;
    return GestureDetector(
      onTap: () => setStateDialog(() => aggiornaTemp(value)),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected ? Colors.blue : Colors.transparent,
                width: 3,
              ),
            ),
            child: CircleAvatar(
              radius: 30,
              backgroundColor: isSelected ? Colors.blue[100] : Colors.grey[200],
              child: Icon(
                value == "male" ? Icons.male : Icons.female,
                color: Colors.black87,
                size: 30,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected ? Colors.blue : Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  void _modificaCarnagione() {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: const Text("Scegli la carnagione"),
              content: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _skinButton(setStateDialog, "bla", const Color(0xFF66320a)),
                  const SizedBox(width: 16),
                  _skinButton(setStateDialog, "wh", const Color(0xFFEAC58E)),
                ],
              ),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    _aggiornaAvatar();
                    Navigator.pop(context);
                  },
                  child: const Text("Conferma"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _skinButton(
    void Function(void Function()) setStateDialog,
    String code,
    Color color,
  ) {
    final isSelected = carnagioneScelta == code;
    return GestureDetector(
      onTap: () => setStateDialog(() => carnagioneScelta = code),
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.grey.shade300,
            width: isSelected ? 4 : 1,
          ),
        ),
      ),
    );
  }

  void _modificaCapelli() {
    String capelliTemp = capelliScelti;
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              insetPadding: const EdgeInsets.symmetric(
                horizontal: 40,
                vertical: 120,
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "Scegli il colore dei capelli",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _hairButton(
                          setStateDialog,
                          capelliTemp,
                          "bru",
                          "Bruno",
                          (val) => capelliTemp = val,
                        ),
                        _hairButton(
                          setStateDialog,
                          capelliTemp,
                          "bio",
                          "Biondo",
                          (val) => capelliTemp = val,
                        ),
                        _hairButton(
                          setStateDialog,
                          capelliTemp,
                          "ros",
                          "Rosso",
                          (val) => capelliTemp = val,
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          setState(() {
                            capelliScelti = capelliTemp;
                          });
                          _aggiornaAvatar();
                          Navigator.pop(context);
                        },
                        child: const Text("Conferma"),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _hairButton(
    void Function(void Function()) setStateDialog,
    String capelliSelezionati,
    String code,
    String label,
    void Function(String) aggiornaTemp,
  ) {
    final isSelected = capelliSelezionati == code;
    return GestureDetector(
      onTap: () => setStateDialog(() => aggiornaTemp(code)),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected ? Colors.blue : Colors.transparent,
                width: 3,
              ),
            ),
            child: CircleAvatar(
              backgroundColor: Colors.brown[300],
              radius: 24,
              child: Text(
                label[0],
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              fontSize: 13,
              color: isSelected ? Colors.blue : Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  void _modificaAccessori() {
    String? accessorioTemp = SessionData.accessorioEquipaggiato;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              insetPadding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 120,
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "Scegli un accessorio",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF003366),
                      ),
                    ),
                    const SizedBox(height: 16),
                    GridView.count(
                      crossAxisCount: 3,
                      shrinkWrap: true,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      physics: const NeverScrollableScrollPhysics(),
                      children: SessionData.accessoriInventario.map((acc) {
                        final isSelected = accessorioTemp == acc['path'];
                        return GestureDetector(
                          onTap: () => setStateDialog(
                            () => accessorioTemp = acc['path']!,
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? Colors.blue[100]
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: isSelected
                                  ? Border.all(color: Colors.blue, width: 3)
                                  : Border.all(color: Colors.transparent),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 4,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.all(8),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Image.asset(
                                    acc['path']!,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  acc['nome']!,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: isSelected
                                        ? FontWeight.bold
                                        : FontWeight.w500,
                                    color: isSelected
                                        ? Colors.blue
                                        : Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: () {
                            setState(() {
                              accessorioTemp = null;
                              SessionData.accessorioEquipaggiato = null;
                              _aggiornaAvatar();
                            });
                            Navigator.pop(context);
                          },
                          child: const Text("Rimuovi accessorio"),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              SessionData.accessorioEquipaggiato =
                                  accessorioTemp;
                              _aggiornaAvatar();
                            });
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  (accessorioTemp?.isNotEmpty ?? false)
                                      ? "Accessorio equipaggiato!"
                                      : "Accessorio rimosso!",
                                ),
                              ),
                            );
                          },
                          child: const Text("Conferma"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
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
                  const CircleAvatar(
                    radius: 80,
                    backgroundColor: Colors.grey,
                    child: Icon(Icons.person, size: 48, color: Colors.white),
                  ),
                const SizedBox(height: 24),
                _buildButton("Modifica sesso", _modificaSesso),
                _buildButton("Modifica carnagione", _modificaCarnagione),
                _buildButton("Modifica capelli", _modificaCapelli),
                _buildButton("Modifica accessori", _modificaAccessori),
              ],
            ),
          ),
        ),
      ),
    );
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
