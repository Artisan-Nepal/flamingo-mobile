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
    return SmartRefresher(
      controller: widget.controller,
      enablePullDown: widget.enablePullDown,
      enablePullUp: widget.enablePullUp,
      onLoading: _onLoading,
      onRefresh: _onRefresh,
      child: widget.child,
    );
  }
}
