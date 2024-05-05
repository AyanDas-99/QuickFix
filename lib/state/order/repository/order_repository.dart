import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:quickfix/state/cart/model/cart_item.dart';
import 'package:quickfix/state/order/models/order_payload.dart';
import 'package:quickfix/state/strings/firebase_field_names.dart';
import 'package:quickfix/state/typedefs.dart';
import 'package:quickfix/state/user/providers/user_by_id.dart';
import 'package:quickfix/state/user/providers/user_provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

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

      final totalPrice = cart.fold<int>(
          0, (previousValue, item) => previousValue + item.subtotal);

      var options = {
        'key': 'rzp_test_1CpRd8yOOLoy3A',
        'amount': totalPrice * 100, //in the smallest currency sub-unit.
        'name': '',
        // 'order_id': 'order_EMBFqjDHEEn80l', // Generate order_id using Orders API
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
      return false;
    }
  }

  Future<bool> payOnDelivery(List<CartItem> cart) async {
    state = true;
    try {
      final uid = ref.read(userProvider)!.uid;
      final user = await ref.read(UserByIdProvider(uid).future);
      final totalPrice = cart.fold<int>(
          0, (previousValue, item) => previousValue + item.subtotal);
      final OrderPayload payload = OrderPayload(
          userId: uid,
          price: totalPrice,
          isCashOnDelivery: true,
          shippingAddress: user.shippingAddress!,
          items: cart);
      final addedToDb = await addOrder(payload);
      state = false;
      return addedToDb;
    } catch (e) {
      state = false;
      return false;
    }
  }

  // Add order to firestore after payment completion
  Future<bool> addOrder(OrderPayload orderPayload) async {
    state = true;
    try {
      final docRef = await FirebaseFirestore.instance
          .collection(FirebaseFieldNames.ordersCollection)
          .add(orderPayload);
      final doc = await docRef.get();
      state = false;
      // return doc.data();
      return true;
    } catch (e) {
      state = false;
      return false;
    }
  }
}
