import 'package:flamingo/feature/fit-reference/data/model/fit_comparison.dart';
import 'package:flamingo/feature/fit-reference/data/model/fit_reference.dart';
import 'package:flamingo/feature/fit-reference/data/model/suggested_size.dart';

abstract class FitReferenceRemote {
  Future<List<FitReference>> getFitReferences({String? garmentZone});
  Future<FitReference> createFitReference({
    required String label,
    required String garmentZone,
    required String fitTypeHint,
    required List<FitReferenceMeasurement> measurements,
  });
  Future<FitReference> updateFitReference({
    required String id,
    String? label,
    String? fitTypeHint,
    List<FitReferenceMeasurement>? measurements,
  });
  Future<FitReference> setDefaultFitReference(String id);
  Future<void> deleteFitReference(String id);
  Future<FitComparisonResult> getFitComparison({
    required String variantId,
    required String referenceId,
  });
  Future<SuggestedSizeResult> getSuggestedSize({
    required String productId,
    required String referenceId,
  });
}
