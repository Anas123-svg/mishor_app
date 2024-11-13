import 'package:mishor_app/models/template.dart';
class Assessment2 {
  final int id;
  final int clientId;
  final int templateId;
  final int userId;
  final Template template;

  Assessment2({
    required this.id,
    required this.clientId,
    required this.templateId,
    required this.userId,
    required this.template,
  });

  factory Assessment2.fromJson(Map<String, dynamic> json) {
    return Assessment2(
      id: json['id']??0,
      clientId: json['client_id']??0 ,
      templateId: json['template_id']??0,
      userId: json['user_id'],
      template: Template.fromJson(json['assessment']),
    );
  }
    Map<String, dynamic> toJson() {
    return {
      'id': id,
      'client_id': clientId,
      'template_id': templateId,
      'user_id': userId,
      'template': template.toJson(),
    };
  }

}