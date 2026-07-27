import 'package:flamingo/feature/fit-reference/data/fit_reference_repository.dart';
import 'package:flamingo/feature/fit-reference/data/model/fit_comparison.dart';
import 'package:flamingo/feature/fit-reference/data/model/fit_reference.dart';
import 'package:flamingo/feature/fit-reference/data/model/suggested_size.dart';
import 'package:flamingo/feature/fit-reference/data/remote/fit_reference_remote.dart';

class FitReferenceRepositoryImpl implements FitReferenceRepository {
  final FitReferenceRemote _fitReferenceRemote;

  FitReferenceRepositoryImpl({required FitReferenceRemote fitReferenceRemote})
      : _fitReferenceRemote = fitReferenceRemote;

  @override
  Future<List<FitReference>> getFitReferences({String? garmentZone}) async {
    return await _fitReferenceRemote.getFitReferences(
        garmentZone: garmentZone);
  }

  @override
  Future<FitReference> createFitReference({
    required String label,
    required String garmentZone,
    required String fitTypeHint,
    required List<FitReferenceMeasurement> measurements,
  }) async {
    return await _fitReferenceRemote.createFitReference(
      label: label,
      garmentZone: garmentZone,
      fitTypeHint: fitTypeHint,
      measurements: measurements,
    );
  }

  @override
  Future<FitReference> updateFitReference({
    required String id,
    String? label,
    String? fitTypeHint,
    List<FitReferenceMeasurement>? measurements,
  }) async {
    return await _fitReferenceRemote.updateFitReference(
      id: id,
      label: label,
      fitTypeHint: fitTypeHint,
      measurements: measurements,
    );
  }

  @override
  Future<FitReference> setDefaultFitReference(String id) async {
    return await _fitReferenceRemote.setDefaultFitReference(id);
  }

  @override
  Future<void> deleteFitReference(String id) async {
    return await _fitReferenceRemote.deleteFitReference(id);
  }

  @override
  Future<FitComparisonResult> getFitComparison({
    required String variantId,
    required String referenceId,
  }) async {
    return await _fitReferenceRemote.getFitComparison(
      variantId: variantId,
      referenceId: referenceId,
    );
  }

  @override
  Future<SuggestedSizeResult> getSuggestedSize({
    required String productId,
    required String referenceId,
  }) async {
    return await _fitReferenceRemote.getSuggestedSize(
      productId: productId,
      referenceId: referenceId,
    );
  }
}
