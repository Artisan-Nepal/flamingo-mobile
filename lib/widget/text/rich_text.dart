//function to create a RichText with bold matching parts

import 'package:flamingo/widget/text/text.dart';
import 'package:flutter/material.dart';

Widget createTextWithBoldMatches(String text, String query) {
  final List<Widget> textWidgets = [];
  final originalText = text; // Keep a copy of the original text
  text = text.toLowerCase();
  query = query.toLowerCase();
  int start = -1;
  int end = -1;
  if (text.contains(query)) {
    start = text.indexOf(query);
    end = start + query.length - 1;
  }

  for (int i = 0; i < text.length; i++) {
    if (i >= start && i <= end) {
      textWidgets.add(TextWidget(
        originalText[i],
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ));
    } else {
      textWidgets.add(
        TextWidget(
          originalText[i],
          style: TextStyle(fontSize: 18),
        ),
      );
    }
  }
  return Row(
    children: textWidgets,
  );
}
