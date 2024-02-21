import 'package:flamingo/di/di.dart';
import 'package:flamingo/feature/auth/auth_view_model.dart';
import 'package:flamingo/feature/user/data/model/update_user_request.dart';
import 'package:flamingo/feature/user/update_user_view_model.dart';
import 'package:flamingo/shared/shared.dart';
import 'package:flamingo/widget/button/variants/text_button_widget.dart';
import 'package:flamingo/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditEmailScreen extends StatefulWidget {
  const EditEmailScreen({super.key});

  @override
  State<EditEmailScreen> createState() => _EditEmailScreenState();
}

class _EditEmailScreenState extends State<EditEmailScreen> {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    setInitialValues();
  }

  setInitialValues() async {
    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
    _emailController.text = authViewModel.user?.email ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => locator<UpdateUserViewModel>(),
      builder: (context, child) {
        return Consumer<UpdateUserViewModel>(
          builder: (context, viewModel, child) {
            return DefaultScreen(
              appBarTitle: const Text('Edit Email'),
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
                      controller: _emailController,
                      label: 'Email',
                      enabled: !viewModel.updateUserHandlerUseCase.isLoading,
                      hintText: 'Enter your email',
                      validator: (text) {
                        return checkIfEmpty('Email', text);
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
      final request = UpdateUserRequest(email: _emailController.text);
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
