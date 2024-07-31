import 'package:flamingo/di/di.dart';
import 'package:flamingo/widget/load-more/load_more_view_model.dart';
import 'package:flamingo/widget/loader/loader.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoadMoreWidget extends StatefulWidget {
  const LoadMoreWidget({
    super.key,
    required this.scrollController,
    required this.onLoadMore,
    required this.child,
    this.initialPage,
    this.limit,
    this.useSliver = false,
  });

  final ScrollController scrollController;
  final Future<bool> Function(int page, int limit) onLoadMore;
  final int? initialPage;
  final int? limit;
  final Widget child;
  final bool useSliver;

  @override
  State<LoadMoreWidget> createState() => _LoadMoreWidgetState();
}

class _LoadMoreWidgetState extends State<LoadMoreWidget> {
  final _viewModel = locator<LoadMoreViewModel>();

  @override
  void initState() {
    super.initState();

    _viewModel.init(widget.initialPage ?? 1, widget.limit ?? 10);

    attachScrollControllerListener();
  }

  attachScrollControllerListener() {
    widget.scrollController.addListener(() async {
      if (widget.scrollController.position.maxScrollExtent ==
          widget.scrollController.position.pixels) {
        print('Hit bottom');

        _viewModel.setLoader(true);
        final success =
            await widget.onLoadMore(_viewModel.page, _viewModel.limit);
        _viewModel.setLoader(false);

        if (success) {
          _viewModel.increasePage();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => _viewModel,
      child: widget.useSliver ? buildSliver() : buildNormal(),
    );
  }

  Widget buildSliver() {
    return CustomScrollView(
      controller: widget.scrollController,
      slivers: [
        widget.child,
        Consumer<LoadMoreViewModel>(builder: (context, viewModel, child) {
          if (viewModel.isLoading) {
            return SliverToBoxAdapter(child: CircularProgressIndicatorWidget());
          }
          return SliverToBoxAdapter(child: SizedBox());
        })
      ],
    );
  }

  Widget buildNormal() {
    return Column(
      children: [
        widget.child,
        Consumer<LoadMoreViewModel>(builder: (context, viewModel, child) {
          if (viewModel.isLoading) {
            return CircularProgressIndicatorWidget();
          }
          return SizedBox();
        })
      ],
    );
  }
}
