import 'dart:io';
import '../entities/report.dart';
import '../repositories/report_repository.dart';


class CreateReportUseCase {
  final ReportRepository repository;

  CreateReportUseCase(this.repository);

  Future<Report> call(CreateReportParams params) async {
    
    if (params.wasteType.isEmpty) {
      throw Exception('Waste type is required');
    }

    return await repository.createReport(
      image: params.image,
      wasteType: params.wasteType,
      locationDescription: params.locationDescription,
      latitude: params.latitude,
      longitude: params.longitude,
      locationName: params.locationName,
      additionalDetails: params.additionalDetails,
    );
  }
}


class CreateReportParams {
  final File image;
  final String wasteType;
  final String? locationDescription;
  final double? latitude;
  final double? longitude;
  final String? locationName;
  final String? additionalDetails;

  CreateReportParams({
    required this.image,
    required this.wasteType,
    this.locationDescription,
    this.latitude,
    this.longitude,
    this.locationName,
    this.additionalDetails,
  });
}
