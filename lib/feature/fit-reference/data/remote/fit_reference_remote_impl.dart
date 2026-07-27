import 'package:flamingo/data/data.dart';
import 'package:flamingo/feature/fit-reference/data/model/fit_comparison.dart';
import 'package:flamingo/feature/fit-reference/data/model/fit_reference.dart';
import 'package:flamingo/feature/fit-reference/data/model/suggested_size.dart';
import 'package:flamingo/feature/fit-reference/data/remote/fit_reference_remote.dart';

class FitReferenceRemoteImpl implements FitReferenceRemote {
  final ApiClient _apiClient;

  FitReferenceRemoteImpl({required ApiClient apiClient})
      : _apiClient = apiClient;

  @override
  Future<List<FitReference>> getFitReferences({String? garmentZone}) async {
    final apiResponse = await _apiClient.get(
      ApiUrls.fitReferences,
      queryParams:
          garmentZone == null ? null : {'garmentZone': garmentZone},
    );
    return FitReference.fromJsonList(apiResponse.data);
  }

  @override
  Future<FitReference> createFitReference({
    required String label,
    required String garmentZone,
    required String fitTypeHint,
    required List<FitReferenceMeasurement> measurements,
  }) async {
    final apiResponse = await _apiClient.post(
      ApiUrls.fitReferences,
      body: {
        'label': label,
        'garmentZone': garmentZone,
        'fitTypeHint': fitTypeHint,
        'measurements': measurements.map((m) => m.toJson()).toList(),
      },
    );
    return FitReference.fromJson(apiResponse.data);
  }

  @override
  Future<FitReference> updateFitReference({
    required String id,
    String? label,
    String? fitTypeHint,
    List<FitReferenceMeasurement>? measurements,
  }) async {
    final apiResponse = await _apiClient.patch(
      '${ApiUrls.fitReferences}/$id',
      body: {
        if (label != null) 'label': label,
        if (fitTypeHint != null) 'fitTypeHint': fitTypeHint,
        if (measurements != null)
          'measurements': measurements.map((m) => m.toJson()).toList(),
      },
    );
    return FitReference.fromJson(apiResponse.data);
  }

  @override
  Future<FitReference> setDefaultFitReference(String id) async {
    final apiResponse =
        await _apiClient.patch('${ApiUrls.fitReferences}/$id/default');
    return FitReference.fromJson(apiResponse.data);
  }

  @override
  Future<void> deleteFitReference(String id) async {
    await _apiClient.delete('${ApiUrls.fitReferences}/$id');
  }

  @override
  Future<FitComparisonResult> getFitComparison({
    required String variantId,
    required String referenceId,
  }) async {
    final url = ApiUrls.fitComparison.replaceFirst(':id', variantId);
    final apiResponse = await _apiClient.get(
      url,
      queryParams: {'referenceId': referenceId},
    );
    return FitComparisonResult.fromJson(apiResponse.data);
  }

  @override
  Future<SuggestedSizeResult> getSuggestedSize({
    required String productId,
    required String referenceId,
  }) async {
    final url = ApiUrls.suggestedSize.replaceFirst(':id', productId);
    final apiResponse = await _apiClient.get(
      url,
      queryParams: {'referenceId': referenceId},
    );
    return SuggestedSizeResult.fromJson(apiResponse.data);
  }
}
