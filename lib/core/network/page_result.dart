/// One page of a paginated list response (Laravel native `{data, meta}`).
class PageResult<T> {
  const PageResult({
    required this.items,
    required this.page,
    required this.lastPage,
  });

  final List<T> items;
  final int page;
  final int lastPage;

  bool get hasMore => page < lastPage;
}
