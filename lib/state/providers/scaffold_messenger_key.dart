import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'scaffold_messenger_key.g.dart';

@riverpod
GlobalKey<ScaffoldMessengerState> scaffoldMessagerKey(
    ScaffoldMessagerKeyRef ref) {
  return GlobalKey<ScaffoldMessengerState>();
}
