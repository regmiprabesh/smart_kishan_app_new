import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_kishan/app/theme/app_theme.dart';
import 'package:smart_kishan/core/localization/app_localizations.dart';
import 'package:smart_kishan/core/utils/app_snackbar.dart';
import 'package:smart_kishan/core/widgets/app_bar.dart';
import 'package:smart_kishan/core/widgets/app_dropdown.dart';
import 'package:smart_kishan/core/widgets/app_primary_button.dart';
import 'package:smart_kishan/core/widgets/app_text_field.dart';
import 'package:smart_kishan/features/auth/cubit/session_cubit.dart';
import 'package:smart_kishan/features/auth/cubit/session_state.dart';
import 'package:smart_kishan/features/profile/cubit/update_location_cubit.dart';
import 'package:smart_kishan/features/profile/cubit/update_location_state.dart';
import 'package:smart_kishan/shared/models/multilingual_field.dart';

/// Cascading province → district → municipality → ward picker. On save it
/// persists the location, refreshes the session, and pops `true` so the caller
/// (e.g. the subsidies apply gate) knows a location is now set.
class UpdateLocationScreen extends StatefulWidget {
  const UpdateLocationScreen({super.key});

  @override
  State<UpdateLocationScreen> createState() => _UpdateLocationScreenState();
}

class _UpdateLocationScreenState extends State<UpdateLocationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final session = context.read<SessionCubit>().state;
    if (session is Authenticated) {
      _addressController.text = session.user.address ?? '';
    }
  }

  @override
  void dispose() {
    _addressController.dispose();
    super.dispose();
  }

  void _save(UpdateLocationCubit cubit) {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState!.validate()) {
      cubit.submit(address: _addressController.text.trim());
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocConsumer<UpdateLocationCubit, UpdateLocationState>(
      listenWhen: (p, c) => p.outcome != c.outcome,
      listener: (context, state) {
        switch (state.outcome) {
          case UpdateLocationOutcome.success:
            AppSnackbar.success(l10n.locationUpdatedSuccessfully);
            context.pop(true);
          case UpdateLocationOutcome.failure:
            AppSnackbar.error(l10n.locationUpdateFailed);
          case UpdateLocationOutcome.none:
            break;
        }
      },
      builder: (context, state) {
        final cubit = context.read<UpdateLocationCubit>();
        return Scaffold(
          appBar: AppAppBar(title: l10n.profileUpdateLocation),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _LocationField(
                    label: l10n.locationProvince,
                    hint: l10n.locationSelectProvince,
                    loading: state.loadingProvinces,
                    value: state.provinceId,
                    ids: [for (final p in state.provinces) p.id!],
                    labelFor: (id) => _name(
                      state.provinces.firstWhere((p) => p.id == id).name,
                    ),
                    onChanged: cubit.selectProvince,
                    validatorMsg: l10n.locationSelectProvince,
                  ),
                  const SizedBox(height: 20),
                  _LocationField(
                    label: l10n.locationDistrict,
                    hint: l10n.locationSelectDistrict,
                    loading: state.loadingDistricts,
                    value: state.districtId,
                    ids: [for (final d in state.districts) d.id!],
                    labelFor: (id) => _name(
                      state.districts.firstWhere((d) => d.id == id).name,
                    ),
                    onChanged: cubit.selectDistrict,
                    validatorMsg: l10n.locationSelectDistrict,
                  ),
                  const SizedBox(height: 20),
                  _LocationField(
                    label: l10n.locationMunicipality,
                    hint: l10n.locationSelectMunicipality,
                    loading: state.loadingMunicipalities,
                    value: state.municipalityId,
                    ids: [for (final m in state.municipalities) m.id!],
                    labelFor: (id) {
                      final m = state.municipalities.firstWhere(
                        (m) => m.id == id,
                      );
                      final name = _name(m.name);
                      return m.type != null ? '$name (${m.type})' : name;
                    },
                    onChanged: cubit.selectMunicipality,
                    validatorMsg: l10n.locationSelectMunicipality,
                  ),
                  const SizedBox(height: 20),
                  _LocationField(
                    label: l10n.locationWard,
                    hint: l10n.locationSelectWard,
                    loading: state.loadingWards,
                    value: state.wardId,
                    ids: [for (final w in state.wards) w.id!],
                    labelFor: (id) {
                      final w = state.wards.firstWhere((w) => w.id == id);
                      final name = _name(w.name);
                      return name.isNotEmpty
                          ? name
                          : (w.wardNumber?.toString() ?? '');
                    },
                    onChanged: cubit.selectWard,
                    validatorMsg: l10n.locationSelectWard,
                  ),
                  const SizedBox(height: 20),
                  AppTextField(
                    controller: _addressController,
                    label: l10n.locationAddress,
                    hint: l10n.locationAddressHint,
                    maxLines: 2,
                    textInputAction: TextInputAction.done,
                  ),
                  const SizedBox(height: 32),
                  AppPrimaryButton(
                    label: l10n.profileUpdateLocation,
                    isLoading: state.submitting,
                    onPressed: () => _save(cubit),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  String _name(MultilingualField? name) => name == null ? '' : name.of(context);
}

/// One labelled dropdown in the cascade, with a thin progress bar while its
/// options load. Selection is keyed on the integer id.
class _LocationField extends StatelessWidget {
  const _LocationField({
    required this.label,
    required this.hint,
    required this.loading,
    required this.value,
    required this.ids,
    required this.labelFor,
    required this.onChanged,
    required this.validatorMsg,
  });

  final String label;
  final String hint;
  final bool loading;
  final int? value;
  final List<int> ids;
  final String Function(int) labelFor;
  final ValueChanged<int?> onChanged;
  final String validatorMsg;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppDropdown<int>(
          // Re-create the field when the selection changes (incl. a cascade
          // reset to null) so its internal FormField validates the live value
          // rather than a stale one.
          key: ValueKey('$label::$value'),
          label: label,
          hint: hint,
          value: value,
          items: ids,
          itemLabel: labelFor,
          validator: (v) => v == null ? validatorMsg : null,
          onChanged: onChanged,
        ),
        if (loading)
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: LinearProgressIndicator(
              minHeight: 2,
              backgroundColor: colors.border,
              color: colors.primary,
            ),
          ),
      ],
    );
  }
}
