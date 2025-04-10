import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yoga/attendence.dart';
import 'package:yoga/login.dart';
import 'package:yoga/traning%20set.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String userName = "User";
  String? profileImagePath;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('fullName') ?? "User";
      profileImagePath = prefs.getString('profileImagePath');
    });
  }

  Future<void> _pickProfileImage() async {
    final picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('profileImagePath', pickedFile.path);
      setState(() {
        profileImagePath = pickedFile.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.shade50,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: GestureDetector(
              onTap: _pickProfileImage,
              child: CircleAvatar(
                radius: 18,
                backgroundImage: profileImagePath != null
                    ? FileImage(File(profileImagePath!)) as ImageProvider
                    : const AssetImage('assets/user_avatar.png'),
              ),
            ),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          physics: const BouncingScrollPhysics(),
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(color: Colors.green),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: _pickProfileImage,
                    child: CircleAvatar(
                      radius: 40,
                      backgroundImage: profileImagePath != null
                          ? FileImage(File(profileImagePath!)) as ImageProvider
                          : const AssetImage('assets/user_avatar.png'),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(userName, style: const TextStyle(fontSize: 18, color: Colors.white)),
                  const Text('user@email.com', style: TextStyle(fontSize: 14, color: Colors.white70)),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.person, color: Colors.green),
              title: const Text('Profile'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.settings, color: Colors.green),
              title: const Text('Settings'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.check_circle, color: Colors.blue),
              title: const Text('Attendance'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const AttendanceScreen()));
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text('Logout'),
              onTap: _logout,
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Namaste,', style: TextStyle(fontSize: 22, color: Colors.black54)),
              Text(userName, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              TextField(
                decoration: InputDecoration(
                  hintText: 'Search for your mood',
                  prefixIcon: const Icon(Icons.search, color: Colors.black54),
                  suffixIcon: const Icon(Icons.filter_list, color: Colors.black54),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              const Text('Categories for you', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  CategoryWidget('Bikram', 'assets/bikram_yoga_pose-removebg-preview.png'),
                  CategoryWidget('Jnana', 'assets/jnana_yoga_pose-removebg-preview.png'),
                  CategoryWidget('Kundalini', 'assets/kundalini_yoga_pose__1_-removebg-preview.png'),
                  CategoryWidget('Hatha', 'assets/hatha_yoga_pose-removebg-preview.png'),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text('Featured for you', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Text('See all', style: TextStyle(fontSize: 14, color: Colors.green)),
                ],
              ),
              const SizedBox(height: 10),
              Column(
                children: [
                  for (int i = 0; i < yogaLessons.length; i += 2)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        YogaLessonCard(
                          yogaLessons[i]['title'] ?? 'Unknown Title',
                          yogaLessons[i]['subtitle'] ?? 'No Lessons',
                          yogaLessons[i]['imagePath'] ?? 'assets/default_image.png',
                        ),
                        if (i + 1 < yogaLessons.length)
                          YogaLessonCard(
                            yogaLessons[i + 1]['title'] ?? 'Unknown Title',
                            yogaLessons[i + 1]['subtitle'] ?? 'No Lessons',
                            yogaLessons[i + 1]['imagePath'] ?? 'assets/default_image.png',
                          ),
                      ],
                    ),
                  const SizedBox(height: 80),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('fullName');
    await prefs.setBool('isLoggedIn', false);
    if (mounted) setState(() {});
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => StudentLogin ()),
      (route) => false,
    );
  }
}

// Add this to pubspec.yaml under dependencies:
// image_picker: ^1.0.4

final List<Map<String, String>> yogaLessons = [
  {'title': 'Bikram Yoga', 'subtitle': '12 Lessons | Beginner', 'imagePath': 'assets/bikram_yoga_lesson_card-removebg-preview.png'},
  {'title': 'Hatha Yoga', 'subtitle': '10 Lessons | Intermediate', 'imagePath': 'assets/hatha_yoga_pose_3-removebg-preview.png'},
  {'title': 'Kundalini Yoga', 'subtitle': '15 Lessons | Advanced', 'imagePath': 'assets/kundalini_yoga_pose__2_-removebg-preview.png'},
  {'title': 'Vinyasa Yoga', 'subtitle': '18 Lessons | Beginner', 'imagePath': 'assets/vinyasa_yoga_pose-removebg-preview.png'},
  {'title': 'Ashtanga Yoga', 'subtitle': '14 Lessons | Intermediate', 'imagePath': 'assets/ashtanga_yoga_pose-removebg-preview.png'},
  {'title': 'Iyengar Yoga', 'subtitle': '16 Lessons | Beginner', 'imagePath': 'assets/iyengar_yoga_pose-removebg-preview.png'},
];

class CategoryWidget extends StatelessWidget {
  final String name;
  final String iconPath;
  const CategoryWidget(this.name, this.iconPath, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          backgroundColor: Colors.green.shade100,
          radius: 30,
          child: Image.asset(iconPath, width: 40),
        ),
        const SizedBox(height: 5),
        Text(name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
      ],
    );
  }
}

class YogaLessonCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String imagePath;

  const YogaLessonCard(this.title, this.subtitle, this.imagePath, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180,
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 5)],
      ),
      child: Column(
        children: [
          Image.asset(imagePath, width: 150, height: 100, fit: BoxFit.cover),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 5),
                Text(subtitle, style: const TextStyle(fontSize: 12, color: Colors.black54)),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TrainingScreen(
                          title: title,
                          subtitle: subtitle,
                          imagePath: imagePath,
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text('Start Training'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
