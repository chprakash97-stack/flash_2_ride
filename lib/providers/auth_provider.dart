import 'package:flutter/material.dart';
import '../models/user_model.dart';

class AuthProvider extends ChangeNotifier {
  UserModel? _currentUser;
  bool _isLoggedIn = false;
  bool _audioSafetyEnabled = true;
  String _selectedLanguage = 'English';

  UserModel? get currentUser => _currentUser;
  bool get isLoggedIn => _isLoggedIn;
  bool get audioSafetyEnabled => _audioSafetyEnabled;
  String get selectedLanguage => _selectedLanguage;

  void toggleAudioSafety(bool val) {
    _audioSafetyEnabled = val;
    notifyListeners();
  }

  void setLanguage(String lang) {
    _selectedLanguage = lang;
    notifyListeners();
  }

  void sendOtp(String phoneNumber) {
    notifyListeners();
  }

  bool verifyOtp(String otp, String phone) {
    _currentUser = UserModel(
      id: 'USR_001',
      name: 'Prakash Chebolu',
      phone: phone,
      email: 'prakash@flash2ride.com',
      emergencyContact: '+91 9988776655',
      walletBalance: 350.0,
    );
    _isLoggedIn = true;
    notifyListeners();
    return true;
  }

  void updateProfile(String name, String email, String emergency) {
    if (_currentUser != null) {
      _currentUser = _currentUser!.copyWith(name: name, email: email, emergencyContact: emergency);
      notifyListeners();
    }
  }

  void updateWallet(double amount) {
    if (_currentUser != null) {
      _currentUser = _currentUser!.copyWith(walletBalance: _currentUser!.walletBalance + amount);
      notifyListeners();
    }
  }

  void logout() {
    _currentUser = null;
    _isLoggedIn = false;
    notifyListeners();
  }
}
