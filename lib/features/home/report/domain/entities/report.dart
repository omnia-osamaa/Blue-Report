import 'package:equatable/equatable.dart';


class Report extends Equatable {
  final String id;
  final String displayId;
  final String userId;
  final String wasteType;
  final String? adminNote;
  final double? latitude;
  final double? longitude;
  final String? locationName;
  final String imagePath;
  final String? additionalDetails;
  final ReportStatus status;
  final int pointsEarned;
  final DateTime createdAt;
  final DateTime? verifiedAt;

  const Report({
    required this.id,
    required this.displayId,
    required this.userId,
    required this.wasteType,
    this.adminNote,
    this.latitude,
    this.longitude,
    this.locationName,
    required this.imagePath,
    this.additionalDetails,
    required this.status,
    this.pointsEarned = 0,
    required this.createdAt,
    this.verifiedAt,
  });

  @override
  List<Object?> get props => [
        id,
        displayId,
        userId,
        wasteType,
        adminNote,
        latitude,
        longitude,
        locationName,
        imagePath,
        additionalDetails,
        status,
        pointsEarned,
        createdAt,
        verifiedAt,
      ];

  
  bool get isAccepted => status == ReportStatus.accepted;

  
  bool get isRejected => status == ReportStatus.rejected;

  
  String get statusText {
    switch (status) {
      case ReportStatus.accepted:
        return 'Accepted';
      case ReportStatus.rejected:
        return 'Rejected';
    }
  }

  
  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(createdAt);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}


enum ReportStatus {
  accepted,
  rejected,
}
