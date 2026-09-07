class UserModel {
  final String id;
  final String name;
  final String phone;
  final String email;
  final String emergencyContact;
  final double walletBalance;
  final String referralCode;

  UserModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    required this.emergencyContact,
    this.walletBalance = 250.0,
    this.referralCode = 'FLASH998',
  });

  UserModel copyWith({String? name, String? email, String? emergencyContact, double? walletBalance}) {
    return UserModel(
      id: id,
      name: name ?? this.name,
      phone: phone,
      email: email ?? this.email,
      emergencyContact: emergencyContact ?? this.emergencyContact,
      walletBalance: walletBalance ?? this.walletBalance,
      referralCode: referralCode,
    );
  }
}
