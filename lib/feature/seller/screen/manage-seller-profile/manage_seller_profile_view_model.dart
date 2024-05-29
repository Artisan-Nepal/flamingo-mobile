import 'package:flamingo/di/di.dart';
import 'package:flamingo/feature/auth/auth_view_model.dart';
import 'package:flamingo/feature/seller/data/model/register_seller_request.dart';
import 'package:flamingo/feature/seller/data/model/update_seller_request.dart';
import 'package:flamingo/feature/seller/data/seller_repository.dart';
import 'package:flamingo/shared/util/util.dart';
import 'package:flutter/material.dart';

class ManageSellerProfileViewModel extends ChangeNotifier {
  final SellerRepository _sellerRepository;

  ManageSellerProfileViewModel({required SellerRepository sellerRepository})
      : _sellerRepository = sellerRepository;

  Response _manageSellerAccountUseCase = Response();
  Response get manageSellerAccountUseCase => _manageSellerAccountUseCase;

  void setManageSellerAccountUseCase(Response response) {
    _manageSellerAccountUseCase = response;
    notifyListeners();
  }

  Future<void> manageSellerProfile({
    String? existingSellerId,
    required String storeName,
    required String storeDescription,
  }) async {
    try {
      setManageSellerAccountUseCase(Response.loading());
      final response = existingSellerId == null
          ? await _sellerRepository.registerSeller(
              RegisterSellerRequest(
                storeDescription: storeDescription,
                storeName: storeName,
              ),
            )
          : await _sellerRepository.updateSeller(
              existingSellerId,
              UpdateSellerRequest(
                storeName: storeName,
                storeDescription: storeDescription,
              ),
            );

      await locator<AuthViewModel>().syncRemotely();

      setManageSellerAccountUseCase(Response.complete(response));
    } catch (exception) {
      setManageSellerAccountUseCase(Response.error(exception));
    }
  }
}
