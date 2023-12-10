import 'package:flamingo/di/di.dart';
import 'package:flamingo/feature/address/data/model/address.dart';
import 'package:flamingo/feature/address/data/model/sub_address.dart';
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
  final _addressController = TextEditingController();
  final _landmarkController = TextEditingController();

  final _viewModel = locator<ManageAddressViewModel>();

  @override
  void initState() {
    super.initState();
    _setAddressValues(widget.existingAddress);
  }

  _setAddressValues(Address? address) async {
    _viewModel.init(address);
    _addressController.text = address?.name ?? "";
    _landmarkController.text = address?.landmark ?? "";
    _viewModel.getProvinces();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => _viewModel,
      child: Consumer<ManageAddressViewModel>(
        builder: (context, viewModel, child) {
          return DefaultScreen(
            appBarTitle: const Text('Address'),
            bottomNavigationBar: _buildBottomBar(viewModel),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  DropDownFieldWidget<SubAddress>(
                    label: 'Province',
                    hintText: viewModel.provinceUseCase.isLoading
                        ? 'Loading...'
                        : 'Select Province',
                    items: viewModel.provinceUseCase.data ?? [],
                    selectedItem: viewModel.selectedProvince,
                    itemAsString: (province) => province.name,
                    compareFn: (p0, p1) => p0.id == p0.id,
                    enabled: !viewModel.provinceUseCase.isLoading &&
                        !viewModel.manageAddressUseCase.isLoading,
                    onChanged: (province) {
                      if (province != null) {
                        viewModel.setSelectedProvince(province);
                      }
                    },
                    validator: (province) {
                      return checkIfEmpty('Province', province?.name);
                    },
                  ),
                  const VerticalSpaceWidget(height: Dimens.spacingSizeDefault),
                  DropDownFieldWidget<City>(
                    label: 'City',
                    hintText: viewModel.cityUseCase.isLoading
                        ? 'Loading...'
                        : 'Select City',
                    selectedItem: viewModel.selectedCity,
                    compareFn: (p0, p1) => p0.id == p0.id,
                    enabled: viewModel.selectedProvince != null &&
                        !viewModel.cityUseCase.isLoading &&
                        !viewModel.manageAddressUseCase.isLoading,
                    itemAsString: (province) => province.name,
                    items: viewModel.cityUseCase.data ?? [],
                    onChanged: (city) {
                      if (city != null) {
                        viewModel.setSelectedCity(city);
                      }
                    },
                    validator: (city) {
                      return checkIfEmpty('City', city?.name);
                    },
                  ),
                  const VerticalSpaceWidget(height: Dimens.spacingSizeDefault),
                  DropDownFieldWidget<Area>(
                    label: 'Area',
                    hintText: viewModel.areaUseCase.isLoading
                        ? 'Loading...'
                        : 'Select Area',
                    selectedItem: viewModel.selectedArea,
                    itemAsString: (province) => province.name,
                    compareFn: (p0, p1) => p0.id == p0.id,
                    items: viewModel.areaUseCase.data ?? [],
                    enabled: viewModel.selectedCity != null &&
                        !viewModel.areaUseCase.isLoading &&
                        !viewModel.manageAddressUseCase.isLoading,
                    onChanged: (area) {
                      if (area != null) {
                        viewModel.setSelectedArea(area);
                      }
                    },
                    validator: (area) {
                      return checkIfEmpty('Area', area?.name);
                    },
                  ),
                  const VerticalSpaceWidget(height: Dimens.spacingSizeDefault),
                  TextFieldWidget(
                    controller: _addressController,
                    label: 'Address',
                    hintText: 'Enter address',
                    validator: (text) {
                      return checkIfEmpty('Address', text);
                    },
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

  _onSubmit(ManageAddressViewModel viewModel) async {
    if (_formKey.currentState!.validate()) {
      await viewModel.manageAddress(widget.existingAddress?.id);

      if (!context.mounted) return;
      if (viewModel.manageAddressUseCase.hasCompleted) {
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

  Widget _buildBottomBar(ManageAddressViewModel viewModel) {
    return RoundedFilledButtonWidget(
      label: 'Submit',
      isLoading: viewModel.manageAddressUseCase.isLoading,
      onPressed: () {
        _onSubmit(viewModel);
      },
    );
  }
}
