import 'package:flutter/material.dart';
import 'package:yoga/homescreen.dart';
import 'package:yoga/login.dart'; 

class YogaExperienceScreen extends StatefulWidget {
  const YogaExperienceScreen({super.key});

  @override
  _YogaExperienceScreenState createState() => _YogaExperienceScreenState();
}

class _YogaExperienceScreenState extends State<YogaExperienceScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/yoga.webp'), // Background Image
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 80), // Adjust space from top

                // Heading Text
                Text(
                  'Have the best',
                  style: TextStyle(fontSize: 24, color: Colors.black87),
                ),
                Text(
                  'Yoga Experience',
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 10),

                // Description Text
                Text(
                  'Rejuvenate your body and mind with our all-inclusive yoga app. '
                  'Explore expert-guided sessions and tailored routines.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black54),
                ),

                const SizedBox(height: 20),

                // Button
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>StudentLogin()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                  ),
                  child: Text(
                    'Begin Your Practice',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),

                const SizedBox(height:500 ), // Adjust bottom spacing

                // Image at the bottom
               
              ],
            ),
          ),
        ],
      ),
    );
  }
}
