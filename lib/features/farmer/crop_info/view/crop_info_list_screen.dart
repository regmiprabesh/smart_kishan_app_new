import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_kishan/app/router/app_routes.dart';
import 'package:smart_kishan/core/localization/app_localizations.dart';
import 'package:smart_kishan/core/widgets/app_bar.dart';
import 'package:smart_kishan/core/widgets/app_empty_state.dart';
import 'package:smart_kishan/core/widgets/app_search_field.dart';
import '../cubit/crop_info_cubit.dart';
import '../cubit/crop_info_state.dart';
import '../widgets/crop_grid_card.dart';
import '../widgets/crop_grid_skeleton.dart';
import 'crop_info_args.dart';

/// Crop info grid with a search bar and shimmer loading.
class CropInfoListScreen extends StatefulWidget {
  const CropInfoListScreen({super.key, required this.cubit});
  final CropInfoCubit cubit;

  @override
  State<CropInfoListScreen> createState() => _CropInfoListScreenState();
}

class _CropInfoListScreenState extends State<CropInfoListScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocProvider.value(
      value: widget.cubit,
      child: Scaffold(
        appBar: AppAppBar(title: l10n.cropInfoTitle),
        body: Column(
          children: [
            AppSearchField(
              hintText: l10n.cropInfoSearchHint,
              controller: _searchController,
              onChanged: widget.cubit.search,
            ),
            Expanded(
              child: BlocBuilder<CropInfoCubit, CropInfoState>(
                builder: (context, state) {
                  return switch (state) {
                    CropInfoLoading() => const CropGridSkeleton(),
                    CropInfoFailure() => AppEmptyState(
                      icon: Icons.error_outline,
                      title: l10n.errorGeneric,
                      actionLabel: l10n.commonRefresh,
                      actionIcon: Icons.refresh,
                      onAction: () => widget.cubit.load(),
                    ),
                    CropInfoLoaded() => _Grid(
                      state: state,
                      cubit: widget.cubit,
                    ),
                  };
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Grid extends StatelessWidget {
  const _Grid({required this.state, required this.cubit});
  final CropInfoLoaded state;
  final CropInfoCubit cubit;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final crops = cubit.filtered(state);

    if (crops.isEmpty) {
      return AppEmptyState(
        icon: state.query.isEmpty ? Icons.eco_outlined : Icons.search_off,
        title: state.query.isEmpty
            ? l10n.cropInfoEmpty
            : l10n.cropInfoNoResults,
        compact: true,
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: crops.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.82,
      ),
      itemBuilder: (_, i) => CropGridCard(
        crop: crops[i],
        onTap: () => context.push(
          AppRoutePath.cropInfoDetail,
          extra: CropInfoArgs(crop: crops[i]),
        ),
      ),
    );
  }
}
