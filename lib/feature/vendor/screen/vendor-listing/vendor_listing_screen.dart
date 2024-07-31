import 'package:flamingo/data/model/paginated_option.dart';
import 'package:flamingo/di/di.dart';
import 'package:flamingo/feature/auth/auth_view_model.dart';
import 'package:flamingo/feature/vendor/data/model/vendor.dart';
import 'package:flamingo/feature/vendor/screen/vendor-profile/vendor_profile_screen.dart';
import 'package:flamingo/feature/vendor/vendor_listing_view_model.dart';
import 'package:flamingo/shared/shared.dart';
import 'package:flamingo/widget/button/button.dart';
import 'package:flamingo/widget/fav-button/fav_vendor_button_widget.dart';
import 'package:flamingo/widget/load-more/load_more_view_model.dart';
import 'package:flamingo/widget/load-more/load_more_widget.dart';
import 'package:flamingo/widget/loader/loader.dart';
import 'package:flamingo/widget/screen/screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class VendorListingScreen extends StatefulWidget {
  const VendorListingScreen({super.key});

  @override
  State<VendorListingScreen> createState() => _VendorListingScreenState();
}

class _VendorListingScreenState extends State<VendorListingScreen> {
  final _viewModel = locator<VendorListingViewModel>();
  final _loadMoreViewModel = locator<LoadMoreViewModel>();
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _viewModel.getVendors();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => _loadMoreViewModel,
      child: ChangeNotifierProvider(
        create: (context) => _viewModel,
        child: TitledScreen(
          automaticallyImplyAppBarLeading: false,
          title: 'Brands',
          scrollable: false,
          appbarActions: const [CartButtonWidget()],
          child: Consumer<VendorListingViewModel>(
            builder: (context, viewModel, child) {
              if (!viewModel.vendorUseCase.hasCompleted) {
                return const DefaultScreenLoaderWidget();
              }
              return RefreshIndicator.adaptive(
                onRefresh: () async {
                  await _viewModel.getVendors(updateState: false);
                },
                child: CustomScrollView(
                  controller: _scrollController,
                  slivers: [
                    if (viewModel.favoriteBrands.isNotEmpty)
                      SliverToBoxAdapter(
                          child: Padding(
                        padding: const EdgeInsets.only(
                            bottom: Dimens.spacingSizeDefault),
                        child: Text(
                          'Your Favorite Brands',
                          style: textTheme(context).bodyLarge,
                        ),
                      )),
                    if (viewModel.favoriteBrands.isNotEmpty)
                      SnippetVendorListing(
                        vendors: _viewModel.favoriteBrands,
                      ),
                    SliverToBoxAdapter(
                        child: Padding(
                      padding: const EdgeInsets.only(
                          top: Dimens.spacingSizeDefault,
                          bottom: Dimens.spacingSizeDefault),
                      child: Text(
                        'Discover Brands',
                        style: textTheme(context).bodyLarge,
                      ),
                    )),
                    SnippetVendorListing(
                      vendors: _viewModel.nonFavoriteBrands,
                    ),
                    SliverToBoxAdapter(
                      child: LoadMoreWidget(
                        scrollController: _scrollController,
                        onLoadMore: (page, limit) async {
                          await viewModel.getVendors(
                              updateState: false,
                              paginationOption: PaginationOption(
                                page: page,
                                limit: limit,
                              ));
                          return incrementPage(viewModel.vendorUseCase);
                        },
                      ),
                    )
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class SnippetVendorListing extends StatelessWidget {
  const SnippetVendorListing({
    super.key,
    required this.vendors,
  });

  final List<Vendor> vendors;

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);
    return SliverList.builder(
      itemCount: vendors.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            NavigationHelper.push(
              context,
              VendorProfileScreen(
                seller: vendors[index].seller,
              ),
            );
          },
          child: Container(
            height: 70,
            padding: const EdgeInsets.symmetric(
              horizontal: Dimens.spacingSizeDefault,
            ),
            margin: const EdgeInsets.only(bottom: Dimens.spacingSizeDefault),
            color: AppColors.grayLighter,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  vendors[index].seller.storeName,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (authViewModel.isLoggedIn)
                  FavVendorButtonWidget(
                    vendorId: vendors[index].id,
                  )
              ],
            ),
          ),
        );
      },
    );
  }
}
