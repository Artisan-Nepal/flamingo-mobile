class PaginationOption {
  final int page;
  final int limit;

  PaginationOption({
    this.page = 1,
    this.limit = 10,
  });

  Map<String, dynamic> toJson() => {
        "page": page,
        "limit": limit,
      };
}
