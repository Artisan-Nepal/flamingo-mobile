import 'package:flamingo/feature/fit-reference/data/fit_reference_repository.dart';
import 'package:flamingo/feature/fit-reference/data/model/fit_reference.dart';
import 'package:flamingo/shared/shared.dart';
import 'package:flutter/cupertino.dart';

class ManageFitReferenceViewModel extends ChangeNotifier {
  final FitReferenceRepository _fitReferenceRepository;

  ManageFitReferenceViewModel({
    required FitReferenceRepository fitReferenceRepository,
  }) : _fitReferenceRepository = fitReferenceRepository;

  Response<FitReference> _saveUseCase = Response<FitReference>();
  Response<FitReference> get saveUseCase => _saveUseCase;

  void setSaveUseCase(Response<FitReference> response) {
    _saveUseCase = response;
    notifyListeners();
  }

  Future<void> create({
    required String label,
    required String garmentZone,
    required String fitTypeHint,
    required List<FitReferenceMeasurement> measurements,
  }) async {
    try {
      setSaveUseCase(Response.loading());
      final response = await _fitReferenceRepository.createFitReference(
        label: label,
        garmentZone: garmentZone,
        fitTypeHint: fitTypeHint,
        measurements: measurements,
      );
      setSaveUseCase(Response.complete(response));
    } catch (exception) {
      setSaveUseCase(Response.error(exception));
    }
  }

  Future<void> update({
    required String id,
    required String label,
    required String fitTypeHint,
    required List<FitReferenceMeasurement> measurements,
  }) async {
    try {
      setSaveUseCase(Response.loading());
      final response = await _fitReferenceRepository.updateFitReference(
        id: id,
        label: label,
        fitTypeHint: fitTypeHint,
        measurements: measurements,
      );
      setSaveUseCase(Response.complete(response));
    } catch (exception) {
      setSaveUseCase(Response.error(exception));
    }
  }
}
