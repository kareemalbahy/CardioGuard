part of 'auth_cubit.dart';

enum AuthStatus { initial, loading, authenticated, failure }

class AuthState extends Equatable {
  final AuthStatus status;
  final AppUser? user;
  final String? message;

  const AuthState({
    required this.status,
    this.user,
    this.message,
  });

  const AuthState.initial()
      : status = AuthStatus.initial,
        user = null,
        message = null;

  const AuthState.loading()
      : status = AuthStatus.loading,
        user = null,
        message = null;

  const AuthState.authenticated(AppUser u)
      : status = AuthStatus.authenticated,
        user = u,
        message = null;

  const AuthState.failure(String m)
      : status = AuthStatus.failure,
        user = null,
        message = m;

  @override
  List<Object?> get props => [status, user, message];
}
