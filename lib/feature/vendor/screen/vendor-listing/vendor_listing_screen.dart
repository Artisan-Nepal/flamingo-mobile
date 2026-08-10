import 'package:flamingo/di/di.dart';
import 'package:flamingo/feature/auth/auth_view_model.dart';
import 'package:flamingo/feature/vendor/data/model/vendor.dart';
import 'package:flamingo/feature/vendor/screen/vendor-profile/vendor_profile_screen.dart';
import 'package:flamingo/feature/vendor/vendor_listing_view_model.dart';
import 'package:flamingo/shared/shared.dart';
import 'package:flamingo/widget/button/button.dart';
import 'package:flamingo/widget/fav-button/fav_vendor_button_widget.dart';
import 'package:flamingo/widget/loader/loader.dart';
import 'package:flamingo/widget/screen/screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Fixed layout metrics. The alphabet rail scrolls to a section by computing its
// pixel offset directly, so every element above and within the list must have a
// known, constant height. Keep these in sync with the widgets that render them.
const double _kListTopPadding = 8;
const double _kFavBlockHeight = 88;
const double _kAllBrandsTitleHeight = 44;
const double _kSectionHeaderHeight = 36;
const double _kRowHeight = 56;
const double _kRailWidth = 24;

class VendorListingScreen extends StatefulWidget {
  const VendorListingScreen({super.key});

  @override
  State<VendorListingScreen> createState() => _VendorListingScreenState();
}

class _VendorListingScreenState extends State<VendorListingScreen> {
  final _viewModel = locator<VendorListingViewModel>();
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();

  // The letter the finger is currently over while dragging the rail; drives the
  // floating preview bubble. Null when the rail isn't being dragged.
  String? _activeRailLetter;

