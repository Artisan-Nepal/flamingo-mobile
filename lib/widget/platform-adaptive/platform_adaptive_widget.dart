import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

abstract class PlatformAdaptiveWidget<C extends Widget, M extends Widget>
    extends StatelessWidget {
  const PlatformAdaptiveWidget({Key? key}) : super(key: key);

  C buildCupertinoWidget(BuildContext context);
  M buildMaterialWidget(BuildContext context);

  @override
  Widget build(BuildContext context) {
    if (!kIsWeb) {
      if (Platform.isAndroid) {
        return buildMaterialWidget(context);
      } else {
        return buildCupertinoWidget(context);
      }
    } else {
      return buildMaterialWidget(context);
    }
  }
}
