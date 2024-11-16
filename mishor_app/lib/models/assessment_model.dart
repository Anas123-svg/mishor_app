import 'package:mishor_app/models/template.dart';
import 'package:mishor_app/models/template.dart';

class Assessment2 {
  final int id;
  final int clientId;
  final int templateId;
  final int userId;
  final Template template;
  final List<SiteImage> siteImages;  // New field for site images

  Assessment2({
    required this.id,
    required this.clientId,
    required this.templateId,
    required this.siteImages,
    required this.userId,
    required this.template,
  });

  factory Assessment2.fromJson(Map<String, dynamic> json) {
    return Assessment2(
      id: json['id'] ?? 0,
      clientId: json['client_id'] ?? 0,
      templateId: json['template_id'] ?? 0,
      userId: json['user_id'] ?? 0,
      template: Template.fromJson(json['assessment']),
      siteImages: json['site_images'] != null
          ? List<SiteImage>.from(json['site_images'].map((x) => SiteImage.fromJson(x)))
          : [],  // Handle the site_images field, parse it if available
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'client_id': clientId,
      'template_id': templateId,
      'user_id': userId,
      'template': template.toJson(),
      'site_images': List<dynamic>.from(siteImages.map((x) => x.toJson())), // Convert site images to JSON
    };
  }
}





class SiteImage {
  final int id;
  final int assessmentId;
  final String siteImage;
  final int isFlagged;
  final DateTime createdAt;
  final DateTime updatedAt;

  SiteImage({
    required this.id,
    required this.assessmentId,
    required this.siteImage,
    required this.isFlagged,
    required this.createdAt,
    required this.updatedAt,
  });

  // Factory constructor to create SiteImage from JSON
  factory SiteImage.fromJson(Map<String, dynamic> json) {
    return SiteImage(
      id: json['id'] ?? 0,
      assessmentId: json['assessment_id'] ?? 0,
      siteImage: json['site_image'] ?? '',
      isFlagged: json['is_flagged'] ?? 0,
      createdAt: DateTime.parse(json['created_at'] ?? ''),
      updatedAt: DateTime.parse(json['updated_at'] ?? ''),
    );
  }

  // Convert the SiteImage object back to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'assessment_id': assessmentId,
      'site_image': siteImage,
      'is_flagged': isFlagged,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
