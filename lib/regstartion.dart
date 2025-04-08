import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yoga/login.dart';
import 'dart:convert';

class YogaSignUpScreen extends StatefulWidget {
  const YogaSignUpScreen({super.key});

  @override
  _YogaSignUpScreenState createState() => _YogaSignUpScreenState();
}

class _YogaSignUpScreenState extends State<YogaSignUpScreen> {
  final _formKey = GlobalKey<FormState>(); // Form Key for Validation
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  bool rememberMe = false;
  bool isLoading = false;

  // Function to save user details in Shared Preferences
Future<void> _saveUserDetails() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  // ✅ Fetch existing users safely
  String? usersData = prefs.getString('users');
  List<Map<String, String>> users = usersData != null
      ? (json.decode(usersData) as List).map((user) => Map<String, String>.from(user)).toList()
      : [];

  // ✅ Check if email is already registered
  for (var user in users) {
    if (user['email'] == emailController.text.trim()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Email is already registered!"), backgroundColor: Colors.red),
      );
      return; // Stop registration if email exists
    }
  }

  // ✅ Add new user to the list
  users.add({
    'fullName': fullNameController.text.trim(),
    'email': emailController.text.trim(),
    'password': passwordController.text.trim(),
  });

  // ✅ Save updated user list in SharedPreferences
  await prefs.setString('users', json.encode(users));
  await prefs.setBool('isLoggedIn', false); // Prevent auto-login
}
  // Function to handle sign-up
  Future<void> _signUp() async {
    if (_formKey.currentState!.validate()) {
      setState(() => isLoading = true);

      await _saveUserDetails();

      setState(() => isLoading = false);

      // Show Snackbar instead of navigating to another screen
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Registration Successful! Please log in."),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );

      // Redirect to login screen after successful registration
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => YogaLoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[50], // Light green background
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Back Button
                Align(
                  alignment: Alignment.topLeft,
                  child: TextButton(
                    onPressed: () => Navigator.pop(context), // Navigate back
                    child: const Text(
                      "◉ Back",
                      style: TextStyle(color: Colors.black54),
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // Yoga Illustration
                Image.asset(
                  'assets/yoga_pose_cobra-removebg-preview.png', // Replace with actual image path
                  width: 180,
                ),

                const SizedBox(height: 30),

                // Sign-Up Form Container
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.green[100], // Light green card
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Center(
                          child: Text(
                            "Create Account",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Full Name Field
                        const Text("Full Name"),
                        const SizedBox(height: 5),
                        TextFormField(
                          controller: fullNameController,
                          decoration: InputDecoration(
                            hintText: "Enter your full name",
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Full Name is required';
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 10),

                        // Email Field
                        const Text("Email"),
                        const SizedBox(height: 5),
                        TextFormField(
                          controller: emailController,
                          decoration: InputDecoration(
                            hintText: "Enter your email",
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Email is required';
                            } else if (!RegExp(
                                    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
                                .hasMatch(value)) {
                              return 'Enter a valid email';
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 10),

                        // Password Field
                        const Text("Password"),
                        const SizedBox(height: 5),
                        TextFormField(
                          controller: passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            hintText: "Enter your password",
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Password is required';
                            } else if (value.length < 6) {
                              return 'Password must be at least 6 characters';
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 10),

                        // Confirm Password Field
                        const Text("Confirm Password"),
                        const SizedBox(height: 5),
                        TextFormField(
                          controller: confirmPasswordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            hintText: "Re-enter your password",
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Confirm Password is required';
                            } else if (value != passwordController.text) {
                              return 'Passwords do not match';
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 15),

                        // Sign Up Button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: isLoading ? null : _signUp,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                            child: isLoading
                                ? const CircularProgressIndicator(color: Colors.white)
                                : const Text(
                                    "Sign Up",
                                    style: TextStyle(fontSize: 18, color: Colors.white),
                                  ),
                          ),
                        ),

                        const SizedBox(height: 10),

                        // Already have an account?
                        Center(
                          child: TextButton(
                            onPressed: () => Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => YogaLoginScreen()),
                            ),
                            child: const Text(
                              "Already have an account? Log in",
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
