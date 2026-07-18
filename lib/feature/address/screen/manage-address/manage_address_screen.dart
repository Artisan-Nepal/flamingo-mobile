import 'package:flamingo/di/di.dart';
import 'package:flamingo/feature/address/data/model/address.dart';
import 'package:flamingo/feature/address/data/model/picked_location.dart';
import 'package:flamingo/feature/address/screen/address-listing/address_listing_view_model.dart';
import 'package:flamingo/feature/address/screen/location-picker/location_picker_screen.dart';
import 'package:flamingo/feature/address/screen/manage-address/manage_address_view_model.dart';
import 'package:flamingo/shared/shared.dart';
import 'package:flamingo/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ManageAddressScreen extends StatefulWidget {
  const ManageAddressScreen({
    super.key,
    this.existingAddress,
  });

  final Address? existingAddress;

  @override
  State<ManageAddressScreen> createState() => _ManageAddressScreenState();
}

class _ManageAddressScreenState extends State<ManageAddressScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _mobileNumberController = TextEditingController();
  final _addressController = TextEditingController();
  final _landmarkController = TextEditingController();

  final _viewModel = locator<ManageAddressViewModel>();

  @override
  void initState() {
    super.initState();
    _setAddressValues(widget.existingAddress);
  }

  void _setAddressValues(Address? address) {
    _viewModel.init(address);
    _fullNameController.text = address?.fullName ?? "";
    _mobileNumberController.text = address?.mobileNumber ?? "";
    _addressController.text = address?.name ?? "";
    _landmarkController.text = address?.landmark ?? "";
  }

  Future<void> _openLocationPicker(ManageAddressViewModel viewModel) async {
    FocusScope.of(context).unfocus();
    final result = await Navigator.of(context).push<PickedLocation>(
      MaterialPageRoute(
        builder: (_) => LocationPickerScreen(
          initialLatitude: viewModel.latitude,
          initialLongitude: viewModel.longitude,
        ),
      ),
    );
    if (result != null) {
      viewModel.setPickedLocation(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => _viewModel,
      child: Consumer<ManageAddressViewModel>(
        builder: (context, viewModel, child) {
          return DefaultScreen(
            appBarTitle: Text(
              widget.existingAddress == null ? 'Add New Address' : 'Edit Address',
            ),
            bottomNavBarWithButton: true,
            bottomNavBarWithButtonLabel: 'Save And Continue',
            bottomNavBarWithButtonOnPressed: () {
              _onSubmit(viewModel);
            },
            isLoading: viewModel.manageAddressUseCase.isLoading,
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFieldWidget(
                    controller: _fullNameController,
                    label: 'Full Name',
                    hintText: 'Enter full name',
                    validator: (text) => checkIfEmpty('Full name', text),
                    enabled: !viewModel.manageAddressUseCase.isLoading,
                  ),
                  const VerticalSpaceWidget(height: Dimens.spacingSizeDefault),
                  PhoneTextFieldWidget(
                    label: 'Mobile number',
                    controller: _mobileNumberController,
                    maxLength: 10,
                    enabled: !viewModel.manageAddressUseCase.isLoading,
                    textInputAction: TextInputAction.done,
                    validator: validatePhoneNumber,
                  ),
                  const VerticalSpaceWidget(height: Dimens.spacingSizeDefault),
                  _buildLocationField(viewModel),
                  const VerticalSpaceWidget(height: Dimens.spacingSizeDefault),
                  TextFieldWidget(
                    controller: _addressController,
                    label: 'Address',
                    hintText: 'Eg. Home, Office',
                    validator: (text) => checkIfEmpty('Address', text),
                    enabled: !viewModel.manageAddressUseCase.isLoading,
                  ),
                  const VerticalSpaceWidget(height: Dimens.spacingSizeDefault),
                  TextFieldWidget(
                    controller: _landmarkController,
                    label: 'Landmark (Optional)',
                    hintText: 'Eg. Near driving center',
                    enabled: !viewModel.manageAddressUseCase.isLoading,
                    textInputAction: TextInputAction.done,
                  ),
                  const VerticalSpaceWidget(height: Dimens.spacingSizeDefault),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildLocationField(ManageAddressViewModel viewModel) {
    final hasLocation = viewModel.hasLocation;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Location', style: TypographyStyles.bodyMedium),
        const VerticalSpaceWidget(height: Dimens.spacingSizeExtraSmall),
        InkWell(
          onTap: viewModel.manageAddressUseCase.isLoading ? null : () => _openLocationPicker(viewModel),
          borderRadius: BorderRadius.circular(Dimens.radiusSmall),
          child: Container(
            padding: const EdgeInsets.all(Dimens.spacingSizeDefault),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Dimens.radiusSmall),
              border: Border.all(color: AppColors.grayLight),
            ),
            child: Row(
              children: [
                Icon(
                  hasLocation ? Icons.location_on : Icons.add_location_alt_outlined,
                  color: hasLocation ? AppColors.secondaryMain : AppColors.grayMain,
                  size: Dimens.iconSizeDefault,
                ),
                const SizedBox(width: Dimens.spacingSizeSmall),
                Expanded(
                  child: Text(
                    hasLocation ? (viewModel.formattedAddress ?? 'Location selected') : 'Set location on map',
                    style: TypographyStyles.bodyMedium.copyWith(
                      color: hasLocation ? AppColors.grayDarker : AppColors.grayMain,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  hasLocation ? 'Change' : '',
                  style: TypographyStyles.labelLarge.copyWith(color: AppColors.secondaryMain),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _onSubmit(ManageAddressViewModel viewModel) async {
    final formValid = _formKey.currentState!.validate();
    if (!viewModel.hasLocation) {
      showToast(context, message: 'Please set your location on the map', isSuccess: false);
      return;
    }
    if (!formValid) return;

    await viewModel.manageAddress(
      _fullNameController.text,
      _mobileNumberController.text,
      _addressController.text,
      _landmarkController.text,
      widget.existingAddress?.id,
    );

    if (!context.mounted) return;
    if (viewModel.manageAddressUseCase.hasCompleted) {
      Provider.of<AddressListingViewModel>(context, listen: false).getAddresses();
      NavigationHelper.pop(context);
    } else {
      showToast(
        context,
        message: viewModel.manageAddressUseCase.exception!,
        isSuccess: false,
      );
    }
  }
}
