import 'package:flamingo/di/di.dart';
import 'package:flamingo/feature/advertisement/advertisement_listing_view_model.dart';
import 'package:flamingo/feature/dashboard/screen/home/snippet_home_advertisement.dart';
import 'package:flamingo/feature/search/screen/search_screen.dart';
import 'package:flamingo/shared/shared.dart';
import 'package:flamingo/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  final _advertisementListingViewModel =
      locator<AdvertisementListingViewModel>();

  @override
  void initState() {
    super.initState();
    _advertisementListingViewModel.getAdvertisements();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => _advertisementListingViewModel,
        )
      ],
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: Dimens.spacingSizeSmall),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const VerticalSpaceWidget(height: Dimens.spacingSizeDefault),
                  _buildAppBar(),
                  const VerticalSpaceWidget(height: Dimens.spacingSizeDefault),
                  SearchBarFieldWidget(
                    readOnly: true,
                    onTap: () {
                      NavigationHelper.pushWithoutAnimation(
                        context,
                        const SearchScreen(),
                      );
                    },
                  ),
                  const VerticalSpaceWidget(height: Dimens.spacingSizeDefault),

                  //
                  if ((_advertisementListingViewModel
                              .getAdvertisementsUseCase.data?.rows ??
                          [])
                      .isNotEmpty)
                    SnippetHomeAdvertisement(
                      advertisement: (_advertisementListingViewModel
                                  .getAdvertisementsUseCase.data?.rows ??
                              [])
                          .first,
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Flamingo',
          style: textTheme(context).headlineSmall!.copyWith(
                color: isLightMode(context)
                    ? themedPrimaryColor(context)
                    : AppColors.white,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.05,
              ),
        ),
        const CartButtonWidget()
      ],
    );
  }
}
