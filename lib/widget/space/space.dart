import 'package:flutter/material.dart';
import 'package:flamingo/shared/util/util.dart';

class VerticalSpaceWidget extends StatelessWidget {
  final double height;
  final bool? adapt;
  final double? adaptValue;

  const VerticalSpaceWidget({
    Key? key,
    required this.height,
    this.adapt,
    this.adaptValue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isMediumScreen = SizeConfig.isMediumDevice;
    bool isSmallerScreen = SizeConfig.isSmallerDevice;
    return SizedBox(
      height: adapt != null && adapt! && isMediumScreen
          ? height * (adaptValue ?? 1.0)
          : adapt != null && adapt! && isSmallerScreen
              ? height * 0.5
              : height,
    );
  }
}

class BottomSpaceWidget extends StatelessWidget {
  final double height;
  final bool? adapt;
  final double? adaptValue;

  const BottomSpaceWidget({
    Key? key,
    required this.height,
    this.adapt,
    this.adaptValue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isMediumScreen = SizeConfig.isMediumDevice;
    bool isSmallerScreen = SizeConfig.isSmallerDevice;
    return Padding(
      padding: EdgeInsets.only(
        bottom: adapt != null && adapt! && isMediumScreen
            ? height * (adaptValue ?? 1.0)
            : adapt != null && adapt! && isSmallerScreen
                ? height * 0.5
                : height,
      ),
    );
  }
}

class TopSpaceWidget extends StatelessWidget {
  final double height;
  final bool? adapt;
  final double? adaptValue;

  const TopSpaceWidget({
    Key? key,
    required this.height,
    this.adapt,
    this.adaptValue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isMediumScreen = SizeConfig.isMediumDevice;
    bool isSmallerScreen = SizeConfig.isSmallerDevice;
    return Padding(
      padding: EdgeInsets.only(
        top: adapt != null && adapt! && isMediumScreen
            ? height * (adaptValue ?? 1.0)
            : adapt != null && adapt! && isSmallerScreen
                ? height * 0.5
                : height,
      ),
    );
  }
}

class HorizontalSpaceWidget extends StatelessWidget {
  final double width;
  final bool? adapt;
  final double? adaptValue;

  const HorizontalSpaceWidget({
    Key? key,
    required this.width,
    this.adapt,
    this.adaptValue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isMediumScreen = SizeConfig.isMediumDevice;
    bool isSmallerScreen = SizeConfig.isSmallerDevice;
    return SizedBox(
      width: adapt != null && adapt! && isMediumScreen
          ? width * (adaptValue ?? 1.0)
          : adapt != null && adapt! && isSmallerScreen
              ? width * 0.5
              : width,
    );
  }
}
