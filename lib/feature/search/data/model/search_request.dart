class SearchRequest {
  String key;

  SearchRequest({
    required this.key,
  });

  Map<String, dynamic> toJson() => {
        "key": key,
      };
}
