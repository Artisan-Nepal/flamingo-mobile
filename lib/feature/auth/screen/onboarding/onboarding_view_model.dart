import 'package:flamingo/feature/auth/data/model/onboarding.dart';
import 'package:flamingo/feature/feature.dart';
import 'package:flutter/foundation.dart';
import 'package:flamingo/shared/shared.dart';

class OnboardingViewModel extends ChangeNotifier {
  // ignore: unused_field
  final AuthRepository _authRepository;
  OnboardingViewModel({required AuthRepository authRepository})
      : _authRepository = authRepository;

  Response<List<OnboardingModel>> _onboardingUseCase =
      Response<List<OnboardingModel>>();

  Response<List<OnboardingModel>> get onboardingUseCase => _onboardingUseCase;

  Future<void> getOnboardingData() async {
    _onboardingUseCase = Response.complete(
      [
        OnboardingModel(
          title: 'Enjoy exciting offers',
          description:
              'Our exclusive offers are here to make your experience extraordinary.',
          color: AppColors.primaryLight,
          image: ImageConstants.onboarding1,
        ),
        OnboardingModel(
          title: 'Exclusive products only for you',
          description: "We've got something special for every taste & style.",
          color: AppColors.secondaryLight,
          image: ImageConstants.onboarding2,
        ),
        OnboardingModel(
          title: 'Enjoy exciting offers',
          description:
              'Our exclusive offers are here to make your experience extraordinary.',
          color: AppColors.pink,
          image: ImageConstants.onboarding3,
        ),
      ],
    );
  }

  Future<void> onboard() async {
    await _authRepository.onBoard();
  }
}
