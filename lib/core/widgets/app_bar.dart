// core/widgets/app_app_bar.dart
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppAppBar extends StatelessWidget implements PreferredSizeWidget {
  const AppAppBar({super.key, required this.title, this.actions, this.onBack});
  final String title;
  final List<Widget>? actions;
  final VoidCallback? onBack;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      leading: context.canPop()
          ? IconButton(
              icon: const Icon(CupertinoIcons.back),
              onPressed: onBack ?? () => context.pop(),
            )
          : null,
      title: Text(title),
      actions: actions,
    );
  }
}
