import '../data/subsidy.dart';

/// Passed to the application-detail route. Carries the full [Subsidy] with its
/// populated [Subsidy.application] (status, dates, submitted form & documents).
/// Withdrawal is signalled back to the list via `pop(true)` (single-level nav).
class ApplicationDetailArgs {
  const ApplicationDetailArgs({required this.subsidy});
  final Subsidy subsidy;
}
