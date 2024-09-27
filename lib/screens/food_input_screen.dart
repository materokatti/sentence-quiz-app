// lib/screens/food_input_screen.dart
import 'package:flutter/material.dart';
import '../models/food.dart';
import 'dart:math'; // 임시로 랜덤 값 생성에 사용

class FoodInputScreen extends StatefulWidget {
  const FoodInputScreen({Key? key}) : super(key: key);

  @override
  _FoodInputScreenState createState() => _FoodInputScreenState();
}

class _FoodInputScreenState extends State<FoodInputScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  Food? _currentFood;

  // AI 서비스를 시뮬레이션하는 함수
  Future<Food> _getAINutritionInfo(String foodName) async {
    // 실제로는 여기서 AI 서비스 API를 호출합니다.
    // 이 예제에서는 임의의 값을 생성합니다.
    await Future.delayed(Duration(seconds: 1)); // API 호출을 시뮬레이션
    return Food(
      name: foodName,
      calories: Random().nextInt(500) + 50,
      protein: double.parse((Random().nextDouble() * 30).toStringAsFixed(1)),
      carbs: double.parse((Random().nextDouble() * 50).toStringAsFixed(1)),
      fat: double.parse((Random().nextDouble() * 20).toStringAsFixed(1)),
    );
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final foodName = _nameController.text;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Analyzing $foodName...')),
      );

      final food = await _getAINutritionInfo(foodName);
      setState(() {
        _currentFood = food;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Food Input'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Food Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a food name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Analyze Food'),
              ),
              SizedBox(height: 20),
              if (_currentFood != null) ...[
                Text('Nutrition Information:',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(height: 10),
                Text('Calories: ${_currentFood!.calories} kcal'),
                Text('Protein: ${_currentFood!.protein}g'),
                Text('Carbs: ${_currentFood!.carbs}g'),
                Text('Fat: ${_currentFood!.fat}g'),
              ],
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }
}
