import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yoga/admin/provider/adminprovider.dart';
import 'package:yoga/homescreen.dart';
import 'package:yoga/regstartion.dart';

class StudentLogin extends StatefulWidget {
  const StudentLogin({super.key});

  @override
  State<StudentLogin> createState() => _StudentLoginState();
}

class _StudentLoginState extends State<StudentLogin> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.green, Colors.white],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Card(
              color: const Color.fromARGB(255, 255, 255, 255),
              elevation: 12,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Logo
                      Image.network(
                        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSAgJfGGxulCdwkqeIxP6XrF04HtaePLC1Quw&s',
                        height: 120,
                        width: 120,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(height: 20),

                      // Email
                      CustomTextField(
                        labelText: 'Email',
                        icon: Icons.email,
                        keyboardType: TextInputType.emailAddress,
                        controller: _emailController,
                      ),
                      const SizedBox(height: 20),

                      // Password
                      CustomTextField(
                        labelText: 'Password',
                        icon: Icons.lock,
                        isPassword: true,
                        controller: _passwordController,
                      ),
                      const SizedBox(height: 30),

                      // Login Button
                      ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const HomeScreen(),
                              ),
                            );
                            final authProvider =
                                context.read<Adminprovider>();
                            String result = await authProvider.loginUserProvider(
                              _emailController.text.trim(),
                              _passwordController.text.trim(),
                            );

                            if (result != "User login successfully!") {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(result)),
                              );
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: const Color.fromARGB(255, 33, 156, 72),
                          backgroundColor: const Color.fromARGB(255, 248, 250, 255),
                          elevation: 6,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          padding: const EdgeInsets.symmetric(
                              vertical: 14, horizontal: 32),
                          textStyle: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        child: const Text("Login"),
                      ),
                      const SizedBox(height: 15),

                      // Register Button
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const StudentRegistration(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: const Color.fromARGB(255, 65, 207, 94),
                          backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                          elevation: 6,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          padding: const EdgeInsets.symmetric(
                              vertical: 14, horizontal: 32),
                          textStyle: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        child: const Text("Register"),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CustomTextField extends StatelessWidget {
  final String labelText;
  final IconData icon;
  final bool isPassword;
  final TextEditingController? controller;
  final TextInputType keyboardType;

  const CustomTextField({
    super.key,
    required this.labelText,
    required this.icon,
    this.isPassword = false,
    this.controller,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: isPassword,
      style: const TextStyle(color: Colors.black87, fontSize: 16),
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: const TextStyle(
          color: Colors.green,
          fontWeight: FontWeight.bold,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Colors.green, width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.green, width: 3),
          borderRadius: BorderRadius.circular(15),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.green, width: 2),
          borderRadius: BorderRadius.circular(15),
        ),
        prefixIcon: Icon(icon, color: Colors.green),
        filled: true,
        fillColor: Colors.white.withOpacity(0.9),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 20,
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your $labelText';
        }
        if (labelText == "Email" &&
            !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
          return 'Please enter a valid email address';
        }
        if (labelText == "Password" && value.length < 6) {
          return 'Password must be at least 6 characters';
        }
        return null;
      },
    );
  }
}
