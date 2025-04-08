import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:local_auth/local_auth.dart';
import 'package:yoga/booking.dart';

class TrainingScreen extends StatefulWidget {
  final String title;
  final String subtitle;
  final String imagePath;

  const TrainingScreen({super.key, required this.title, required this.subtitle, required this.imagePath});

  @override
  _TrainingScreenState createState() => _TrainingScreenState();
}

class _TrainingScreenState extends State<TrainingScreen> with SingleTickerProviderStateMixin {
  final LocalAuthentication auth = LocalAuthentication();
  bool _isAuthenticated = false;
  bool _trainingStarted = false;
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _loadTrainingStatus();

    // Setup animations
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 600),
    );

    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _slideAnimation = Tween<Offset>(begin: Offset(0, 0.2), end: Offset.zero).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Load training completion status
  Future<void> _loadTrainingStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _trainingStarted = prefs.getBool('${widget.title}_trainingStarted') ?? false;
    });
  }

  // Authenticate with fingerprint before training
  Future<void> _authenticate() async {
    try {
      bool authenticated = await auth.authenticate(
        localizedReason: "Scan your fingerprint to start training",
        options: AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
        ),
      );

      if (authenticated) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool('${widget.title}_trainingStarted', true);

        setState(() {
          _isAuthenticated = true;
          _trainingStarted = true;
        });

        _showSnackBar("✅ Training Started!", Colors.green);
      } else {
        _showSnackBar("❌ Authentication failed. Try again!", Colors.red);
      }
    } catch (e) {
      _showSnackBar("❌ Error during authentication!", Colors.red);
    }
  }

  // Show a notification
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
      appBar: AppBar(title: Text(widget.title), backgroundColor: Colors.green),
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: Padding(
              padding: EdgeInsets.all(25),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Training Image with Shadow
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.green.withOpacity(0.3),
                          blurRadius: 15,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.asset(widget.imagePath, width: 280, height: 200, fit: BoxFit.cover),
                    ),
                  ),
                  SizedBox(height: 20),

                  // Title and Subtitle
                  Text(
                    widget.title,
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                  Text(
                    widget.subtitle,
                    style: TextStyle(fontSize: 18, color: Colors.black54, fontStyle: FontStyle.italic),
                  ),
                  SizedBox(height: 25),

                  // Fingerprint Authentication Button
                  if (!_trainingStarted)
                    GestureDetector(
                      onTap: _authenticate,
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 400),
                        width: 250,
                        padding: EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.green.shade700, Colors.green.shade400],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.green.shade300,
                              blurRadius: 10,
                              spreadRadius: 2,
                              offset: Offset(2, 5),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.fingerprint, color: Colors.white, size: 24),
                              SizedBox(width: 10),
                              Text(
                                "Scan to Start Training",
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                  // Training Instructions & Proceed to Booking
                  if (_trainingStarted)
                    Column(
                      children: [
                        SizedBox(height: 20),
                        Text(
                          "Training Instructions",
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green.shade800),
                        ),
                        SizedBox(height: 10),
                        Card(
                          elevation: 5,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          child: Padding(
                            padding: EdgeInsets.all(15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _instructionRow("Start with a warm-up session.", Icons.directions_run),
                                _instructionRow("Maintain steady breathing.", Icons.self_improvement),
                                _instructionRow("Hold each pose for 30 seconds.", Icons.timer),
                                _instructionRow("Stay hydrated and take breaks.", Icons.local_drink),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 30),

                        // Navigate to Booking
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BookingScreen(
                                  title: widget.title,
                                  subtitle: widget.subtitle,
                                  imagePath: widget.imagePath,
                                ),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            padding: EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          child: Text("Proceed to Booking", style: TextStyle(fontSize: 18, color: Colors.white)),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _instructionRow(String text, IconData icon) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, color: Colors.green.shade700, size: 24),
          SizedBox(width: 12),
          Expanded(child: Text(text, style: TextStyle(fontSize: 16, color: Colors.black87))),
        ],
      ),
    );
  }
}
