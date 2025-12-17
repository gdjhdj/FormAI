import 'package:flutter/material.dart';

class Results extends StatelessWidget {
  final Map<String, dynamic> feedback;

  const Results({Key? key, required this.feedback}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Analysis Results'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildFeedbackSection(
              'Form Feedback',
              feedback['Form Feedback'] ?? {},
              Icons.fitness_center,
            ),
            SizedBox(height: 16),
            _buildFeedbackSection(
              'Suggestions for Improvement',
              feedback['Suggestions for Improvement'] ?? {},
              Icons.lightbulb,
            ),
            SizedBox(height: 16),
            _buildFeedbackSection(
              'Key Angle Ranges',
              feedback['Key Angle Ranges'] ?? {},
              Icons.analytics,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeedbackSection(String title, Map<String, dynamic> data, IconData icon) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.blue),
                SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            ...data.entries.map((entry) => Padding(
              padding: EdgeInsets.only(bottom: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    entry.key.replaceAll('_', ' ').toUpperCase(),
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.blue,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    entry.value.toString(),
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            )).toList(),
          ],
        ),
      ),
    );
  }
}
