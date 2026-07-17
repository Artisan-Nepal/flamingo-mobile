import 'package:flamingo/feature/notification/notification_view_model.dart';
import 'package:flamingo/feature/notification/screen/notification_inbox_screen.dart';
import 'package:flamingo/shared/shared.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class NotificationButtonWidget extends StatelessWidget {
  const NotificationButtonWidget({super.key, this.iconColor = AppColors.black});

  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    final unreadCount =
        Provider.of<NotificationViewModel>(context).unreadCount;
    return GestureDetector(
      onTap: () {
        NavigationHelper.push(context, const NotificationInboxScreen());
      },
      child: Container(
        color: AppColors.transparent,
        height: 30,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Icon(
              CupertinoIcons.bell,
              size: 22,
              color: iconColor,
            ),
            if (unreadCount > 0)
              Positioned(
                right: -2,
                top: -2,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: AppColors.secondaryMain,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
