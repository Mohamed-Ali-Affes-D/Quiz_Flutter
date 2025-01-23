import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quiz/pages/homePage.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class LeaderboardPage extends StatelessWidget {
  final String selectedCategory;
  final String selectedDifficulty;
  User? currentUser = FirebaseAuth.instance.currentUser;

  LeaderboardPage({required this.selectedCategory, required this.selectedDifficulty});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        
        automaticallyImplyLeading: false,
        title: Text(
          'Leaderboard',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.5,
            color: Colors.white,
            fontFamily: 'Poppins',
          ),
        ),
        backgroundColor: Colors.purple.shade400,
        elevation: 12,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, size: 28),
            onPressed: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => LeaderboardPage(
                  selectedCategory: selectedCategory,
                  selectedDifficulty: selectedDifficulty,
                ),
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.home, size: 28),
            onPressed: () {
              Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => HomePage(
                                    user: currentUser ??
                                        null), // ou rediriger vers une page de connexion
                              ),
              );
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.purple.shade100],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: FutureBuilder(
          future: _getScores(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(
                child: Text(
                  "Error loading scores",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.redAccent,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              );
            }

            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(
                child: Text(
                  "No scores yet",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey.shade600,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              );
            }

            List<String> scores = snapshot.data as List<String>;

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
              child: ListView.builder(
                itemCount: scores.length,
                itemBuilder: (context, index) {
                  String scoreStr = scores[index];
                  int score = 0;
                  String message = 'Unknown';

                  try {
                    score = int.parse(scoreStr.split(': ')[1]);
                  } catch (e) {
                    score = 0;
                  }

                  if (score >= 90) {
                    message = 'Excellent job!';
                  } else if (score >= 70) {
                    message = 'Great effort!';
                  } else if (score >= 50) {
                    message = 'Good try, keep going!';
                  } else {
                    message = 'Better luck next time!';
                  }

                  return Container(
                    margin: EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.4),
                          blurRadius: 12,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ListTile(
                      contentPadding: EdgeInsets.symmetric(vertical: 18, horizontal: 24),
                      leading: CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.purple.shade400,
                        child: Text(
                          (index + 1).toString(),
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                          ),
                        ),
                      ),
                      title: Text(
                        scoreStr,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      subtitle: Text(
                        'Rank #${index + 1} - $message',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black.withOpacity(0.7),
                        ),
                      ),
                      trailing: Icon(
                        Icons.star,
                        color: Colors.amber.shade500,
                        size: 28,
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }

  Future<List<String>> _getScores() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String key = "$selectedCategory-$selectedDifficulty";

    List<String>? scores = prefs.getStringList(key);
    return scores ?? [];
  }
}
