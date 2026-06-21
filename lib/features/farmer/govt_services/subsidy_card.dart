// import 'package:flutter/material.dart';
// import 'package:smart_kishan/app/theme/app_theme.dart';
// import 'package:smart_kishan/core/localization/app_localizations.dart';
// import 'package:smart_kishan/core/utils/formatters.dart';

// import '../data/subsidy.dart';
// import '../subsidy_labels.dart';

// /// A subsidy summary card: colored header (title + category + status), budget &
// /// rating chips, description, deadline, an expandable details section, and
// /// Apply / More actions.
// class SubsidyCard extends StatefulWidget {
//   const SubsidyCard({
//     super.key,
//     required this.subsidy,
//     required this.onTap,
//     required this.onApply,
//     required this.onRate,
//   });

//   final Subsidy subsidy;
//   final VoidCallback onTap;
//   final VoidCallback onApply;
//   final VoidCallback onRate;

//   @override
//   State<SubsidyCard> createState() => _SubsidyCardState();
// }

// class _SubsidyCardState extends State<SubsidyCard> {
//   bool _expanded = false;

//   @override
//   Widget build(BuildContext context) {
//     final colors = context.colors;
//     final s = widget.subsidy;

//     return Container(
//       margin: const EdgeInsets.only(bottom: 16),
//       decoration: BoxDecoration(
//         color: colors.surface,
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: colors.border.withValues(alpha: 0.5)),
//         boxShadow: [
//           BoxShadow(
//             color: colors.shadow.withValues(alpha: 0.06),
//             blurRadius: 12,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       clipBehavior: Clip.antiAlias,
//       child: Material(
//         color: Colors.transparent,
//         child: InkWell(
//           onTap: widget.onTap,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               _header(context),
//               Padding(
//                 padding: const EdgeInsets.all(16),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     _chipsRow(context),
//                     if (_localized(context, s.description).isNotEmpty) ...[
//                       const SizedBox(height: 12),
//                       Text(
//                         _localized(context, s.description),
//                         style: TextStyle(
//                           fontSize: 14,
//                           height: 1.4,
//                           color: colors.textSecondary,
//                         ),
//                       ),
//                     ],
//                     if (s.deadline != null) ...[
//                       const SizedBox(height: 12),
//                       _deadlineRow(context),
//                     ],
//                     _expandable(context),
//                     const SizedBox(height: 16),
//                     _actions(context),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   String _localized(BuildContext context, dynamic field) {
//     final lang = Localizations.localeOf(context).languageCode;
//     return field?.get(lang) ?? '';
//   }

