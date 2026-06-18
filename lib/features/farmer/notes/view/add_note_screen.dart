import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_kishan/core/localization/app_localizations.dart';
import 'package:smart_kishan/core/utils/app_snackbar.dart';
import 'package:smart_kishan/core/widgets/app_bar.dart';
import 'package:smart_kishan/core/widgets/app_text_field.dart';
import 'package:smart_kishan/core/widgets/app_primary_button.dart';
import 'package:smart_kishan/features/farmer/notes/data/note.dart';
import 'package:smart_kishan/features/farmer/notes/view/note_args.dart';

class AddNoteScreen extends StatefulWidget {
  const AddNoteScreen({super.key, required this.args});
  final NoteArgs args;

  @override
  State<AddNoteScreen> createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _title;
  late final TextEditingController _description;
  late final TextEditingController _priority;
  bool _saving = false;

  bool get _isEdit => widget.args.note != null;

  @override
  void initState() {
    super.initState();
    final n = widget.args.note;
    _title = TextEditingController(text: n?.title ?? '');
    _description = TextEditingController(text: n?.description ?? '');
    _priority = TextEditingController(text: n?.priority?.toString() ?? '');
  }

  @override
  void dispose() {
    _title.dispose();
    _description.dispose();
    _priority.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;

    setState(() => _saving = true);
    final l10n = AppLocalizations.of(context)!;
    final cubit = widget.args.cubit;

    final note = Note(
      id: widget.args.note?.id,
      title: _title.text.trim(),
      description: _description.text.trim(),
      priority: int.tryParse(_priority.text.trim()),
    );

    final ok = _isEdit ? await cubit.update(note) : await cubit.add(note);

    if (!mounted) return;
    if (ok) {
      AppSnackbar.success(
        _isEdit ? l10n.notesUpdatedSuccessfully : l10n.notesAddedSuccessfully,
      );
      context.pop();
    } else {
      setState(() => _saving = false);
      AppSnackbar.error(l10n.errorGeneric);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppAppBar(title: _isEdit ? l10n.notesUpdate : l10n.notesAdd),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppTextField(
                controller: _title,
                label: l10n.notesTitleLabel,
                hint: l10n.notesTitleHint,
                validator: (v) {
                  if (v == null || v.trim().isEmpty) {
                    return l10n.notesTitleRequired;
                  }
                  if (v.trim().length < 3) return l10n.notesTitleInvalid;
                  return null;
                },
              ),
              const SizedBox(height: 16),
              AppTextField(
                controller: _description,
                label: l10n.notesDescriptionLabel,
                hint: l10n.notesDescriptionHint,
                maxLines: 4,
                textInputAction: TextInputAction.newline,
              ),
              const SizedBox(height: 16),
              AppTextField(
                controller: _priority,
                label: l10n.notesPriorityLabel,
                hint: l10n.notesPriorityHint,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
              const SizedBox(height: 28),
              AppPrimaryButton(
                label: _isEdit ? l10n.commonUpdate : l10n.commonAdd,
                isLoading: _saving,
                onPressed: _submit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
