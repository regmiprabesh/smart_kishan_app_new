import 'package:equatable/equatable.dart';
import 'package:smart_kishan/shared/models/user.dart';

/// Global auth state. go_router's redirect reads this on every navigation.
sealed class SessionState extends Equatable {
  const SessionState();
  @override
  List<Object?> get props => [];
}

/// Still restoring from storage — router holds everything at /splash.
class SessionUnknown extends SessionState {
  const SessionUnknown();
}

class Unauthenticated extends SessionState {
  const Unauthenticated();
}

class Authenticated extends SessionState {
  const Authenticated({required this.user, required this.mode});
  final User user;
  final String mode;

  @override
  List<Object?> get props => [user, mode];
}
