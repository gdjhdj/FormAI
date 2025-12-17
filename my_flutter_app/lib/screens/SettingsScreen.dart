import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../main.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class SettingsScreen extends StatefulWidget {
    @override
    _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
    bool _notificationsEnabled = false;
    late bool _darkModeEnabled;

    @override
    void initState() {
        super.initState();
        _darkModeEnabled = themeNotifier.value == ThemeMode.dark;
        _loadSettings();
    }
    Future<void> _loadSettings() async{
      final prefs = await SharedPreferences.getInstance();
      setState(() {
        _notificationsEnabled = prefs.getBool('notificationsEnabled') ?? false;
      });

    }
    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(
                title: Text('Settings'),
            ),
            body: ListView(
                children: [
                    SwitchListTile(
                        title: Text('Enable Notifications'),
                        value: _notificationsEnabled,
                        onChanged: (bool value) {
                            setState(() {
                                _notificationsEnabled = value;
                            });
                            _persistNotifications(value);
                        },
                    ),
                    SwitchListTile(
                        title: Text('Dark Mode'),
                        value: _darkModeEnabled,
                        onChanged: (bool value) async{
                            setState(() {
                                _darkModeEnabled = value;
                            });
                            themeNotifier.value = value ? ThemeMode.dark : ThemeMode.light;
                            final prefs = await SharedPreferences.getInstance();
                            await prefs.setBool('isDarkMode', value);
                        },
                    ),
                    Divider(),
                    ListTile(
                        leading: Icon(Icons.person),
                        title: Text('Profile'),
                        onTap: () {
                          Navigator.pushNamed(context, '/profile');
                        },
                    ),
                    ListTile(
                        leading: Icon(Icons.lock),
                        title: Text('Change Password'),
                        onTap: () {
                            Navigator.pushNamed(context, '/change_password');
                        },
                    ),Divider(),
                    ListTile(
                        leading: Icon(Icons.exit_to_app),
                        title: Text('Log Out'),
                        onTap: () async{
                            // Handle logout and navigate to login screen
                            final prefs = await SharedPreferences.getInstance();
                            await prefs.setBool('isLoggedIn', false);
                            Navigator.pushNamedAndRemoveUntil(context, '/login', (Route<dynamic> route) => false);
                        },
                    ),
                    ListTile(
                        leading: Icon(Icons.help),
                        title: Text('Help & Support'),
                        onTap: () {
                        Navigator.pushNamed(context, '/help');
                        },
                    ),
                    ListTile(
                        leading: Icon(Icons.info),
                        title: Text('About'),
                        onTap: () {
                        Navigator.pushNamed(context, '/about');
                        },
                    ),
                ],
            ),
        );
    }

    Future<void> _persistNotifications(bool enabled) async{
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('notificationsEnabled', enabled);
    
    }
}

class NotificationService {
  //#1 Ensure only one manager exists
  //#2 Setup method
  //We are gonna need a function called initialized
  //That function is gonna check if it's ready, it's gonna set an icon, call system plugin to setup the icon,
  //setup is equal to true
  //#3 Actions, show and cancel
  //#4 Clean up
}
