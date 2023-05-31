part of 'login_bloc.dart';

@immutable
abstract class LoginEvent {}

class SaveLoginEvent extends LoginEvent {
  final LoginModel request;
  SaveLoginEvent({
    required this.request,
  });
}
