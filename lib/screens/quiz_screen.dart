import 'package:flutter/material.dart';
import '../models/sentence.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({Key? key}) : super(key: key);

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  final _answerController = TextEditingController();
  Sentence? _currentSentence;
  bool _showResult = false;

  @override
  void initState() {
    super.initState();
    _loadNextSentence();
  }

  void _loadNextSentence() {
    // TODO: Load a random sentence from your database or state management solution
    setState(() {
      _currentSentence = Sentence(
        nativeSentence: "I'll pay for it",
        answer: "C'est moi qui paie",
      );
      _showResult = false;
      _answerController.clear();
    });
  }

  void _checkAnswer() {
    setState(() {
      _showResult = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Text(
            _currentSentence?.nativeSentence ?? '',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          TextField(
            controller: _answerController,
            decoration: InputDecoration(labelText: 'Enter your answer'),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: _checkAnswer,
            child: Text('Check Answer'),
          ),
          if (_showResult) ...[
            SizedBox(height: 20),
            Text(
              'Correct Answer: ${_currentSentence?.answer}',
              style: TextStyle(fontSize: 18, color: Colors.green),
            ),
            SizedBox(height: 10),
            Text(
              'Your Answer: ${_answerController.text}',
              style: TextStyle(fontSize: 18, color: Colors.blue),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _loadNextSentence,
              child: Text('Next Question'),
            ),
          ],
        ],
      ),
    );
  }

  @override
  void dispose() {
    _answerController.dispose();
    super.dispose();
  }
}
