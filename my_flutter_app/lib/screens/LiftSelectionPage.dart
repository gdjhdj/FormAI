import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class LiftSelectionPage extends StatefulWidget {
  @override _LiftSelectionPageState createState() => _LiftSelectionPageState();
}

class _LiftSelectionPageState extends State<LiftSelectionPage> {
  final List<Map<String, dynamic>> _allExercises = [
    {
      'name': 'Bench Press',
      'icon': Icons.fitness_center,
      'description': 'Classic chest exercise',
      'muscles': 'Chest, Triceps, Shoulders',
    },
    {
      'name': 'Overhead Press',
      'icon': Icons.fitness_center,
      'description': 'Shoulder strengthening exercise',
      'muscles': 'Deltoids, Triceps, Trapezius',
    },
    {
      'name': 'Lying Triceps Extension',
      'icon': Icons.fitness_center,
      'description': 'Upper arm exercise',
      'muscles': 'Triceps, Chest',
    },
     {
      'name': 'Deadlift',
      'icon': Icons.fitness_center,
      'description': 'Legs and back exercise',
      'muscles': 'Glutes, Hamstrings, Erector Spinae',
    },
     {
      'name': 'Bicep curl',
      'icon': Icons.fitness_center,
      'description': 'Arm exercise',
      'muscles': 'Biceps',
    },
     {
      'name': 'Pushups',
      'icon': Icons.fitness_center,
      'description': 'Chest exercise',
      'muscles': 'Chest, Triceps, Shoulders',
    },
    {
      'name': 'Pull Ups',
      'icon': Icons.fitness_center,
      'description': 'Back and arms exercise',
      'muscles': 'Biceps, Lats, Forearms',
    },
  ];
  List<Map<String, dynamic>> _filteredExercises = [];
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  @override
  void initState() {
    super.initState();
    _filteredExercises = _allExercises;
    _searchController.addListener(_onSearchChanged);

  }

  Future<void> _launchURL(String exerciseName) async {
    final String encodedExerciseName = Uri.encodeComponent(exerciseName); 
    final Uri url = Uri.parse('https://en.wikipedia.org/wiki/Special:Search?search=$encodedExerciseName');
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not launch $url')),
      );
      print('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _buildAppBarTitle(),
        actions: [
          IconButton(
            icon: Icon(_isSearching? Icons.close : Icons.search),
            onPressed: _toggleSearch,
          ),
        ],
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: _filteredExercises.length,
        itemBuilder: (context, index) {
          final exercise = _filteredExercises[index];
          return Card(
            margin: EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              contentPadding: EdgeInsets.all(16),
              leading: CircleAvatar(
                backgroundColor: Colors.blue.withOpacity(0.1),
                child: Icon(
                  exercise['icon'],
                  color: Colors.blue,
                ),
              ),
              title: Text(
                exercise['name'],
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 8),
                  Text(exercise['description']),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      _buildInfoChip(
                        'Target Muscles',
                        exercise['muscles'],
                      ),
                    ],
                  ),
                ],
              ),
              trailing: Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                _launchURL(exercise['name']);
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoChip(String label, String value) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.fitness_center,
            size: 14,
            color: Colors.blue,
          ),
          SizedBox(width: 4),
          Text(
            value,
            style: TextStyle(
              color: Colors.blue,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
 

  // Whenever the user taps the search field, 
  // Build the appBar method
  Widget _buildAppBarTitle() {
    if (_isSearching) {
      return TextField(
        controller: _searchController,
        autofocus: true,
        decoration: InputDecoration(
          hintText: 'Look for an exercise...',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12),),
        ),
      );
    }
    else {
      return Text('Exercises');
    }
  } 
  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
    });
  }
  void _onSearchFieldChanged(String text) {
    setState(() {
      _isSearching = true;
      _filteredExercises = _allExercises
          .where((exercise) =>
              exercise['name'].toLowerCase().contains(text.toLowerCase()))
          .toList();
    });
  }
  void _onSearchChanged() {
    _onSearchFieldChanged(_searchController.text);
  }

}


