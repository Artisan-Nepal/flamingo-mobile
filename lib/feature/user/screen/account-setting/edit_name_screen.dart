import 'package:flamingo/di/di.dart';
import 'package:flamingo/feature/auth/auth_view_model.dart';
import 'package:flamingo/feature/user/data/model/update_user_request.dart';
import 'package:flamingo/feature/user/update_user_view_model.dart';
import 'package:flamingo/shared/shared.dart';
import 'package:flamingo/widget/button/variants/text_button_widget.dart';
import 'package:flamingo/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditNameScreen extends StatefulWidget {
  const EditNameScreen({super.key});

  @override
  State<EditNameScreen> createState() => _EditNameScreenState();
}

class _EditNameScreenState extends State<EditNameScreen> {
  final _fnameController = TextEditingController();
  final _lnameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    setInitialValues();
  }

  setInitialValues() async {
    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
    _fnameController.text = authViewModel.user?.firstName ?? "";
    _lnameController.text = authViewModel.user?.lastName ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => locator<UpdateUserViewModel>(),
      builder: (context, child) {
        return Consumer<UpdateUserViewModel>(
          builder: (context, viewModel, child) {
            return DefaultScreen(
              appBarTitle: const Text('Edit Name'),
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
                    TextFieldWidget(
                      controller: _fnameController,
                      label: 'First Name',
                      enabled: !viewModel.updateUserHandlerUseCase.isLoading,
                      hintText: 'Enter your first name',
                      validator: (text) {
                        return checkIfEmpty('First name', text);
                      },
                    ),
                    VerticalSpaceWidget(height: Dimens.spacingSizeDefault),
                    TextFieldWidget(
                      controller: _lnameController,
                      label: 'Last Name',
                      enabled: !viewModel.updateUserHandlerUseCase.isLoading,
                      hintText: 'Enter your last name',
                      textInputAction: TextInputAction.done,
                      validator: (text) {
                        return checkIfEmpty('Last name', text);
                      },
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
      final request = UpdateUserRequest(
        firstName: _fnameController.text,
        lastName: _lnameController.text,
      );
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
