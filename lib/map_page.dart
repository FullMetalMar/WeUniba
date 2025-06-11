import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  @override
  void initState() {
    super.initState();
    // Blocca in portrait
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
  }

  @override
  void dispose() {
    // Ripristina orientamenti consentiti globalmente
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
        return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
appBar: AppBar(
  title: const Text('Mappa', style: TextStyle(color: Colors.white)),
  backgroundColor: const Color(0xFF003366),
  centerTitle: true,
  iconTheme: const IconThemeData(color: Colors.white),
  actions: [
    IconButton(
      icon: Icon(Icons.info_outline),
      onPressed: () {
        _showLegendDialog(context);
      },
    ),
  ],
),

      body: Center(
        child: SizedBox(
          width: 400,
          height: 400,
          child: Stack(
            children: [
              // Mappa come sfondo
              Positioned.fill(
                child: Image.asset('assets/map/campus_map.png'),
              ),

              //fontane
              Positioned(
                top: 172,
                left: 140,
                child: _buildMarker2(context, 'Fontane, spazio ricreativo', 'Sempre aperto ;)',
                icon: Icons.water_drop_outlined,),
              ),

              //informatica
              Positioned(
                top: 155,
                left: 237,
                child: _buildMarker2(context, 'Dipartimento di Informatica', 'Direttore: Filippo Lanubile',
                icon: Icons.memory_sharp,),
              ),

              //segreteria
              Positioned(
                top: 115,
                left: 240,
                child: _buildMarker(context, 'Segreteria degli studenti', 'Aperto: 9.00-13.00',),
              ),

               //palazzo delle aule
              Positioned(
                top: 186,
                left: 240,
                child: _buildMarker2(context, 'Palazzo delle aule', 'Lezioni 8.30-17.00',
                icon: Icons.apartment_rounded,),
              ),

              //farmacia
              Positioned(
                top: 236,
                left: 250,
                child: _buildMarker2(context, 'Dipartimento di Farmacia', 'Direttore: Francesco Leonetti',
                icon: Icons.medication_liquid,),
              ),

              //agraria
              Positioned(
                top: 100,
                left: 290,
                child: _buildMarker2(context, 'Dipartimento di Scienze Agro Ambientali e Territoriali, Giardini, Serre', 'Direttore: Giovanni Sanesi',
                icon: Icons.park_rounded,),
              ),

              //matematica
              Positioned(
                top: 220,
                left: 168,
                child: _buildMarker2(context, 'Dipartimento di Matematica', 'Direttrice: Anna Maria Candela',
                icon: Icons.calculate_outlined,),
              ),

              //geologia
              Positioned(
                top: 140,
                left: 175,
                child: _buildMarker2(context, 'Dipartimento di Scienze della Terra e Geoambientali', 'Direttore: Antonio Mastronuzzi',
                icon: Icons.terrain,),
              ),

              //INGRESSO VIA ORABONA
              Positioned(
                top: 264,
                left: 131,
                child: _buildMarker1(context, 'Ingresso Principale', 'Accesso di Via Orabona',
                icon: Icons.arrow_upward_rounded,),
              ),

              //fisica
              Positioned(
                top: 310,
                left: 330,
                child: _buildMarker2(context, 'Dipartimento di Fisica', 'Direttore: Roberto Bellotti',
                icon: Icons.lightbulb_sharp,),
              ),

              //chimica
              Positioned(
                top: 240,
                left: 320,
                child: _buildMarker2(context, 'Dipartimento di Chimica', 'Direttore: Gerardo Palazzo',
                icon: Icons.science,),
              ),

              //INGRESSO VIA AMENDOLA
              Positioned(
                top: 41,
                left: 345,
                child: _buildMarker1(context, 'Ingresso Alloggi Adisu', 'Accesso di Via Amendola',
                icon: Icons.arrow_back_rounded,),
              ),

              //mensa
              Positioned(
                top: 10,
                left: 313,
                child: _buildMarker2(context, 'Mensa Adisu', 'Pranzo: 12.30-14.30, Cena: 19.30-21.30',
                icon: Icons.restaurant,),
              ),

              //INGRESSO VIA RE DAVID
              Positioned(
                top: 87,
                left: -10,
                child: _buildMarker1(context, 'Ingresso Politecnico', 'Accesso di Via Re David',
                icon: Icons.arrow_forward_rounded,)
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMarker(BuildContext context, String title, String description) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text(title),
            content: Text(description),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text("Chiudi"),
              ),
            ],
          ),
        );
      },
      child: Icon(Icons.location_on, size: 28, color: Colors.red),
    );
  }
}

Widget _buildMarker1(BuildContext context, String title, String description, {IconData icon = Icons.location_on}) {
  return GestureDetector(
    onTap: () {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text(title),
          content: Text(description),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Chiudi"),
            ),
          ],
        ),
      );
    },
    child: Icon(icon, size: 46, color: Colors.deepOrange),
  );
}


Widget _buildMarker2(BuildContext context, String title, String description, {IconData icon = Icons.location_on}) {
  return GestureDetector(
    onTap: () {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text(title),
          content: Text(description),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Chiudi"),
            ),
          ],
        ),
      );
    },
    child: Icon(icon, size: 30, color: Colors.blue[900]),
  );
}

Widget _legendItem(IconData icon, String label) {
  return Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(icon, size: 18, color: Color(0xFF003366)),
      const SizedBox(width: 4),
      Text(label, style: TextStyle(fontSize: 13)),
    ],
  );
}

void _showLegendDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Legenda'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Clicca le icone sulla mappa per ricevere più informazioni.'),
              Text(''),
              _legendItem(Icons.memory_sharp, "Dipartimento di Informatica"),
              _legendItem(Icons.calculate_outlined, "Dipartimento di Matematica"),
              _legendItem(Icons.science, "Dipartimento di Chimica"),
              _legendItem(Icons.lightbulb_sharp, "Dipartimento di Fisica"),
              _legendItem(Icons.park_rounded, "Dipartimento di Agraria"),
              _legendItem(Icons.terrain, "Dipartimento di Scienze Geo-Ambientali"),
              _legendItem(Icons.medication_liquid, "Dipartimento di Farmacia"),
              _legendItem(Icons.restaurant, "Mensa"),
              _legendItem(Icons.water_drop_outlined, "Fontane"),
              _legendItem(Icons.arrow_upward, "Ingressi al campus"),
              ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Chiudi'),
          ),
        ],
      );
    },
  );
}