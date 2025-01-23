import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VoirScore extends StatefulWidget {
  @override
  _VoirScoreState createState() => _VoirScoreState();
}

class _VoirScoreState extends State<VoirScore> {
  Map<String, List<String>> scoresByCategory = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadScores();
  }

  Future<void> _loadScores() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys();
    Map<String, List<String>> tempScores = {};

    for (String key in keys) {
      List<String>? scores = prefs.getStringList(key);
      if (scores != null) {
        tempScores[key] = scores;
      }
    }

    setState(() {
      scoresByCategory = tempScores;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true, // Cette ligne est cruciale
      appBar: AppBar(
        title: Text('Voir_Scores'.tr()),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Stack(
        children: [
          // Dégradé en arrière-plan
          Container(
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
          ),
          // Contenu principal
          Column(
            children: [
              Expanded(
                child: isLoading
                    ? Center(child: CircularProgressIndicator())
                    : scoresByCategory.isEmpty
                        ? Center(
                            child: Text(
                              'Aucun score enregistré.',
                              style: TextStyle(fontSize: 18),
                            ),
                          )
                        : ListView.builder(
                            itemCount: scoresByCategory.length,
                            itemBuilder: (context, index) {
                              String category =
                                  scoresByCategory.keys.elementAt(index);
                              List<String> scores = scoresByCategory[category]!;

                              return Card(
                                margin: EdgeInsets.all(8),
                                child: ExpansionTile(
                                  title: Text(
                                    category,
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  children: scores
                                      .map((score) => ListTile(
                                            title: Text(score),
                                          ))
                                      .toList(),
                                ),
                              );
                            },
                          ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
