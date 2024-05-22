import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quickfix/state/models/shipping_address.dart';
import 'package:quickfix/state/providers/scaffold_messenger.dart';
import 'package:quickfix/state/strings/firebase_field_names.dart';
import 'package:quickfix/state/user/strings/user_field_names.dart';
import 'package:quickfix/state/user/providers/user_provider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:quickfix/state/typedefs.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'dart:developer' as dev;
part 'update_user.g.dart';

@riverpod
class UpdateUserRepository extends _$UpdateUserRepository {
  @override
  IsLoading build() {
    return false;
  }

  Future<bool> updateName(String name) async {
    state = true;
    final user = ref.read(userProvider);
    try {
      if (name.isEmpty) {
        throw 'Name cannot be empty';
      }
      final userRef = await FirebaseFirestore.instance
          .collection("users")
          .where(UserFieldNames.uid, isEqualTo: user!.uid)
          .get();
      await userRef.docs.first.reference.update({
        UserFieldNames.displayName: name,
      });

      await ref.watch(userProvider)!.updateDisplayName(name);
      await ref.watch(userProvider)!.reload();
      state = false;
      ref
          .read(scaffoldMessengerProvider)
          .showSnackBar(const SnackBar(content: Text('Name updated!')));
      return true;
    } on FirebaseException catch (e) {
      dev.log("Profile name update", error: e);
      ref
          .read(scaffoldMessengerProvider)
          .showSnackBar(SnackBar(content: Text(e.code)));

      state = false;
      return false;
    } catch (e) {
      dev.log("Profile name update", error: e);
      ref
          .read(scaffoldMessengerProvider)
          .showSnackBar(SnackBar(content: Text(e.toString())));

      state = false;
      return false;
    }
  }

  Future<bool> updateAddress(ShippingAddress shippingAddress) async {
    state = true;
    final user = ref.read(userProvider);
    try {
      final userRef = await FirebaseFirestore.instance
          .collection(FirebaseFieldNames.usersCollection)
          .where(UserFieldNames.uid, isEqualTo: user!.uid)
          .get();
      await userRef.docs.first.reference
          .update({UserFieldNames.shippingAddress: shippingAddress.toMap()});
      state = false;
      ref
          .read(scaffoldMessengerProvider)
          .showSnackBar(const SnackBar(content: Text('Address updated!')));

      return true;
    } catch (e) {
      dev.log('Shipping address update error', error: e);
      ref
          .read(scaffoldMessengerProvider)
          .showSnackBar(SnackBar(content: Text(e.toString())));

      state = false;
      return false;
    }
  }

  Future<bool> updatePhoto(String path) async {
    state = true;
    final user = ref.read(userProvider);
    final storageRef = FirebaseStorage.instance.ref();
    try {
      // step 1. Uploading image to storage
      final imageName = "${user!.uid}.jpg";
      final imageRef = storageRef.child("profile/$imageName");
      // Delete existing profile photo if exists in storage
      try {
        await imageRef.delete();
      } catch (e) {
        dev.log("Deleting previous picture error", error: e);
      }
      // Upload the picture
      await imageRef.putFile(File(path));
      final photoLink = await imageRef.getDownloadURL();

      // step 2. Updating user with new image url for profile
      final userRef = await FirebaseFirestore.instance
          .collection("users")
          .where(UserFieldNames.uid, isEqualTo: user.uid)
          .get();
      await userRef.docs.first.reference.update({
        UserFieldNames.photoUrl: photoLink,
      });

      await ref.watch(userProvider)!.updatePhotoURL(photoLink);
      await ref.watch(userProvider)!.reload();

      state = false;
    } catch (e) {
      dev.log("Profile image update", error: e);
      state = false;
      return false;
    }
    return true;
  }
}
