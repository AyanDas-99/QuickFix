import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:quickfix/state/cart/model/cart_item.dart';
import 'package:quickfix/state/order/models/order_payload.dart';
import 'package:quickfix/state/providers/scaffold_messenger.dart';
import 'package:quickfix/state/strings/firebase_field_names.dart';
import 'package:quickfix/state/typedefs.dart';
import 'package:quickfix/state/user/providers/user_by_id.dart';
import 'package:quickfix/state/user/providers/user_provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:http/http.dart' as http;

part 'order_repository.g.dart';

@riverpod
class OrderRepository extends _$OrderRepository {
  @override
  IsLoading build() {
    return false;
  }

  // On pay now clicked
  // Pay, then add order to db on success
  // Navigate to success page
  Future<bool> buy({
    required List<CartItem> cart,
    required Razorpay razorPay,
  }) async {
    state = true;
    try {
      final uid = ref.read(userProvider)!.uid;
      final user = await ref.read(UserByIdProvider(uid).future);

      if (user!.shippingAddress == null) {
        throw 'Please add your shipping address from the UPDATE PROFILE section';
      }

      final totalPrice = cart.fold<int>(
          0, (previousValue, item) => previousValue + item.subtotal);

      final orderId = await _createRazorpayOrder(totalPrice);

      var options = {
        'key': dotenv.env['RAZORPAY_API_ID'],
        'amount': totalPrice * 100, //in the smallest currency sub-unit.
        'name': '',
        'order_id': orderId, // Generate order_id using Orders API
        'description': '',
        'timeout': 120, // in seconds
        'prefill': {'contact': user.phoneNumber},
        'external': ['paytm']
      };

      razorPay.open(options);

      state = false;
      return true;
    } catch (e) {
      state = false;
      ref
          .read(scaffoldMessengerProvider)
          .showSnackBar(SnackBar(content: Text(e.toString())));
      return false;
    }
  }

  Future<bool> payOnDelivery(List<CartItem> cart) async {
    state = true;
    try {
      final uid = ref.read(userProvider)!.uid;
      final user = await ref.read(UserByIdProvider(uid).future);
      if (user!.shippingAddress == null) {
        throw 'Please add your shipping address from the UPDATE PROFILE section';
      }
      final totalPrice = cart.fold<int>(
          0, (previousValue, item) => previousValue + item.subtotal);
      final OrderPayload payload = OrderPayload(
          userId: uid,
          price: totalPrice,
          isCashOnDelivery: true,
          shippingAddress: user.shippingAddress!,
          items: cart);
      final addedToDb = await addOrder(orderPayload: payload);
      state = false;
      return addedToDb;
    } catch (e) {
      state = false;
      ref
          .read(scaffoldMessengerProvider)
          .showSnackBar(SnackBar(content: Text(e.toString())));

      return false;
    }
  }

  Future<String?> _createRazorpayOrder(int amount) async {
    String username = dotenv.env['RAZORPAY_API_ID']!; // razorpay pay key
    String password = dotenv.env['RAZORPAY_KEY_SECRET']!; // razoepay secret key
    String basicAuth =
        'Basic ${base64Encode(utf8.encode('$username:$password'))}';

    Map<String, dynamic> body = {
      "amount": amount * 100,
      "currency": "INR",
      "receipt": "rcptid_11"
    };
    var res = await http.post(
      Uri.https("api.razorpay.com",
          "v1/orders"), //https://api.razorpay.com/v1/orders // Api provided by Razorpay Official 💙
      headers: <String, String>{
        "Content-Type": "application/json",
        'authorization': basicAuth,
      },
      body: jsonEncode(body),
    );

    print(res.body);
    if (res.statusCode == 200) {
      return (jsonDecode(res.body)['id']);
    }
    return null;
  }

  // Add order to firestore after payment completion
  Future<bool> addOrder(
      {required OrderPayload orderPayload, String? id}) async {
    state = true;
    try {
      await FirebaseFirestore.instance
          .collection(FirebaseFieldNames.ordersCollection)
          .doc(id)
          .set(orderPayload);
      state = false;
      // return doc.data();
      return true;
    } catch (e) {
      state = false;
      return false;
    }
  }
}
