import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:quickfix/state/providers/scaffold_messenger.dart';
import 'package:quickfix/view/payments/payment_success_page.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'dart:developer' as dev;

class PaymentScreen extends ConsumerStatefulWidget {
  const PaymentScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends ConsumerState<PaymentScreen> {
  Razorpay _razorpay = Razorpay();

  @override
  void initState() {
    super.initState();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    // Do something when payment succeeds
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => PaymentSuccessPage(
          paymentSuccessResponse: response,
        ),
      ),
      ModalRoute.withName('/'),
    );
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    // Do something when payment fails
    ref.read(scaffoldMessengerProvider).showSnackBar(
        SnackBar(content: Text("Payment failed: ${response.message}")));
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Do something when an external wallet is selected
    ref.read(scaffoldMessengerProvider).showSnackBar(SnackBar(
        content: Text("External Wallet selected : ${response.walletName}")));
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  void openCheckout() async {
    var options = {
      'key': 'rzp_test_1CpRd8yOOLoy3A',
      'amount': 500, //in the smallest currency sub-unit.
      'name': 'Acme Corp.',
      // 'order_id': 'order_EMBFqjDHEEn80l', // Generate order_id using Orders API
      'description': 'Redmi note 9 pro max ultra',
      'timeout': 120, // in seconds
      'prefill': {'contact': '9000090000', 'email': 'ayandas9531@gmail.com'},
      'external': ['paytm']
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      dev.log("Open checkout error", error: e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: TextButton(
            onPressed: () {
              openCheckout();
            },
            child: const Text("Pay")),
      ),
    );
  }
}
