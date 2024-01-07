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
        appBar: _buildAppBar(),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const VerticalSpaceWidget(height: Dimens.spacingSizeSmall),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: Dimens.spacingSizeSmall),
                  child: SearchBarFieldWidget(
                    readOnly: true,
                    onTap: () {
                      NavigationHelper.pushWithoutAnimation(
                        context,
                        const SearchScreen(),
                      );
                    },
                  ),
                ),
                const VerticalSpaceWidget(height: Dimens.spacingSizeLarge),
                SnippetHomeAdvertisement(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _buildAppBar() {
    return AppBar(
      title: Text(
        'Flamingo',
        style: textTheme(context).headlineSmall!.copyWith(
              color: isLightMode(context)
                  ? themedPrimaryColor(context)
                  : AppColors.white,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.05,
            ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(
            top: Dimens.spacingSizeExtraSmall - 1,
            right: Dimens.spacingSizeSmall,
          ),
          child: const CartButtonWidget(),
        )
      ],
    );
  }
}
