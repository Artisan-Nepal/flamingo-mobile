import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flamingo/widget/rating/star_rating_input.dart';
import 'package:flamingo/widget/rating/star_rating_widget.dart';

void main() {
  group('StarRatingInput', () {
    testWidgets('tapping a star reports its 1-indexed position', (tester) async {
      int? tapped;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StarRatingInput(
              value: 0,
              onChanged: (value) => tapped = value,
            ),
          ),
        ),
      );

      // Five stars laid out left to right - tap the third.
      final stars = find.byIcon(Icons.star_border);
      await tester.tap(stars.at(2));
      await tester.pump();

      expect(tapped, 3);
    });

    testWidgets('renders filled stars up to value, empty after', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: StarRatingInput(value: 3, onChanged: _noop),
          ),
        ),
      );

      expect(find.byIcon(Icons.star), findsNWidgets(3));
      expect(find.byIcon(Icons.star_border), findsNWidgets(2));
    });
  });

  group('StarRatingWidget', () {
    testWidgets('renders a half star for a fractional value', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: StarRatingWidget(value: 3.5),
          ),
        ),
      );

      expect(find.byIcon(Icons.star), findsNWidgets(3));
      expect(find.byIcon(Icons.star_half), findsOneWidget);
      expect(find.byIcon(Icons.star_border), findsOneWidget);
    });

    testWidgets('renders all empty stars for a zero value', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: StarRatingWidget(value: 0),
          ),
        ),
      );

      expect(find.byIcon(Icons.star_border), findsNWidgets(5));
    });
  });
}

void _noop(int _) {}
