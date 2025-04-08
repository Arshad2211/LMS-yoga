import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:yoga/lessondetails.dart';
import 'package:yoga/lessons.dart';
import 'package:yoga/qrcode.dart';

class PaymentScreen extends StatefulWidget {
  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>(); // Form key for validation
final TextEditingController cardNumberController = TextEditingController();
final TextEditingController cvvController = TextEditingController();
  String selectedPaymentMethod = "";
  String cardNumber = "**** **** **** 0000"; // Default card number display
  String cvv = ""; // CVV storage
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    _scaleAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeOutBack);
  }

  // Function to select payment method
 void _selectPaymentMethod(String method) {
  setState(() {
    selectedPaymentMethod = method;
  });

  if (method == "GPay") {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QRCodeScreen(
          paymentMethod: "Google Pay",
          qrImagePath: "assets/qr_code-removebg-preview.png", // ✅ Google Pay QR Code
        ),
      ),
    );
  } else if (method == "Razorpay") {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QRCodeScreen(
          paymentMethod: "Razorpay",
          qrImagePath: "assets/razorpay_qrcode.png", // ✅ Razorpay QR Code
        ),
      ),
    );
  } else if (method == "PayPal") {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QRCodeScreen(
          paymentMethod: "PayPal",
          qrImagePath: "assets/paypall_qrcode-removebg-preview.png", // ✅ PayPal QR Code
        ),
      ),
    );
  }
}


  Widget _inputField(String hintText, IconData icon, TextInputType inputType, int maxLength, Function(String) onChanged) {
  return TextField(
    keyboardType: inputType,
    maxLength: maxLength,
    onChanged: onChanged,
    decoration: InputDecoration(
      hintText: hintText,
      prefixIcon: Icon(icon, color: Colors.green),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey),
      ),
      filled: true,
      fillColor: Colors.grey.shade200,
    ),
  );
}


  // ✅ Animated Payment Success Dialog
 void _showSuccessDialog() {
  if (_formKey.currentState!.validate()) { 
    // ✅ Payment is allowed if Card Number & CVV are valid
    _controller.forward();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ScaleTransition(
          scale: _scaleAnimation,
          child: AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: Center(child: Text("Payment Successful! 🎉", style: TextStyle(fontWeight: FontWeight.bold))),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.check_circle, color: Colors.green, size: 80),
                SizedBox(height: 10),
                Text("Your payment has been processed successfully."),
              ],
            ),
            actions: [
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    _controller.reverse();
                    Navigator.pop(context); // Close Dialog
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => LessonsScreen()),
                    ); // Navigate to Lessons Page
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text("OK", style: TextStyle(fontSize: 16, color: Colors.white)),
                ),
              ),
            ],
          ),
        );
      },
    );
  } else {
    // ✅ Show error if Card Number & CVV are empty or incorrect
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Please enter valid card details."),
        backgroundColor: Colors.red,
      ),
    );
  }
}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // ✅ Set Background to White
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text("Payment", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ✅ Enhanced Payment Card UI
              _buildPaymentCard(),
              SizedBox(height: 20),

              // ✅ Card Number & CVV Input Fields
              _buildCardDetailsInput(),
              SizedBox(height: 20),

              // ✅ Payment Methods with Original Colors
              Text("Choose Payment Method", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
              SizedBox(height: 10),
              _paymentOptions(),
              SizedBox(height: 20),

              // ✅ Promo Code Input
              _buildPromoCodeInput(),
              SizedBox(height: 20),

              // ✅ Total & Checkout Button
              _buildCheckoutSection(),
            ],
          ),
        ),
      ),
    );
  }
 Widget _buildCardDetailsInput() {
  return Form(
    key: _formKey,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ✅ Card Number Field
        Text("Card Number", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black)),
        SizedBox(height: 5),
        TextFormField(
          controller: cardNumberController, // ✅ Uses the controller
          keyboardType: TextInputType.number,
          maxLength: 16,
          onChanged: (value) {
            setState(() {}); // ✅ Force UI update when typing
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Card number is required.";
            } else if (value.length != 16) {
              return "Card number must be 16 digits.";
            }
            return null;
          },
          decoration: InputDecoration(
            hintText: "Enter your card number",
            prefixIcon: Icon(Icons.credit_card, color: Colors.green),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            filled: true,
            fillColor: Colors.grey.shade200,
          ),
        ),
        SizedBox(height: 15),

        // ✅ CVV Field
        Text("CVV", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black)),
        SizedBox(height: 5),
        TextFormField(
          controller: cvvController, // ✅ Uses the controller
          keyboardType: TextInputType.number,
          maxLength: 4,
          obscureText: true, // Hide CVV for security
          onChanged: (value) {
            setState(() {}); // ✅ Force UI update when typing
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "CVV is required.";
            } else if (value.length < 3 || value.length > 4) {
              return "CVV must be 3 or 4 digits.";
            }
            return null;
          },
          decoration: InputDecoration(
            hintText: "Enter CVV",
            prefixIcon: Icon(Icons.lock, color: Colors.green),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            filled: true,
            fillColor: Colors.grey.shade200,
          ),
        ),
      ],
    ),
  );
}


  // ✅ Beautiful Payment Card UI
 Widget _buildPaymentCard() {
  return Container(
    decoration: BoxDecoration(
      color: Colors.black,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 8)],
    ),
    padding: EdgeInsets.all(16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Bank Name", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
        SizedBox(height: 10),

        // ✅ Display only the last 4 digits dynamically
        Text(
          cardNumberController.text.isNotEmpty && cardNumberController.text.length >= 4
              ? "**** **** **** ${cardNumberController.text.substring(cardNumberController.text.length - 4)}"
              : "**** **** **** 0000", // Default placeholder
          style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
        ),

        SizedBox(height: 8),

        // ✅ Display CVV dynamically
        Text(
          "CVV: ${cvvController.text.isNotEmpty ? cvvController.text : "***"}",
          style: TextStyle(color: Colors.grey.shade400, fontSize: 16),
        ),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(FontAwesomeIcons.ccVisa, color: Colors.blue, size: 28),
                SizedBox(width: 8),
                Icon(FontAwesomeIcons.ccMastercard, color: Colors.red, size: 28),
              ],
            ),
          ],
        ),
      ],
    ),
  );
}


  // ✅ Payment Methods with Original Colors (ONLY GPay with correct colors)
  // ✅ Payment Methods with Original Colors (GPay, Apple Pay, PayPal)


