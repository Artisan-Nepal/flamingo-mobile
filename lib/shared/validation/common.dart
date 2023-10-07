String? checkIfEmpty(String placeHolder, String? text) {
  if (text == null || text.isEmpty) {
    return '$placeHolder is required.';
  }
  return null;
}
