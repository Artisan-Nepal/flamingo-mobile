import 'package:flamingo/feature/address/data/model/picked_location.dart';
import 'package:flamingo/shared/shared.dart';
import 'package:flamingo/widget/widget.dart';
import 'package:flamingo/widget/loader/loader.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';

/// Full-screen map location picker (Pathao-style): the pin stays fixed at the
/// centre of the screen and the map pans underneath it. Reverse-geocoding
/// happens exactly once - when the user taps Confirm - to keep API usage
/// minimal (see LOCATION_PICKER_PLAN.md). Pops with a [PickedLocation].
class LocationPickerScreen extends StatefulWidget {
  const LocationPickerScreen({
    super.key,
    this.initialLatitude,
    this.initialLongitude,
  });

  /// Pre-centre the map on an existing address when editing.
  final double? initialLatitude;
  final double? initialLongitude;

  @override
  State<LocationPickerScreen> createState() => _LocationPickerScreenState();
}

class _LocationPickerScreenState extends State<LocationPickerScreen> {
  GoogleMapController? _mapController;
  final _searchController = TextEditingController();

  late LatLng _center;
  bool _resolving = false;
  bool _locating = false;

  @override
  void initState() {
    super.initState();
    _center = LatLng(
      widget.initialLatitude ?? MapConstants.defaultLatitude,
      widget.initialLongitude ?? MapConstants.defaultLongitude,
    );
    // No stored pin yet (adding a fresh address) - jump to the device location
    // once the map is ready so the user starts near where they are.
    if (widget.initialLatitude == null) {
      _goToMyLocation(animate: false);
    }
  }

