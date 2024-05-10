import 'dart:async';
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
      controller.add(true);
    } else {
      controller.add(false);
    }
  });

  ref.onDispose(() {
    sub.cancel();
    controller.close();
  });
  return controller.stream;
}
