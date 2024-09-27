import 'package:flutter/material.dart';
import '../helpers/database_helper.dart';
import 'quiz_screen.dart';

class QuizStartScreen extends StatelessWidget {
  const QuizStartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz'),
      ),
      body: Center(
        child: FutureBuilder<int>(
          future: DatabaseHelper.instance.getTotalSentences(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              int totalQuestions = snapshot.data ?? 0;
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Total Questions: $totalQuestions',
                    style: const TextStyle(fontSize: 24),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    child: const Text('Start Quiz'),
                    onPressed: totalQuestions > 0
                        ? () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    QuizScreen(totalQuestions: totalQuestions),
                              ),
                            );
                          }
                        : null,
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
