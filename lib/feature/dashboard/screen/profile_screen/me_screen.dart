import 'package:flamingo/di/di.dart';
import 'package:flamingo/feature/dashboard/screen/profile_screen/me_screen_model.dart';
import 'package:flamingo/feature/profile/model/profile.dart';
import 'package:flamingo/shared/shared.dart';
import 'package:flamingo/widget/arrowdown/arrowdown.dart';
import 'package:flamingo/widget/profile/profile.dart';
import 'package:flamingo/widget/text/text.dart';
import 'package:flamingo/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MeScreen extends StatefulWidget {
  const MeScreen({Key? key});

  @override
  State<MeScreen> createState() => _MeScreenState();
}

class _MeScreenState extends State<MeScreen> {
  final _viewmodel = locator<MeScreenModel>();
  Profile? profile;

  int _selectedTabIndex = 0; // 0 for Profile, 1 for Reviews
  final TextEditingController _textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _viewmodel.getid();
    _viewmodel.getuserprofile();
    // Place any initialization logic here if needed
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => _viewmodel,
      builder: (context, child) => DefaultScreen(
        appBarTitle: const TextWidget(
          'My Profile',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 24,
          ),
        ),
        bottomNavigationBar: const VerticalSpaceWidget(height: 0),
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildTab('Profile', 0),
                _buildTab('Reviews', 1),
              ],
            ),
          ),
          SafeArea(
            child: Consumer<MeScreenModel>(
              builder: (context, viewModel, child) {
                if (viewModel.profile.isLoading && viewModel.id.isLoading) {
                  return const CircularProgressIndicator();
                }
                return _selectedTabIndex == 0
                    ? buildProfileLayout(
                        viewModel.profile.data, context, viewModel.id.data)
                    : _buildReviewWidget();
              },
            ),
          ),
        ]),
      ),
    );
  }

  Widget _buildReviewWidget() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          ArrowDown(title: 'Reviews', body: Container()),
          VerticalSpaceColoredWidget(
              height: 19, thickness: 2, color: Colors.grey),
          TextFieldWidget(
            controller: _textEditingController,
            label: 'Write a review',
            onFieldSubmitted: (value) {
              print('Done');
            },
          ),
          VerticalSpaceWidget(height: 10),
          ButtonWidget(
            label: 'Submit',
            onPressed: () {
              print(_textEditingController.text);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTab(String title, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTabIndex = index;
        });
      },
      child: Container(
        width: MediaQuery.of(context).size.width / 2.65,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: _selectedTabIndex == index
              ? AppColors.grayLighter // Selected tab color
              : AppColors.transparent,
          borderRadius: BorderRadius.circular(5),
        ),
        child: TextWidget(
          title,
          style: TextStyle(
            fontWeight: _selectedTabIndex == index
                ? FontWeight.bold
                : FontWeight.normal,
            color: _selectedTabIndex == index
                ? AppColors.black // Selected text color
                : AppColors.black, // Default text color
          ),
        ),
      ),
    );
  }
}
