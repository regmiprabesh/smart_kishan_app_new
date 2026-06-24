import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

/// Per-feature presentation config for the shared rating UI.
///
/// [rateTitle] is the rate-page app-bar title. The optional [title] /
/// [description] / [imageUrl] drive the "what am I rating?" header shown on the
/// rate and reviews pages — all optional, so a feature can supply none, some,
/// or all. When there is no image, [fallbackIcon] is shown instead (e.g. a
/// subsidy glyph). [tagContext] selects which catalog of quick-pick tag chips
/// to show on the rate page ('subsidy', 'service_center'); null hides them.
class RatingsConfig {
  const RatingsConfig({
    required this.rateTitle,
    required this.targetType,
    this.tagContext,
    this.title,
    this.description,
    this.imageUrl,
    this.fallbackIcon = Icons.star_rounded,
  });

  final String rateTitle;
  final String targetType;
  final String? tagContext;
  final String? title;
  final String? description;
  final String? imageUrl;
  final IconData fallbackIcon;
}
