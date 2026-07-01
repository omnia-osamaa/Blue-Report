import '../../domain/entities/report.dart';


class ReportModel extends Report {
  const ReportModel({
    required super.id,
    required super.displayId,
    required super.userId,
    required super.wasteType,
    super.adminNote,
    super.latitude,
    super.longitude,
    super.locationName,
    required super.imagePath,
    super.additionalDetails,
    required super.status,
    super.pointsEarned = 0,
    required super.createdAt,
    super.verifiedAt,
  });

  factory ReportModel.fromJson(Map<String, dynamic> json) {
    return ReportModel(
      id: json['id']?.toString() ?? '',
      displayId: json['report_id']?.toString() ?? json['id']?.toString() ?? '',
      userId: json['user_id']?.toString() ?? '',
      wasteType: json['waste_type'] ?? json['wasteType'] ?? 'General',
      adminNote: json['admin_note']?.toString(),
      latitude: double.tryParse(json['lat']?.toString() ?? ''),
      longitude: double.tryParse(json['lng']?.toString() ?? ''),
      locationName: json['location_text']?.toString() ?? json['locationName']?.toString(),
      imagePath: json['image']?.toString() ?? json['imagePath']?.toString() ?? '',
      additionalDetails: json['description']?.toString() ?? json['additionalDetails']?.toString(),
      status: _parseStatus(json['status']),
      pointsEarned: json['points'] is int
          ? json['points']
          : int.tryParse(json['points']?.toString() ?? '0') ?? 0,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at']) ?? DateTime.now()
          : DateTime.now(),
      verifiedAt: null,
    );
  }

  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'report_id': displayId,
      'user_id': userId,
      'image': imagePath,
      'lat': latitude?.toString(),
      'lng': longitude?.toString(),
      'location_text': locationName,
      'description': additionalDetails,
      'status': status.name,
      'points': pointsEarned,
      'admin_note': adminNote,
      'created_at': createdAt.toIso8601String(),
    };
  }

  
  static ReportStatus _parseStatus(dynamic status) {
    if (status == null) return ReportStatus.accepted;
    switch (status.toString().toLowerCase()) {
      case 'accepted':
      case 'approved':
      case 'verified':
        return ReportStatus.accepted;
      case 'rejected':
      case 'declined':
        return ReportStatus.rejected;
      default:
        return ReportStatus.accepted;
    }
  }

  
  factory ReportModel.fromEntity(Report report) {
    return ReportModel(
      id: report.id,
      displayId: report.displayId,
      userId: report.userId,
      wasteType: report.wasteType,
      adminNote: report.adminNote,
      latitude: report.latitude,
      longitude: report.longitude,
      locationName: report.locationName,
      imagePath: report.imagePath,
      additionalDetails: report.additionalDetails,
      status: report.status,
      pointsEarned: report.pointsEarned,
      createdAt: report.createdAt,
      verifiedAt: report.verifiedAt,
    );
  }
}
