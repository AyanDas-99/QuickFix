import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quickfix/state/cart/model/cart_payload.dart';
import 'package:quickfix/state/cart/strings/cart_field_names.dart';
import 'package:quickfix/state/strings/firebase_field_names.dart';
import 'package:quickfix/state/typedefs.dart';
import 'package:quickfix/state/user/providers/user_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'dart:developer' as dev;

part 'cart_repository.g.dart';

@riverpod
class CartRepository extends _$CartRepository {
  @override
  IsLoading build() {
    return false;
  }

  Future<bool> addToCart(CartPayload cartPayload) async {
    state = true;
    final user = ref.watch(userProvider);
    try {
      // Cart reference
      final cartRef = FirebaseFirestore.instance
          .collection(FirebaseFieldNames.cartsCollection)
          .doc(user!.uid);
      // Cart data
      final cartSnapshot = await cartRef.get();

      if (cartSnapshot.exists) {
        // Extract the cart items array from the cart document data
        List<dynamic> cartItems = cartSnapshot.data()!['items'];

        // Find the item with the matching productId in the cartItems array
        int itemIndex = cartItems.indexWhere((item) =>
            item[CartFieldNames.productId] ==
            cartPayload[CartFieldNames.productId]);

        if (itemIndex != -1) {
          final int quantity = cartItems[itemIndex][CartFieldNames.quantity];

          // Update the quantity of the item in the cartItems array
          cartItems[itemIndex]['quantity'] = quantity + 1;

          // Update the cart document with the modified cartItems array
          await cartRef.update({'items': cartItems});
          dev.log('Cart item quantity updated successfully.');
        } else {
          cartItems.add(cartPayload);
          await cartRef.update({'items': cartItems});
          dev.log('New item added to cart');
        }
      } else {
        cartRef.set({
          'items': [cartPayload]
        });
        dev.log('New cart for user created');
      }

      return true;
    } catch (e) {
      dev.log('Add to cart error', error: e);
      return false;
    } finally {
      state = false;
    }
  }

  Future<bool> decrement(String productId) async {
    state = true;
    final user = ref.watch(userProvider);
    try {
      // Cart reference
      final cartRef = FirebaseFirestore.instance
          .collection(FirebaseFieldNames.cartsCollection)
          .doc(user!.uid);
      // Cart data
      final cartSnapshot = await cartRef.get();

      if (cartSnapshot.exists) {
        // Extract the cart items array from the cart document data
        List<dynamic> cartItems = cartSnapshot.data()!['items'];

        // Find the item with the matching productId in the cartItems array
        int itemIndex = cartItems
            .indexWhere((item) => item[CartFieldNames.productId] == productId);

        if (itemIndex != -1) {
          final int quantity = cartItems[itemIndex][CartFieldNames.quantity];
          if (quantity == 1) {
            return await deleteItem(productId);
          }
          // Update the quantity of the item in the cartItems array
          cartItems[itemIndex]['quantity'] = quantity - 1;

          // Update the cart document with the modified cartItems array
          await cartRef.update({'items': cartItems});
          dev.log('Cart item quantity updated successfully.');
        } else {
          dev.log('Item with the product id not found in cart');
          return false;
        }
      } else {
        dev.log('Cart for user not found');
        return false;
      }

      return true;
    } catch (e) {
      return false;
    } finally {
      state = false;
    }
  }

  Future<bool> deleteItem(String productId) async {
    state = true;
    final user = ref.watch(userProvider);
    try {
      // Cart reference
      final cartRef = FirebaseFirestore.instance
          .collection(FirebaseFieldNames.cartsCollection)
          .doc(user!.uid);
      // Cart data
      final cartSnapshot = await cartRef.get();

      if (cartSnapshot.exists) {
        // Extract the cart items array from the cart document data
        List<dynamic> cartItems = cartSnapshot.data()!['items'];

        // Find the item with the matching productId in the cartItems array
        int itemIndex = cartItems
            .indexWhere((item) => item[CartFieldNames.productId] == productId);

        if (itemIndex != -1) {
          // Delete the item from cart
          cartItems.removeAt(itemIndex);

          // Update the cart document with the modified cartItems array
          await cartRef.update({'items': cartItems});
          dev.log('Cart item deleted successfully.');
        } else {
          dev.log('Item with the product id not found in cart');
          return false;
        }
      } else {
        dev.log('Cart for user not found');
        return false;
      }

      return true;
    } catch (e) {
      return false;
    } finally {
      state = false;
    }
  }
}
