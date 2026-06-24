import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_kishan/app/theme/app_theme.dart';
import 'package:smart_kishan/core/di/injector.dart';
import 'package:smart_kishan/core/localization/app_localizations.dart';
import 'package:smart_kishan/core/utils/app_snackbar.dart';
import 'package:smart_kishan/core/widgets/app_bar.dart';
import 'package:smart_kishan/core/widgets/app_primary_button.dart';
import 'package:smart_kishan/core/widgets/app_text_field.dart';

import '../cubit/ratings_cubit.dart';
import '../data/rating_tag_catalog.dart';
import '../ratings_config.dart';
import '../data/ratings_repository.dart';
import '../data/review.dart';
import '../widgets/ratings_entity_header.dart';
import '../widgets/satisfaction.dart';
import '../widgets/satisfaction_rating.dart';

/// Full-page rating flow (replaces the old dialog): a big star scale with a
/// live emoji + satisfaction label, quick tag chips to reduce typing, a review
/// text area, and a sticky submit button. Generic — driven by [RatingsCubit]
/// and the feature's [RatingsConfig].
class RatePage extends StatefulWidget {
  const RatePage({super.key, required this.config, this.existing});

  final RatingsConfig config;
  final Review? existing;

  @override
  State<RatePage> createState() => _RatePageState();
}

class _RatePageState extends State<RatePage> {
  late int _rating = widget.existing?.rating ?? 0;
  late final Set<String> _tags = {...?widget.existing?.tags};
  late final _textController = TextEditingController(
    text: widget.existing?.text ?? '',
  );

  @override
  void initState() {
    super.initState();
    // Make sure the tag catalog is available so chips render with labels.
    if (widget.config.tagContext != null) {
      final catalog = sl<RatingTagCatalog>();
      if (!catalog.isLoaded) {
        catalog.ensureLoaded().then((_) {
          if (mounted) setState(() {});
        });
      }
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final cubit = context.read<RatingsCubit>();
    final l10n = AppLocalizations.of(context)!;
    final text = _textController.text.trim();
    final outcome = await cubit.submit(
      rating: _rating,
      text: text.isEmpty ? null : text,
      tags: _tags.toList(),
    );
    if (!mounted) return;
    switch (outcome) {
      case RatingMutationResult.submitted:
        AppSnackbar.success(l10n.ratingSubmittedSuccess);
        Navigator.of(context).pop();
      case RatingMutationResult.updated:
        AppSnackbar.success(l10n.ratingUpdatedSuccess);
        Navigator.of(context).pop();
      default:
        AppSnackbar.error(l10n.errorGeneric);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colors = context.colors;
    final submitting = context.select<RatingsCubit, bool>(
      (c) => c.state.submitting,
    );

    return Scaffold(
      appBar: AppAppBar(title: widget.config.rateTitle),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
        children: [
          RatingsEntityHeader(config: widget.config),
          const SizedBox(height: 20),
          Text(
            l10n.ratingHowWasExperience,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: colors.textPrimary,
            ),
          ),
          const SizedBox(height: 20),
          SatisfactionRating(
            rating: _rating,
            onChanged: (v) => setState(() => _rating = v),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 22,
            child: Center(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 150),
                child: _rating == 0
                    ? const SizedBox.shrink()
                    : Text(
                        satisfactionLabel(l10n, _rating),
                        key: ValueKey(_rating),
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: SatisfactionRating.colorOf(context, _rating),
                        ),
                      ),
              ),
            ),
          ),
          if (sl<RatingTagCatalog>()
              .forContext(widget.config.tagContext)
              .isNotEmpty) ...[
            const SizedBox(height: 24),
            Text(
              l10n.ratingTagsPrompt,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: colors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            Builder(
              builder: (context) {
                final lang = Localizations.localeOf(context).languageCode;
                final options = sl<RatingTagCatalog>().forContext(
                  widget.config.tagContext,
                );
                return Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final tag in options)
                      _TagChip(
                        label: tag.label(lang),
                        selected: _tags.contains(tag.key),
                        onTap: () => setState(
                          () => _tags.contains(tag.key)
                              ? _tags.remove(tag.key)
                              : _tags.add(tag.key),
                        ),
                      ),
                  ],
                );
              },
            ),
          ],
          const SizedBox(height: 24),
          AppTextField(
            controller: _textController,
            maxLines: 5,
            maxLength: 500,
            label: l10n.writeReviewOptional,
          ),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: colors.surface,
          border: Border(
            top: BorderSide(color: colors.border.withValues(alpha: 0.5)),
          ),
        ),
        child: SafeArea(
          minimum: const EdgeInsets.fromLTRB(20, 12, 20, 12),
          child: AppPrimaryButton(
            label: l10n.ratingSubmitButton,
            isLoading: submitting,
            onPressed: _rating == 0 ? null : _submit,
          ),
        ),
      ),
    );
  }
}

class _TagChip extends StatelessWidget {
  const _TagChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Material(
      color: selected ? colors.primary : colors.primary.withValues(alpha: 0.08),
      borderRadius: BorderRadius.circular(20),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (selected) ...[
                const Icon(Icons.check, size: 15, color: Colors.white),
                const SizedBox(width: 5),
              ],
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: selected ? Colors.white : colors.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
