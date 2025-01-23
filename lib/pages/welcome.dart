import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Welcome extends StatelessWidget {
  const Welcome({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            // Le fond avec un dégradé
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.purple[100] ?? Colors.purple, Colors.white],
                ),
              ),
            ),
            // Le contenu principal
            Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Positioned(
                      bottom: 16,
                      left: 0,
                      child: IconButton(
                        icon: Icon(Icons.language, size: 32),
                        onPressed: () {
                          // Affiche un menu avec les langues
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Choose Language').tr(),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    ListTile(
                                      title: Text('English'),
                                      onTap: () {
                                        context.setLocale(
                                            Locale('en')); // Change en anglais
                                        Navigator.of(context)
                                            .pop(); // Ferme le dialogue
                                      },
                                    ),
                                    ListTile(
                                      title: Text('Français'),
                                      onTap: () {
                                        context.setLocale(
                                            Locale('fr')); // Change en français
                                        Navigator.of(context)
                                            .pop(); // Ferme le dialogue
                                      },
                                    ),
                                    ListTile(
                                      title: Text('العربية'),
                                      onTap: () {
                                        context.setLocale(
                                            Locale('ar')); // Change en arabe
                                        Navigator.of(context)
                                            .pop(); // Ferme le dialogue
                                      },
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Bienvenue'.tr(),
                      style: TextStyle(
                        fontSize: 33,
                        fontFamily: "myFont",
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 20),
                    SvgPicture.asset(
                      "assets/icons/chat.svg",
                      width: MediaQuery.of(context).size.width * 0.7,
                      placeholderBuilder: (BuildContext context) =>
                          const CircularProgressIndicator(),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 100),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(266, 50),
                          backgroundColor: Colors.purple[300],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        onPressed: () {
                          Navigator.pushNamed(context, '/login');
                        },
                        child: Text(
                          'login'.tr(),
                          style: TextStyle(
                              fontSize: 22,
                              color: Colors.black,
                              fontFamily: "myFont"),
                        ), // Ajoutez .tr() ici
                      ),
                    ),
                    const SizedBox(height: 15),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 100),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(266, 50),
                          backgroundColor:
                              Colors.purple[100] ?? Colors.purple[50]!,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        onPressed: () {
                          Navigator.pushNamed(context, '/signup');
                        },
                        child: Text(
                          'Signup'.tr(),
                          style: TextStyle(
                              fontSize: 22,
                              color: Colors.black,
                              fontFamily: "myFont"),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
