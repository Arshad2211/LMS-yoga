import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:local_auth/local_auth.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  _AttendanceScreenState createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> with SingleTickerProviderStateMixin {
  bool _attendanceMarked = false;
  bool _trainingCompleted = false;
  String todayDate = "";
  final LocalAuthentication auth = LocalAuthentication();
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _loadAttendanceStatus();
    _checkTrainingCompletion();
    todayDate = _getFormattedDate();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );

    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _slideAnimation = Tween<Offset>(begin: Offset(0, 0.1), end: Offset.zero).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _getFormattedDate() {
    final now = DateTime.now();
    return "${now.day} ${_getMonthName(now.month)}, ${now.year}";
  }

  String _getMonthName(int month) {
    const List<String> monthNames = [
      "January", "February", "March", "April", "May", "June",
      "July", "August", "September", "October", "November", "December"
    ];
    return monthNames[month - 1];
  }

  Future<void> _loadAttendanceStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _attendanceMarked = prefs.getBool('attendanceMarked_$todayDate') ?? false;
    });
  }

  Future<void> _checkTrainingCompletion() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _trainingCompleted = prefs.getBool('trainingCompleted_$todayDate') ?? false;
    });
  }

  Future<void> _markAttendance() async {
    if (!_trainingCompleted) {
      _showSnackBar("❌ Complete your training before marking attendance!", Colors.red);
      return;
    }

    bool authenticated = await _authenticateWithBiometrics();
    if (!authenticated) return;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('attendanceMarked_$todayDate', true);

    setState(() {
      _attendanceMarked = true;
    });

    _showSnackBar("✅ Attendance Marked: Present", Colors.green);
  }

  Future<bool> _authenticateWithBiometrics() async {
    try {
      bool canCheckBiometrics = await auth.canCheckBiometrics;
      bool hasBiometrics = await auth.isDeviceSupported();

      if (!canCheckBiometrics || !hasBiometrics) {
        _showSnackBar("❌ Biometric authentication not available!", Colors.red);
        return false;
      }

      bool authenticated = await auth.authenticate(
        localizedReason: "Scan your fingerprint to mark attendance",
        options: AuthenticationOptions(biometricOnly: true, stickyAuth: true),
      );

      return authenticated;
    } catch (e) {
      _showSnackBar("❌ Error during authentication! Try again.", Colors.red);
      return false;
    }
  }

  void _showSnackBar(String message, Color color) {
    final snackBar = SnackBar(
      content: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(color == Colors.red ? Icons.error : Icons.check_circle, color: Colors.white),
          SizedBox(width: 10),
          Expanded(
            child: Text(message, textAlign: TextAlign.center, style: TextStyle(fontSize: 16)),
          ),
        ],
      ),
      backgroundColor: color,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      duration: Duration(seconds: 2),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Attendance"),
        backgroundColor: Colors.green.shade700,
        centerTitle: true,
        elevation: 5,
      ),
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // 📌 Date Display Card
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.green.shade400,
                          blurRadius: 10,
                          spreadRadius: 2,
                          offset: Offset(2, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Icon(Icons.calendar_today, color: Colors.green.shade700, size: 50),
                        SizedBox(height: 10),
                        Text(
                          "📅 Today's Date",
                          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                        SizedBox(height: 5),
                        Text(
                          todayDate,
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green.shade800),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 40),

                  // ✅ Attendance Status
                  _attendanceMarked
                      ? Column(
                          children: [
                            Icon(Icons.check_circle, size: 100, color: Colors.green.shade700),
                            SizedBox(height: 10),
                            Text("✅ Attendance Already Marked", style: TextStyle(fontSize: 22, color: Colors.blue)),
                          ],
                        )
                      : GestureDetector(
                          onTap: _markAttendance,
                          child: AnimatedContainer(
                            duration: Duration(milliseconds: 400),
                            width: 230,
                            padding: EdgeInsets.symmetric(vertical: 16),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: _trainingCompleted
                                    ? [Colors.green.shade700, Colors.green.shade500]
                                    : [Colors.grey.shade400, Colors.grey.shade300],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(30),
                              boxShadow: _trainingCompleted
                                  ? [
                                      BoxShadow(
                                        color: Colors.green.shade300,
                                        blurRadius: 10,
                                        spreadRadius: 2,
                                        offset: Offset(2, 5),
                                      ),
                                    ]
                                  : [],
                            ),
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.fingerprint, color: Colors.white, size: 24),
                                  SizedBox(width: 10),
                                  Text(
                                    "Scan Fingerprint",
                                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

