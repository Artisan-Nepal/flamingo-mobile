import 'package:flamingo/di/di.dart';
import 'package:flamingo/feature/category/screen/category-listing/category_listing_screen.dart';
import 'package:flamingo/feature/category/screen/category-search/category_search_view_model.dart';
import 'package:flamingo/feature/product/screen/product-listing/product_listing_screen.dart';
import 'package:flamingo/shared/shared.dart';
import 'package:flamingo/widget/list-tile/list_tile.dart';
import 'package:flamingo/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CategorySearchScreen extends StatefulWidget {
  const CategorySearchScreen({super.key});

  @override
  State<CategorySearchScreen> createState() => _CategorySearchScreenState();
}

class _CategorySearchScreenState extends State<CategorySearchScreen>
    with AutomaticKeepAliveClientMixin {
  final _viewModel = locator<CategorySearchViewModel>();
  @override
  void initState() {
    super.initState();
    _viewModel.getCategories();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ChangeNotifierProvider(
      create: (context) => _viewModel,
      builder: (context, child) {
        return TitledScreen(
          scrollable: false,
          title: 'CATEGORY',
          child: Consumer<CategorySearchViewModel>(
            builder: (context, viewModel, child) {
              if (!viewModel.categoriesUseCase.hasCompleted) {
                return const SizedBox();
              }
              final categories = viewModel.categoriesUseCase.data ?? [];
              return SizedBox(
                height: SizeConfig.screenHeight,
                child: DefaultTabController(
                  animationDuration: Duration.zero,
                  length: categories.length,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTabBar(),
                      _buildTabBarView(),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Container _buildTabBar() {
    return Container(
      width: double.infinity,
      height: 55,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: isLightMode(context)
                ? AppColors.grayLighter
                : AppColors.grayDarker,
            width: 1,
          ),
        ),
      ),
      child: Consumer<CategorySearchViewModel>(
        builder: (context, viewModel, child) => Theme(
          data: Theme.of(context).copyWith(
            splashColor: AppColors.transparent,
            highlightColor: AppColors.transparent,
          ),
          child: TabBar(
            unselectedLabelColor:
                isLightMode(context) ? AppColors.grayDarker : AppColors.white,
            labelColor:
                isLightMode(context) ? AppColors.grayDarker : AppColors.white,
            isScrollable: true,
            labelStyle: textTheme(context)
                .titleSmall!
                .copyWith(fontWeight: FontWeight.bold),
            unselectedLabelStyle: textTheme(context).titleSmall!,
            indicatorColor:
                isLightMode(context) ? AppColors.grayDarker : AppColors.white,
            labelPadding:
                const EdgeInsets.symmetric(horizontal: Dimens.spacingSizeSmall),
            tabs: List<Widget>.from(
              viewModel.categoriesUseCase.data!.map(
                (e) => Tab(
                  child: Text(e.name.toUpperCase()),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTabBarView() {
    return Expanded(
      child: Consumer<CategorySearchViewModel>(
        builder: (context, viewModel, child) {
          final categories = viewModel.categoriesUseCase.data ?? [];
          return TabBarView(
            children: [
              ...List<Widget>.from(
                categories.map(
                  (category) {
                    final subCategories = category.children ?? [];
                    return ListView.builder(
                      itemCount: subCategories.length,
                      itemBuilder: (context, index) {
                        return ListTileV2Wdiget(
                          title: subCategories[index].name,
                          onPressed: () {
                            if (subCategories[index].children != null &&
                                subCategories[index].children!.isNotEmpty) {
                              NavigationHelper.push(
                                context,
                                CategoryListingScreen(
                                  categories:
                                      subCategories[index].children ?? [],
                                  title: subCategories[index].name,
                                ),
                              );
                            } else {
                              NavigationHelper.push(
                                context,
                                ProductListingScreen(
                                  title: subCategories[index].name,
                                  productListingType:
                                      ProductListingType.category,
                                  categoryId: subCategories[index].id,
                                ),
                              );
                            }
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
