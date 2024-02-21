import 'package:flamingo/di/di.dart';
import 'package:flamingo/feature/auth/auth_view_model.dart';
import 'package:flamingo/feature/user/data/model/update_user_request.dart';
import 'package:flamingo/feature/user/update_user_view_model.dart';
import 'package:flamingo/shared/shared.dart';
import 'package:flamingo/widget/button/variants/text_button_widget.dart';
import 'package:flamingo/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditMobileNumberScreen extends StatefulWidget {
  const EditMobileNumberScreen({super.key});

  @override
  State<EditMobileNumberScreen> createState() => _EditMobileNumberScreenState();
}

class _EditMobileNumberScreenState extends State<EditMobileNumberScreen> {
  final _mobileNumberController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    setInitialValues();
  }

  setInitialValues() async {
    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
    _mobileNumberController.text = authViewModel.user?.mobileNumber ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => locator<UpdateUserViewModel>(),
      builder: (context, child) {
        return Consumer<UpdateUserViewModel>(
          builder: (context, viewModel, child) {
            return DefaultScreen(
              appBarTitle: const Text('Edit Mobile Number'),
              appBarActions: [
                SizedBox(
                  height: 30,
                  child: TextButtonWidget(
                    isLoading: viewModel.updateUserHandlerUseCase.isLoading,
                    onPressed: () {
                      _onSave(viewModel);
                    },
                    label: 'Save',
                  ),
                )
              ],
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    PhoneTextFieldWidget(
                      maxLength: 10,
                      controller: _mobileNumberController,
                      label: 'Mobile Number',
                      enabled: !viewModel.updateUserHandlerUseCase.isLoading,
                      hintText: 'Enter your mobile number',
                      validator: validatePhoneNumber,
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _onSave(UpdateUserViewModel viewModel) async {
    if (_formKey.currentState!.validate()) {
      final request =
          UpdateUserRequest(mobileNumber: _mobileNumberController.text);
      await viewModel.updateUser(request);

      if (!context.mounted) return;
      if (viewModel.updateUserHandlerUseCase.hasCompleted) {
        NavigationHelper.pop(context);
      } else {
        showToast(
          context,
          message: viewModel.updateUserHandlerUseCase.exception,
          isSuccess: false,
        );
      }
    }
  }
}
