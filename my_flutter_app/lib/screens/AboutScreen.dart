import 'package:flutter/material.dart';
import 'package:my_flutter_app/main.dart';

class AboutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
         title: Text('About Us')
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'About FormAI',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold,),
            ),
            SizedBox(height: 20),
            Text('Many individuals, particularly youth, lack access to affordable and safe exercise '
            'guidance due to limited time, resources, and the high cost of personal training. '
            'FormAI is an AI-powered fitness application that analyzes user-submitted workout videos '
            'through the OpenAI API to provide real-time feedback on form, technique, and improvement suggestions. '
            'Built using Flutter, it features secure login, workout tracking, search-enabled exercise lists, and integrated educational links. '
            'By combining accessibility, intelligent form analysis, and an ad-supported free model, the invention empowers users to exercise '
            'safely and effectively, reducing injuries while promoting healthier lifestyles at no cost.',
            style: Theme.of(context).textTheme.bodyMedium,
            ),
            SizedBox(height: 20),
            Text(
              'Our Team',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold,),
            ),
            SizedBox(height: 20),
            Text(
              'FormAI was developed by a small group of two people passionate about fitness and technology. There is no big company behind us, just to young developers trying to make a difference in the world of fitness using modern technology.',
            ),
            SizedBox(height: 10),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(Icons.info_outline),
              title: Text('Version'),
              subtitle: Text('0.0.1'),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(Icons.school_outlined),
              title: Text('Credits'),
              subtitle: Text('Built for education using flutter and python')
            ),
            const Spacer(),
            Center(
              child: Text(
                '© ${DateTime.now().year} FormAI',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey),
              ),
            )
        

          ],
        ),
      ),
    );

  }
}
