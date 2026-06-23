/// Route args for the service-center detail screen. We pass only the id (an
/// int, trivially serializable) and let the detail screen's cubit fetch the
/// full record — so deep links / refreshes work without needing the object in
/// `extra`. Consistent with the farmland-detail decision (id over object).
class ServiceCenterDetailArgs {
  const ServiceCenterDetailArgs({required this.id, this.onRated});
  final int id;

  /// Called with the server's recomputed aggregate when the user rates/deletes
  /// on the detail screen, so the list can patch the card in place.
  final void Function(double average, int total)? onRated;
}
