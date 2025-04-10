import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:yoga/homescreen.dart';

class Studentbottomnav extends StatefulWidget {
  const Studentbottomnav({super.key});

  @override
  State<Studentbottomnav> createState() => _StudentHomeState();
}

class _StudentHomeState extends State<Studentbottomnav> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    HomeScreen(),
    // Add your other screens here
    Center(child: Text("Courses")),
    Center(child: Text("Notifications")),
    Center(child: Text("Profile")),
  ];

  void onitemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Colors.green, Colors.white],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              spreadRadius: 3,
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: GNav(
          backgroundColor: Colors.transparent, // Important for gradient visibility
          color: Colors.green.shade800,
          activeColor: Colors.white,
          tabBackgroundColor: Colors.green.shade700.withOpacity(0.3),
          gap: 8,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          selectedIndex: _selectedIndex,
          onTabChange: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          tabs: const [
            GButton(
              icon: Icons.home,
              text: 'Home',
            ),
            GButton(
              icon: Icons.menu_book,
              text: 'Courses',
            ),
            GButton(
              icon: Icons.mark_email_read,
              text: 'Notification',
            ),
            GButton(
              icon: Icons.person,
              text: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
