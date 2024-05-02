import 'dart:async';
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
      print(images);
      payload = payload.copyWithImages(images);
      print(payload);
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

  // Future<List<String>> _uploadImages(
  //     List<String> imagePaths, Function(double) onImageUploadLoading) async {
  //   List<String> links = [];
  //   double totalProgress = 0;
  //   Completer<List<String>> completer = Completer<List<String>>();

  //   for (var path in imagePaths) {
  //     final name = '${const Uuid().v4()}${p.extension(path)}';

  //     final imageRef = FirebaseStorage.instance
  //         .ref()
  //         .child("${FirebaseFieldNames.productImages}/$name");

  //     final file = File(path);
  //     final snap = imageRef.putData(
  //       file.readAsBytesSync(),
  //       SettableMetadata(contentType: 'image'),
  //     );

  //     await snap.whenComplete(() {}); // Wait for upload task to complete

  //     snap.snapshotEvents.listen(
  //       (TaskSnapshot taskSnapshot) async {
  //         switch (taskSnapshot.state) {
  //           case TaskState.running:
  //             final progress = 100.0 *
  //                 (taskSnapshot.bytesTransferred / taskSnapshot.totalBytes);
  //             dev.log("The progress is ${progress}");
  //             totalProgress += progress;
  //             onImageUploadLoading(totalProgress);
  //             break;
  //           case TaskState.success:
  //             final url = await imageRef.getDownloadURL();
  //             links.add(url); // Add URL to the list
  //             break;
  //           case TaskState.canceled || TaskState.error:
  //             dev.log("Image upload cancelled or error for ${path}");
  //             break;
  //           case TaskState.paused:
  //             dev.log("Image upload paused for ${path}");
  //             break;
  //         }
  //       },
  //     );
  //   }

  //   completer.complete(links); // Complete with the list of URLs
  //   return completer.future;
  // }

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
      final uploadTask = imageRef.putData(
        file.readAsBytesSync(),
        SettableMetadata(contentType: 'image'),
      );

      // Await the completion of each upload task

      uploadTask.snapshotEvents.listen((TaskSnapshot taskSnapshot) async {
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
            links.add(url); // Add URL to the list
            break;
          case TaskState.canceled || TaskState.error:
            dev.log("Image upload cancelled or error for ${path}");
            break;
          case TaskState.paused:
            dev.log("Image upload paused for ${path}");
            break;
        }
      });

      // Get the download URL and add it to the links list
      // Update progress
      // totalProgress += 100.0 *
      //     (uploadTask.snapshot.bytesTransferred /
      //         uploadTask.snapshot.totalBytes);
      // onImageUploadLoading(totalProgress);

      await uploadTask;
      final url = await imageRef.getDownloadURL();
      links.add(url);
    }

    return links;
  }
}
