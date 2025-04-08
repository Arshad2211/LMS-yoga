import 'package:flutter/material.dart';
import 'package:yoga/yogaexp.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/nura_yoga_background.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Gradient Overlay for Better Readability
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.black.withOpacity(0.7), Colors.transparent],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
            ),
          ),

          // Content
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),

                // Logo Animation
                ZoomIn(
                  duration: const Duration(seconds: 1),
                  child: Image.asset(
                    'assets/234-removebg-preview.png',
                    width: 150,
                  ),
                ),

                const SizedBox(height: 20),

                // Welcome Text Animation
                FadeInUp(
                  delay: const Duration(milliseconds: 500),
                  duration: const Duration(milliseconds: 800),
                  child: Text(
                    'Welcome to Nura Yoga',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          blurRadius: 6,
                          color: Colors.black.withOpacity(0.4),
                          offset: const Offset(2, 2),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // Description Animation
                FadeInUp(
                  delay: const Duration(milliseconds: 800),
                  child: Text(
                    'Embark on a journey to discover inner peace and vitality through the practice of yoga.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                ),

                const Spacer(),

                // Animated Gradient Button (Smaller and More Attractive)
                FadeInUp(
                  delay: const Duration(milliseconds: 1000),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => YogaExperienceScreen()),
                      );
                    },
                    child: Container(
                      width: 140, // Reduced width
                      padding: const EdgeInsets.symmetric(vertical: 10), // Smaller height
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.green.shade700, Colors.green.shade500],
                        ),
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.green.withOpacity(0.6),
                            blurRadius: 10,
                            spreadRadius: 2,
                            offset: Offset(2, 5),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          'Next',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 60),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