  @override
  void initState() {
    super.initState();
    _viewModel.getVendors();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _viewModel,
      child: TitledScreen(
        automaticallyImplyAppBarLeading: false,
        title: 'Brands',
        scrollable: false,
        padding: EdgeInsets.zero,
        appbarActions: const [CartButtonWidget()],
        child: Consumer<VendorListingViewModel>(
          builder: (context, viewModel, child) {
            if (!viewModel.vendorUseCase.hasCompleted) {
              return const DefaultScreenLoaderWidget();
            }
            return Column(
              children: [
                const SizedBox(height: Dimens.spacingSizeDefault),
                _SearchField(
                  controller: _searchController,
                  query: viewModel.searchQuery,
                  onChanged: viewModel.setSearchQuery,
                  onClear: () {
                    _searchController.clear();
                    viewModel.setSearchQuery('');
                  },
                ),
                const SizedBox(height: Dimens.spacingSizeSmall),
                Expanded(child: _buildBody(context, viewModel)),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, VendorListingViewModel viewModel) {
    final authViewModel = Provider.of<AuthViewModel>(context);
    final sections = viewModel.sections;

    if (sections.isEmpty) {
      return _EmptyState(isSearching: viewModel.isSearching);
    }

    final favorites = viewModel.favoriteBrands;
    final showFavorites = !viewModel.isSearching && favorites.isNotEmpty;
    final showRail = !viewModel.isSearching;

    // Pre-compute the scroll offset at which each section header sits, so a rail
    // tap can jump straight there.
    final sectionOffsets = <String, double>{};
    var offset = _kListTopPadding +
        (showFavorites ? _kFavBlockHeight + _kAllBrandsTitleHeight : 0);
    for (final section in sections) {
      sectionOffsets[section.letter] = offset;
      offset += _kSectionHeaderHeight + section.vendors.length * _kRowHeight;
    }

    final scrollView = CustomScrollView(
      controller: _scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      slivers: [
        const SliverToBoxAdapter(child: SizedBox(height: _kListTopPadding)),
        if (showFavorites)
          SliverToBoxAdapter(
            child: _FavoritesStrip(favorites: favorites),
          ),
        if (showFavorites)
          const SliverToBoxAdapter(child: _AllBrandsTitle()),
        for (final section in sections) ...[
          SliverPersistentHeader(
            pinned: true,
            delegate: _LetterHeaderDelegate(section.letter),
          ),
          SliverList.builder(
            itemCount: section.vendors.length,
            itemBuilder: (context, index) => _BrandRow(
              vendor: section.vendors[index],
              showFavButton: authViewModel.isLoggedIn,
              rightPadding: _kRailWidth,
            ),
          ),
        ],
        // Just breathing room below the final row. Deliberately small: a large
        // tail (it was 70% of the screen) let the list scroll far past the last
        // brand into blank space - the "over-scrolled, no brands visible" bug.
        // The rail's last-letter jump already clamps to maxScrollExtent
        // (_jumpToLetter), so it lands on the bottom section without needing a
        // tall tail to pull that section up to the top.
        const SliverToBoxAdapter(
          child: SizedBox(height: Dimens.spacingSizeOverLarge),
        ),
      ],
    );

    return RefreshIndicator(
      onRefresh: () => viewModel.getVendors(updateState: false),
      child: Stack(
        children: [
          scrollView,
          if (showRail)
            _AlphabetRail(
              presentLetters: sectionOffsets.keys.toSet(),
              onLetter: (letter, animate) =>
                  _jumpToLetter(letter, sectionOffsets, animate: animate),
              onActiveChanged: (letter) =>
                  setState(() => _activeRailLetter = letter),
            ),
          if (_activeRailLetter != null)
            _RailBubble(letter: _activeRailLetter!),
        ],
      ),
    );
  }

  void _jumpToLetter(
    String railLetter,
    Map<String, double> sectionOffsets, {
    required bool animate,
  }) {
    final target = _offsetForRailLetter(railLetter, sectionOffsets);
    if (target == null || !_scrollController.hasClients) return;

    final max = _scrollController.position.maxScrollExtent;
    final clamped = target.clamp(0.0, max);
    if (animate) {
      _scrollController.animateTo(
        clamped,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    } else {
      _scrollController.jumpTo(clamped);
    }
  }

  // A rail letter with no brands maps to the next populated section (then the
  // previous one), so every tap lands somewhere sensible - iOS Contacts style.
  double? _offsetForRailLetter(
    String railLetter,
    Map<String, double> sectionOffsets,
  ) {
    if (sectionOffsets.containsKey(railLetter)) {
      return sectionOffsets[railLetter];
    }
    final order = _AlphabetRail.letters;
    final index = order.indexOf(railLetter);
    if (index == -1) return null;
    for (var i = index; i < order.length; i++) {
      final o = sectionOffsets[order[i]];
      if (o != null) return o;
    }
    for (var i = index; i >= 0; i--) {
      final o = sectionOffsets[order[i]];
      if (o != null) return o;
    }
    return null;
  }
}

class _SearchField extends StatelessWidget {
  const _SearchField({
    required this.controller,
    required this.query,
    required this.onChanged,
    required this.onClear,
  });

  final TextEditingController controller;
  final String query;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: Dimens.spacingSizeDefault),
      padding: const EdgeInsets.symmetric(horizontal: Dimens.spacingSizeDefault),
      decoration: BoxDecoration(
        color: AppColors.grayLighter,
        borderRadius: BorderRadius.circular(Dimens.radius_10),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.search,
            size: Dimens.iconSize_20,
            color: AppColors.grayMain,
          ),
          const SizedBox(width: Dimens.spacingSizeSmall),
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              textInputAction: TextInputAction.search,
              style: textTheme(context).bodyLarge,
              decoration: InputDecoration(
                isDense: true,
                border: InputBorder.none,
                hintText: 'Search brands',
                hintStyle: textTheme(context)
                    .bodyLarge!
                    .copyWith(color: AppColors.grayMain),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: Dimens.spacing_12),
              ),
            ),
          ),
          if (query.isNotEmpty)
            GestureDetector(
              onTap: onClear,
              behavior: HitTestBehavior.opaque,
              child: const Padding(
                padding: EdgeInsets.only(left: Dimens.spacingSizeExtraSmall),
                child: Icon(
                  Icons.close,
                  size: Dimens.iconSize_20,
                  color: AppColors.grayMain,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _FavoritesStrip extends StatelessWidget {
  const _FavoritesStrip({required this.favorites});

  final List<Vendor> favorites;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _kFavBlockHeight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: Dimens.spacingSizeDefault),
            child: _SectionLabel('FAVOURITES'),
          ),
          const SizedBox(height: Dimens.spacingSizeSmall),
          // Reserve the alphabet-rail gutter so the horizontal strip never
          // scrolls a pill underneath the rail.
          Padding(
            padding: const EdgeInsets.only(right: _kRailWidth),
            child: SizedBox(
              height: 40,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(
                    horizontal: Dimens.spacingSizeDefault),
                itemCount: favorites.length,
                separatorBuilder: (_, __) =>
                    const SizedBox(width: Dimens.spacingSizeSmall),
                itemBuilder: (context, index) =>
                    _FavoritePill(vendor: favorites[index]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FavoritePill extends StatelessWidget {
  const _FavoritePill({required this.vendor});

  final Vendor vendor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => NavigationHelper.push(
        context,
        VendorProfileScreen(seller: vendor.seller),
      ),
      child: Container(
        alignment: Alignment.center,
        padding:
            const EdgeInsets.symmetric(horizontal: Dimens.spacingSizeDefault),
        decoration: BoxDecoration(
          color: AppColors.grayLighter,
          border: Border.all(color: AppColors.grayLine),
          borderRadius: BorderRadius.circular(Dimens.radiusSmall),
        ),
        child: Text(
          vendor.seller.storeName,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: textTheme(context).titleSmall!.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
      ),
    );
  }
}

class _AllBrandsTitle extends StatelessWidget {
  const _AllBrandsTitle();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: _kAllBrandsTitleHeight,
      child: Padding(
        padding: EdgeInsets.only(
          left: Dimens.spacingSizeDefault,
          top: Dimens.spacingSizeSmall,
          bottom: Dimens.spacingSizeSmall,
        ),
        child: Align(
          alignment: Alignment.centerLeft,
          child: _SectionLabel('ALL BRANDS'),
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: textTheme(context).bodySmall!.copyWith(
            color: AppColors.grayMain,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.2,
          ),
    );
  }
}

class _BrandRow extends StatelessWidget {
  const _BrandRow({
    required this.vendor,
    required this.showFavButton,
    this.rightPadding = Dimens.spacingSizeDefault,
  });

  final Vendor vendor;
  final bool showFavButton;
  // Extra right inset so trailing content clears the alphabet rail on the
  // listing screen; the search-results reuse passes the plain default.
  final double rightPadding;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => NavigationHelper.push(
        context,
        VendorProfileScreen(seller: vendor.seller),
      ),
      child: Container(
        height: _kRowHeight,
        padding: EdgeInsets.only(
          left: Dimens.spacingSizeDefault,
          right: rightPadding,
        ),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(color: AppColors.grayLine, width: 0.7),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                vendor.seller.storeName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: textTheme(context).titleMedium!.copyWith(
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.2,
                    ),
              ),
            ),
            if (showFavButton) FavVendorButtonWidget(vendorId: vendor.id),
          ],
        ),
      ),
    );
  }
}

// Public sliver list of brand rows, reused by the brand search results screen
// so search stays visually consistent with the redesigned directory.
class SnippetVendorListing extends StatelessWidget {
  const SnippetVendorListing({super.key, required this.vendors});

