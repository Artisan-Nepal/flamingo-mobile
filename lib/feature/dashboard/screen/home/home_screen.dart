import 'package:flamingo/shared/shared.dart';
import 'package:flamingo/widget/space/space.dart';
import 'package:flamingo/widget/widget.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: Dimens.spacingSizeSmall),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const VerticalSpaceWidget(height: Dimens.spacingSizeLarge),
                _buildAppBar(),
                const VerticalSpaceWidget(height: Dimens.spacingSizeDefault),
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
