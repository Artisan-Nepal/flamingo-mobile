import 'package:flamingo/widget/load-more/load_more_view_model.dart';
import 'package:flamingo/widget/loader/loader.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoadMoreWidget extends StatefulWidget {
  const LoadMoreWidget({
    super.key,
    required this.scrollController,
    required this.onLoadMore,
    this.initialPage,
    this.limit,
  });

  final ScrollController scrollController;
  final Future<bool> Function(int page, int limit) onLoadMore;
  final int? initialPage;
  final int? limit;

  @override
  State<LoadMoreWidget> createState() => _LoadMoreWidgetState();
}

class _LoadMoreWidgetState extends State<LoadMoreWidget> {
  @override
  void initState() {
    super.initState();

    final viewModel = Provider.of<LoadMoreViewModel>(context, listen: false);
    viewModel.init(widget.initialPage ?? 2, widget.limit ?? 10);

    attachScrollControllerListener();
  }

  attachScrollControllerListener() {
    final viewModel = Provider.of<LoadMoreViewModel>(context, listen: false);

    widget.scrollController.addListener(() async {
      if (widget.scrollController.position.maxScrollExtent ==
              widget.scrollController.position.pixels &&
          !viewModel.isLoading) {
        viewModel.setLoader(true);
        final success =
            await widget.onLoadMore(viewModel.page, viewModel.limit);
        viewModel.setLoader(false);

        if (success) {
          viewModel.increasePage();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LoadMoreViewModel>(
      builder: (context, viewModel, child) {
        if (viewModel.isLoading) {
          return Center(child: CircularProgressIndicatorWidget());
        }
        return SizedBox();
      },
    );
  }
}
