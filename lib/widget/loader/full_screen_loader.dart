import 'package:flamingo/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

showFullScreenLoader(
  context, {
  bool allowPop = true,
  Color? barrierColor,
}) {
  showDialog(
    barrierColor: barrierColor ?? AppColors.black.withOpacity(0.3),
    context: context,
    builder: (context) => CustomLoader(
      allowPop: allowPop,
    ),
  );
}

class CustomLoader extends StatefulWidget {
  const CustomLoader({
    Key? key,
    this.allowPop = false,
  }) : super(key: key);

  final bool allowPop;

  @override
  State<CustomLoader> createState() => _CustomLoaderState();
}

class _CustomLoaderState extends State<CustomLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 400));
    _animationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return widget.allowPop;
      },
      child: Center(
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return Transform.scale(
              scale: 1,
              child: Stack(alignment: Alignment.center, children: [
                child!,
                SpinKitDualRing(
                  color: Colors.grey.shade500,
                  size: 43,
                  lineWidth: 2,
                )
              ]),
            );
          },
          child: Stack(
            children: [
              Container(
                padding: const EdgeInsets.all(5),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.grayLighter,
                ),
                child: Image.asset(
                  ImageConstants.appLogo,
                  height: 23,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
