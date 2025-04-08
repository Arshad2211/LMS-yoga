import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class FeedbackScreen extends StatefulWidget {
  @override
  _FeedbackScreenState createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final TextEditingController _feedbackController = TextEditingController();
  List<Map<String, String>> feedbackList = [];

  @override
  void initState() {
    super.initState();
    _loadFeedback();
  }

  // ✅ Load Existing Feedback from SharedPreferences
  Future<void> _loadFeedback() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? feedbackData = prefs.getString('feedback');

    if (feedbackData != null) {
      setState(() {
        feedbackList = List<Map<String, String>>.from(json.decode(feedbackData));
      });
    }
  }

  // ✅ Save New Feedback to SharedPreferences
  Future<void> _saveFeedback() async {
    if (_feedbackController.text.trim().isEmpty) {
      _showSnackBar("❌ Feedback cannot be empty!", Colors.red);
      return;
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    
    // ✅ Load existing feedback
    String? feedbackData = prefs.getString('feedback');
    List<Map<String, String>> feedbacks = feedbackData != null
        ? List<Map<String, String>>.from(json.decode(feedbackData))
        : [];

    // ✅ Add new feedback
    feedbacks.add({
      'feedback': _feedbackController.text.trim(),
      'date': DateTime.now().toString().split(' ')[0], // Only date
    });

    await prefs.setString('feedback', json.encode(feedbacks));

    setState(() {
      feedbackList = feedbacks;
      _feedbackController.clear();
    });

    _showSnackBar("✅ Feedback submitted successfully!", Colors.green);
  }

  // ✅ Show Snackbar Messages
  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, textAlign: TextAlign.center),
        backgroundColor: color,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Feedback", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              "We value your feedback!",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green),
            ),
            SizedBox(height: 10),

            // ✅ Feedback Input Field
            TextField(
              controller: _feedbackController,
              decoration: InputDecoration(
                hintText: "Write your feedback...",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                filled: true,
                fillColor: Colors.grey.shade100,
              ),
              maxLines: 3,
            ),
            SizedBox(height: 10),

            // ✅ Submit Button
            ElevatedButton(
              onPressed: _saveFeedback,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: EdgeInsets.symmetric(vertical: 14, horizontal: 50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: Text("Submit Feedback", style: TextStyle(fontSize: 18, color: Colors.white)),
            ),

            SizedBox(height: 20),

            // ✅ Show Previous Feedback
            Text(
              "Previous Feedback:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: feedbackList.length,
                itemBuilder: (context, index) {
                  return Card(
                    color: Colors.grey.shade100,
                    margin: EdgeInsets.symmetric(vertical: 5),
                    child: ListTile(
                      title: Text(feedbackList[index]['feedback']!),
                      subtitle: Text("Date: ${feedbackList[index]['date']}"),
                      leading: Icon(Icons.feedback, color: Colors.green),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
