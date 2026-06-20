import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_kishan/app/router/app_routes.dart';
import 'package:smart_kishan/app/theme/app_theme.dart';
import 'package:smart_kishan/core/localization/app_localizations.dart';
import 'package:smart_kishan/core/utils/app_snackbar.dart';
import 'package:smart_kishan/core/utils/formatters.dart';
import 'package:smart_kishan/core/widgets/app_bar.dart';
import 'package:smart_kishan/core/widgets/app_confirm_dialog.dart';
import 'package:smart_kishan/core/widgets/app_empty_state.dart';
import 'package:smart_kishan/core/widgets/app_icon_action_button.dart';
import 'package:smart_kishan/features/auth/cubit/session_cubit.dart';
import 'package:smart_kishan/features/auth/cubit/session_state.dart';
import 'package:smart_kishan/features/farmer/notes/cubit/notes_cubit.dart';
import 'package:smart_kishan/features/farmer/notes/cubit/notes_state.dart';
import 'package:smart_kishan/features/farmer/notes/data/note.dart';
import 'package:smart_kishan/features/farmer/notes/view/note_args.dart';
import 'package:smart_kishan/features/farmer/notes/widgets/notes_skeleton.dart';

class NotesListScreen extends StatelessWidget {
  const NotesListScreen({super.key, required this.notesCubit});
  final NotesCubit notesCubit;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocProvider.value(
      value: notesCubit,
      child: BlocBuilder<NotesCubit, NotesState>(
        builder: (context, state) {
          final hasNotes = state is NotesLoaded && state.notes.isNotEmpty;
          return Scaffold(
            appBar: AppAppBar(title: l10n.notes),
            floatingActionButton: hasNotes
                ? FloatingActionButton.extended(
                    onPressed: () => context.push(
                      AppRoutePath.addNote,
                      extra: NoteArgs(cubit: notesCubit),
                    ),
                    icon: const Icon(Icons.add),
                    label: Text(l10n.notesAdd),
                  )
                : null,
            body: switch (state) {
              NotesLoading() => NotesListSkeleton(),
              NotesFailure() => AppEmptyState(
                icon: Icons.error_outline,
                title: l10n.errorGeneric,
                actionLabel: l10n.commonRefresh,
                actionIcon: Icons.refresh,
                onAction: () => notesCubit.load(),
              ),
              NotesLoaded(:final notes) =>
                notes.isEmpty
                    ? AppEmptyState(
                        icon: Icons.description_outlined,
                        title: l10n.notesEmpty,
                        description: l10n.notesEmptyDescription,
                        actionLabel: l10n.notesAdd,
                        onAction: () => context.push(
                          AppRoutePath.addNote,
                          extra: NoteArgs(cubit: notesCubit),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: notes.length,
                        itemBuilder: (context, i) =>
                            _NoteCard(note: notes[i], cubit: notesCubit),
                      ),
            },
          );
        },
      ),
    );
  }
}

class _NoteCard extends StatelessWidget {
  const _NoteCard({required this.note, required this.cubit});
  final Note note;
  final NotesCubit cubit;

  Future<void> _confirmDelete(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    final ok = await AppConfirmDialog.delete(
      context,
      title: l10n.notesDeleteConfirmTitle,
      message: l10n.notesDeleteConfirmMessage,
    );
    if (ok) {
      final success = await cubit.delete(note.id!);
      if (!success && context.mounted) AppSnackbar.error(l10n.errorGeneric);
    }
  }

  void _edit(BuildContext context) {
    context.push(
      AppRoutePath.addNote,
      extra: NoteArgs(cubit: cubit, note: note),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = AppLocalizations.of(context)!;
    final sessionState = context.read<SessionCubit>().state;
    final currentUser = sessionState is Authenticated
        ? sessionState.user
        : null;
    final isParent =
        currentUser?.parentId == null || currentUser?.parentId == 0;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => _edit(context),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title row + actions
                Row(
                  children: [
                    Container(
                      width: 4,
                      height: 20,
                      decoration: BoxDecoration(
                        color: colors.primary,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        note.title ?? '',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: colors.textPrimary,
                          height: 1.3,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    AppIconActionButton(
                      icon: Icons.edit_rounded,
                      color: colors.primary,
                      tooltip: l10n.commonEdit,
                      onTap: () => _edit(context),
                    ),
                    const SizedBox(width: 8),
                    AppIconActionButton(
                      icon: Icons.delete_rounded,
                      color: colors.error,
                      tooltip: l10n.commonDelete,
                      onTap: () => _confirmDelete(context),
                    ),
                  ],
                ),
                // Description
                if (note.description != null &&
                    note.description!.isNotEmpty) ...[
                  Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: Text(
                      note.description!,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 13,
                        color: colors.textSecondary,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
                // Date footer
                if (note.date != null) ...[
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: Row(
                      children: [
                        // Date
                        if (note.date != null) ...[
                          Icon(
                            Icons.calendar_today_rounded,
                            size: 14,
                            color: colors.iconSecondary,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            context.shortDate(note.date),
                            style: TextStyle(
                              fontSize: 11,
                              color: colors.textSecondary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                        // Added by (parent accounts only, when a sub-user authored it)
                        if (isParent && note.user != null) ...[
                          const SizedBox(width: 12),
                          Container(
                            width: 4,
                            height: 4,
                            decoration: BoxDecoration(
                              color: colors.iconSecondary,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Icon(
                            Icons.person_outline_rounded,
                            size: 14,
                            color: colors.iconSecondary,
                          ),
                          const SizedBox(width: 6),
                          Flexible(
                            child: Text(
                              note.user!.name ?? '',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 11,
                                color: colors.textSecondary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
