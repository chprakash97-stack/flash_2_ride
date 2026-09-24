class UserModel {
  final String id;
  final String name;
  final String phone;
  final String email;
  final String emergencyContact;
  final double walletBalance;

  UserModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    required this.emergencyContact,
    required this.walletBalance,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      phone: map['phone'] ?? '',
      email: map['email'] ?? '',
      emergencyContact: map['emergencyContact'] ?? '',
      walletBalance: (map['walletBalance'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'email': email,
      'emergencyContact': emergencyContact,
      'walletBalance': walletBalance,
    };
  }

  UserModel copyWith({
    String? id,
    String? name,
    String? phone,
    String? email,
    String? emergencyContact,
    double? walletBalance,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      emergencyContact: emergencyContact ?? this.emergencyContact,
      walletBalance: walletBalance ?? this.walletBalance,
    );
  }
}