  final List<Vendor> vendors;

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);
    return SliverList.builder(
      itemCount: vendors.length,
      itemBuilder: (context, index) => _BrandRow(
        vendor: vendors[index],
        showFavButton: authViewModel.isLoggedIn,
      ),
    );
  }
}

class _LetterHeaderDelegate extends SliverPersistentHeaderDelegate {
  _LetterHeaderDelegate(this.letter);

  final String letter;

  @override
  double get minExtent => _kSectionHeaderHeight;

  @override
  double get maxExtent => _kSectionHeaderHeight;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      height: _kSectionHeaderHeight,
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.only(left: Dimens.spacingSizeDefault),
      // Opaque so pinned headers cleanly cover rows scrolling underneath.
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Text(
        letter,
        style: textTheme(context).bodyMedium!.copyWith(
              color: AppColors.grayMain,
              fontWeight: FontWeight.w700,
              letterSpacing: 1,
            ),
      ),
    );
  }

  @override
  bool shouldRebuild(covariant _LetterHeaderDelegate oldDelegate) =>
      oldDelegate.letter != letter;
}

class _AlphabetRail extends StatelessWidget {
  const _AlphabetRail({
    required this.presentLetters,
    required this.onLetter,
    required this.onActiveChanged,
  });

  final Set<String> presentLetters;
  // (letter, animate) - taps animate, drags jump for a live follow.
  final void Function(String letter, bool animate) onLetter;
  final ValueChanged<String?> onActiveChanged;

  static const List<String> letters = [
    'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', //
    'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z', '#',
  ];

  void _handleAt(double localY, double height, {required bool animate}) {
    final step = height / letters.length;
    final index = (localY / step).floor().clamp(0, letters.length - 1);
    final letter = letters[index];
    onActiveChanged(letter);
    onLetter(letter, animate);
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      bottom: 0,
      right: 0,
      width: _kRailWidth,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final height = constraints.maxHeight;
          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTapDown: (d) =>
                _handleAt(d.localPosition.dy, height, animate: true),
            onTapUp: (_) => onActiveChanged(null),
            onVerticalDragStart: (d) =>
                _handleAt(d.localPosition.dy, height, animate: false),
            onVerticalDragUpdate: (d) =>
                _handleAt(d.localPosition.dy, height, animate: false),
            onVerticalDragEnd: (_) => onActiveChanged(null),
            onVerticalDragCancel: () => onActiveChanged(null),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (final letter in letters)
                  Expanded(
                    child: Center(
                      child: Text(
                        letter,
                        style: TextStyle(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w600,
                          color: presentLetters.contains(letter)
                              ? AppColors.secondaryMain
                              : AppColors.grayLight,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _RailBubble extends StatelessWidget {
  const _RailBubble({required this.letter});

  final String letter;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: IgnorePointer(
        child: Center(
          child: Container(
            width: 72,
            height: 72,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.secondaryMain.withOpacity(0.92),
              shape: BoxShape.circle,
            ),
            child: Text(
              letter,
              style: const TextStyle(
                color: AppColors.white,
                fontSize: Dimens.fontSizeOverLarge,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.isSearching});

  final bool isSearching;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(Dimens.spacingSizeLarge),
        child: Text(
          isSearching ? 'No brands match your search.' : 'No brands yet.',
          textAlign: TextAlign.center,
          style: textTheme(context)
              .bodyLarge!
              .copyWith(color: AppColors.grayMain),
        ),
      ),
    );
  }
}
