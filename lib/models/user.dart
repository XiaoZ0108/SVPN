class UserInfo {
  final String email;
  final bool isPremium;

  UserInfo({required this.email, required this.isPremium});

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'isPremium': isPremium,
    };
  }

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
      email: json['email'],
      isPremium: json['isPremium'],
    );
  }
}
