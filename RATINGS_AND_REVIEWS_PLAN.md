# Customer Ratings & Reviews — Implementation Plan

Status: **DRAFT (awaiting sign-off)**
App: `flamingo-mobile` (customer)
Author: engineering
Last updated: 2026-08-05

---

## 1. Goal

Let customers rate a product (1–5 stars) and leave an optional written
review, and let shoppers read those ratings/reviews on the Product Detail
Page (PDP) before buying.

Two jobs to be done:

- **Write** — a buyer who received a product tells others how it went.
- **Read** — a shopper on the PDP sees an aggregate score, the star
  distribution, and individual reviews to build (or lose) confidence.

## 2. Product decisions (proposed defaults)

| # | Decision | Proposed default | Why |
|---|----------|------------------|-----|
| D1 | **Who can review** | Purchase‑gated: only a customer with a **Delivered** order for that product. Backend is the source of truth; app also uses order status to decide where to show the "Rate" CTA. | Matches the trust model already implied by the order pipeline; kills spam/fake reviews. |
| D2 | **One review per customer per product** | Yes; re‑opening the flow **edits** the existing review. | Standard; avoids review stuffing. |
| D3 | **Text required?** | Star rating required, title + comment optional. | Lowers friction; most users only tap stars. |
| D4 | **Photos in reviews** | **Phase 2** (upload-file feature already exists, so it's cheap to add later). | Keep MVP tight. |
| D5 | **Helpful votes / vendor replies / report** | **Phase 2**. | Backend-heavy, not core to the ask. |
| D6 | **Moderation** | Backend concern; app just renders what the API returns and shows a "pending review" state if the API flags it. | Out of app scope. |

> D1 and D4 are the two decisions that change the build the most — see the
> questions at the end.

## 3. Architecture fit

The app is MVVM: `ChangeNotifier` view-models + `provider`, a
`Response<T>` loading/complete/error wrapper, a feature-per-folder layout
(`data/{model,remote,mapper,local}` + `*_repository(_impl)` +
`screen/<name>/{screen,view_model,snippet_*}`), `get_it` DI registered per
feature, and `NavigationHelper.push(context, Screen(...))` navigation.
Pagination uses `FetchResponse<T>` + `PaginationOption` with the existing
`Refresher`/`LoadMore` widgets.

We add **one new feature module: `lib/feature/review/`** and a small set of
**reusable star widgets: `lib/widget/rating/`**. No architectural changes.

## 4. Backend contract (frontend assumes these; needs backend alignment)

New endpoints (added to `lib/data/remote/api_urls.dart`):

```
GET    /products/:id/reviews/summary      -> ReviewSummary
GET    /products/:id/reviews              -> FetchResponse<Review>  (?page,&limit,&sort,&star,&withPhotos)
GET    /products/:id/reviews/me           -> Review | null           (my existing review, for edit prefill)
POST   /reviews                           -> Review                  (CreateReviewRequest)
PATCH  /reviews/:id                       -> Review                  (CreateReviewRequest)
DELETE /reviews/:id                       -> 204
POST   /reviews/:id/helpful               -> { helpfulCount, voted } (Phase 2)
```

Also expose (so cards/PDP header show a star without an extra call):

- `ProductDetail.averageRating: double?`, `ProductDetail.reviewCount: int?`
- `Product.averageRating: double?`, `Product.reviewCount: int?`
  (nullable so existing payloads keep parsing).

### JSON shapes

```jsonc
// Review
{
  "id": "…",
  "productId": "…",
  "rating": 5,                     // 1..5
  "title": "Runs true to size",    // optional
  "comment": "Great fabric…",      // optional
  "images": ["https://…"],         // optional, Phase 2
  "reviewerName": "Aayush T.",
  "reviewerAvatar": "https://…",   // nullable
  "isVerifiedPurchase": true,
  "helpfulCount": 3,               // Phase 2
  "votedHelpful": false,           // Phase 2
  "createdAt": "2026-08-01T10:00:00Z",
  "updatedAt": "2026-08-01T10:00:00Z"
}

// ReviewSummary
{
  "averageRating": 4.6,
  "totalCount": 128,
  "breakdown": { "5": 90, "4": 22, "3": 8, "2": 5, "1": 3 }
}
```

If the backend isn't ready, we build against this contract and can point the
remote at a stub; nothing else in the app changes.

## 5. New files

```
lib/feature/review/
  data/
    model/
      review.dart                     # Review + fromJson/fromJsonList
      review_summary.dart             # ReviewSummary (avg, total, breakdown)
      create_review_request.dart      # productId, rating, title?, comment?, images?
      review_filter_params.dart       # sort + star + withPhotos -> query params
      model.dart                      # barrel
    remote/
      review_remote.dart
      review_remote_impl.dart
    review_repository.dart
    review_repository_impl.dart
  screen/
    product-reviews/                  # the PDP section + "see all" list
      product_review_view_model.dart  # summary + paginated list + sort/filter
      snippet_product_reviews.dart    # compact section embedded in PDP
      review_list_screen.dart         # full paginated list
      snippet_review_tile.dart        # one review row
      snippet_review_summary.dart     # big avg + distribution bars
      snippet_review_sort_sheet.dart  # sort bottom sheet
    write-review/
      write_review_view_model.dart    # form state + create/update/delete
      write_review_screen.dart        # star input + title + comment (+ photos P2)

lib/widget/rating/
  star_rating_widget.dart             # read-only star row from a double
  star_rating_input.dart              # interactive 1..5 selector
  rating_badge_widget.dart            # "★ 4.6 (128)" chip for cards/headers

lib/di/registration/feature/review.dart   # registerReviewFeature(...)
```

Edits to existing files:

- `lib/data/remote/api_urls.dart` — add review URLs.
- `lib/di/service_locator.dart` — call `registerReviewFeature(locator)`.
- `lib/feature/product/data/model/product_detail.dart` + `product.dart` — add
  nullable `averageRating`, `reviewCount`.
- `lib/feature/product/screen/product-detail/product_detail_screen.dart` —
  insert `SnippetProductReviews` between the info/expansion block and the
  related-products section; show `RatingBadgeWidget` near the title.
- `lib/feature/order/screen/order-detail/order_detail_screen.dart` and
  `.../order-listing/snippet_order_listing_item.dart` — add a **Rate & Review**
  CTA when `orderStatus.code` is delivered.
- `lib/widget/product/product_widget.dart` — optional tiny rating badge on the
  card when `averageRating != null`.

## 6. State / view-models

**`ProductReviewViewModel`** (factory)
- `Response<ReviewSummary> summaryUseCase`
- `Response<FetchResponse<Review>> reviewsUseCase` + accumulated `List<Review>`
- `ReviewSort sort` (recent | highest | lowest | helpful), `int? starFilter`, `bool withPhotos`
- `loadSummary(productId)`, `loadFirstPage(...)`, `loadMore()`, `applySort()`, `applyStarFilter()`
- `bool get hasMore` from `metadata.next`

**`WriteReviewViewModel`** (factory)
- form: `int rating`, `String title`, `String comment`, `List<String> imageUrls` (P2)
- `Response<Review> submitUseCase`
- `prefillFrom(productId)` → `getMyReviewForProduct` (edit mode)
- `submit(productId)` → create or update; `delete()`
- exposes `bool get isEditing`, `bool get canSubmit` (rating >= 1)

Both registered in `review.dart` as `registerFactory` (fresh per screen),
repository/remote as `registerLazySingleton`, mirroring `product.dart`.

## 7. UI plan

Design language: reuse existing tokens/widgets — `Dimens` spacing,
`AppColors` (stars use `AppColors.warning` = amber `#E6A313`, empty stars
`AppColors.grayLight`), `VerticalSpaceWidget`, `ButtonWidget` /
`OutlinedButtonWidget` / `TextButtonWidget`, `TextFieldWidget`,
`ExpansionTileWidget`, `BottomSheetWidget`, `DefaultScreenLoaderWidget`,
`DefaultErrorWidget`, `NotLoggedInWidget`, `Refresher` + `LoadMore`,
shimmer widgets for loading.

### 7.1 PDP — reviews section (`SnippetProductReviews`)

Placed after product info / expansion tiles, before related products.

```
┌─────────────────────────────────────────────┐
│  Ratings & Reviews                 See all → │
│                                              │
│   4.6   ★★★★★           5 ▓▓▓▓▓▓▓▓▓░  90     │
│   ─────  128 ratings    4 ▓▓▓░░░░░░░  22     │
│                         3 ▓░░░░░░░░░   8     │
│                         2 �…              5   │
│                         1 �…              3   │
│  ────────────────────────────────────────    │
│  ⬤ Aayush T.  ★★★★★  ✓ Verified   2d ago     │
│  "Runs true to size" — Great fabric, the …   │
│                                              │
│  ⬤ Sita K.    ★★★★☆  ✓ Verified   5d ago     │
│  Comfortable but the color is a shade …      │
│                                              │
│        [  Write a review  ]                  │
└─────────────────────────────────────────────┘
```

- Left: big `averageRating` + read-only `StarRatingWidget` + "N ratings".
- Right: 5→1 distribution bars, each a proportional fill (`AppColors.warning`
  track on `AppColors.grayLine`) with the per-star count.
- Then up to **2 preview review tiles** (`SnippetReviewTile`).
- **See all** → `ReviewListScreen`.
- **Write a review** button:
  - not logged in → route through the app's `NotLoggedInWidget` flow;
  - logged in but not eligible (no delivered order) → info bottom sheet:
    "You can review this after your order is delivered."
  - eligible → `WriteReviewScreen`.
- Loading → shimmer; error → compact retry; **empty state**: a soft card
  "No reviews yet — Be the first to review this product."

### 7.2 Review list screen (`ReviewListScreen`)

`TitledScreen` "Reviews (128)". Structure:

- Sticky **summary header** (`SnippetReviewSummary`, same block as PDP).
- **Controls row**: `Sort ▾` (opens `SnippetReviewSortSheet`: Most recent /
  Highest rated / Lowest rated / Most helpful[P2]) + star filter chips
  `All · 5 · 4 · 3 · 2 · 1` + `With photos` toggle[P2].
- **Paginated list** of `SnippetReviewTile` via `Refresher` (pull-to-refresh)
  + `LoadMore` (infinite scroll), matching order/product listings.
- Empty/filter-empty state and error/retry states.

`SnippetReviewTile`:

```
⬤  Aayush T.            ✓ Verified purchase
★★★★★                                2d ago
Runs true to size                      (title, bold, optional)
Great fabric and the stitching held up after
three washes. Ordered my usual size and it fit.
[img][img]                             (Phase 2)
👍 Helpful (3)                          (Phase 2)
```

### 7.3 Write / edit review (`WriteReviewScreen`)

`TitledScreen` "Write a review" (or "Edit your review").

```
┌─────────────────────────────────────────────┐
│  [img]  Nike Dri-FIT Tee                     │
│         Black · L                            │
│  ─────────────────────────────────────────   │
│  Your rating                                 │
│        ★  ★  ★  ★  ★     (tap to set)        │
│                                              │
│  Title (optional)                            │
│  [ ___________________________________ ]     │
│                                              │
│  Your review (optional)                      │
│  [ ________________________________     ]    │
│  [ ________________________________     ]    │
│                                   0 / 1000   │
│                                              │
│  + Add photos   (Phase 2)                    │
│                                              │
│        [        Submit review        ]       │
│  (edit mode)  Delete review                  │
└─────────────────────────────────────────────┘
```

- `StarRatingInput` — large, tappable 1–5 (drag-to-set optional). Submit
  disabled until `rating >= 1`.
- Title: single-line `TextFieldWidget` (optional).
- Comment: multiline `TextFieldWidget` with a character counter.
- Submit → loading state on the button; on success pop + success snackbar and
  tell the PDP section to refresh (summary + first page). On error, inline
  error + retry.
- Edit mode: prefilled from `getMyReviewForProduct`, adds **Delete** with a
  confirm `AlertDialog`.

### 7.4 Reusable rating widgets (`lib/widget/rating/`)

- `StarRatingWidget(value, size, showHalf)` — renders `Icons.star` /
  `star_half` / `star_border` in `AppColors.warning`.
- `StarRatingInput(value, onChanged, size)` — interactive selector.
- `RatingBadgeWidget(average, count)` — compact "★ 4.6 (128)" for PDP
  header and product cards; hidden when there are no ratings.

### 7.5 Entry points summary

| From | Control | Guard |
|------|---------|-------|
| PDP reviews section | "Write a review" button | login + delivered-order eligibility |
| Order **detail** (delivered) | "Rate & Review" primary/secondary button | order is delivered |
| Order **listing** item (delivered) | inline "Rate" text button | order is delivered |
| PDP header + product cards | `RatingBadgeWidget` (read-only) | shown only if `averageRating != null` |

## 8. DI & wiring

`registerReviewFeature(GetIt locator)`:
- `ReviewRemote` → `ReviewRemoteImpl(apiClient)` — lazy singleton
- `ReviewRepository` → `ReviewRepositoryImpl(reviewRemote)` — lazy singleton
- `ProductReviewViewModel`, `WriteReviewViewModel` — factories

Add `registerReviewFeature(locator);` in `service_locator.dart` (after
`registerProductFeature`, since it's PDP-adjacent).

## 9. Testing

- Model tests: `Review.fromJson`, `ReviewSummary.fromJson` (incl. missing
  optional fields), `CreateReviewRequest.toJson`, filter → query params.
- Widget test: `StarRatingInput` reports the tapped value; `StarRatingWidget`
  renders half stars.
- Follow the existing `test/` layout.

## 10. Phasing

**Phase 1 (MVP)** — models, remote, repo, DI, star widgets, PDP summary +
preview, review list with sort/star-filter/pagination, write/edit/delete from
order + PDP, rating badge on cards/header.

**Phase 2** — review photos, helpful votes, vendor replies, report‑review,
"with photos" filter, "most helpful" sort.

## 11. Open questions (need answers before coding)

1. **Eligibility (D1)** — purchase‑gated (only delivered orders) or open to any
   logged‑in customer?
2. **Backend** — do these endpoints exist / is there an API contract to match,
   or do we build frontend‑first against the contract in §4?
3. **Photos (D4)** — MVP or Phase 2?
