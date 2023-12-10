import 'package:flamingo/di/di.dart';
import 'package:flamingo/feature/address/data/model/address.dart';
import 'package:flamingo/feature/address/screen/address-listing/address_listing_view_model.dart';
import 'package:flamingo/feature/address/screen/manage-address/manage_address_screen.dart';
import 'package:flamingo/shared/shared.dart';
import 'package:flamingo/widget/alert-dialog/alert_dialog_widget.dart';
import 'package:flamingo/widget/loader/loader.dart';
import 'package:flamingo/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class AddressListingScreen extends StatefulWidget {
  const AddressListingScreen({
    Key? key,
    this.onAddressPressed,
    required this.title,
  }) : super(key: key);

  final Function(Address address)? onAddressPressed;
  final String title;

  @override
  State<AddressListingScreen> createState() => _AddressListingScreenState();
}

class _AddressListingScreenState extends State<AddressListingScreen> {
  final _viewModel = locator<AddressListingViewModel>();
  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    await _viewModel.getAddresses();
    if (!context.mounted) return;
    if (_viewModel.getAddressesUseCase.hasCompleted &&
        _viewModel.getAddressesUseCase.data!.rows.isEmpty) {
      NavigationHelper.push(context, const ManageAddressScreen());
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => _viewModel,
      child: DefaultScreen(
        appBarTitle: Text(widget.title),
        scrollable: false,
        child: Consumer<AddressListingViewModel>(
          builder: (context, viewModel, child) {
            final addresses = viewModel.getAddressesUseCase.data?.rows ?? [];
            return !viewModel.getAddressesUseCase.hasCompleted
                ? const Center(
                    child: CircularProgressIndicatorWidget(
                      size: Dimens.iconSizeLarge,
                    ),
                  )
                : Column(
                    children: [
                      OutlinedButtonWidget(
                        label: 'Add New Address',
                        onPressed: () {
                          NavigationHelper.push(
                              context, const ManageAddressScreen());
                        },
                      ),
                      ListView.builder(
                        padding: EdgeInsets.zero,
                        physics: const BouncingScrollPhysics(),
                        itemCount: addresses.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return Slidable(
                            endActionPane: ActionPane(
                              motion: const ScrollMotion(),
                              children: [
                                // edit
                                SlidableAction(
                                  onPressed: (context1) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            ManageAddressScreen(
                                          existingAddress: addresses[index],
                                        ),
                                      ),
                                    );
                                  },
                                  label: 'Edit',
                                  backgroundColor: Colors.blue,
                                  icon: Icons.edit,
                                ),
                                // delete
                                SlidableAction(
                                  onPressed: (context2) {
                                    _handleOnRemoveAddress(
                                        context, addresses[index].id);
                                  },
                                  label: 'Delete',
                                  backgroundColor: Colors.red,
                                  icon: Icons.delete,
                                ),
                              ],
                            ),
                            child: ListTile(
                              onTap: () {
                                if (widget.onAddressPressed != null) {
                                  widget.onAddressPressed!(addresses[index]);
                                }
                              },
                              // edit Button
                              leading: const SizedBox(
                                height: 50,
                                width: 50,
                                child: Icon(
                                  Icons.location_on,
                                  color: AppColors.primaryMain,
                                ),
                              ),
                              title: Text(addresses[index].name),
                              subtitle: Text(addresses[index].area.name),
                            ),
                          );
                        },
                      ),
                    ],
                  );
          },
        ),
      ),
    );
  }

  _handleOnRemoveAddress(BuildContext context, String addressId) {
    // pop popup menu
    // Navigator.pop(context);
    // Navigator.pop(context);

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialogWidget(
        title: 'Remove  address?',
        message: 'Are you sure you want to remove the address?',
        needSecondButton: true,
        firstButtonLabel: 'Remove',
        firstButtonOnPressed: () {
          // pop dialog
          Navigator.pop(dialogContext);
          showDialog(
              context: dialogContext,
              barrierDismissible: false,
              builder: (context) => const CustomLoader());
        },
      ),
    );
  }
}
