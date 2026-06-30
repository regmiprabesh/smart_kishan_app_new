import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_kishan/app/router/app_routes.dart';
import 'package:smart_kishan/core/localization/app_localizations.dart';
import 'package:smart_kishan/core/widgets/app_confirm_dialog.dart';
import 'package:smart_kishan/features/auth/cubit/session_cubit.dart';
import 'package:smart_kishan/features/auth/cubit/session_state.dart';

/// True when the session user has a complete administrative location
/// (province → district → municipality → ward). Subsidies are location-scoped,
/// so this gates the apply flow (browsing is always allowed).
bool userHasSubsidyLocation(SessionState state) {
  if (state is! Authenticated) return false;
  return state.user.governmentUnitId != null;
}

/// Apply-time location gate. A farmer can browse every subsidy without a
/// location set, but *applying* needs one (the application is filed against the
/// farmer's province/district/municipality/ward).
///
/// - Location already set → returns `true` immediately.
/// - Otherwise → explains that a location must be added to the profile and, if
///   the user agrees, sends them to the Update Location screen. That screen
///   refreshes the global session on success, so on return we re-read the
///   session and report whether a location is now present.
///
/// Returns `true` only when the caller may proceed to apply.
Future<bool> ensureSubsidyLocation(BuildContext context) async {
  if (userHasSubsidyLocation(context.read<SessionCubit>().state)) return true;

  final l10n = AppLocalizations.of(context)!;
  final goAdd = await AppConfirmDialog.show(
    context,
    title: l10n.subsidyLocationRequired,
    message: l10n.subsidyLocationRequiredDescription,
    confirmLabel: l10n.subsidyAddLocation,
    cancelLabel: l10n.commonCancel,
  );
  if (!goAdd || !context.mounted) return false;

  await context.push<bool>(AppRoutePath.updateLocation);
  if (!context.mounted) return false;

  return userHasSubsidyLocation(context.read<SessionCubit>().state);
}
