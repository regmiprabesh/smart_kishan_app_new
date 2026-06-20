import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_kishan/app/router/app_routes.dart';
import 'package:smart_kishan/app/theme/app_theme.dart';
import 'package:smart_kishan/core/localization/app_localizations.dart';
import 'package:smart_kishan/features/farmer/notes/cubit/notes_cubit.dart';
import 'package:smart_kishan/features/farmer/notes/cubit/notes_state.dart';
import 'package:smart_kishan/features/farmer/notes/data/note.dart';
import 'package:smart_kishan/features/farmer/notes/widgets/notes_skeleton.dart';

class NotesSection extends StatelessWidget {
  const NotesSection({super.key});

  void _openList(BuildContext context) {
    context.push(AppRoutePath.notes, extra: context.read<NotesCubit>());
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colors = context.colors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Container(
                height: 24,
                width: 4,
                decoration: BoxDecoration(
                  color: colors.primary,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  l10n.notes,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: colors.textPrimary,
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: colors.primary,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: IconButton(
                  padding: const EdgeInsets.all(4),
                  constraints: const BoxConstraints(),
                  onPressed: () => _openList(context),
                  icon: const Icon(Icons.add, color: Colors.white, size: 20),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // Single full-width preview card
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: GestureDetector(
            onTap: () => _openList(context),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: colors.surface,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: colors.shadow,
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(16),
              child: BlocBuilder<NotesCubit, NotesState>(
                builder: (context, state) {
                  return switch (state) {
                    NotesLoading() => NotesSectionSkeleton(),
                    NotesLoaded(:final topNotes) =>
                      topNotes.isEmpty
                          ? _EmptyPreview(l10n: l10n, colors: colors)
                          : _PreviewList(notes: topNotes, colors: colors),
                    _ => _EmptyPreview(l10n: l10n, colors: colors),
                  };
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// The top-2 notes as compact rows separated by dividers.
class _PreviewList extends StatelessWidget {
  const _PreviewList({required this.notes, required this.colors});
  final List<Note> notes;
  final dynamic colors;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < notes.length; i++) ...[
          if (i > 0)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Divider(color: colors.divider, height: 1),
            ),
          _PreviewRow(note: notes[i], colors: colors),
        ],
      ],
    );
  }
}

class _PreviewRow extends StatelessWidget {
  const _PreviewRow({required this.note, required this.colors});
  final Note note;
  final dynamic colors;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 5),
          height: 8,
          width: 8,
          decoration: BoxDecoration(
            color: colors.primary,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                note.title ?? '',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: colors.textPrimary,
                  height: 1.3,
                ),
              ),
              if (note.description != null && note.description!.isNotEmpty) ...[
                const SizedBox(height: 2),
                Text(
                  note.description!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 13, color: colors.textSecondary),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _EmptyPreview extends StatelessWidget {
  const _EmptyPreview({required this.l10n, required this.colors});
  final AppLocalizations l10n;
  final dynamic colors;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          children: [
            Icon(
              CupertinoIcons.doc_text,
              size: 40,
              color: colors.iconSecondary,
            ),
            const SizedBox(height: 8),
            Text(
              l10n.notesEmpty,
              style: TextStyle(fontSize: 14, color: colors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}
