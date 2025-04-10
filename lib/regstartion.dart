import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yoga/admin/provider/adminprovider.dart';

class StudentRegistration extends StatefulWidget {
  const StudentRegistration({super.key});

  @override
  State<StudentRegistration> createState() => _StudentRegistrationState();
}

class _StudentRegistrationState extends State<StudentRegistration> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _studentController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

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
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: Card(
                elevation: 10,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 120,
                          child: Image.network('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQzLJxyy0_IBnr1ncHhoYF1Wsrlc7vT_q1e5Q&s'),
                        ),
                        const SizedBox(height: 20),

                        _buildTextField(
                          controller: _nameController,
                          label: "Username",
                          icon: Icons.person,
                          validator: (value) => value!.isEmpty ? 'Please enter your username' : null,
                        ),
                        const SizedBox(height: 20),

                        _buildTextField(
                          controller: _emailController,
                          label: "Email",
                          icon: Icons.email,
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value!.isEmpty) return 'Please enter your email';
                            if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) return 'Enter a valid email';
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),

                        _buildTextField(
                          controller: _passwordController,
                          label: "Password",
                          icon: Icons.lock,
                          obscureText: true,
                          validator: (value) => value!.length < 6 ? 'Password must be at least 6 characters' : null,
                        ),
                        const SizedBox(height: 20),

                        _buildTextField(
                          controller: _studentController,
                          label: "Student",
                          icon: Icons.school,
                          validator: (value) => value!.isEmpty ? 'Please enter student name' : null,
                        ),
                        const SizedBox(height: 20),

                        _buildTextField(
                          controller: _phoneController,
                          label: "Phone Number",
                          icon: Icons.phone,
                          keyboardType: TextInputType.phone,
                          validator: (value) {
                            if (value!.isEmpty) return 'Please enter your phone number';
                            if (!RegExp(r'^\d{10}$').hasMatch(value)) return 'Enter a valid 10-digit phone number';
                            return null;
                          },
                        ),
                        const SizedBox(height: 30),

                        ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              final authProvider = context.read<Adminprovider>();
                              String result = await authProvider.registrationProvider(
                                _nameController.text.trim(),
                                _emailController.text.trim(),
                                _passwordController.text.trim(),
                                _studentController.text.trim(),
                                _phoneController.text.trim(),
                              );

                              if (result == "User login successfully!") {
                                // TODO: Navigate to another screen after successful registration
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(result)),
                                );
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green[700],
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          child: const Text('Register'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      style: const TextStyle(fontSize: 16),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.green[800]),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.green.shade700, width: 2),
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _studentController.dispose();
    _phoneController.dispose();
    super.dispose();
  }
}
