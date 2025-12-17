import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'Results.dart';

class InfoUpload extends StatefulWidget {
  @override
  _InfoUploadState createState() => _InfoUploadState();
}

class _InfoUploadState extends State<InfoUpload> {
  File? _video;
  final ImagePicker _picker = ImagePicker();
  bool _isUploading = false;
  String? _error;
  String? _selectedExercise;

  final List<String> _exerciseOptions = [
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
    if (_exerciseOptions.isNotEmpty) {
      _selectedExercise = _exerciseOptions[0];
    }
  }

  Future<void> _pickVideo() async {
    final pickedFile = await _picker.pickVideo(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _video = File(pickedFile.path);
        _isUploading = false;
        _error = null;
      });
    }
  }

  Future<void> _uploadVideo() async {
    if (_video == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select a video first')),
      );
      return;
    }

    setState(() {
      _isUploading = true;
      _error = null;
    });

    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('http://192.168.1.205:5001/analyzeWeightLifting'),
      );

      // Add the video file
      request.files.add(
        await http.MultipartFile.fromPath(
          'video',
          _video!.path,
        ),
      );

      // Add exercise type - normalize to lowercase to match database
      request.fields['exercise'] = _selectedExercise!.toLowerCase();

      var response = await request.send();
      var responseData = await response.stream.bytesToString();
      var jsonResponse = json.decode(responseData);

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Video analyzed successfully!')),
        );
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Results(feedback: jsonResponse),
          ),
        );
      } else {
        setState(() {
          _error = jsonResponse['error'] ?? 'Upload failed';
        });
      }
    } catch (e) {
      String errorMessage = 'Failed to upload video: $e';
      
      // Provide more helpful error messages for common issues
      if (e.toString().contains('Connection refused') || 
          e.toString().contains('SocketException')) {
        errorMessage = 'Cannot connect to server. Please ensure:\n'
                      '1. The fitness server is running (check fitness_server/server.py)\n'
                      '2. The server IP address (192.168.1.205:5001) is correct\n'
                      '3. Your device and server are on the same network\n'
                      'Error: $e';
      } else if (e.toString().contains('TimeoutException')) {
        errorMessage = 'Connection timeout. The server may be slow or unreachable.';
      }
      
      setState(() {
        _error = errorMessage;
      });
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Progress'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Icon(
                        Icons.video_library,
                        size: 64,
                        color: Colors.blue,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Upload Your Workout Video',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Share your progress with your trainer',
                        style: TextStyle(
                          color: Colors.grey[600],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 24),
              // Exercise Dropdown
              if (_exerciseOptions.isNotEmpty) ...[
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'Select Exercise',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                    filled: true,
                  ),
                  value: _selectedExercise,
                  items: _exerciseOptions.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value[0].toUpperCase() +
                        value.substring(1)), // Capitalize
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedExercise = newValue;
                    });
                  },
                ),
                SizedBox(height: 20),
              ],
              if (_error != null)
                Card(
                  color: Colors.red[50],
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      _error!,
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ),
              if (_video != null) ...[
                Card(
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
                            Icon(Icons.video_file, color: Colors.blue),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                _video!.path.split('/').last,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.close),
                              onPressed: () {
                                setState(() {
                                  _video = null;
                                  _error = null;
                                });
                              },
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        LinearProgressIndicator(
                          value: _isUploading ? null : 1.0,
                          backgroundColor: Colors.grey[200],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 16),
              ],
              ElevatedButton.icon(
                onPressed: _isUploading ? null : _pickVideo,
                icon: Icon(Icons.add),
                label: Text('Choose Video'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16),
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: _isUploading ? null : _uploadVideo,
                icon: _isUploading
                    ? SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : Icon(Icons.upload),
                label: Text(_isUploading ? 'Uploading...' : 'Upload Video'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: _video != null ? Colors.blue : Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


  
