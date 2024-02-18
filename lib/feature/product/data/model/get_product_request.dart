import 'package:flamingo/shared/enum/productType.dart';

class GetProductRequest {
  ProductType? productType;

  GetProductRequest({
    this.productType,
  });

  Map<String, dynamic> toJson() => {
        "productType": productType?.name,
      };
}
