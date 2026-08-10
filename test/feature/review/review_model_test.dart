import 'package:flutter_test/flutter_test.dart';
import 'package:flamingo/feature/review/data/model/create_review_request.dart';
import 'package:flamingo/feature/review/data/model/review.dart';
import 'package:flamingo/feature/review/data/model/review_filter_params.dart';
import 'package:flamingo/feature/review/data/model/review_reply.dart';
import 'package:flamingo/feature/review/data/model/review_summary.dart';

void main() {
  group('Review.fromJson', () {
    test('parses a full review', () {
      final json = {
        'id': 'r1',
        'productId': 'p1',
        'rating': 5,
        'title': 'Runs true to size',
        'comment': 'Great fabric.',
        'reviewerName': 'Aayush T.',
        'reviewerAvatar': 'https://example.com/a.jpg',
        'isVerifiedPurchase': true,
        'createdAt': '2026-08-01T10:00:00.000Z',
        'updatedAt': '2026-08-01T10:00:00.000Z',
      };
      final review = Review.fromJson(json);
      expect(review.id, 'r1');
      expect(review.rating, 5);
      expect(review.title, 'Runs true to size');
      expect(review.isVerifiedPurchase, true);
    });

    test('defaults isVerifiedPurchase to false and allows null title/comment/avatar',
        () {
      final json = {
        'id': 'r2',
        'productId': 'p1',
        'rating': 3,
        'title': null,
        'comment': null,
        'reviewerName': 'Guest',
        'reviewerAvatar': null,
        'createdAt': '2026-08-01T10:00:00.000Z',
        'updatedAt': '2026-08-01T10:00:00.000Z',
      };
      final review = Review.fromJson(json);
      expect(review.isVerifiedPurchase, false);
      expect(review.title, null);
      expect(review.comment, null);
      expect(review.reviewerAvatar, null);
    });

    test('fromJsonList parses a list of reviews', () {
      final json = [
        {
          'id': 'r1',
          'productId': 'p1',
          'rating': 5,
          'reviewerName': 'A',
          'createdAt': '2026-08-01T10:00:00.000Z',
          'updatedAt': '2026-08-01T10:00:00.000Z',
        },
        {
          'id': 'r2',
          'productId': 'p1',
          'rating': 4,
          'reviewerName': 'B',
          'createdAt': '2026-08-01T10:00:00.000Z',
          'updatedAt': '2026-08-01T10:00:00.000Z',
        },
      ];
      final reviews = Review.fromJsonList(json);
      expect(reviews.length, 2);
      expect(reviews[1].rating, 4);
    });

    test('parses a nested vendor reply when present', () {
      final json = {
        'id': 'r3',
        'productId': 'p1',
        'rating': 5,
        'reviewerName': 'Aayush T.',
        'createdAt': '2026-08-01T10:00:00.000Z',
        'updatedAt': '2026-08-01T10:00:00.000Z',
        'reply': {
          'id': 'reply-1',
          'body': 'Thanks so much! Glad it fit well.',
          'storeName': 'Kathmandu Threads',
          'createdAt': '2026-08-04T09:00:00.000Z',
          'updatedAt': '2026-08-04T09:00:00.000Z',
        },
      };
      final review = Review.fromJson(json);
      expect(review.reply, isNotNull);
      expect(review.reply!.body, 'Thanks so much! Glad it fit well.');
      expect(review.reply!.storeName, 'Kathmandu Threads');
    });

    test('reply is null when absent from the payload', () {
      final json = {
        'id': 'r4',
        'productId': 'p1',
        'rating': 5,
        'reviewerName': 'Aayush T.',
        'createdAt': '2026-08-01T10:00:00.000Z',
        'updatedAt': '2026-08-01T10:00:00.000Z',
      };
      expect(Review.fromJson(json).reply, isNull);
    });
  });

  group('ReviewReply.fromJson', () {
    test('parses a reply', () {
      final reply = ReviewReply.fromJson({
        'id': 'reply-1',
        'body': 'Thanks so much!',
        'storeName': 'Kathmandu Threads',
        'createdAt': '2026-08-04T09:00:00.000Z',
        'updatedAt': '2026-08-04T09:00:00.000Z',
      });
      expect(reply.id, 'reply-1');
      expect(reply.body, 'Thanks so much!');
      expect(reply.storeName, 'Kathmandu Threads');
    });
  });

  group('ReviewSummary', () {
    test('fromJson parses breakdown keys as ints', () {
      final json = {
        'averageRating': 4.6,
        'totalCount': 128,
        'breakdown': {'5': 90, '4': 22, '3': 8, '2': 5, '1': 3},
      };
      final summary = ReviewSummary.fromJson(json);
      expect(summary.averageRating, 4.6);
      expect(summary.totalCount, 128);
      expect(summary.countFor(5), 90);
      expect(summary.countFor(1), 3);
      expect(summary.fractionFor(5), closeTo(90 / 128, 0.0001));
    });

    test('missing breakdown defaults counts to 0', () {
      final summary = ReviewSummary.fromJson({
        'averageRating': 0,
        'totalCount': 0,
      });
      expect(summary.countFor(5), 0);
      expect(summary.fractionFor(5), 0);
    });

    test('empty() has zero totals and no division-by-zero in fractionFor', () {
      final summary = ReviewSummary.empty();
      expect(summary.totalCount, 0);
      expect(summary.fractionFor(3), 0);
    });
  });

  group('CreateReviewRequest.toJson', () {
    test('omits blank title/comment', () {
      final request = CreateReviewRequest(
        productId: 'p1',
        rating: 4,
        title: '',
        comment: '',
      );
      final json = request.toJson();
      expect(json.containsKey('title'), false);
      expect(json.containsKey('comment'), false);
      expect(json['rating'], 4);
    });

    test('includes non-blank title/comment', () {
      final request = CreateReviewRequest(
        productId: 'p1',
        rating: 4,
        title: 'Nice',
        comment: 'Good buy',
      );
      final json = request.toJson();
      expect(json['title'], 'Nice');
      expect(json['comment'], 'Good buy');
    });
  });

  group('ReviewFilterParams', () {
    test('toQueryParams includes sort and omits star when unset', () {
      const filters = ReviewFilterParams();
      final params = filters.toQueryParams();
      expect(params['sort'], 'recent');
      expect(params.containsKey('star'), false);
    });

    test('toQueryParams includes star when set', () {
      const filters = ReviewFilterParams(sort: ReviewSort.highest, star: 5);
      final params = filters.toQueryParams();
      expect(params['sort'], 'highest');
      expect(params['star'], '5');
    });

    test('copyWith clearStar removes the star filter', () {
      const filters = ReviewFilterParams(star: 5);
      final cleared = filters.copyWith(clearStar: true);
      expect(cleared.star, null);
    });
  });
}
