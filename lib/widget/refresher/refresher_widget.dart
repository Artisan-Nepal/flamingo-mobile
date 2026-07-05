import 'package:flamingo/widget/load-more/load_more_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class RefresherWidget extends StatefulWidget {
  const RefresherWidget({
    super.key,
    required this.controller,
    this.enablePullDown = true,
    this.onLoadMore,
    this.enablePullUp = false,
    required this.onRefresh,
    required this.child,
    this.initialPage,
    this.limit,
  });

  final RefreshController controller;
  final bool enablePullDown;
  final bool enablePullUp;
  final Future<bool> Function(int page, int limit)? onLoadMore;
  final Future<void> Function() onRefresh;
  final Widget child;
  final int? initialPage;
  final int? limit;

  @override
  State<RefresherWidget> createState() => _RefresherWidgetState();
}

class _RefresherWidgetState extends State<RefresherWidget> {
  @override
  void initState() {
    super.initState();

    final viewModel = Provider.of<LoadMoreViewModel>(context, listen: false);
    viewModel.init(widget.initialPage ?? 2, widget.limit ?? 10);
  }

  _onLoading() async {
    if (widget.onLoadMore == null) return;
    final viewModel = Provider.of<LoadMoreViewModel>(context, listen: false);

    viewModel.setLoader(true);
    final success = await widget.onLoadMore!(viewModel.page, viewModel.limit);
    viewModel.setLoader(false);

    if (success) {
      viewModel.increasePage();
    }

    widget.controller.loadComplete();
  }

  _onRefresh() async {
    await widget.onRefresh();
    widget.controller.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    // pull_to_refresh's default spring (mass 2.2, stiffness 150, damping 16) is
    // underdamped — critical damping for those values is ~36, so it oscillates
    // and the overscroll visibly bounces. Override it with Flutter's own scroll
    // spring (critically damped) so these screens settle like the native
    // RefreshIndicator-based screens (Home, Category) instead of bouncing extra.
    return RefreshConfiguration(
      springDescription: SpringDescription.withDampingRatio(
        mass: 0.5,
        stiffness: 100.0,
        ratio: 1.1,
      ),
      child: SmartRefresher(
        controller: widget.controller,
        enablePullDown: widget.enablePullDown,
        enablePullUp: widget.enablePullUp,
        onLoading: _onLoading,
        onRefresh: _onRefresh,
        // footer: CustomFooter(
        //   builder: (context, mode) {
        //     if (mode == LoadStatus.loading) {
        //       return DefaultScreenLoaderWidget();
        //     }
        //     return SizedBox();
        //   },
        // ),
        child: widget.child,
      ),
    );
  }
}
