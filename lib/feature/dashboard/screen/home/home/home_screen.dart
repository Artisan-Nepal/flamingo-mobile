import 'package:flamingo/di/di.dart';

import 'package:flamingo/feature/dashboard/screen/home/home/home_screen_model.dart';

import 'package:flamingo/feature/dashboard/screen/home/home/home_screen_items.dart';
import 'package:flamingo/feature/dashboard/screen/home/home/snippet_nav_bar.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _viewModel = locator<HomescreenviewModel>();

  @override
  void initState() {
    super.initState();
    _viewModel.init(0);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => _viewModel,
      builder: (context, child) => Scaffold(
        body: Consumer<HomescreenviewModel>(
          builder: (context, viewModel, child) {
            return WillPopScope(
              onWillPop: () async {
                bool quit = false;
                if (viewModel.pageController.page != 0) {
                  // set to home screen
                  viewModel.setPageIndex(0);
                } else {
                  quit = true;
                }
                return quit;
              },
              child: PageView(
                controller: viewModel.pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: homescreenitems,
              ),
            );
          },
        ),
        bottomNavigationBar: const SnippetHomeNavBar(),
      ),
    );
  }
}
