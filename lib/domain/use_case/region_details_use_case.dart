import 'package:injectable/injectable.dart';
import 'package:medusa_admin/app/data/models/app/api_error_handler.dart';
import 'package:medusa_admin/di/di.dart';
import 'package:medusa_admin_flutter/medusa_admin.dart';
import 'package:multiple_result/multiple_result.dart';

@lazySingleton
class RegionDetailsUseCase {
  final RegionsRepository _regionsRepository =
      getIt<MedusaAdmin>().regionsRepository;
  final ShippingOptionsRepository _shippingOptionsRepository =
      getIt<MedusaAdmin>().shippingOptionsRepository;

  static RegionDetailsUseCase get instance => getIt<RegionDetailsUseCase>();

  Future<Result<Region, Failure>> fetchRegion(String id, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final result = await _regionsRepository.retrieve(id: id, queryParams: queryParameters);
      return Success(result!);
    } catch (error) {
      return Error(Failure.from(error));
    }
  }

  Future<Result<UserDeleteRegionRes, Failure>> deleteRegion(String id) async {
    try {
      final result = await _regionsRepository.delete(id: id);
      return Success(result!);
    } catch (error) {
      return Error(Failure.from(error));
    }
  }

  Future<Result<UserDeleteShippingOptionRes, Failure>> deleteShippingOption(
      String id) async {
    try {
      final result = await _shippingOptionsRepository.delete(id: id);
      return Success(result!);
    } catch (error) {
      return Error(Failure.from(error));
    }
  }

  Future<Result<UserRetrieveAllShippingOptionRes, Failure>>
      fetchShippingOptions({
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final result = await _shippingOptionsRepository.retrieveAll(
          queryParams: queryParameters);
      return Success(result!);
    } catch (error) {
      return Error(Failure.from(error));
    }
  }
}
