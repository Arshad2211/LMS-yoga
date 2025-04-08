import 'package:flutter/material.dart';

class QRCodeScreen extends StatelessWidget {
  final String paymentMethod; // ✅ Payment method name (GPay / Razorpay / PayPal)
  final String qrImagePath;   // ✅ QR Code image path

  QRCodeScreen({required this.paymentMethod, required this.qrImagePath});

  @override
  Widget build(BuildContext context) {
    // ✅ Define separate height & width for different QR Codes
    double qrHeight = 250, qrWidth = 200; // Default values

    if (paymentMethod == "GPay") {
      qrHeight = 300;  // ✅ GPay QR Code is larger
      qrWidth = 250;
    } else if (paymentMethod == "Razorpay") {
      qrHeight = 350;  // ✅ Razorpay QR Code is wider
      qrWidth = 300;
    } else if (paymentMethod == "PayPal") {
      qrHeight = 280;  // ✅ PayPal QR Code is medium-sized
      qrWidth = 240;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Scan QR Code", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Scan to Pay with $paymentMethod",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 15),

            // ✅ Conditionally Sized QR Code
            AnimatedContainer(  // ✅ Ensures smooth resizing animation
              duration: Duration(milliseconds: 500),
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(color: Colors.grey.shade300, blurRadius: 5, spreadRadius: 2),
                ],
              ),
              child: Image.asset(
                qrImagePath,
                height: qrHeight, // ✅ Dynamic Height
                width: qrWidth,    // ✅ Dynamic Width
                fit: BoxFit.cover, // ✅ Ensures full coverage
              ),
            ),

            SizedBox(height: 25),
            ElevatedButton(
              onPressed: () => Navigator.pop(context), // ✅ Return to Payment Screen
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              ),
              child: Text("Back to Payment", style: TextStyle(fontSize: 18, color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
