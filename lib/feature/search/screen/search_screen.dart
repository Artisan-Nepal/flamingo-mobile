import 'package:flamingo/shared/shared.dart';
import 'package:flamingo/widget/button/variants/text_button_widget.dart';
import 'package:flamingo/widget/widget.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
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
                const VerticalSpaceWidget(height: Dimens.spacingSizeDefault),
                Row(
                  children: [
                    Expanded(
                      child: SearchBarFieldWidget(
                        autofocus: true,
                      ),
                    ),
                    TextButtonWidget(
                      label: 'Cancel',
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      padding: EdgeInsets.only(
                        left: 10,
                      ),
                      onPressed: () {
                        NavigationHelper.pop(context);
                      },
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
