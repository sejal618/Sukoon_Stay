import 'package:flutter/material.dart';
import 'NextPages.dart';


class PaymentPage extends StatelessWidget {
  final TextEditingController amountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Payment Options',
          style: TextStyle(fontFamily: 'San Francisco'), // Use San Francisco font
        ),
        backgroundColor: Color.fromARGB(255, 0, 0, 0), // Set header background color
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Enter the amount and choose a payment method to proceed.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, fontFamily: 'San Francisco'), // Use San Francisco font
            ),
            SizedBox(height: 20),
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Enter Amount',
                border: OutlineInputBorder(),
                prefixText: '₹',
              ),
            ),
            SizedBox(height: 20),
            PaymentButton(
              title: 'PhonePe/PayTM/BHIM UPI',
              onPressed: () => navigateToNext(context),
            ),
          ],
        ),
      ),
    );
  }

  void navigateToNext(BuildContext context) {
    double? enteredAmount = double.tryParse(amountController.text);
    if (enteredAmount == null || enteredAmount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a valid amount!')),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NextPage(amount: enteredAmount), // Pass the amount
      ),
    );
  }
}

class PaymentButton extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;

  const PaymentButton({required this.title, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: 15),
        backgroundColor: Color.fromARGB(255, 0 ,0 ,0), // Dark forest green color
      ),
      onPressed: onPressed,
      child: Text(
        title,
        style: TextStyle(fontSize: 16, color: Colors.white, fontFamily: 'San Francisco'), // Use San Francisco font
      ),
    );
  }
}