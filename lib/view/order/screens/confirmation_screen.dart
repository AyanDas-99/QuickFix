import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quickfix/state/cart/model/cart_item.dart';
import 'package:quickfix/state/order/models/order_payload.dart';
import 'package:quickfix/state/order/repository/order_repository.dart';
import 'package:quickfix/state/user/providers/user_by_id.dart';
import 'package:quickfix/state/user/providers/user_provider.dart';
import 'package:quickfix/view/components/main_button.dart';
import 'package:quickfix/view/order/screens/order_success_page.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'dart:developer' as dev;

class ConfirmationScreen extends ConsumerStatefulWidget {
  final List<CartItem> cart;
  const ConfirmationScreen({super.key, required this.cart});

  @override
  ConsumerState<ConfirmationScreen> createState() => _ConfirmationScreenState();
}

class _ConfirmationScreenState extends ConsumerState<ConfirmationScreen> {
  Razorpay _razorpay = Razorpay();

  @override
  void initState() {
    super.initState();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    final uid = ref.read(userProvider)!.uid;
    final user = await ref.read(UserByIdProvider(uid).future);
    final added = await ref.read(orderRepositoryProvider.notifier).addOrder(
        OrderPayload(
            orderId: response.orderId,
            userId: uid,
            price: widget.cart.fold<int>(
                0, (previousValue, item) => previousValue + item.subtotal),
            isCashOnDelivery: false,
            shippingAddress: user.shippingAddress!,
            items: widget.cart));

    dev.log('Order added: $added');

    // Do something when payment succeeds
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => OrderSuccessPage(
          cart: widget.cart,
          paymentSuccessResponse: response,
        ),
      ),
      ModalRoute.withName('/'),
    );
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    // Do something when payment fails
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Payment failed: ${response.message}")));
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Do something when an external wallet is selected
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("External Wallet selected : ${response.walletName}")));
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  Future<void> payNow() async {
    ref
        .read(orderRepositoryProvider.notifier)
        .buy(cart: widget.cart, razorPay: _razorpay);
  }

  Future<void> payOnDelivery() async {
    bool ordered = await ref
        .read(orderRepositoryProvider.notifier)
        .payOnDelivery(widget.cart);
    if (ordered) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => OrderSuccessPage(
              cart: widget.cart,
              paymentSuccessResponse: null,
            ),
          ),
          ModalRoute.withName('/'));
    }
  }

  @override
  Widget build(BuildContext context) {
    final uid = ref.watch(userProvider)!.uid;
    final user = ref.watch(UserByIdProvider(uid));
    return Scaffold(
      appBar: AppBar(
        title: const Text('Confirm order details'),
      ),
      body: user.when(
        data: (user) {
          return SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  color: Colors.white,
                  child: Text(user.shippingAddress.toString()),
                ),
                const SizedBox(height: 30),
                Container(
                  color: Colors.white,
                  child: Column(children: [
                    ...widget.cart.map((e) => Row(
                          children: [
                            Text(e.name),
                            Text('${e.quantity} X ${e.price} = ${e.subtotal}'),
                          ],
                        )),
                    const Divider(height: 10),
                    Row(
                      children: [
                        Text('Total'),
                        SizedBox(width: 10),
                        Text(widget.cart
                            .fold<int>(
                                0,
                                (previousValue, cartItem) =>
                                    previousValue + cartItem.subtotal)
                            .toString())
                      ],
                    ),
                    const SizedBox(height: 50),
                    MainButton(
                      onPressed: payNow,
                      backgroundColor: Colors.green,
                      child: const Text(
                        'Pay Now',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 10),
                    MainButton(
                        onPressed: payOnDelivery,
                        backgroundColor: Colors.blue,
                        child: const Text(
                          'Pay on Delivery',
                          style: TextStyle(color: Colors.white),
                        ))
                  ]),
                )
              ],
            ),
          );
        },
        error: (e, st) => Text(e.toString()),
        loading: () => const CircularProgressIndicator(),
      ),
    );
  }
}
