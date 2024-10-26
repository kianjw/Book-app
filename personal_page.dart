import 'package:flutter/material.dart';
import 'dart:async';

// Model classes for user's personal information
class UserInfo {
  final String name;
  final String email;
  final List<String> genres;
  final int booksPerYear;
  final String freeTime;

  UserInfo({
    required this.name,
    required this.email,
    required this.genres,
    required this.booksPerYear,
    required this.freeTime,
  });
}

class PersonalPage extends StatefulWidget {
  final UserInfo userInfo;

  PersonalPage({
    required this.userInfo,
  });

  @override
  _PersonalPageState createState() => _PersonalPageState();
}

class _PersonalPageState extends State<PersonalPage> {
  late Timer _timer; // Declare _timer here

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      // Perform periodic task
    });
  }

  @override
  void dispose() {
    _timer.cancel(); // Cancel timer to prevent memory leaks
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Personal Page'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display personal information
            Text(
              'Personal Information',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12.0),
            _buildInfoItem(Icons.person, 'Name', widget.userInfo.name),
            _buildInfoItem(Icons.email, 'Email', widget.userInfo.email),
            _buildInfoItem(Icons.category, 'Genres', widget.userInfo.genres.join(', ')),
            _buildInfoItem(Icons.book, 'Books per Year', widget.userInfo.booksPerYear.toString()),
            _buildInfoItem(Icons.access_time, 'Free Time to Read', widget.userInfo.freeTime),
            SizedBox(height: 24.0),
            Divider(),
            SizedBox(height: 24.0),
            // Placeholder for Borrowing History
            
            
            
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 24),
        SizedBox(width: 12.0),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 4.0),
            Text(
              value,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPlaceholderText(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        text,
        style: TextStyle(fontSize: 16),
      ),
    );
  }
}