// ✅ Google Pay Button with Correct Styling
// ✅ Payment Methods with Image Icons
// ✅ Payment Methods with Image Icons
Widget _paymentOptions() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Space out buttons
    children: [
      _gpayButton(),
      _razorpayButton(),
      _paypalButton(),
    ],
  );
}


// ✅ Google Pay Button with Image
// ✅ Google Pay Button (Navigates to QR Code Page)
Widget _gpayButton() {
  return GestureDetector(
    onTap: () => _selectPaymentMethod("GPay"),
    child: Column(
      children: [
        Image.asset("assets/gpay.png", height: 40), // ✅ Google Pay Image
        SizedBox(height: 5),
        Text("Google Pay", style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold)),
      ],
    ),
  );
}


// ✅ Razor Pay Button with Image
Widget _razorpayButton() {
  return GestureDetector(
    onTap: () => _selectPaymentMethod("Razorpay"),
    child: Column(
      children: [
        Image.asset("assets/razorpay-removebg-preview.png", height: 40), // ✅ Razorpay Logo
        SizedBox(height: 5),
        Text("Razorpay", style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold)),
      ],
    ),
  );
}

// ✅ PayPal Button with Image
// ✅ PayPal Button (Navigates to QR Code Screen)
Widget _paypalButton() {
  return GestureDetector(
    onTap: () => _selectPaymentMethod("PayPal"),
    child: Column(
      children: [
        Image.asset("assets/paypall.png", height: 40), // ✅ PayPal Logo
        SizedBox(height: 5),
        Text("PayPal", style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold)),
      ],
    ),
  );
}




  // ✅ Promo Code Input
  Widget _buildPromoCodeInput() {
    return _inputField("Add your code", Icons.check_circle, TextInputType.text, 10, (value) {});
  }

  // ✅ Total Price & Checkout Button
 Widget _buildCheckoutSection() {
  return Column(
    children: [
      Divider(color: Colors.black54),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("Total", style: TextStyle(color: Colors.black, fontSize: 18)),
          Text("\$499.00", style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold)),
        ],
      ),
      SizedBox(height: 10),
      ElevatedButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) { // ✅ Validate form
            _showSuccessDialog();
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: Text("Make Payment", style: TextStyle(fontSize: 18, color: Colors.white)),
      ),
    ],
  );
}

}
