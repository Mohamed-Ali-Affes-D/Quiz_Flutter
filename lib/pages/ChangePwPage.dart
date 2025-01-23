import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:quiz/pages/homePage.dart';

class ChangePwPage extends StatefulWidget {
  @override
  _ChangePwPageState createState() => _ChangePwPageState();
}

class _ChangePwPageState extends State<ChangePwPage> {
  final _newPasswordController = TextEditingController();
  final _oldPasswordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? currentUser = FirebaseAuth.instance.currentUser;
  // Fonction pour changer le mot de passe
  Future<void> _changePassword() async {
    User? user = _auth.currentUser;

    if (user != null) {
      try {
        // Vérifier l'ancien mot de passe
        final credential = EmailAuthProvider.credential(
          email: user.email!,
          password: _oldPasswordController.text,
        );

        // Réauthentification
        await user.reauthenticateWithCredential(credential);

        // Mise à jour du mot de passe
        await user.updatePassword(_newPasswordController.text);

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('password_changed_successfully'.tr()),
        ));
      } on FirebaseAuthException catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Erreur: ${e.message}'.tr()),
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
           
      
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.purple[100] ?? Colors.purple,
              Colors.white,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // AppBar avec transparence
              AppBar(
                leading: IconButton(
    onPressed: () {
          Navigator.pop(context);
        Navigator.pushReplacementNamed(context, '/home');
      
    }, // Handle your on tap here.
    icon: Icon(Icons.arrow_back_ios),
  ),
                backgroundColor: Colors.transparent,
                elevation: 0,
                title: Text("Changer_mot_passe".tr()),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        controller: _oldPasswordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'Ancienmotdepasse'.tr(),
                        ),
                      ),
                      SizedBox(height: 10),
                      TextField(
                        controller: _newPasswordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'Nouveaumotdepasse'.tr(),
                        ),
                      ),
                      SizedBox(height: 20),
                      Center(
                        child: ElevatedButton(
                          onPressed: () async {
                            await _changePassword;
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => HomePage(
                                    user: currentUser ??
                                        null), // ou rediriger vers une page de connexion
                              ),
                            );
                          },
                          child: Text('Changerlemotdepasse'.tr()),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