//   Widget _header(BuildContext context) {
//     final colors = context.colors;
//     final l10n = AppLocalizations.of(context)!;
//     final s = widget.subsidy;
//     final applied = s.hasApplied;
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//       color: colors.primary.withValues(alpha: 0.20),
//       child: Row(
//         children: [
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   s.title?.of(context) ?? '',
//                   // _localized(context, s.title).isEmpty
//                   //     ? l10n.subsidyUntitled
//                   //     : _localized(context, s.title),
//                   style: TextStyle(
//                     color: colors.textPrimary,
//                     fontSize: 14,
//                     fontWeight: FontWeight.w700,
//                   ),
//                 ),
//                 const SizedBox(height: 4),
//                 Container(
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 8,
//                     vertical: 2,
//                   ),
//                   decoration: BoxDecoration(
//                     color: colors.primary.withValues(alpha: 0.2),
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: Text(
//                     subsidyTypeLabel(l10n, s.subsidyType),
//                     style: TextStyle(
//                       color: colors.textPrimary,
//                       fontSize: 12,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(width: 8),
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//             decoration: BoxDecoration(
//               color: applied ? colors.warning : Colors.white,
//               borderRadius: BorderRadius.circular(20),
//             ),
//             child: Text(
//               applied ? l10n.subsidyApplied : l10n.subsidyActive,
//               style: TextStyle(
//                 color: applied ? Colors.white : colors.primary,
//                 fontSize: 12,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _chipsRow(BuildContext context) {
//     final colors = context.colors;
//     final s = widget.subsidy;
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         if (s.budgetPerBeneficiary != null)
//           Flexible(
//             child: Container(
//               padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//               decoration: BoxDecoration(
//                 color: colors.secondary.withValues(alpha: 0.1),
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               child: Text(
//                 'Rs. ${s.budgetPerBeneficiary}',
//                 overflow: TextOverflow.ellipsis,
//                 style: TextStyle(
//                   fontSize: 12,
//                   fontWeight: FontWeight.bold,
//                   color: colors.primary,
//                 ),
//               ),
//             ),
//           ),
//         GestureDetector(
//           onTap: widget.onRate,
//           child: Container(
//             padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
//             decoration: BoxDecoration(
//               color: colors.rating.withValues(alpha: 0.12),
//               borderRadius: BorderRadius.circular(8),
//             ),
//             child: Row(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Icon(Icons.star_rounded, color: colors.rating, size: 12),
//                 const SizedBox(width: 4),
//                 Text(
//                   s.averageRating.toStringAsFixed(1),
//                   style: TextStyle(
//                     fontWeight: FontWeight.bold,
//                     color: colors.rating,
//                   ),
//                 ),
//                 const SizedBox(width: 4),
//                 Text(
//                   '(${s.totalRatings})',
//                   style: TextStyle(fontSize: 11, color: colors.textSecondary),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _deadlineRow(BuildContext context) {
//     final colors = context.colors;
//     final l10n = AppLocalizations.of(context)!;
//     final s = widget.subsidy;
//     final expired = s.isExpired;
//     final text = expired
//         ? l10n.subsidyExpired
//         : '${l10n.subsidyDeadline}: ${context.shortDate(s.deadline)}';
//     final color = expired ? colors.error : colors.warning;
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
//       decoration: BoxDecoration(
//         color: color.withValues(alpha: 0.12),
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: Row(
//         children: [
//           Icon(Icons.schedule_rounded, size: 16, color: color),
//           const SizedBox(width: 6),
//           Expanded(
//             child: Text(
//               text,
//               style: TextStyle(
//                 fontSize: 13,
//                 color: color,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _expandable(BuildContext context) {
//     final colors = context.colors;
//     final l10n = AppLocalizations.of(context)!;
//     final s = widget.subsidy;
//     return AnimatedCrossFade(
//       duration: const Duration(milliseconds: 250),
//       crossFadeState: _expanded
//           ? CrossFadeState.showSecond
//           : CrossFadeState.showFirst,
//       firstChild: const SizedBox(width: double.infinity),
//       secondChild: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const SizedBox(height: 12),
//           Divider(color: colors.divider, height: 1),
//           const SizedBox(height: 10),
//           _detail(
//             context,
//             l10n.subsidyEligibility,
//             _localized(context, s.eligibilityCriteria).isEmpty
//                 ? l10n.subsidyNoInfo
//                 : _localized(context, s.eligibilityCriteria),
//           ),
//           if (_localized(context, s.targetCropOrSector).isNotEmpty)
//             _detail(
//               context,
//               l10n.subsidyTargetSector,
//               _localized(context, s.targetCropOrSector),
//             ),
//           if (s.locationLevel != null)
//             _detail(
//               context,
//               l10n.subsidyLocationLevel,
//               subsidyLevelLabel(l10n, s.locationLevel),
//             ),
//         ],
//       ),
//     );
//   }

//   Widget _detail(BuildContext context, String label, String value) {
//     final colors = context.colors;
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 8),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             label,
//             style: TextStyle(
//               fontWeight: FontWeight.bold,
//               fontSize: 13,
//               color: colors.textPrimary,
//             ),
//           ),
//           const SizedBox(height: 2),
//           Text(
//             value,
//             style: TextStyle(fontSize: 13, color: colors.textSecondary),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _actions(BuildContext context) {
//     final colors = context.colors;
//     final l10n = AppLocalizations.of(context)!;
//     final s = widget.subsidy;
//     final disabled = s.hasApplied || s.isExpired;
//     return Row(
//       children: [
//         Expanded(
//           child: ElevatedButton.icon(
//             onPressed: disabled ? null : widget.onApply,
//             icon: const Icon(Icons.assignment_outlined, size: 18),
//             label: Text(
//               s.hasApplied ? l10n.subsidyAlreadyApplied : l10n.subsidyApplyNow,
//             ),
//             style: ElevatedButton.styleFrom(
//               backgroundColor: colors.primary,
//               foregroundColor: Colors.white,
//               padding: const EdgeInsets.symmetric(vertical: 10),
//             ),
//           ),
//         ),
//         const SizedBox(width: 8),
//         OutlinedButton.icon(
//           onPressed: () => setState(() => _expanded = !_expanded),
//           icon: Icon(
//             _expanded ? Icons.expand_less : Icons.expand_more,
//             size: 18,
//           ),
//           label: Text(_expanded ? l10n.subsidyLess : l10n.subsidyMore),
//           style: OutlinedButton.styleFrom(foregroundColor: colors.primary),
//         ),
//       ],
//     );
//   }
// }
