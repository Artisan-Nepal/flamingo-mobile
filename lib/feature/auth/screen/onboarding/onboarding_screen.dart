import 'package:flamingo/di/di.dart';
import 'package:flamingo/feature/auth/screen/onboarding/onboarding_view_model.dart';
import 'package:flamingo/navigation/navigation_route_names.dart';
import 'package:flamingo/shared/shared.dart';
import 'package:flamingo/widget/image/image.dart';
import 'package:flamingo/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({Key? key}) : super(key: key);

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  OnboardingViewModel viewModel = locator<OnboardingViewModel>();
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    viewModel.getOnboardingData();
  }

  @override
  Widget build(BuildContext context) {
    final isMediumDevice = SizeConfig.isMediumDevice;
    final isSmallerDevice = SizeConfig.isSmallerDevice;
    return ChangeNotifierProvider(
      create: (context) => viewModel,
      builder: (context, child) {
        return Scaffold(
          body: Consumer<OnboardingViewModel>(
            builder: (context, viewmodel, child) {
              final data = viewModel.onboardingUseCase.data!;
              return Container(
                color: data[_currentIndex].color,
                child: Column(
                  children: [
                    VerticalSpaceWidget(
                        height: isMediumDevice || isSmallerDevice
                            ? Dimens.spacing_50
                            : 0),
                    Expanded(
                      flex: isMediumDevice || isSmallerDevice ? 1 : 2,
                      child: PageView.builder(
                        onPageChanged: (pageIndex) {
                          setState(() {
                            _currentIndex = pageIndex;
                          });
                        },
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          return Center(
                            child: SvgImageWidget(
                              image: data[index].image,
                            ),
                          );
                        },
                      ),
                    ),
                    VerticalSpaceWidget(
                      height: isMediumDevice ? Dimens.spacing_50 : 0,
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: Dimens.spacingSizeLarge,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(
                              Dimens.radiusMedium,
                            ),
                            topRight: Radius.circular(
                              Dimens.radiusMedium,
                            ),
                          ),
                        ),
                        width: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const VerticalSpaceWidget(
                                height: Dimens.spacingSizeLarge),
                            PageIndicatorWidget(
                              length: data.length,
                              currentIndex: _currentIndex,
                            ),
                            const VerticalSpaceWidget(
                              height: Dimens.spacingSizeOverLarge,
                            ),
                            SizedBox(
                              height: 100,
                              child: Column(children: [
                                TextWidget(
                                  text: data[_currentIndex].title,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge!
                                      .copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                  adaptive: true,
                                  adaptiveValue: 1,
                                  miniAdaptiveValue: Dimens.adaptExtraSmall,
                                ),
                                const SizedBox(height: 16.0),
                                TextWidget(
                                  text: data[_currentIndex].description,
                                  style:
                                      Theme.of(context).textTheme.titleSmall!,
                                  adaptive: true,
                                  adaptiveValue: 1,
                                  miniAdaptiveValue: Dimens.adaptExtraSmall,
                                ),
                              ]),
                            ),
                            const SizedBox(
                              height: 16.0,
                            ),
                            IntrinsicWidth(
                              child: RoundedOutlinedButtonWidget(
                                textColor: Theme.of(context)
                                    .textTheme
                                    .labelLarge!
                                    .color!,
                                label: 'Get Started',
                                onPressed: () => {
                                  viewModel.onboard(),
                                  Navigator.pushReplacementNamed(
                                    context,
                                    NavigationRouteNames.login,
                                  ),
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}
