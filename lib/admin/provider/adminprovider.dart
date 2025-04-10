import 'package:flutter/widgets.dart';
import 'package:yoga/admin/service/adminservice.dart';
import 'package:yoga/tokenmanager/tokenmanager.dart';


class Adminprovider with ChangeNotifier{
   final Adminservice _api = Adminservice();

  String? _token; // ✅ Store token for reuse

  // Getter for token
  String? get token => _token;

Future<String> loginUserProvider(String email, String password) async {
  try {
    final Map<String, dynamic> response = await _api.LoginApi(email, password);
    
    print("API Response: $response"); // Debugging API response

    if (response.containsKey("token")) {
      _token = response["token"]; // Store token in provider
      print("✅ Token: $_token");

      if (_token != null && _token!.isNotEmpty) {
        await TokenManager.saveToken(_token!); 
        notifyListeners(); // Notify UI about changes
        return "User logged in successfully!";
      } else {
        return "Invalid token received.";
      }
    } else {
      return "Token not found in response.";
    }
  } catch (e) {
    print("Error logging in user: $e");
    return "Failed to login user.";
  }
}


  Future<String> registrationProvider(
    String name,
    String email,
    String password,
    String role,
    String phoneNumber,
  ) async {
    try {
      final Map<String, dynamic> response = await _api.registrationapi(
        name,
        email,
        password,
        role ="student",
        phoneNumber,
      );

      if (response["success"] == true) {
        notifyListeners();
        return "User registered successfully!";
      } else {
        return response["message"] ?? "Registration failed.";
      }
    } catch (e) {
      print("Error registering user: $e");
      return "Failed to register user.";
    }
  }
}