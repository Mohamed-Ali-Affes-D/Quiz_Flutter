import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // Méthode pour se connecter avec email et mot de passe
  Future<void> signInWithEmailAndPassword(String email, String password) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      // Gestion des erreurs FirebaseAuth
      if (e.code == 'user-not-found') {
        throw Exception('Aucun utilisateur trouvé pour cet email.');
      } else if (e.code == 'wrong-password') {
        throw Exception('Mot de passe incorrect pour cet utilisateur.');
      } else {
        throw Exception(e.message ?? 'Une erreur inconnue est survenue.');
      }
    } catch (e) {
      throw Exception('Erreur lors de la connexion : $e');
    }
  }

  // Méthode pour s'inscrire avec email et mot de passe
  Future<void> signUpWithEmailAndPassword(String email, String password) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      // Gestion des erreurs FirebaseAuth
      if (e.code == 'email-already-in-use') {
        throw Exception('L\'email est déjà utilisé.');
      } else if (e.code == 'weak-password') {
        throw Exception('Le mot de passe est trop faible.');
      } else if (e.code == 'invalid-email') {
        throw Exception('L\'adresse email est invalide.');
      } else {
        throw Exception(e.message ?? 'Une erreur inconnue est survenue.');
      }
    } catch (e) {
      throw Exception('Erreur lors de l\'inscription : $e');
    }
  }

  // Méthode pour déconnecter l'utilisateur
  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      throw Exception('Error during sign out: $e');
    }
  }

  // Méthode pour obtenir l'utilisateur actuellement connecté
  User? get currentUser => _firebaseAuth.currentUser;

  // Méthode pour écouter les changements d'état de l'utilisateur (connecté/déconnecté)
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();
}
