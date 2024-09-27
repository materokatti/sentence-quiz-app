import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../models/food.dart';
import 'dart:math';

class FoodInputScreen extends StatefulWidget {
  const FoodInputScreen({Key? key}) : super(key: key);

  @override
  _FoodInputScreenState createState() => _FoodInputScreenState();
}

class _FoodInputScreenState extends State<FoodInputScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  Food? _currentFood;
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  String _selectedMealTime = 'Breakfast';

  Future<Food> _getAINutritionInfo(String foodName) async {
    await Future.delayed(Duration(seconds: 1));
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
    return SingleChildScrollView(
      child: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2010, 10, 16),
            lastDay: DateTime.utc(2030, 3, 14),
            focusedDay: _focusedDay,
            calendarFormat: CalendarFormat.week,
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildMealTimeButton('Breakfast'),
                _buildMealTimeButton('Lunch'),
                _buildMealTimeButton('Dinner'),
                _buildMealTimeButton('Snack'),
              ],
            ),
          ),
          Padding(
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
                    Text(
                        '${_selectedDay.toString().split(' ')[0]} $_selectedMealTime Nutrition Info:',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
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
        ],
      ),
    );
  }

  Widget _buildMealTimeButton(String mealTime) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          _selectedMealTime = mealTime;
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor:
            _selectedMealTime == mealTime ? Colors.green : Colors.grey,
      ),
      child: Text(mealTime),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }
}
