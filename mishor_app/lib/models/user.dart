
class User {
  final int id;
  final String email;
  final String token;
  String? name;
  String? phone;
  String? company;
 // final Client client;
  final int client_id;
  final bool isVerified;
  final int completed_assessments;
  final int total_assessments;
  final int rejected_assessments;
  final int pending_assessments;

  User({
    required this.id,
    required this.email,
    required this.token,
    this.name,
    this.phone,
    this.company,
   // required this.client,
    required this.client_id,
    required this.isVerified,
    required this.completed_assessments,
    required this.total_assessments ,
    required this.rejected_assessments,
    required this.pending_assessments,
  });

  

factory User.fromJson(Map<String, dynamic> json) {
  final user = json["user"];
  return User(
    id: user['id'] ?? 0, 
    email: user['email'] ?? '',
    token: json['token'] ?? '', 
    name: user['name'] as String?, 
    phone: user['phone'] as String?, 
    client_id: user['client_id'] ?? 0,
    company: user['client']?['name'] as String?,
    isVerified: user['is_verified'] == 1,
    completed_assessments: user['completed_assessments'] ?? 0,
    total_assessments: user['total_assessments'] ?? 0,
    rejected_assessments: user['rejected_assessments'] ?? 0,
    pending_assessments: user['pending_assessments'] ?? 0,
  );
}


  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'client_id': client_id,
      'name': name,
      'phone': phone,
      'company': company,
      'token': token,
      'is_verified': isVerified ? 1 : 0,
      'completed_assessments': completed_assessments,
      'total_assessments': total_assessments,
      'pending_assessments': pending_assessments,
      'rejected_assessments': rejected_assessments,
    };
  }
}

