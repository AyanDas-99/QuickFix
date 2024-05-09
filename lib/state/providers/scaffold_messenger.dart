import 'package:quickfix/state/providers/scaffold_messenger_key.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter/material.dart';

part 'scaffold_messenger.g.dart';

@riverpod
ScaffoldMessengerState scaffoldMessenger(ScaffoldMessengerRef ref) {
  return ref.watch(scaffoldMessagerKeyProvider).currentState!;
}
