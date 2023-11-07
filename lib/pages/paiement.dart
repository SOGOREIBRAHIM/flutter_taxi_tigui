import 'package:flutter/material.dart';

class Paiement extends StatefulWidget {
  const Paiement({super.key});

  @override
  State<Paiement> createState() => _PaiementState();
}

class _PaiementState extends State<Paiement> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Pour supprimer le bouton de retour
        centerTitle: true, // Pour centrer le titre
        backgroundColor: Color(0xFFEDB602),
        elevation: 0,
        title: const Text(
          "Paiement",
          style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image(image: AssetImage("assets/images/oms.png")),
            Padding(
              padding: const EdgeInsets.only(right: 215),
              child: Text(
                "Montant à payer",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: TextFormField(
                decoration: const InputDecoration(
                  suffix: Text("FCFA"),
                  prefixIcon: ImageIcon(
                    AssetImage("assets/images/cash2.png"),
                    color: Color(0xFFEDB602),
                    size: 20,
                  ),
                  border: UnderlineInputBorder(),
                  labelText: 'Montant à payer',
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Color(
                            0xFFEDB602)), // Couleur de la bordure lorsqu'elle est désactivée
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
