class FetchResponse<T> {
  List<T> rows;
  FetchResponseMetadata metadata;

  FetchResponse({
    required this.rows,
    required this.metadata,
  });

  factory FetchResponse.fromJson(
      Map<String, dynamic> json, List<T> Function(dynamic json) dataFromJson) {
    return FetchResponse(
      rows: dataFromJson(json['rows']),
      metadata: FetchResponseMetadata.fromJson(json['meta']),
    );
  }
}

class FetchResponseMetadata {
  final int total;
  final int lastPage;
  final int currentPage;
  final int? prev;
  final int? next;

  FetchResponseMetadata({
    required this.total,
    required this.lastPage,
    required this.currentPage,
    required this.prev,
    required this.next,
  });

  factory FetchResponseMetadata.fromJson(Map<String, dynamic> json) {
    return FetchResponseMetadata(
      total: json['total'],
      lastPage: json['lastPage'],
      currentPage: json['currentPage'],
      prev: json['prev'],
      next: json['next'],
    );
  }
}
