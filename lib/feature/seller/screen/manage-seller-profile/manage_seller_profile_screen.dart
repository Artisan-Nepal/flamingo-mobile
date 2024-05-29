import 'package:flamingo/di/di.dart';
import 'package:flamingo/feature/seller/screen/manage-seller-profile/manage_seller_profile_view_model.dart';
import 'package:flamingo/feature/seller/screen/seller-profile/my-seller_profile_screen.dart';
import 'package:flamingo/feature/vendor/data/model/seller.dart';
import 'package:flamingo/shared/shared.dart';
import 'package:flamingo/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ManageSellerScreen extends StatefulWidget {
  const ManageSellerScreen({
    super.key,
    this.existingSeller,
  });

  final Seller? existingSeller;

  @override
  State<ManageSellerScreen> createState() => _ManageSellerScreenState();
}

class _ManageSellerScreenState extends State<ManageSellerScreen> {
  final _viewModel = locator<ManageSellerProfileViewModel>();

  late TextEditingController _storeNameController;
  late TextEditingController _storeDescriptionController;

  @override
  void initState() {
    super.initState();
    _storeNameController =
        TextEditingController(text: widget.existingSeller?.storeName);
    _storeDescriptionController =
        TextEditingController(text: widget.existingSeller?.storeDescription);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => _viewModel,
      child: DefaultScreen(
        appBarTitle: Text(widget.existingSeller == null
            ? 'Seller registration'
            : 'Manage store'),
        child: Consumer<ManageSellerProfileViewModel>(
          builder: (context, viewModel, child) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const VerticalSpaceWidget(height: Dimens.spacingSizeExtraLarge),
                TextFieldWidget(
                  label: 'Store name',
                  hintText: 'Enter your store name',
                  controller: _storeNameController,
                  enabled: !viewModel.manageSellerAccountUseCase.isLoading,
                ),
                VerticalSpaceWidget(height: Dimens.spacingSizeDefault),
                TextFieldWidget(
                  label: 'Store description',
                  hintText: 'Enter your store description',
                  controller: _storeDescriptionController,
                  enabled: !viewModel.manageSellerAccountUseCase.isLoading,
                ),
                VerticalSpaceWidget(height: Dimens.spacingSizeDefault),
                FilledButtonWidget(
                  label: widget.existingSeller == null
                      ? 'Become a seller'
                      : 'Update',
                  isLoading: viewModel.manageSellerAccountUseCase.isLoading,
                  onPressed: () {
                    _onContinue(viewModel);
                  },
                )
              ],
            );
          },
        ),
      ),
    );
  }

  void _onContinue(ManageSellerProfileViewModel viewModel) async {
    if (_storeNameController.text.isEmpty) {
      showToast(context,
          message: 'Please enter your store name', isSuccess: false);
      return;
    }
    if (_storeDescriptionController.text.isEmpty) {
      showToast(context,
          message: 'Please enter your store description', isSuccess: false);
      return;
    }

    await viewModel.manageSellerProfile(
      existingSellerId: widget.existingSeller?.id,
      storeName: _storeNameController.text,
      storeDescription: _storeDescriptionController.text,
    );

    if (viewModel.manageSellerAccountUseCase.hasCompleted) {
      if (widget.existingSeller == null)
        NavigationHelper.pushReplacement(
          context,
          ChangeNotifierProvider.value(
            value: viewModel,
            child: MySellerProfileScreen(),
          ),
        );
      else
        NavigationHelper.pop(context);
    } else {
      showToast(
        context,
        message: viewModel.manageSellerAccountUseCase.exception,
        isSuccess: false,
      );
    }
  }
}
