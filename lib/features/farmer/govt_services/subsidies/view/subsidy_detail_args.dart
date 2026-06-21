import '../data/subsidy.dart';

/// Passed to the detail route. The list already holds the full [Subsidy]
/// (form fields, documents, ratings summary), so detail reuses it and only
/// fetches the reviews list separately.
class SubsidyDetailArgs {
  const SubsidyDetailArgs({required this.subsidy});
  final Subsidy subsidy;
}