  @override
  void dispose() {
    _mapController?.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _goToMyLocation({bool animate = true}) async {
    setState(() => _locating = true);
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return;

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
        return;
      }

      final position = await Geolocator.getCurrentPosition();
      final target = LatLng(position.latitude, position.longitude);
      if (!mounted) return;
      setState(() => _center = target);
      await _mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(target, MapConstants.defaultZoom),
      );
    } catch (_) {
      // Location is best-effort - the user can always pan the map manually.
    } finally {
      if (mounted) setState(() => _locating = false);
    }
  }

  Future<void> _onPlaceSelected(Prediction prediction) async {
    final lat = double.tryParse(prediction.lat ?? '');
    final lng = double.tryParse(prediction.lng ?? '');
    if (lat == null || lng == null) return;
    final target = LatLng(lat, lng);
    setState(() => _center = target);
    _searchController.clear();
    FocusScope.of(context).unfocus();
    await _mapController?.animateCamera(
      CameraUpdate.newLatLngZoom(target, MapConstants.defaultZoom),
    );
  }

  Future<void> _onConfirm() async {
    setState(() => _resolving = true);
    String formattedAddress = '';
    try {
      final placemarks = await placemarkFromCoordinates(_center.latitude, _center.longitude);
      if (placemarks.isNotEmpty) {
        formattedAddress = _formatPlacemark(placemarks.first);
      }
    } catch (_) {
      // Fall back to coordinates if reverse-geocoding is unavailable.
    }
    if (formattedAddress.isEmpty) {
      formattedAddress = '${_center.latitude.toStringAsFixed(5)}, ${_center.longitude.toStringAsFixed(5)}';
    }
    if (!mounted) return;
    // Navigator.pop directly (not NavigationHelper.pop) so we can hand the
    // picked location back to the address form as the route's result.
    Navigator.pop(
      context,
      PickedLocation(
        latitude: _center.latitude,
        longitude: _center.longitude,
        formattedAddress: formattedAddress,
      ),
    );
  }

  String _formatPlacemark(Placemark p) {
    return [p.name, p.subLocality, p.locality, p.administrativeArea]
        .where((part) => part != null && part.trim().isNotEmpty)
        .toSet() // drop duplicates (name often repeats locality)
        .join(', ');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(target: _center, zoom: MapConstants.defaultZoom),
            onMapCreated: (controller) => _mapController = controller,
            onCameraMove: (position) => _center = position.target,
            myLocationEnabled: false, // we render our own control for consistent styling
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            mapToolbarEnabled: false,
          ),
          _buildCenterPin(),
          _buildTopBar(),
          _buildMyLocationButton(),
          _buildBottomSheet(),
        ],
      ),
    );
  }

  // Fixed pin at the visual centre. Lifted by half its height so the tip
  // (not the middle) points at the exact map centre. A small shadow dot marks
  // the precise ground point.
  Widget _buildCenterPin() {
    return IgnorePointer(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Transform.translate(
              offset: const Offset(0, -Dimens.iconSizeExtraLarge / 2),
              child: const Icon(
                Icons.location_on,
                size: Dimens.iconSizeExtraLarge,
                color: AppColors.secondaryMain,
              ),
            ),
            Transform.translate(
              offset: const Offset(0, -Dimens.iconSizeExtraLarge / 2),
              child: Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  color: AppColors.secondaryMain.withOpacity(0.4),
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(Dimens.spacingSizeDefault),
        child: Row(
          children: [
            _circleButton(
              child: const BackButtonWidget(),
              onTap: () => NavigationHelper.pop(context),
            ),
            const SizedBox(width: Dimens.spacingSizeSmall),
            Expanded(child: _buildSearchField()),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchField() {
    return Container(
      // Fixed height: GooglePlaceAutoCompleteTextField's root Container sets
      // `alignment: Alignment.centerLeft`, which makes it expand to fill any
      // bounded height it's given - and inside this screen's Stack, that's
      // "up to the full screen height". Without an explicit height here it
      // balloons into a giant box instead of a normal search bar.
      height: Dimens.spacing_48,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(Dimens.radius_10),
        boxShadow: const [
          BoxShadow(color: Color(0x1A000000), blurRadius: 8, offset: Offset(0, 2)),
        ],
      ),
      child: GooglePlaceAutoCompleteTextField(
        textEditingController: _searchController,
        googleAPIKey: MapConstants.googlePlacesApiKey,
        countries: const [MapConstants.countryCode],
        isLatLngRequired: true,
        debounceTime: 500,
        boxDecoration: const BoxDecoration(color: AppColors.transparent),
        inputDecoration: InputDecoration(
          hintText: 'Search for a place',
          hintStyle: TypographyStyles.bodyMedium.copyWith(color: AppColors.grayMain),
          prefixIcon: const Icon(Icons.search, size: Dimens.iconSizeDefault, color: AppColors.grayMain),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: Dimens.spacing_12),
        ),
        getPlaceDetailWithLatLng: _onPlaceSelected,
        itemClick: (prediction) {
          _searchController.text = prediction.description ?? '';
        },
      ),
    );
  }

  Widget _buildMyLocationButton() {
    return Positioned(
      right: Dimens.spacingSizeDefault,
      bottom: 190,
      child: _circleButton(
        onTap: _locating ? null : () => _goToMyLocation(),
        child: _locating
            ? const Padding(
                padding: EdgeInsets.all(Dimens.spacing_12),
                child: CircularProgressIndicatorWidget(size: Dimens.iconSizeSmall),
              )
            : const Icon(Icons.my_location, color: AppColors.secondaryMain),
      ),
    );
  }

  Widget _buildBottomSheet() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(Dimens.radiusMedium)),
          boxShadow: [BoxShadow(color: Color(0x1A000000), blurRadius: 12, offset: Offset(0, -2))],
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.all(Dimens.spacingSizeDefault),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.grayLine,
                      borderRadius: BorderRadius.circular(Dimens.radius_5),
                    ),
                  ),
                ),
                const VerticalSpaceWidget(height: Dimens.spacingSizeDefault),
                Text('Set delivery location', style: TypographyStyles.titleMedium),
                const VerticalSpaceWidget(height: Dimens.spacingSizeExtraSmall),
                Row(
                  children: [
                    const Icon(Icons.place_outlined, size: Dimens.iconSizeSmall, color: AppColors.grayMain),
                    const SizedBox(width: Dimens.spacingSizeExtraSmall),
                    Expanded(
                      child: Text(
                        'Move the map to place the pin at your exact location.',
                        style: TypographyStyles.bodyMedium.copyWith(color: AppColors.grayMain),
                      ),
                    ),
                  ],
                ),
                const VerticalSpaceWidget(height: Dimens.spacingSizeDefault),
                FilledButtonWidget(
                  label: 'Confirm location',
                  isLoading: _resolving,
                  onPressed: _onConfirm,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _circleButton({required Widget child, VoidCallback? onTap}) {
    return Material(
      color: AppColors.white,
      shape: const CircleBorder(),
      elevation: 3,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox(width: Dimens.spacing_48, height: Dimens.spacing_48, child: Center(child: child)),
      ),
    );
  }
}
