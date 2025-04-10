import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yoga/login.dart';
import 'dart:convert';

class ResetPasswordScreen extends StatefulWidget {
  @override
  _ResetPasswordScreenState createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController _emailController = TextEditingController(); // ✅ Email Field
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool _passwordVisible = false;
  bool _confirmPasswordVisible = false;

  // ✅ Function to Reset Password
  Future<void> _resetPassword() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? usersData = prefs.getString('users');

    if (usersData == null) {
      _showSnackBar("❌ No users found! Please sign up.", Colors.red);
      return;
    }

    List<Map<String, String>> users = (json.decode(usersData) as List)
        .map((user) => Map<String, String>.from(user))
        .toList();

    String email = _emailController.text.trim();
    String newPassword = _newPasswordController.text.trim();
    String confirmPassword = _confirmPasswordController.text.trim();

    // ✅ Validation
    if (email.isEmpty || newPassword.isEmpty || confirmPassword.isEmpty) {
      _showSnackBar("❌ All fields are required!", Colors.red);
      return;
    }
    if (newPassword != confirmPassword) {
      _showSnackBar("❌ Passwords do not match!", Colors.red);
      return;
    }

    bool emailFound = false;

    // ✅ Update the password for the user with matching email
    for (var user in users) {
      if (user['email'] == email) {
        user['password'] = newPassword;
        emailFound = true;
        break;
      }
    }

    if (!emailFound) {
      _showSnackBar("❌ Email not found!", Colors.red);
      return;
    }

    // ✅ Save updated user data
    await prefs.setString('users', json.encode(users));

    _showSnackBar("✅ Password reset successfully!", Colors.green);

    // ✅ Redirect to Login Page after 2 seconds
    Future.delayed(Duration(seconds: 2), () {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => StudentLogin()));
    });
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
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("assets/new password.png", height: 150),
              SizedBox(height: 10),

              Text(
                "Reset Your Password",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.green),
              ),
              Text(
                "Enter your registered email and set a new password.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),

              SizedBox(height: 20),

              // ✅ Email Field
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: "Email",
                  hintText: "Enter your registered email",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  prefixIcon: Icon(Icons.email),
                ),
              ),
              SizedBox(height: 15),

              // ✅ New Password Field
              TextField(
                controller: _newPasswordController,
                obscureText: !_passwordVisible,
                decoration: InputDecoration(
                  labelText: "New Password",
                  hintText: "Create a new password",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  prefixIcon: Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(_passwordVisible ? Icons.visibility : Icons.visibility_off),
                    onPressed: () {
                      setState(() {
                        _passwordVisible = !_passwordVisible;
                      });
                    },
                  ),
                ),
              ),
              SizedBox(height: 15),

              // ✅ Confirm Password Field
              TextField(
                controller: _confirmPasswordController,
                obscureText: !_confirmPasswordVisible,
                decoration: InputDecoration(
                  labelText: "Confirm Password",
                  hintText: "Re-enter your password",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  prefixIcon: Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    icon: Icon(_confirmPasswordVisible ? Icons.visibility : Icons.visibility_off),
                    onPressed: () {
                      setState(() {
                        _confirmPasswordVisible = !_confirmPasswordVisible;
                      });
                    },
                  ),
                ),
              ),
              SizedBox(height: 20),

              // ✅ Reset Password Button
              ElevatedButton(
                onPressed: _resetPassword,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: EdgeInsets.symmetric(vertical: 14, horizontal: 50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Text("Reset Password", style: TextStyle(fontSize: 18, color: Colors.white)),
              ),

              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
