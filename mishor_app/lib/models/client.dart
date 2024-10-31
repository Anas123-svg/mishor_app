class Client {
  final String id;
  final String name;
  final String username;
  final String profileImage;
  final bool isVerified;

  Client({
    required this.id,
    required this.name,
    required this.username,
    required this.profileImage,
    required this.isVerified,
  });

  factory Client.fromJson(Map<String, dynamic> json) {
    return Client(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      username: json['username'] ?? '',
      profileImage: json['profileImage'] ?? '',
      isVerified: json['isVerified'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'username': username,
      'profileImage': profileImage,
      'isVerified': isVerified,
    };
  }
}
