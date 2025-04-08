import 'package:flutter/material.dart';
import 'package:yoga/payment.dart';

class BookingScreen extends StatefulWidget {
  final String title;
  final String subtitle;
  final String imagePath;

  const BookingScreen({super.key, required this.title, required this.subtitle, required this.imagePath});

  @override
  _BookingScreenState createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> with SingleTickerProviderStateMixin {
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _buttonScaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 900),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );

    _slideAnimation = Tween<Offset>(
      begin: Offset(0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    _buttonScaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.elasticOut,
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Select Date Function
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 30)),
    );
    if (picked != null) {
      setState(() => selectedDate = picked);
    }
  }

  // Select Time Function
  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() => selectedTime = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Book Training Session"), backgroundColor: Colors.green),
      body: SingleChildScrollView(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Animated Image
                SlideTransition(
                  position: _slideAnimation,
                  child: Center(
                    child: Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.green.withOpacity(0.3),
                            blurRadius: 20,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.asset(widget.imagePath, width: 280, height: 200, fit: BoxFit.cover),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),

                // Animated Title
                SlideTransition(
                  position: _slideAnimation,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.title,
                        style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                      Text(
                        widget.subtitle,
                        style: TextStyle(fontSize: 18, color: Colors.black54, fontStyle: FontStyle.italic),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 25),

                // Booking Details with Ripple Effect
                _buildBookingCard(Icons.calendar_today, "Select Date",
                    selectedDate == null ? "Choose a date" : "${selectedDate!.toLocal()}".split(' ')[0], () => _selectDate(context)),

                _buildBookingCard(Icons.access_time, "Select Time",
                    selectedTime == null ? "Choose a time" : selectedTime!.format(context), () => _selectTime(context)),

                SizedBox(height: 40),

                // Animated Proceed to Payment Button
                Center(
                  child: GestureDetector(
                    onTap: selectedDate != null && selectedTime != null
                        ? () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PaymentScreen(),
                              ),
                            );
                          }
                        : null,
                    child: ScaleTransition(
                      scale: _buttonScaleAnimation,
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 300),
                        width: 220,
                        padding: EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: selectedDate != null && selectedTime != null
                                ? [Colors.green.shade700, Colors.green.shade400]
                                : [Colors.grey.shade400, Colors.grey.shade300],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: selectedDate != null && selectedTime != null
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
                          child: Text(
                            "Proceed to Payment",
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                        ),
                      ),
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

  // Booking Card Widget with Ripple Effect
  Widget _buildBookingCard(IconData icon, String title, String value, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: ScaleTransition(
        scale: _buttonScaleAnimation,
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 12),
            child: Row(
              children: [
                Icon(icon, color: Colors.green, size: 28),
                SizedBox(width: 15),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                Text(value, style: TextStyle(fontSize: 16, color: Colors.black54)),
                SizedBox(width: 10),
                Icon(Icons.arrow_forward_ios, size: 18, color: Colors.black54),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
