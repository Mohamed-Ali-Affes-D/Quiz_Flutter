import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quiz/pages/LeaderboardPage.dart';
import 'package:quiz/pages/ChangePwPage.dart';
import 'package:quiz/pages/VoirScore%20.dart';

class MyDrawer extends StatelessWidget {
  final String displayName;
  final String avatarInitial;
  final String email;

  const MyDrawer({
    Key? key,
    required this.displayName,
    required this.avatarInitial,
    required this.email,
  }) : super(key: key);

  get selectedType => null;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.purple[400]),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white,
                  child: Text(
                    avatarInitial,
                    style: TextStyle(
                        color: Colors.purple[800],
                        fontSize: 24,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  displayName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  email,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          ExpansionTile(
            title: Text('Paramètres'.tr()),
            leading: Icon(Icons.settings), //add icon
            childrenPadding: EdgeInsets.only(left: 60), //children padding
            children: [
              ListTile(
                title: Text('Changer_mot_passe'.tr()),
                 leading: Icon(Icons.password), 
                onTap: () {
                 Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => ChangePwPage()));
                },
              ),

              ListTile(
                title: Text('Choose_Language'.tr()),
                 leading: Icon(Icons.language), 
                onTap: () {
                  //action on press
                },
              ),

              //more child menu
            ],
          ),
        
          
          ListTile(
            leading: Icon(Icons.bar_chart),
            title: Text('Voir_Scores'.tr()),
            onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => VoirScore()));
            },
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Deconnexion'.tr()),
            onTap: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.of(context).pushReplacementNamed('/login');
            },
          ),
        ],
      ),
    );
  }
}
