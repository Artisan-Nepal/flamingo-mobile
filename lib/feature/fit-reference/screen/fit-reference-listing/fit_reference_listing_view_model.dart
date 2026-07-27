import 'package:flamingo/feature/fit-reference/data/fit_reference_repository.dart';
import 'package:flamingo/feature/fit-reference/data/model/fit_reference.dart';
import 'package:flamingo/shared/shared.dart';
import 'package:flutter/cupertino.dart';

class FitReferenceListingViewModel extends ChangeNotifier {
  final FitReferenceRepository _fitReferenceRepository;

  FitReferenceListingViewModel({
    required FitReferenceRepository fitReferenceRepository,
  }) : _fitReferenceRepository = fitReferenceRepository;

  Response<List<FitReference>> _getReferencesUseCase =
      Response<List<FitReference>>();
  Response<List<FitReference>> get getReferencesUseCase =>
      _getReferencesUseCase;

  void setReferencesUseCase(Response<List<FitReference>> response) {
    _getReferencesUseCase = response;
    notifyListeners();
  }

  Future<void> getReferences() async {
    try {
      setReferencesUseCase(Response.loading());
      final response = await _fitReferenceRepository.getFitReferences();
      setReferencesUseCase(Response.complete(response));
    } catch (exception) {
      setReferencesUseCase(Response.error(exception));
    }
  }

  Future<bool> deleteReference(String id) async {
    try {
      await _fitReferenceRepository.deleteFitReference(id);
      await getReferences();
      return true;
    } catch (exception) {
      return false;
    }
  }

  Future<bool> setDefault(String id) async {
    try {
      await _fitReferenceRepository.setDefaultFitReference(id);
      await getReferences();
      return true;
    } catch (exception) {
      return false;
    }
  }
}
