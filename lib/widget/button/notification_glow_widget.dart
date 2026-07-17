import 'package:flamingo/feature/notification/notification_view_model.dart';
import 'package:flamingo/feature/notification/screen/notification_inbox_screen.dart';
import 'package:flamingo/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// A subtle, pulsing pink "bulb" that sits on the left of the home app bar.
///
/// When there are no unread notifications it renders nothing at all - the glow
/// stays "under the sheet" and only surfaces when there is something to see.
/// Tapping it opens the notification inbox.
class NotificationGlowWidget extends StatefulWidget {
  const NotificationGlowWidget({super.key});

  @override
  State<NotificationGlowWidget> createState() => _NotificationGlowWidgetState();
}

class _NotificationGlowWidgetState extends State<NotificationGlowWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  static const _pink = AppColors.secondaryMain;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final unreadCount = Provider.of<NotificationViewModel>(context).unreadCount;

    // Nothing to show - keep the glow tucked away entirely.
    if (unreadCount == 0) return const SizedBox.shrink();

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        NavigationHelper.push(context, const NotificationInboxScreen());
      },
      child: SizedBox(
        width: 44,
        height: 44,
        child: Center(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              // Ease into a gentle breathing curve between a dim and a bright
              // state so the glow feels alive but never distracting.
              final t = Curves.easeInOut.transform(_controller.value);
              return Container(
                width: 9,
                height: 9,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color.lerp(
                    _pink.withOpacity(0.75),
                    _pink,
                    t,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: _pink.withOpacity(0.25 + 0.35 * t),
                      blurRadius: 6 + 10 * t,
                      spreadRadius: 0.5 + 2 * t,
                    ),
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
