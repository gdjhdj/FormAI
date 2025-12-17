import "package:flutter/material.dart";
import "package:my_flutter_app/main.dart";

class HelpAndSupportScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Help & Support')
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  _buildInfoTile(
                    icon: Icons.phone,
                    title: 'Phone Number:',
                    subtitle: '+1-555-452-7284'
                  
                  ),
                  _buildInfoTile(
                    icon: Icons.email,
                    title: 'Email:',
                    subtitle: 'helpAndSupport@formai.org'
                  )

                ]
              )
            )
          ]
        )
      )
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