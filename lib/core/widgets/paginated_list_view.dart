import 'package:flutter/material.dart';

/// A scrollable list that loads the next page when the user nears the bottom,
/// shows a footer spinner while [isLoadingMore], and supports pull-to-refresh.
/// The feature owns the data + cubit; this only handles the scroll plumbing.
class PaginatedListView extends StatelessWidget {
  const PaginatedListView({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    required this.hasMore,
    required this.isLoadingMore,
    required this.onLoadMore,
    this.onRefresh,
    this.padding = const EdgeInsets.all(16),
    this.separatorBuilder,
  });

  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;
  final bool hasMore;
  final bool isLoadingMore;
  final VoidCallback onLoadMore;
  final Future<void> Function()? onRefresh;
  final EdgeInsets padding;
  final IndexedWidgetBuilder? separatorBuilder;

  @override
  Widget build(BuildContext context) {
    // Trigger ~300px before the end so the next page is ready in time.
    final list = NotificationListener<ScrollNotification>(
      onNotification: (n) {
        if (hasMore &&
            !isLoadingMore &&
            n.metrics.pixels >= n.metrics.maxScrollExtent - 300) {
          onLoadMore();
        }
        return false;
      },
      child: ListView.separated(
        padding: padding,
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: itemCount + (hasMore ? 1 : 0),
        separatorBuilder: (c, i) =>
            separatorBuilder?.call(c, i) ?? const SizedBox.shrink(),
        itemBuilder: (context, i) {
          if (i >= itemCount) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Center(child: CircularProgressIndicator()),
            );
          }
          return itemBuilder(context, i);
        },
      ),
    );
    if (onRefresh == null) return list;
    return RefreshIndicator(onRefresh: onRefresh!, child: list);
  }
}
