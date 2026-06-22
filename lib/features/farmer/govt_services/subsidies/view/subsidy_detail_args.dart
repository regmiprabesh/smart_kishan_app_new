import 'package:flutter/widgets.dart';

import '../data/subsidy.dart';

/// Passed to the detail/apply routes. The list already holds the full
/// [Subsidy] (form fields, documents, ratings summary), so detail reuses it.
/// [onApplied] lets a successful application notify the launching screen
/// (e.g. the list) so it can mark this subsidy applied without a refetch.
class SubsidyDetailArgs {
  const SubsidyDetailArgs({required this.subsidy, this.onApplied});
  final Subsidy subsidy;
  final VoidCallback? onApplied;
}
