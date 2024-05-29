class UpdateSellerRequest {
  String? storeName;
  String? storeDescription;
  String? displayImageUrl;
  String? bankName;
  String? bankAccName;
  String? bankAccNumber;
  String? bankBranchName;
  String? bankCheckPhoto;
  String? pan;

  UpdateSellerRequest({
    this.storeName,
    this.storeDescription,
    this.displayImageUrl,
    this.bankName,
    this.bankAccName,
    this.bankBranchName,
    this.bankCheckPhoto,
    this.pan,
    this.bankAccNumber,
  });

  Map<String, dynamic> toJson() {
    Map<String, dynamic> jsonMap = {};

    if (storeName != null) jsonMap['storeName'] = storeName;
    if (storeDescription != null)
      jsonMap['storeDescription'] = storeDescription;

    if (displayImageUrl != null) jsonMap['displayImageId'] = displayImageUrl;
    if (bankName != null) jsonMap['bankName'] = bankName;
    if (bankAccName != null) jsonMap['bankAccName'] = bankAccName;
    if (bankAccNumber != null) jsonMap['bankAccNumber'] = bankAccNumber;
    if (bankBranchName != null) jsonMap['bankBranchName'] = bankBranchName;
    if (bankCheckPhoto != null) jsonMap['bankCheckPhoto'] = bankCheckPhoto;
    if (pan != null) jsonMap['pan'] = pan;

    return jsonMap;
  }
}
