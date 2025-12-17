import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? _firstName;
  String? _username;
  String? _birthday;
  String? _email;
  @override
  void initState(){
    super.initState();
    _loadProfileData();
  }
  Future<void> _loadProfileData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _firstName = prefs.getString('firstName');
      _username = prefs.getString('username');
      _birthday = prefs.getString('birthday');
      _email = prefs.getString('email');
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Profile'),),
      body: _firstName == null
      ? Center(child: CircularProgressIndicator())
      : SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.blue.shade100,
              child: Icon(
                Icons.person,
                size: 60,
                color: Colors.blue.shade800,
              ),
            ),
            SizedBox(height: 10),
            Text(
                _firstName ?? 'User',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold,),
            ),
            SizedBox(height: 32),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  _buildInfoTile(
                    icon: Icons.person_outline,
                    title: 'Username',
                    subtitle: _username ?? 'Not set',
                  ),
                  Divider(height: 4),
                  _buildInfoTile(
                    icon: Icons.email_outlined,
                    title: 'Email',
                    subtitle: _email ?? 'Not set',
                  ),
                  Divider(height: 4),
                  _buildInfoTile(
                    icon: Icons.cake_outlined,
                    title: 'Birthday',
                    subtitle: _birthday ?? 'Not set',
                  )
                ]
              )





            )
          ],
        ),
      ),





    );



  }
  Widget _buildInfoTile(
    {required IconData icon, 
    required String title,
    required String subtitle}) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue),
      title: Text(title, style: TextStyle(fontWeight: FontWeight.bold),),
      subtitle: Text(subtitle),
    );
    }



}
