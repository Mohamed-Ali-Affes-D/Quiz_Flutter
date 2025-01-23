import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:quiz/pages/drawer.widget.dart';
import 'package:flutter_svg/flutter_svg.dart'; // Import flutter_svg package

class HomePage extends StatelessWidget {
  final User? user;

  const HomePage({Key? key, required this.user}) : super(key: key);

  String formatName(String email) {
    final String namePart = email.split('@').first;
    final List<String> nameWords = namePart.split('.');
    return nameWords
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .join(' ');
  }

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Utilisateur non connecté.',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushReplacementNamed('/login');
                },
                child: const Text('Retour à la page de connexion'),
              ),
            ],
          ),
        ),
      );
    }

    final String displayName =
        user?.displayName ?? formatName(user?.email ?? 'User');
    final String avatarInitial =
        displayName.isNotEmpty ? displayName[0].toUpperCase() : '?';
    final String email = user?.email ?? '';

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text('${'Bienvenue'.tr()}, $displayName!'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          CircleAvatar(
            backgroundColor: Colors.purple[300],
            child: Text(
              avatarInitial,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 10),
        ],
      ),
      drawer: MyDrawer(
        displayName: displayName,
        avatarInitial: avatarInitial,
        email: email,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.purple[100]!,
              Colors.white,
            ],
          ),
        ),
        child: Stack(
          children: [
            // SVG Image centered on the page
            Align(
              alignment: Alignment.center,
              child: SvgPicture.asset(
                'assets/images/home.svg',
                height: MediaQuery.of(context).size.height * 0.6,
                width: MediaQuery.of(context).size.width * 0.7,
                fit: BoxFit.contain,
                color: Colors.purple.shade400, // Applique la couleur rouge
              ),
            ),
            // Button at the bottom of the page
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 40.0),
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width * 0.2,
                        vertical: 10),
                    backgroundColor: Colors.purple.shade400,
                    foregroundColor: Colors.white,
                    textStyle: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    elevation: 10,
                  ),
                  icon: const Icon(Icons.play_arrow, size: 28),
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/choices');
                  },
                  label: Text('play_quiz'.tr()),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
