import 'package:flutter/material.dart';
import 'package:yoga/lessondetails.dart';

class LessonsScreen extends StatelessWidget {
   LessonsScreen({super.key});

  final List<Map<String, dynamic>> yogaSessions = [
    {
      "sessionTitle": "Bikram Yoga",
      "image": "assets/bikram_yoga_lesson_card-removebg-preview.png",
      "lessons": [
        {"title": "Breathing Control", "videoUrl": "https://youtu.be/ICK0vEixWvE?si=vUMzFgGW35eT5FaC"},
        {"title": "Posture Alignment", "videoUrl": "https://youtu.be/lP_urJDz9Ro?si=8JXE_g_9AKYYSZS0"},
      ],
    },
    {
      "sessionTitle": "Hatha Yoga",
      "image": "assets/hatha_yoga_pose_3-removebg-preview.png",
      "lessons": [
        {"title": "Gentle Warm-up", "videoUrl": "https://www.youtube.com/watch?v=zzzz"},
        {"title": "Balance Techniques", "videoUrl": "https://www.youtube.com/watch?v=aaaa"},
      ],
    },
    {
      "sessionTitle": "Kundalini Yoga",
      "image": "assets/kundalini_yoga_pose__2_-removebg-preview.png",
      "lessons": [
        {"title": "Energy Awakening", "videoUrl": "https://www.youtube.com/watch?v=bbbb"},
        {"title": "Chakra Meditation", "videoUrl": "https://www.youtube.com/watch?v=cccc"},
      ],
    },
    {
      "sessionTitle": "Vinyasa Yoga",
      "image": "assets/vinyasa_yoga_pose-removebg-preview.png",
      "lessons": [
        {"title": "Fluid Movements", "videoUrl": "https://www.youtube.com/watch?v=dddd"},
        {"title": "Power Yoga", "videoUrl": "https://www.youtube.com/watch?v=eeee"},
      ],
    },
    {
      "sessionTitle": "Ashtanga Yoga",
      "image": "assets/ashtanga_yoga_pose-removebg-preview.png",
      "lessons": [
        {"title": "Strength Training", "videoUrl": "https://www.youtube.com/watch?v=ffff"},
        {"title": "Advanced Postures", "videoUrl": "https://www.youtube.com/watch?v=gggg"},
      ],
    },
    {
      "sessionTitle": "Iyengar Yoga",
      "image": "assets/iyengar_yoga_pose-removebg-preview.png",
      "lessons": [
        {"title": "Props & Alignment", "videoUrl": "https://www.youtube.com/watch?v=hhhh"},
        {"title": "Therapeutic Yoga", "videoUrl": "https://www.youtube.com/watch?v=iiii"},
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Yoga Sessions"), backgroundColor: Colors.green),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: ListView.builder(
          itemCount: yogaSessions.length,
          itemBuilder: (context, index) {
            var session = yogaSessions[index];

            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LessonDetailsScreen(
                      sessionTitle: session["sessionTitle"],
                      lessons: session["lessons"],
                    ),
                  ),
                );
              },
              child: Card(
                elevation: 5,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: EdgeInsets.all(15),
                  child: Row(
                    children: [
                      Image.asset(session["image"], width: 80, height: 80),
                      SizedBox(width: 20),
                      Expanded(
                        child: Text(
                          session["sessionTitle"],
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
