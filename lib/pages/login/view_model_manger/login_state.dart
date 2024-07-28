part of 'login_cubit.dart';

@immutable
abstract class LoginState {}

class LoginInitial extends LoginState {}
class LoginChangePasswordVisibility extends LoginState{}
class LoginShowLoadingDialogue extends LoginState{}
class LoginSuccessfully extends LoginState{}
class LoginFailed extends LoginState{}