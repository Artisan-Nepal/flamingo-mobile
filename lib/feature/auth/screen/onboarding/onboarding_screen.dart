// import 'package:flamingo/di/di.dart';
// import 'package:flamingo/feature/auth/screen/onboarding/onboarding_view_model.dart';
// import 'package:flamingo/navigation/navigation_route_names.dart';
// import 'package:flamingo/shared/shared.dart';
// import 'package:flamingo/widget/image/image.dart';
// import 'package:flamingo/widget/widget.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// class OnBoardingScreen extends StatefulWidget {
//   const OnBoardingScreen({Key? key}) : super(key: key);

//   @override
//   State<OnBoardingScreen> createState() => _OnBoardingScreenState();
// }

// class _OnBoardingScreenState extends State<OnBoardingScreen> {
//   OnboardingViewModel viewModel = locator<OnboardingViewModel>();
//   int _currentIndex = 0;

//   @override
//   void initState() {
//     super.initState();
//     viewModel.getOnboardingData();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final isMediumDevice = SizeConfig.isMediumDevice;
//     final isSmallerDevice = SizeConfig.isSmallerDevice;
//     return ChangeNotifierProvider(
//       create: (context) => viewModel,
//       builder: (context, child) {
//         return Scaffold(
//           body: Consumer<OnboardingViewModel>(
//             builder: (context, viewmodel, child) {
//               final data = viewModel.onboardingUseCase.data!;
//               return Container(
//                 color: data[_currentIndex].color,
//                 child: Column(
//                   children: [
//                     VerticalSpaceWidget(
//                         height: isMediumDevice || isSmallerDevice
//                             ? Dimens.spacing_50
//                             : 0),
//                     Expanded(
//                       flex: isMediumDevice || isSmallerDevice ? 1 : 2,
//                       child: PageView.builder(
//                         onPageChanged: (pageIndex) {
//                           setState(() {
//                             _currentIndex = pageIndex;
//                           });
//                         },
//                         itemCount: data.length,
//                         itemBuilder: (context, index) {
//                           return Center(
//                             child: SvgImageWidget(
//                               image: data[index].image,
//                             ),
//                           );
//                         },
//                       ),
//                     ),
//                     VerticalSpaceWidget(
//                       height: isMediumDevice ? Dimens.spacing_50 : 0,
//                     ),
//                     Expanded(
//                       flex: 1,
//                       child: Container(
//                         padding: const EdgeInsets.symmetric(
//                           horizontal: Dimens.spacingSizeLarge,
//                         ),
//                         decoration: BoxDecoration(
//                           color: Theme.of(context).cardColor,
//                           borderRadius: const BorderRadius.only(
//                             topLeft: Radius.circular(
//                               Dimens.radiusMedium,
//                             ),
//                             topRight: Radius.circular(
//                               Dimens.radiusMedium,
//                             ),
//                           ),
//                         ),
//                         width: double.infinity,
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           children: [
//                             const VerticalSpaceWidget(
//                                 height: Dimens.spacingSizeLarge),
//                             PageIndicatorWidget(
//                               length: data.length,
//                               currentIndex: _currentIndex,
//                             ),
//                             const VerticalSpaceWidget(
//                               height: Dimens.spacingSizeOverLarge,
//                             ),
//                             SizedBox(
//                               height: 100,
//                               child: Column(children: [
//                                 TextWidget(
//                                   data[_currentIndex].title,
//                                   style: Theme.of(context)
//                                       .textTheme
//                                       .titleLarge!
//                                       .copyWith(
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                   scaleForSmallerDevice: 1,
//                                 ),
//                                 const SizedBox(height: 16.0),
//                                 TextWidget(
//                                   data[_currentIndex].description,
//                                   style:
//                                       Theme.of(context).textTheme.titleSmall!,
//                                   scaleForSmallerDevice: 1,
//                                 ),
//                               ]),
//                             ),
//                             const SizedBox(
//                               height: 16.0,
//                             ),
//                             IntrinsicWidth(
//                               child: RoundedOutlinedButtonWidget(
//                                 textColor: Theme.of(context)
//                                     .textTheme
//                                     .labelLarge!
//                                     .color!,
//                                 label: 'Get Started',
//                                 onPressed: () => {
//                                   viewModel.onboard(),
//                                   Navigator.pushReplacementNamed(
//                                     context,
//                                     NavigationRouteNames.login,
//                                   ),
//                                 },
//                               ),
//                             )
//                           ],
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               );
//             },
//           ),
//         );
//       },
//     );
//   }
// }

import 'dart:io';

import 'package:flamingo/di/di.dart';
import 'package:flamingo/feature/auth/auth.dart';
import 'package:flamingo/feature/dashboard/dashboard.dart';
import 'package:flamingo/shared/shared.dart';
import 'package:flamingo/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  OnboardingViewModel _viewModel = locator<OnboardingViewModel>();
  LoginViewModel _loginViewModel = locator<LoginViewModel>();

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: SystemUiOverlayStyle(
        statusBarColor: AppColors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => _viewModel,
          ),
          ChangeNotifierProvider(
            create: (context) => _loginViewModel,
          ),
        ],
        child:
            Consumer<OnboardingViewModel>(builder: (context, viewModel, child) {
          return Scaffold(
            body: SizedBox(
              width: SizeConfig.screenWidth,
              child: Column(
                children: [
                  Expanded(
                    child: Image.asset(
                      ImageConstants.onboarding,
                      width: SizeConfig.screenWidth,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(Dimens.spacingSizeDefault),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'WELCOME TO FLAMINGO',
                          style: textTheme(context).bodyLarge!.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        Text(
                          'Experience the quickest way to shop, and immerse yourself into the current fashion trends.',
                        ),
                        VerticalSpaceWidget(height: Dimens.spacingSizeDefault),
                        Row(
                          children: [
                            Expanded(
                              child: Consumer<LoginViewModel>(
                                  builder: (context, loginViewModel, child) {
                                return OutlinedButtonWidget(
                                  label: 'As guest',
                                  onPressed: () {
                                    viewModel.onboard();
                                    _onContinueAsGuest(loginViewModel);
                                  },
                                );
                              }),
                            ),
                            HorizontalSpaceWidget(
                                width: Dimens.spacingSizeDefault),
                            Expanded(
                              child: FilledButtonWidget(
                                label: 'Login',
                                onPressed: () {
                                  viewModel.onboard();
                                  NavigationHelper.pushAndReplaceAll(
                                    context,
                                    LoginScreen(),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                        if (Platform.isIOS)
                          VerticalSpaceWidget(
                              height: Dimens.spacingSizeDefault),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  void _onContinueAsGuest(LoginViewModel viewModel) async {
    await viewModel.continueAsGuest();

    NavigationHelper.pushAndReplaceAll(
      context,
      const DashboardScreen(),
    );
  }
}
