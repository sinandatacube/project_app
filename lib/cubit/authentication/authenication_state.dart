part of 'authenication_cubit.dart';

@immutable
sealed class AuthenicationState {}

final class AuthenicationInitial extends AuthenicationState {}

final class AuthSuccess extends AuthenicationState {
  final String note;
  AuthSuccess({required this.note});
}

final class AuthFailed extends AuthenicationState {
  final String error;

  AuthFailed({required this.error});
}

final class AuthLoading extends AuthenicationState {}
