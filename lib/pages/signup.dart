import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'auth_service.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final AuthService authService = AuthService();
  bool isLoading = false;

  // Méthode pour gérer l'inscription
  Future<void> registerUser() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });

      final email = emailController.text.trim();
      final password = passwordController.text.trim();

      try {
        await authService.signUpWithEmailAndPassword(email, password);

        // Redirige l'utilisateur vers la page de test après une inscription réussie
        Navigator.pop(context);
        Navigator.pushNamed(context, '/home');
      } catch (e) {
        // Affiche une boîte de dialogue avec un message d'erreur
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text("Sign Up Error"),
              content: Text(e.toString()),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("OK"),
                ),
              ],
            );
          },
        );
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // Arrière-plan en dégradé clair
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.purple[100]!, Colors.white],
                ),
              ),
            ),
           
            Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: size.height * 0.03),
                    // Titre
                    Text(
                      'Signup'.tr(),
                      style: TextStyle(
                        fontSize: 33,
                        color: Colors.purple[800],
                        fontFamily: "",
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: size.height * 0.02),
                    // Image SVG
                    SvgPicture.asset(
                      "assets/icons/signup.svg",
                      width: size.width * 0.6,
                    ),
                    SizedBox(height: size.height * 0.05),
                    // Champ Email
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(66),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 1,
                            blurRadius: 4,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      width: 266,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: TextFormField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          suffixIcon: Icon(
                            Icons.mail_outline,
                            color: Colors.purple[300],
                          ),
                          icon: Icon(
                            Icons.person_outline,
                            color: Colors.purple[300],
                            size: 20,
                          ),
                          hintText: 'Email'.tr(),
                          hintStyle: TextStyle(color: Colors.purple[300]),
                          border: InputBorder.none,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter your email";
                          } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                              .hasMatch(value)) {
                            return "Enter a valid email address";
                          }
                          return null;
                        },
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                    SizedBox(height: size.height * 0.03),
                    // Champ Mot de passe
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(66),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 1,
                            blurRadius: 4,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      width: 266,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: TextFormField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          suffixIcon: Icon(
                            Icons.visibility_off_outlined,
                            color: Colors.purple[300],
                          ),
                          icon: Icon(
                            Icons.lock_outline,
                            color: Colors.purple[300],
                            size: 20,
                          ),
                          hintText: 'Password'.tr(),
                          hintStyle: TextStyle(color: Colors.purple[300]),
                          border: InputBorder.none,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter your password";
                          } else if (value.length < 6) {
                            return "Password must be at least 6 characters";
                          }
                          return null;
                        },
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                    SizedBox(height: size.height * 0.03),
                    // Bouton Sign Up
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(266, 50),
                        backgroundColor: Colors.purple[300],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      onPressed: isLoading ? null : registerUser,
                      child: isLoading
                          ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : Text(
                              'Signup'.tr(),
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontFamily: '',
                              ),
                            ),
                    ),
                    SizedBox(height: size.height * 0.02),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'have_account'.tr(),
                          style: TextStyle(color: Colors.black54, fontSize: 14),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, "/login");
                          },
                          child: Text(
                            'login'.tr(),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.purple[800],
                              fontSize: 14,
                              fontFamily: '',
                            ),
                          ),
                        ),
                      ],
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
