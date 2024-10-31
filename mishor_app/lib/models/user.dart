import 'package:mishor_app/models/client.dart'; 
class User {
  final String id;       
  final String email; 
  final String token;
  String? name; 
  String? phone; 
  String? company; 
  final Client client; 

  User({
    required this.id,
    required this.email,
    required this.token,
    this.name,
    this.phone,
    this.company,
    required this.client,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['user']['_id'] ?? '', 
      email: json['user']['email'] ?? '',
      token: json['token'] ?? '',
      name: json['user']['name'] as String?, 
      phone: json['user']['phone'] as String?, 
      company: json['user']['client']?['name'] as String?,
      client: Client.fromJson(json['user']['client'] ?? {}), 
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'phone': phone,
      'company': company,
      'token': token,
      'client': client.toJson(),
    };
  }
}
