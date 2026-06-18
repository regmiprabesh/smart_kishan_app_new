import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_kishan/app/router/app_routes.dart';
import 'package:smart_kishan/app/theme/app_theme.dart';
import 'package:smart_kishan/core/localization/app_localizations.dart';
import 'package:smart_kishan/core/utils/app_snackbar.dart';
import 'package:smart_kishan/core/widgets/app_bar.dart';
import 'package:smart_kishan/core/widgets/app_confirm_dialog.dart';
import 'package:smart_kishan/core/widgets/app_empty_state.dart';
import '../cubit/farmland_cubit.dart';
import '../cubit/farmland_state.dart';
import '../data/farmland.dart';
import '../widgets/farmland_card.dart';
import '../widgets/farmland_list_skeleton.dart';
import 'farmland_args.dart';

/// Lists farmlands with a shimmer skeleton while loading. Cards open the
/// add/edit screen; ⋮ menu edits/deletes.
class FarmlandListScreen extends StatelessWidget {
  const FarmlandListScreen({super.key, required this.cubit});
  final FarmlandCubit cubit;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocProvider.value(
      value: cubit,
      child: Scaffold(
        appBar: AppAppBar(title: l10n.farmLands),
        body: BlocBuilder<FarmlandCubit, FarmlandState>(
          builder: (context, state) {
            return switch (state) {
              FarmlandLoading() => const FarmlandListSkeleton(),
              FarmlandFailure() => AppEmptyState(
                icon: Icons.error_outline,
                title: l10n.errorGeneric,
                actionLabel: l10n.commonRefresh,
                actionIcon: Icons.refresh,
                onAction: () => cubit.load(),
              ),
              FarmlandLoaded(:final farmlands) =>
                farmlands.isEmpty
                    ? AppEmptyState(
                        icon: Icons.landscape_outlined,
                        title: l10n.farmlandEmpty,
                        description: l10n.farmlandEmptyDescription,
                        actionLabel: l10n.farmlandAdd,
                        onAction: () => _openEditor(context),
                      )
                    : ListView.builder(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        itemCount: farmlands.length,
                        itemBuilder: (_, i) {
                          final f = farmlands[i];
                          return Column(
                            children: [
                              FarmlandCard(
                                farmland: f,
                                onTap: () => context.push(
                                  AppRoutePath.farmlandDetail,
                                  extra: FarmlandArgs(
                                    cubit: cubit,
                                    farmland: f,
                                  ),
                                ),
                                onEdit: () => _openEditor(context, farmland: f),
                                onDelete: () => _confirmDelete(context, f),
                              ),
                              Divider(
                                height: 1,
                                thickness: 1,
                                indent: 16,
                                endIndent: 16,
                                color: context.colors.divider,
                              ),
                            ],
                          );
                        },
                      ),
            };
          },
        ),
        floatingActionButton: BlocBuilder<FarmlandCubit, FarmlandState>(
          builder: (context, state) {
            final hasItems =
                state is FarmlandLoaded && state.farmlands.isNotEmpty;
            return hasItems
                ? FloatingActionButton.extended(
                    onPressed: () => _openEditor(context),
                    icon: const Icon(Icons.add),
                    label: Text(l10n.farmlandAdd),
                  )
                : const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  void _openEditor(BuildContext context, {Farmland? farmland}) {
    context.push(
      AppRoutePath.addFarmland,
      extra: FarmlandArgs(cubit: cubit, farmland: farmland),
    );
  }

  Future<void> _confirmDelete(BuildContext context, Farmland f) async {
    final l10n = AppLocalizations.of(context)!;
    final ok = await AppConfirmDialog.show(
      context,
      title: l10n.farmlandDeleteConfirmTitle,
      message: l10n.farmlandDeleteConfirmMessage,
      confirmLabel: l10n.commonDelete,
      cancelLabel: l10n.commonCancel,
      destructive: true,
    );
    if (ok) {
      final success = await cubit.delete(f.id!);
      if (!success && context.mounted) AppSnackbar.error(l10n.errorGeneric);
    }
  }
}
