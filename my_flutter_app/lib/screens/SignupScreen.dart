import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}


class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController birthdayController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(title: Text("Sign Up")),
        body: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: emailController,
                decoration: InputDecoration(labelText: 'email'),
                keyboardType: TextInputType.emailAddress,
              ),
              TextField(
                controller: usernameController,
                decoration: InputDecoration(labelText: 'username'),
              ),
              TextField(
                controller: passwordController,
                obscureText: _obscurePassword, // Controls visibility
                decoration: InputDecoration(
                  labelText: 'Password',
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                ),
              ),
              TextField(
                controller: firstNameController,
                decoration: InputDecoration(labelText: 'First Name'),
              ),
              TextField(
                controller: birthdayController,
                decoration: InputDecoration(
                  labelText: 'Birthday',
                  hintText: 'YYYY-MM-DD',
                  suffixIcon: IconButton(
                    icon: Icon(Icons.calendar_today),
                    onPressed: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context, 
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1900), 
                        lastDate: DateTime.now(),
                      );
                      if (pickedDate != null) {
                        setState(() {
                          birthdayController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
                        });
                      }
                    },
                  )
                ),
                keyboardType: TextInputType.datetime,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _signup,
                child: Text('Signup'),
              ),
              TextButton(
                onPressed: () => Navigator.pushNamed(context, '/login'),
                child: Text('Already have an account? Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _signup() async {
    if (emailController.text.isEmpty || usernameController.text.isEmpty || passwordController.text.isEmpty || firstNameController.text.isEmpty || birthdayController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }


    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('email', emailController.text);
    await prefs.setString('username', usernameController.text);
    await prefs.setString('password', passwordController.text);
    await prefs.setString('firstName', firstNameController.text);
    await prefs.setString('birthday', birthdayController.text);
    Navigator.pushReplacementNamed(context, '/home');
  }
}