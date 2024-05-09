import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class PaymentSuccessPage extends StatelessWidget {
  final PaymentSuccessResponse paymentSuccessResponse;
  const PaymentSuccessPage({super.key, required this.paymentSuccessResponse});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            const Row(
              children: [
                Icon(
                  Icons.check_circle,
                  color: Colors.green,
                ),
                Text("Payment Success"),
              ],
            ),
            Text(paymentSuccessResponse.paymentId.toString()),
            Text(paymentSuccessResponse.signature.toString()),
          ],
        ),
      ),
    );
  }
}
