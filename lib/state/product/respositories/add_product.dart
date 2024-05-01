import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quickfix/state/product/models/product_payload.dart';
import 'package:quickfix/state/strings/firebase_field_names.dart';
import 'package:quickfix/state/typedefs.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';
import 'package:path/path.dart' as p;
import 'dart:developer' as dev;

part 'add_product.g.dart';

@riverpod
class AddProduct extends _$AddProduct {
  @override
  IsLoading build() {
    return false;
  }

  Future<bool> addNewProduct(
      {required ProductPayload payload,
      required Function(double) onImageUploadLoading}) async {
    try {
      state = true;
      final images = await _uploadImages(payload.images, onImageUploadLoading);
      payload.copyWithImages(images);

      final productsCollection = FirebaseFirestore.instance
          .collection(FirebaseFieldNames.productsCollection);
      await productsCollection.add(payload);
      return true;
    } catch (e) {
      return false;
    } finally {
      state = false;
    }
  }

  Future<List<String>> _uploadImages(
      List<String> imagePaths, Function(double) onImageUploadLoading) async {
    List<String> links = [];
    double totalProgress = 0;
    for (var path in imagePaths) {
      final name = '${const Uuid().v4()}${p.extension(path)}';

      final imageRef = FirebaseStorage.instance
          .ref()
          .child("${FirebaseFieldNames.productImages}/$name");

      final file = File(path);
      final snap = imageRef.putData(
        file.readAsBytesSync(),
        SettableMetadata(contentType: 'image'),
      );
      snap.snapshotEvents.listen((TaskSnapshot taskSnapshot) async {
        switch (taskSnapshot.state) {
          case TaskState.running:
            final progress = 100.0 *
                (taskSnapshot.bytesTransferred / taskSnapshot.totalBytes);
            dev.log("The progress is ${progress}");
            totalProgress += progress;
            onImageUploadLoading(totalProgress);
            break;
          case TaskState.success:
            final url = await imageRef.getDownloadURL();
            links.add(url);
          case TaskState.canceled || TaskState.error:
            dev.log("Image upload cancelled or error for ${path}");
          //
          case TaskState.paused:
            dev.log("Image upload paused for ${path}");
          //
        }
        await snap.whenComplete(() {});
      });
    }
    return links;
  }
}
