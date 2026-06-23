import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

/// Per-feature presentation config for the shared rating UI.
///
/// [rateTitle] is the rate-page app-bar title. The optional [title] /
/// [description] / [imageUrl] drive the "what am I rating?" header shown on the
/// rate and reviews pages — all optional, so a feature can supply none, some,
/// or all. When there is no image, [fallbackIcon] is shown instead (e.g. a
/// subsidy glyph). [suggestedTags] are the quick-pick chips on the rate page.
class RatingsConfig {
  const RatingsConfig({
    required this.rateTitle,
    this.suggestedTags = const [],
    this.title,
    this.description,
    this.imageUrl,
    this.fallbackIcon = Icons.star_rounded,
  });

  final String rateTitle;
  final List<String> suggestedTags;

  final String? title;
  final String? description;
  final String? imageUrl;
  final IconData fallbackIcon;
}
