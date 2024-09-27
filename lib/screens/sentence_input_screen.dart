import 'package:flutter/material.dart';
import '../models/sentence.dart';
import '../helpers/database_helper.dart';

class SentenceInputScreen extends StatefulWidget {
  const SentenceInputScreen({Key? key}) : super(key: key);

  @override
  _SentenceInputScreenState createState() => _SentenceInputScreenState();
}

class _SentenceInputScreenState extends State<SentenceInputScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nativeController = TextEditingController();
  final _answerController = TextEditingController();

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final sentence = Sentence(
        id: null, // Set id to null for new sentences
        nativeSentence: _nativeController.text,
        answer: _answerController.text,
      );

      await DatabaseHelper.instance.insertSentence(sentence);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Sentence added successfully!')),
      );
      _nativeController.clear();
      _answerController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: _nativeController,
              decoration:
                  InputDecoration(labelText: 'Native Sentence (Question)'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a native sentence';
                }
                return null;
              },
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: _answerController,
              decoration: InputDecoration(labelText: 'Answer'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter an answer';
                }
                return null;
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitForm,
              child: Text('Add Sentence'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nativeController.dispose();
    _answerController.dispose();
    super.dispose();
  }
}
