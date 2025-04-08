import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yoga/admin/adminhome.dart';
import 'package:yoga/forgetpassword.dart';
import 'package:yoga/regstartion.dart';
import 'dart:convert';
import 'bottomnavi.dart';

class YogaLoginScreen extends StatefulWidget {
  const YogaLoginScreen({super.key});

  @override
  _YogaLoginScreenState createState() => _YogaLoginScreenState();
}

class _YogaLoginScreenState extends State<YogaLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;
  bool rememberMe = false;
  bool _passwordVisible = false;

  @override
  void initState() {
    super.initState();
    _loadSavedCredentials();
  }

  Future<void> _loadSavedCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getBool('rememberMe') ?? false) {
      emailController.text = prefs.getString('email') ?? '';
      passwordController.text = prefs.getString('password') ?? '';
      rememberMe = true;
      setState(() {});
    }
  }

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() => isLoading = true);

      final email = emailController.text.trim();
      final password = passwordController.text.trim();

      SharedPreferences prefs = await SharedPreferences.getInstance();

      // ✅ Admin login (hardcoded)
      if (email == 'admin@yoga.com' && password == 'admin123') {
        await prefs.setBool('isLoggedIn', true);
        await prefs.setString('fullName', 'Admin');

        if (rememberMe) {
          await prefs.setBool('rememberMe', true);
          await prefs.setString('email', email);
          await prefs.setString('password', password);
        } else {
          await prefs.setBool('rememberMe', false);
          await prefs.remove('email');
          await prefs.remove('password');
        }

        setState(() => isLoading = false);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Adminhome()),
        );
        return;
      }

      String? usersData = prefs.getString('users');

      if (usersData == null) {
        _showError("No registered users found. Please sign up.");
        setState(() => isLoading = false);
        return;
      }

      List<Map<String, String>> users = (json.decode(usersData) as List)
          .map((user) => Map<String, String>.from(user))
          .toList();

      Map<String, String>? matchedUser;

      for (var user in users) {
        if (user['email'] == email && user['password'] == password) {
          matchedUser = user;
          break;
        }
      }

      if (matchedUser != null) {
        await prefs.setBool('isLoggedIn', true);
        await prefs.setString('fullName', matchedUser['fullName'] ?? "User");

        if (rememberMe) {
          await prefs.setBool('rememberMe', true);
          await prefs.setString('email', email);
          await prefs.setString('password', password);
        } else {
          await prefs.setBool('rememberMe', false);
          await prefs.remove('email');
          await prefs.remove('password');
        }

        setState(() => isLoading = false);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const BottomNavPage()),
        );
      } else {
        setState(() => isLoading = false);
        _showError("Invalid email or password. Please try again.");
      }
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[50],
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("◉ Back", style: TextStyle(color: Colors.black54)),
                  ),
                ),
                const SizedBox(height: 30),
                Image.asset('assets/yoga_pose__1_-removebg-preview.png', width: 180),
                const SizedBox(height: 30),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.green[100],
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Center(
                          child: Text("Welcome Back!", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                        ),
                        const SizedBox(height: 20),
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
                          validator: (value) => value == null || value.isEmpty ? 'Email is required' : null,
                        ),
                        const SizedBox(height: 15),
                        const Text("Password"),
                        const SizedBox(height: 5),
                        TextFormField(
                          controller: passwordController,
                          obscureText: !_passwordVisible,
                          decoration: InputDecoration(
                            hintText: "Enter your password",
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(_passwordVisible ? Icons.visibility : Icons.visibility_off),
                              onPressed: () => setState(() => _passwordVisible = !_passwordVisible),
                            ),
                          ),
                          validator: (value) => value == null || value.isEmpty ? 'Password is required' : null,
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) =>  ResetPasswordScreen()),
                            ),
                            child: const Text("Forgot password?", style: TextStyle(color: Colors.red)),
                          ),
                        ),
                        Row(
                          children: [
                            Checkbox(
                              value: rememberMe,
                              onChanged: (val) => setState(() => rememberMe = val ?? false),
                            ),
                            const Text("Remember me"),
                          ],
                        ),
                        const SizedBox(height: 15),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: isLoading ? null : _login,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                            child: isLoading
                                ? const CircularProgressIndicator(color: Colors.white)
                                : const Text("Login", style: TextStyle(fontSize: 18, color: Colors.white)),
                          ),
                        ),
                        const SizedBox(height: 30),
                        Center(
                          child: TextButton(
                            onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const YogaSignUpScreen()),
                            ),
                            child: const Text("Don't have an account yet? Sign up", style: TextStyle(color: Colors.black)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
