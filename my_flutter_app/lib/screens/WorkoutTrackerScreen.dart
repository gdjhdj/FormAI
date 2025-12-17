import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class WorkoutTrackerScreen extends StatefulWidget {
  @override
  _WorkoutTrackerScreenState createState() => _WorkoutTrackerScreenState();
}

class _WorkoutTrackerScreenState extends State<WorkoutTrackerScreen> {
  Map<String, double> _personalBests = {};
  final List<String> _exercises = [
    'bench press',
    'Overhead Press',
    'Lying Triceps Extension',
    'Deadlift',
    'Bicep curl',
    'Pushups',
    'Pull Ups',
  ];
  @override
  void initState() {
    super.initState();
    _loadPersonalBests();
  }
  Future<void> _loadPersonalBests() async {
    final prefs = await SharedPreferences.getInstance();
    final String? savedData = prefs.getString('workout_data');  
    if (savedData != null) {
      final Map<String, dynamic> decodedData = json.decode(savedData);
      setState(() {
        _personalBests = decodedData.map((key, value) => MapEntry(key, value.toDouble()));
      });
    }
  }
  Future<void> _savePersonalBests() async {
    final prefs = await SharedPreferences.getInstance();
    final String encodedData = json.encode(_personalBests);
    await prefs.setString('workout_data', encodedData);
  }
  void _updateWeight(String exercise, String newWeight) {
    final double? weight = double.tryParse(newWeight);
    if (weight != null) {
      setState(() {
        _personalBests[exercise] = weight;
      });
      _savePersonalBests();
      Navigator.of(context).pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a valid number')),
      );
    }
  }
  Future <void> _showUpdateDialog(String exercise) async {
    final TextEditingController controller = TextEditingController();
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Update Personal Best for $exercise'),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              labelText: 'Weight (lbs)',
              hintText: 'Enter new personal best',
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: Text('Save'),
              onPressed: () {
                _updateWeight(exercise, controller.text);
              },
            ),
          ],
        );
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tracker'),
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: _exercises.length,
        itemBuilder: (context, index) {
          final exercise = _exercises[index];
          final topWeight = _personalBests[exercise] ?? 0.0;
          return Card(
            margin: EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              title: Text(exercise, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
              subtitle: Text('Top Weight: $topWeight lbs', style: TextStyle(fontSize: 16, color: Colors.grey.shade600),),
              trailing: Icon(Icons.edit, color: Colors.blue),
              onTap: () => _showUpdateDialog(exercise),
            ),
          );
        },
      ),

    );
  }
}