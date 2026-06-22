import '../data/subsidy_request.dart';

/// Passed to the request-detail route. The list carries the full
/// [SubsidyRequest], so detail reuses it. Cancellation signals back via
/// `pop(true)`.
class RequestDetailArgs {
  const RequestDetailArgs({required this.request});
  final SubsidyRequest request;
}
