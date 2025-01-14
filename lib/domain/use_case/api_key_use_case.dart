import 'package:injectable/injectable.dart';
import 'package:medusa_admin/app/data/models/app/api_error_handler.dart';
import 'package:medusa_admin/di/di.dart';
import 'package:medusa_admin_flutter/medusa_admin.dart';
import 'package:multiple_result/multiple_result.dart';
@lazySingleton
class ApiKeyUseCase {
  final PublishableApiKeyRepository _apiKeyRepository = getIt<MedusaAdmin>().publishableApiKeyRepository;

  static ApiKeyUseCase get instance => getIt<ApiKeyUseCase>();

  Future<Result<PublishableApiKey, Failure>> create(String title) async {
    try {
      final result = await _apiKeyRepository.createPublishableApiKey(title: title);
      return Success(result!);
    } catch (error) {
      return Error(Failure.from(error));
    }
  }
  Future<Result<UserRetrievePublishableApiKeysRes, Failure>> fetchApiKeys({
    Map<String, dynamic>? queryParameters,
}) async {
    try {
      final result = await _apiKeyRepository.retrievePublishableApiKeys(queryParameters: queryParameters);
      return Success(result!);
    } catch (error) {
      return Error(Failure.from(error));
    }
  }
}
