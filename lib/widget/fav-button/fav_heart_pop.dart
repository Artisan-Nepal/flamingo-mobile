import 'package:flutter/animation.dart';

/// Shared "pop" scale animation used by the favourite/wishlist heart buttons.
///
/// Drives a quick scale up to 1.3x and back to 1.0x so pressing a heart gives a
/// small, satisfying bounce. Kept in one place so the product and vendor heart
/// buttons stay visually consistent.
class FavHeartPop {
  const FavHeartPop._();

  static Animation<double> buildScale(AnimationController controller) {
    return TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: 1.0, end: 1.3)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 50,
      ),
      TweenSequenceItem(
        tween:
            Tween(begin: 1.3, end: 1.0).chain(CurveTween(curve: Curves.easeIn)),
        weight: 50,
      ),
    ]).animate(controller);
  }
}
