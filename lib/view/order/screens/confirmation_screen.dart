import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quickfix/state/cart/model/cart_item.dart';
import 'package:quickfix/state/order/models/order_payload.dart';
import 'package:quickfix/state/order/repository/order_repository.dart';
import 'package:quickfix/state/providers/scaffold_messenger.dart';
import 'package:quickfix/state/user/providers/user_by_id.dart';
import 'package:quickfix/state/user/providers/user_provider.dart';
import 'package:quickfix/view/components/main_button.dart';
import 'package:quickfix/view/extensions/shorten.dart';
import 'package:quickfix/view/order/screens/order_success_page.dart';
import 'package:quickfix/view/strings.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'dart:developer' as dev;

class ConfirmationScreen extends ConsumerStatefulWidget {
  final List<CartItem> cart;
  const ConfirmationScreen({super.key, required this.cart});

  @override
  ConsumerState<ConfirmationScreen> createState() => _ConfirmationScreenState();
}

class _ConfirmationScreenState extends ConsumerState<ConfirmationScreen> {
  final Razorpay _razorpay = Razorpay();

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
        orderPayload: OrderPayload(
            userId: uid,
            price: widget.cart.fold<int>(
                0, (previousValue, item) => previousValue + item.subtotal),
            isCashOnDelivery: false,
            shippingAddress: user!.shippingAddress!,
            items: widget.cart),
        id: response.orderId);

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
    final orderLoading = ref.watch(orderRepositoryProvider);
    print(widget.cart);
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: const Text('Confirm order details'),
          ),
          body: user.when(
            data: (user) {
              return ListView(
                padding: const EdgeInsets.all(10),
                children: [
                  Container(
                    padding: const EdgeInsets.all(5),
                    color: Colors.white,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Product',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 20),
                          ...widget.cart.map((e) => Row(
                                children: [
                                  Expanded(
                                      flex: 1, child: Text(e.name.shorten(25))),
                                  Expanded(
                                    flex: 1,
                                    child: Text(
                                        '${e.quantity} X ${e.price} = $rupee ${e.subtotal}'),
                                  ),
                                ],
                              )),
                          const Divider(
                            height: 30,
                          ),
                          RichText(
                            text: TextSpan(
                              style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                              children: [
                                const TextSpan(text: 'Total   '),
                                TextSpan(
                                    text:
                                        '$rupee ${widget.cart.fold<int>(0, (previousValue, cartItem) => previousValue + cartItem.subtotal).toString()}')
                              ],
                            ),
                          ),
                        ]),
                  ),
                  const SizedBox(height: 50),
                  Container(
                    color: Colors.white,
                    padding: const EdgeInsets.all(5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Shipping Address',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 20),
                        (user!.shippingAddress == null)
                            ? const Text(
                                'Please add a shipping address before placing order.',
                                style: TextStyle(color: Colors.red),
                              )
                            : Text(user.shippingAddress.toString()),
                      ],
                    ),
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
                      )),
                ],
              );
            },
            error: (e, st) => Text(e.toString()),
            loading: () => const CircularProgressIndicator(),
          ),
        ),
        if (orderLoading)
          Container(
            color: Colors.black.withOpacity(0.7),
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          )
      ],
    );
  }
}
