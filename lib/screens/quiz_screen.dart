import 'package:flutter/material.dart';
import '../models/sentence.dart';
import '../helpers/database_helper.dart';

class QuizScreen extends StatefulWidget {
  final int totalQuestions;

  const QuizScreen({Key? key, required this.totalQuestions}) : super(key: key);

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  final _answerController = TextEditingController();
  List<Sentence> _sentences = [];
  int _currentIndex = 0;
  bool _showResult = false;
  int _correctAnswers = 0;

  @override
  void initState() {
    super.initState();
    _loadSentences();
  }

  Future<void> _loadSentences() async {
    final sentences = await DatabaseHelper.instance.getAllSentences();
    sentences.shuffle();
    setState(() {
      _sentences = sentences;
    });
  }

  void _checkAnswer() {
    setState(() {
      _showResult = true;
      if (_answerController.text.trim().toLowerCase() ==
          _sentences[_currentIndex].answer.toLowerCase()) {
        _correctAnswers++;
      }
    });
  }

  void _nextQuestion() {
    if (_currentIndex < _sentences.length - 1) {
      setState(() {
        _currentIndex++;
        _showResult = false;
        _answerController.clear();
      });
    } else {
      _showQuizComplete();
    }
  }

  void _showQuizComplete() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Quiz Complete'),
          content: Text(
              'You got $_correctAnswers out of ${_sentences.length} correct!'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_sentences.isEmpty) {
      return Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(
        title:
            Text('Quiz - Question ${_currentIndex + 1}/${_sentences.length}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              _sentences[_currentIndex].nativeSentence,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _answerController,
              decoration: InputDecoration(labelText: 'Enter your answer'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _showResult ? null : _checkAnswer,
              child: Text('Check Answer'),
            ),
            if (_showResult) ...[
              SizedBox(height: 20),
              Text(
                'Correct Answer: ${_sentences[_currentIndex].answer}',
                style: TextStyle(fontSize: 18, color: Colors.green),
              ),
              SizedBox(height: 10),
              Text(
                'Your Answer: ${_answerController.text}',
                style: TextStyle(fontSize: 18, color: Colors.blue),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _nextQuestion,
                child: Text(_currentIndex < _sentences.length - 1
                    ? 'Next Question'
                    : 'Finish Quiz'),
              ),
            ],
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _answerController.dispose();
    super.dispose();
  }
}
