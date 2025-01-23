import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'auth_service.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final AuthService authService = AuthService();

  bool isLoading = false;
  bool isPasswordHidden = true;

  Future<void> loginUser() async {
    if (_formKey.currentState!.validate()) {
      setState(() => isLoading = true);

      final email = emailController.text.trim();
      final password = passwordController.text.trim();

      try {
        await authService.signInWithEmailAndPassword(email, password);
        Navigator.pop(context);
        Navigator.pushReplacementNamed(context, '/home');
      } catch (e) {
        // Show error dialog
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Login Failed"),
            content: Text("An error occurred: ${e.toString()}"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("OK"),
              ),
            ],
          ),
        );
      } finally {
        setState(() => isLoading = false);
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
                      'login'.tr(),
                      style: TextStyle(
                        fontSize: 33,
                        color: Colors.purple[800],
                        fontFamily: "myFont",
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: size.height * 0.02),
                    // Image SVG
                    SvgPicture.asset(
                      "assets/icons/login.svg",
                      width: size.width * 0.6,
                    ),
                    SizedBox(height: size.height * 0.05),
                    // Champ Email
                    buildInputField(
                      controller: emailController,
                      hintText: 'Email'.tr(),
                      icon: Icons.mail_outline,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter your email";
                        } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                            .hasMatch(value)) {
                          return "Enter a valid email address";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: size.height * 0.03),
                    // Champ Mot de passe
                    buildInputField(
                      controller: passwordController,
                      hintText: 'Password'.tr(),
                      icon: Icons.lock_outline,
                      obscureText: isPasswordHidden,
                      suffixIcon: IconButton(
                        icon: Icon(
                          isPasswordHidden
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.purple[800],
                        ),
                        onPressed: () {
                          setState(() => isPasswordHidden = !isPasswordHidden);
                        },
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter your password";
                        } else if (value.length < 6) {
                          return "Password must be at least 6 characters";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: size.height * 0.03),
                    // Bouton Login
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(266, 50),
                        backgroundColor: Colors.purple[300],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      onPressed: isLoading ? null : loginUser,
                      child: isLoading
                          ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : Text(
                              'login'.tr(),
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'myFont',
                              ),
                            ),
                    ),
                   
                    SizedBox(height: size.height * 0.02),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'dont_have_account'.tr(),
                          style: TextStyle(color: Colors.black54, fontSize: 14),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.pushNamed(context, "/signup");
                          },
                          child: Text(
                            'Signup'.tr(),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.purple[800],
                              fontSize: 14,
                              fontFamily: 'myFont',
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

  Widget buildInputField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    bool obscureText = false,
    Widget? suffixIcon,
    required FormFieldValidator<String> validator,
  }) {
    return Container(
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
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          suffixIcon: suffixIcon,
          icon: Icon(icon, color: Colors.purple[300], size: 20),
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.purple[300]),
          border: InputBorder.none,
        ),
        validator: validator,
        style: const TextStyle(color: Colors.black),
      ),
    );
  }
}
