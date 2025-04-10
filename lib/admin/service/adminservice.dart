import 'dart:convert';

import 'package:http/http.dart' as http;

class Adminservice {

   final String baseUrl = 'https://api.portfoliobuilders.in/api';


Future<Map<String, dynamic>> LoginApi(String email, String password) async {
  try {
    final response = await http.post(
      Uri.parse('$baseUrl/student/login'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "email": email,
        "password": password,
      }),
    );

    print("Login Request Email: $email");
    print("Password: $password");
    print("Response: ${response.body}");
    

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return {
        "success": false,
        "message": jsonDecode(response.body)['message'] ?? "Login failed"
      };
    }
  } catch (e) {
    print("Error: $e");
    return {
      "success": false,
      "message": "Something went wrong. Please try again."
    };
  }
}

Future<Map<String, dynamic>> registrationapi(String name, email, String password,String role,String phoneNumber) async {
  try {
    final response = await http.post(
      Uri.parse('$baseUrl/registerUser'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "name":name,
        "email": email,
        "password": password,
        "role": role,
        "phoneNumber":phoneNumber,
      }),
    );

    // print("Login Request Email: $email");
    // print("Password: $password");
    //     print("phonenumber: $phoneNumber");

    // print("Response: ${response.body}");

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return {
        "success": false,
        "message": jsonDecode(response.body)['message'] ?? "registration failed"
      };
    }
  } catch (e) {
    print("Error: $e");
    return {
      "success": false,
      "message": "Something went wrong. Please try again."
    };
  }
}

}