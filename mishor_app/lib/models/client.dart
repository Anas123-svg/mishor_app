class Client {
  final int id;
  final String name;
 // final String username;
  final String profileImage;
  final bool isVerified;

  Client({
    required this.id,
    required this.name,
 //   required this.username,
    required this.profileImage,
    required this.isVerified,
  });

  factory Client.fromJson(Map<String, dynamic> json) {
    return Client(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
//      username: json['username'] ?? '',
      profileImage: json['profile_image'] ?? '',
      isVerified: (json['is_verified'] == 1) ? true : false,  
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
     // 'username': username,
      'profileImage': profileImage,
      'isVerified': isVerified ? 1 : 0,  
    };
  }

  static empty() {}
}
