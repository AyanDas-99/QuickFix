import 'package:quickfix/state/constants.dart';
import 'package:quickfix/state/order/models/order.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:ntp/ntp.dart';

part 'can_cancel.g.dart';

@riverpod
FutureOr<bool> canCancel(CanCancelRef ref, Order order) async {
  final DateTime current = await NTP.now();
  final offset = current.difference(order.timestamp);
  return offset.inMinutes < cancelWithinHours * 60;
}
