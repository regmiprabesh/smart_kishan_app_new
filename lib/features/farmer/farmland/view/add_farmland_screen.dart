import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_kishan/app/theme/app_theme.dart';
import 'package:smart_kishan/core/di/injector.dart';
import 'package:smart_kishan/core/localization/app_localizations.dart';
import 'package:smart_kishan/core/services/geocoding_service.dart';
import 'package:smart_kishan/core/utils/app_snackbar.dart';
import 'package:smart_kishan/core/widgets/app_bar.dart';
import 'package:smart_kishan/core/widgets/app_image_upload_field.dart';
import 'package:smart_kishan/core/widgets/app_media_picker.dart';
import 'package:smart_kishan/core/widgets/app_primary_button.dart';
import 'package:smart_kishan/core/widgets/app_text_field.dart';
import '../data/farmland.dart';
import '../../../../core/services/location_service.dart';
import '../data/soil_data.dart';
import 'farmland_args.dart';

/// Add / edit a farmland: image, title, description, location (with "use my
/// location"), and soil properties (with "auto-fetch from coordinates").
class AddFarmlandScreen extends StatefulWidget {
  const AddFarmlandScreen({super.key, required this.args});
  final FarmlandArgs args;

  @override
  State<AddFarmlandScreen> createState() => _AddFarmlandScreenState();
}

class _AddFarmlandScreenState extends State<AddFarmlandScreen> {
  final _formKey = GlobalKey<FormState>();
  final _location = sl<LocationService>();
  final _geocoding = sl<GeocodingService>();
  late final TextEditingController _title;
  late final TextEditingController _description;
  late final TextEditingController _lat;
  late final TextEditingController _lng;
  late final TextEditingController _address;
  late final TextEditingController _nitrogen;
  late final TextEditingController _phosphate;
  late final TextEditingController _potassium;
  late final TextEditingController _ph;
  late final TextEditingController _organic;

  String? _pickedImagePath; // local file chosen this session
  String? _networkImage; // existing image (edit)
  double? _uploadProgress;
  bool _removeImage = false;

  bool _saving = false;
  bool _locating = false;
  bool _fetchingSoil = false;

  bool get _isEdit => widget.args.farmland != null;

  @override
  void initState() {
    super.initState();
    final f = widget.args.farmland;
    _title = TextEditingController(text: f?.title ?? '');
    _description = TextEditingController(text: f?.description ?? '');
    _lat = TextEditingController(text: f?.lat?.toString() ?? '');
    _lng = TextEditingController(text: f?.lng?.toString() ?? '');
    _address = TextEditingController(text: f?.address?.toString() ?? '');
    _nitrogen = TextEditingController(text: f?.nitrogen?.toString() ?? '');
    _phosphate = TextEditingController(text: f?.phosphate?.toString() ?? '');
    _potassium = TextEditingController(text: f?.potassium?.toString() ?? '');
    _ph = TextEditingController(text: f?.pH?.toString() ?? '');
    _organic = TextEditingController(text: f?.organicMatter?.toString() ?? '');
    _networkImage = f?.image;
  }

