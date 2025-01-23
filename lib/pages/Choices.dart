import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:quiz/pages/QuizPage.dart';
class ChoicesPage extends StatefulWidget {
  @override
  _ChoicesScreenState createState() => _ChoicesScreenState();
}

class _ChoicesScreenState extends State<ChoicesPage> {
  final TextEditingController _questionController = TextEditingController();
  List<Map<String, dynamic>> _categories = [];
  List<String> _difficulties = ['easy', 'medium', 'hard'];
  List<String> _types = ['multiple', 'boolean'];
  String? _selectedCategory;
  String? _selectedDifficulty;
  String? _selectedType;

  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

  Future<void> _fetchCategories() async {
    try {
      final response = await http.get(Uri.parse('https://opentdb.com/api_category.php'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _categories = (data['trivia_categories'] as List)
              .map((category) => {
                    'id': category['id'],
                    'name': category['name'],
                  })
              .toList();
        });
      } else {
        _showError('Failed to load categories');
      }
    } catch (e) {
      _showError('An error occurred while loading categories');
    }
  }

  void _showError(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> _startQuiz() async {
    if (_questionController.text.isNotEmpty &&
        _selectedCategory != null &&
        _selectedDifficulty != null &&
        _selectedType != null) {
      final url =
          'https://opentdb.com/api.php?amount=${_questionController.text}&category=$_selectedCategory&difficulty=$_selectedDifficulty&type=$_selectedType';

      try {
        final response = await http.get(Uri.parse(url));
        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          final questions = data['results'] as List;

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => QuizPage(
                questions: questions,
                selectedType: _selectedType,
              ),
            ),
          );
        } else {
          _showError('Failed to load questions');
        }
      } catch (e) {
        _showError('An error occurred while loading questions');
      }
    } else {
      _showError('Please fill in all fields');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
                  leading: IconButton(
    onPressed: () {
          Navigator.pop(context);
        Navigator.pushReplacementNamed(context, '/home');
      
    }, // Handle your on tap here.
    icon: Icon(Icons.arrow_back_ios),
  ),
         title:  Text('paramétrer_question'.tr(),
            style: TextStyle(fontWeight: FontWeight.bold , color: Colors.white)),
        backgroundColor: Colors.purple.shade300,
        
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.purple[100] ?? Colors.purple, Colors.white],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextField(
                    controller: _questionController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Enter number of questions',
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.8),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'Select Category:',
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.8),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    value: _selectedCategory != null
                        ? _categories.firstWhere((category) =>
                            category['id'].toString() == _selectedCategory)['name']
                        : null,
                    onChanged: (value) {
                      setState(() {
                        _selectedCategory = _categories
                            .firstWhere((category) => category['name'] == value)['id']
                            .toString();
                      });
                    },
                    items: _categories
                        .map((category) => DropdownMenuItem<String>(
                              value: category['name'],
                              child: Text(category['name']),
                            ))
                        .toList(),
                  ),
                  SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'Select Difficulty:',
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.8),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    value: _selectedDifficulty,
                    onChanged: (value) {
                      setState(() {
                        _selectedDifficulty = value;
                      });
                    },
                    items: _difficulties
                        .map((difficulty) => DropdownMenuItem<String>(
                              value: difficulty,
                              child: Text(difficulty),
                            ))
                        .toList(),
                  ),
                  SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'Select Type:',
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.8),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    value: _selectedType,
                    onChanged: (value) {
                      setState(() {
                        _selectedType = value;
                      });
                    },
                    items: _types
                        .map((type) => DropdownMenuItem<String>(
                              value: type,
                              child: Text(type),
                            ))
                        .toList(),
                  ),
                  SizedBox(height: 20),
ElevatedButton.icon(
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
                  onPressed: 
                    _startQuiz
                  ,
                  label: Text('play_quiz'.tr()),
                ),




                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
