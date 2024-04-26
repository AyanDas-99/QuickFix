import 'package:equatable/equatable.dart';
import 'package:quickfix/state/auth/models/auth_result.dart';
import 'package:quickfix/state/typedefs.dart';

class AuthState extends Equatable {
  final AuthResult? authResult;
  final IsLoading isLoading;
  final String? userId;

  const AuthState(
      {required this.authResult,
      required this.isLoading,
      required this.userId});

  const AuthState.unknown()
      : authResult = null,
        isLoading = false,
        userId = null;

  AuthState copyWithIsLoading(IsLoading loading) =>
      AuthState(authResult: authResult, isLoading: loading, userId: userId);

  @override
  List<Object?> get props => [authResult, isLoading, userId];
}
