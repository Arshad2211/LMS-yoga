import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:yoga/customvideoplayer.dart';

class LessonDetailsScreen extends StatelessWidget {
  final String sessionTitle;
  final List<Map<String, String>> lessons;

  const LessonDetailsScreen({super.key, required this.sessionTitle, required this.lessons});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(sessionTitle), backgroundColor: Colors.green),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: ListView.builder(
          itemCount: lessons.length,
          itemBuilder: (context, index) {
            var lesson = lessons[index];

            return GestureDetector(
             onTap: () {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) =>VideoPlayerScreen (
        url: lesson["videoUrl"]!,
      ),
    ),
  );
},

              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: EdgeInsets.all(15),
                  child: Row(
                    children: [
                      Icon(Icons.play_circle_filled, size: 50, color: Colors.green),
                      SizedBox(width: 20),
                      Expanded(
                        child: Text(
                          lesson["title"]!,
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Icon(Icons.arrow_forward_ios, size: 20, color: Colors.grey),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