  @override
  void dispose() {
    for (final c in [
      _title,
      _description,
      _lat,
      _lng,
      _address,
      _nitrogen,
      _phosphate,
      _potassium,
      _ph,
      _organic,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _pickImage() async {
    final media = await AppMediaPicker.pick(
      context,
      sources: const {MediaSource.camera, MediaSource.gallery}, // ← no Files
      allowImagesOnly: true,
    );
    if (media != null) {
      setState(() {
        _pickedImagePath = media.path;
        _removeImage = false; // a fresh pick overrides a prior delete
      });
    }
  }

  Future<void> _useMyLocation() async {
    setState(() => _locating = true);
    final pos = await _location.currentLatLng();
    // fetch address in the app's current language
    final lang = Localizations.localeOf(context).languageCode; // 'en'/'ne'
    final address = await _geocoding.addressFromLatLng(
      pos.lat,
      pos.lng,
      lang: lang,
    );
    if (!mounted) return;
    setState(() {
      _lat.text = pos.lat.toStringAsFixed(6);
      _lng.text = pos.lng.toStringAsFixed(6);
      if (address != null) _address.text = address; // editable afterwards
      _locating = false;
    });
  }

  Future<void> _autoFetchSoil() async {
    final lat = double.tryParse(_lat.text.trim());
    final lng = double.tryParse(_lng.text.trim());
    final l10n = AppLocalizations.of(context)!;
    if (lat == null || lng == null) {
      AppSnackbar.error(l10n.farmlandCoordinatesRequired);
      return;
    }
    setState(() => _fetchingSoil = true);
    final SoilData? soil = await widget.args.cubit.fetchSoil(lat, lng);
    if (!mounted) return;
    setState(() {
      if (soil != null) {
        if (soil.totalNitrogen != null) {
          _nitrogen.text = soil.totalNitrogen!.toString();
        }
        if (soil.p2o5 != null) _phosphate.text = soil.p2o5!.toString();
        if (soil.potassium != null)
          _potassium.text = soil.potassium!.toString();
        if (soil.ph != null) _ph.text = soil.ph!.toString();
        if (soil.organicMatter != null) {
          _organic.text = soil.organicMatter!.toString();
        }
      }
      _fetchingSoil = false;
    });
    if (soil == null && mounted)
      AppSnackbar.error(l10n.farmlandSoilFetchFailed);
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;

    setState(() => _saving = true);
    final l10n = AppLocalizations.of(context)!;
    final cubit = widget.args.cubit;

    double? d(TextEditingController c) =>
        c.text.trim().isEmpty ? null : double.tryParse(c.text.trim());

    final farmland = Farmland(
      id: widget.args.farmland?.id,
      title: _title.text.trim(),
      description: _description.text.trim(),
      image: _networkImage, // kept if no new image picked
      lat: d(_lat),
      lng: d(_lng),
      address: _address.text.trim().isEmpty ? null : _address.text.trim(),
      nitrogen: d(_nitrogen),
      phosphate: d(_phosphate),
      potassium: d(_potassium),
      pH: d(_ph),
      organicMatter: d(_organic),
    );

    final ok = _isEdit
        ? await cubit.update(
            farmland,
            imagePath: _pickedImagePath,
            removeImage: _removeImage,
            onProgress: (p) => setState(() => _uploadProgress = p),
          )
        : await cubit.add(
            farmland,
            imagePath: _pickedImagePath,
            onProgress: (p) => setState(() => _uploadProgress = p),
          );

    if (!mounted) return;
    if (ok) {
      AppSnackbar.success(
        _isEdit
            ? l10n.farmlandUpdatedSuccessfully
            : l10n.farmlandAddedSuccessfully,
      );
      context.pop();
    } else {
      setState(() {
        _saving = false;
        _uploadProgress = null; // ← clear the progress overlay on failure
      });
      AppSnackbar.error(l10n.errorGeneric);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colors = context.colors;

    return Scaffold(
      appBar: AppAppBar(
        title: _isEdit ? l10n.farmlandUpdate : l10n.farmlandAdd,
      ),
      body: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Card 1: Basic Information — name + description
              _SectionCard(
                icon: Icons.info_outline,
                title: l10n.farmlandBasicInfoSection,
                children: [
                  AppTextField(
                    controller: _title,
                    label: l10n.farmlandNameLabel,
                    hint: l10n.farmlandNameHint,
                    validator: (v) => (v == null || v.trim().isEmpty)
                        ? l10n.farmlandNameRequired
                        : null,
                  ),
                  const SizedBox(height: 12),
                  AppTextField(
                    controller: _description,
                    label: l10n.farmlandDescriptionLabel,
                    hint: l10n.farmlandDescriptionHint,
                    maxLines: 3,
                    textInputAction: TextInputAction.newline,
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Card 2: Image — photo
              _SectionCard(
                icon: Icons.image_outlined,
                title: l10n.farmlandImageSection,
                children: [
                  AppImageUploadField(
                    pickedPath: _pickedImagePath,
                    networkUrl: _networkImage,
                    uploadProgress: _uploadProgress,
                    onPickRequested: _pickImage,
                    onRemove:
                        (_pickedImagePath != null ||
                            (!_removeImage && _networkImage != null))
                        ? () => setState(() {
                            _pickedImagePath = null;
                            _networkImage = null;
                            _removeImage = true;
                          })
                        : null,
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Card 3: Location — lat, lng, address (with "use my location")
              _SectionCard(
                icon: Icons.location_on_outlined,
                title: l10n.farmlandLocationSection,
                actionLabel: l10n.farmlandUseMyLocation,
                actionIcon: Icons.my_location,
                loading: _locating,
                onAction: _useMyLocation,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: AppTextField(
                          controller: _lat,
                          label: l10n.farmlandLatLabel,
                          hint: l10n.farmlandLatHint,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                            signed: true,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: AppTextField(
                          controller: _lng,
                          label: l10n.farmlandLngLabel,
                          hint: l10n.farmlandLngHint,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                            signed: true,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  AppTextField(
                    controller: _address,
                    label: l10n.farmlandAddressLabel,
                    hint: l10n.farmlandAddressHint,
                    maxLines: 2,
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Card 4: Soil — soil fields (with "auto-fetch")
              _SectionCard(
                icon: Icons.grass_outlined,
                title: l10n.farmlandSoilSection,
                actionLabel: l10n.farmlandAutoFetch,
                actionIcon: Icons.auto_awesome,
                loading: _fetchingSoil,
                onAction: _autoFetchSoil,
                children: [
                  _soilField(_nitrogen, l10n.farmlandNitrogen),
                  _soilField(_organic, l10n.farmlandOrganicMatter),
                  _soilField(_phosphate, l10n.farmlandPhosphate),
                  _soilField(_potassium, l10n.farmlandPotassium),
                  _soilField(_ph, l10n.farmlandPH, isLast: true),
                ],
              ),
              const SizedBox(height: 24),

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

  Widget _soilField(
    TextEditingController c,
    String label, {
    bool isLast = false,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 12),
      child: AppTextField(
        controller: c,
        label: label,
        hint: label,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.label,
    required this.icon,
    required this.loading,
    required this.onPressed,
  });
  final String label;
  final IconData icon;
  final bool loading;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return ElevatedButton.icon(
      onPressed: loading ? null : onPressed,
      icon: loading
          ? const SizedBox(
              width: 14,
              height: 14,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            )
          : Icon(icon, size: 16),
      label: Text(label, style: const TextStyle(fontSize: 11)),
      style: ElevatedButton.styleFrom(
        backgroundColor: colors.primary,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        elevation: 0,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    );
  }
}

/// A titled section card: header (tint + icon + title) and a body of [children].
/// Optionally shows a header action button — pass [actionLabel] + [onAction]
/// (and [loading] for a spinner). Without them, it's a plain section card.
class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.icon,
    required this.title,
    required this.children,
    this.actionLabel,
    this.actionIcon,
    this.onAction,
    this.loading = false,
  });

  final IconData icon;
  final String title;
  final List<Widget> children;

  // Optional header action (Location's "use my location", Soil's "auto-fetch").
  final String? actionLabel;
  final IconData? actionIcon;
  final VoidCallback? onAction;
  final bool loading;

  bool get _hasAction => actionLabel != null && onAction != null;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header — light primary tint, rounded top corners.
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colors.primary.withValues(alpha: 0.05),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: colors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, size: 18, color: colors.primary),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: colors.textPrimary,
                    ),
                  ),
                ),
                // Optional action button
                if (_hasAction)
                  _ActionButton(
                    label: actionLabel!,
                    icon: actionIcon ?? Icons.bolt,
                    loading: loading,
                    onPressed: onAction!,
                  ),
              ],
            ),
          ),
          // Body
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: children,
            ),
          ),
        ],
      ),
    );
  }
}
