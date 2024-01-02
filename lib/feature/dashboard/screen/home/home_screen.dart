import 'package:flamingo/feature/search/screen/search_screen.dart';
import 'package:flamingo/shared/shared.dart';
import 'package:flamingo/widget/widget.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: Dimens.spacingSizeSmall),
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
              ],
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
