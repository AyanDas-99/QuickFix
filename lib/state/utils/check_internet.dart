import 'dart:async';
import 'package:flutter/material.dart';
import 'package:quickfix/state/providers/scaffold_messenger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

part 'check_internet.g.dart';

@riverpod
Stream<bool> checkInternet(CheckInternetRef ref) {
  final controller = StreamController<bool>();

  final sub = InternetConnectionChecker()
      .onStatusChange
      .listen((InternetConnectionStatus status) {
    if (status == InternetConnectionStatus.connected) {
      ref.read(scaffoldMessengerProvider).showSnackBar(const SnackBar(
            content: Text(
              'Connected to internet!',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.blue,
          ));
      controller.add(true);
    } else {
      ref.read(scaffoldMessengerProvider).showSnackBar(const SnackBar(
            content: Text(
              'Not connected to internet!',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.red,
          ));
      controller.add(false);
    }
  });

  ref.onDispose(() {
    sub.cancel();
    controller.close();
  });
  return controller.stream;
}
