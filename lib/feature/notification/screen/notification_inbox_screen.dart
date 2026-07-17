import 'package:flamingo/di/di.dart';
import 'package:flamingo/feature/notification/data/model/notification_item.dart';
import 'package:flamingo/feature/notification/notification_router.dart';
import 'package:flamingo/feature/notification/notification_view_model.dart';
import 'package:flamingo/shared/shared.dart';
import 'package:flamingo/widget/error/default_error_widget.dart';
import 'package:flamingo/widget/loader/loader.dart';
import 'package:flamingo/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NotificationInboxScreen extends StatefulWidget {
  const NotificationInboxScreen({super.key});

  @override
  State<NotificationInboxScreen> createState() =>
      _NotificationInboxScreenState();
}

class _NotificationInboxScreenState extends State<NotificationInboxScreen> {
  final _viewModel = locator<NotificationViewModel>();

  @override
  void initState() {
    super.initState();
    _viewModel.getNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _viewModel,
      child: TitledScreen(
        title: 'NOTIFICATIONS',
        scrollable: false,
        appbarActions: [
          Consumer<NotificationViewModel>(
            builder: (context, viewModel, child) {
              if (viewModel.unreadCount == 0) return const SizedBox();
              return GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: viewModel.markAllRead,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: Dimens.spacingSizeExtraSmall,
                    vertical: Dimens.spacing_2,
                  ),
                  child: Text(
                    'Mark all read',
                    style: textTheme(context).bodySmall!.copyWith(
                          color: AppColors.secondaryMain,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
              );
            },
          ),
        ],
        child: Consumer<NotificationViewModel>(
          builder: (context, viewModel, child) {
            final useCase = viewModel.getNotificationsUseCase;
            if (useCase.isLoading) {
              return const DefaultScreenLoaderWidget();
            }
            if (useCase.hasError) {
              return DefaultErrorWidget(
                useListView: true,
                manuallyCenter: true,
                manualTop: 0.05,
                errorMessage: useCase.exception!,
                onActionButtonPressed: () => _viewModel.getNotifications(),
              );
            }
            final notifications = useCase.data?.rows ?? [];
            return RefreshIndicator.adaptive(
              onRefresh: () => _viewModel.getNotifications(),
              child: notifications.isEmpty
                  ? DefaultErrorWidget(
                      useListView: true,
                      manuallyCenter: true,
                      needImage: false,
                      errorMessage: 'No notifications yet',
                    )
                  : ListView.separated(
                      itemCount: notifications.length,
                      separatorBuilder: (context, index) =>
                          const VerticalSpaceWidget(
                              height: Dimens.spacingSizeSmall),
                      itemBuilder: (context, index) =>
                          _buildItem(notifications[index]),
                    ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildItem(NotificationItem notification) {
    return Dismissible(
      key: ValueKey(notification.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => _viewModel.delete(notification),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: Dimens.spacingSizeDefault),
        decoration: BoxDecoration(
          color: AppColors.secondaryMain,
          borderRadius: BorderRadius.circular(Dimens.radius_5),
        ),
        child: const Icon(
          Icons.delete_outline,
          color: AppColors.white,
        ),
      ),
      child: GestureDetector(
        onTap: () {
          _viewModel.markRead(notification);
          NotificationRouter.route(notification.metadata);
        },
        child: Container(
        padding: const EdgeInsets.all(Dimens.spacingSizeDefault),
        decoration: BoxDecoration(
          color: notification.hasRead
              ? AppColors.transparent
              : AppColors.grayLighter,
          borderRadius: BorderRadius.circular(Dimens.radius_5),
          border: Border.all(color: AppColors.grayLine),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!notification.hasRead) ...[
              Container(
                margin: const EdgeInsets.only(top: 6),
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: AppColors.secondaryMain,
                  shape: BoxShape.circle,
                ),
              ),
              const HorizontalSpaceWidget(width: Dimens.spacingSizeSmall),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    notification.title,
                    style: textTheme(context).titleSmall!.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  if (notification.description != null &&
                      notification.description!.isNotEmpty) ...[
                    const VerticalSpaceWidget(height: Dimens.spacing_2),
                    Text(
                      notification.description!,
                      style: textTheme(context).bodySmall,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
        ),
      ),
    );
  }
}
