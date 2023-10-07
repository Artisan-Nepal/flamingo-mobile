import 'package:flutter/cupertino.dart';
import 'package:flamingo/feature/feature.dart';
import 'package:flamingo/shared/shared.dart';
import 'package:flamingo/widget/widget.dart';
import 'package:provider/provider.dart';

class SnippetLoginScreenForm extends StatefulWidget {
  const SnippetLoginScreenForm({Key? key}) : super(key: key);

  @override
  State<SnippetLoginScreenForm> createState() => _SnippetLoginScreenFormState();
}

class _SnippetLoginScreenFormState extends State<SnippetLoginScreenForm> {
  final _formKey = GlobalKey<FormState>();
  late String _phone, _password;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.only(left: 32, right: 32),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const TextFieldWidget(
                label: 'Phone number',
              ),
              addVerticalSpace(
                16,
              ),
              PasswordTextFieldWidget(
                validator: (value) {
                  if (value != null && value.isEmpty) {
                    return 'Password should not be empty';
                  } else {
                    return null;
                  }
                },
                onSaved: (String? value) {
                  _password = value ?? "";
                },
                maxLength: 20,
                obscureTextInitially: true,
              ),
              addVerticalSpace(8),
              Container(
                alignment: Alignment.topRight,
                child: const Text(
                  "Forgot password",
                ),
              ),
              getErrorMessage(),
              addVerticalSpace(30),
              getSignInButton(),
              addVerticalSpace(56),
              Container(
                alignment: Alignment.center,
                child: const Text(
                  'Need help?',
                ),
              ),
              addVerticalSpace(4),
              const RoundedOutlinedButtonWidget(
                label: '9849000000',
              ),
              addVerticalSpace(56)
            ],
          ),
        ),
      ),
    );
  }

  Widget getSignInButton() {
    return Consumer<LoginViewModel>(
      builder: (context, viewModel, _) => RoundedFilledButtonWidget(
        label: 'Sign in',
        onPressed: () async {
          if (validate()) {
            await viewModel.login(LoginRequest(
                username: _phone, password: _password, apkVersion: '1.1.0'));
            observeLoginResponse(viewModel);
          }
        },
      ),
    );
  }

  Widget getErrorMessage() {
    return Consumer<LoginViewModel>(
      builder: (context, loginViewModel, _) {
        if (loginViewModel.loginUseCase.state == ResponseState.error) {
          return Text(
            loginViewModel.loginUseCase.exception.toString(),
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }

  bool validate() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      return true;
    } else {
      return false;
    }
  }

  void observeLoginResponse(LoginViewModel viewModel) {
    // if (viewModel.loginUseCase.hasCompleted) {

    // }
  }
}
