import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  UserModel? _currentUser;
  bool _isLoggedIn = false;
  bool _isLoading = false;
  bool _audioSafetyEnabled = true;
  String _selectedLanguage = 'English';

  // OTP Verification Variables
  String? _verificationId;
  int? _resendToken;
  ConfirmationResult? _webConfirmationResult;

  UserModel? get currentUser => _currentUser;
  bool get isLoggedIn => _isLoggedIn;
  bool get isLoading => _isLoading;
  bool get audioSafetyEnabled => _audioSafetyEnabled;
  String get selectedLanguage => _selectedLanguage;

  AuthProvider() {
    _checkCurrentUser();
  }

  Future<void> _checkCurrentUser() async {
    User? firebaseUser = _auth.currentUser;
    if (firebaseUser != null) {
      await fetchUserData(firebaseUser.uid);
    }
  }

  Future<void> fetchUserData(String uid) async {
    try {
      DocumentSnapshot doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists && doc.data() != null) {
        _currentUser = UserModel.fromMap(doc.data() as Map<String, dynamic>);
        _isLoggedIn = true;
        notifyListeners();
      }
    } catch (e) {
      debugPrint("Error fetching user data: $e");
    }
  }

  void toggleAudioSafety(bool val) {
    _audioSafetyEnabled = val;
    notifyListeners();
  }

  void setLanguage(String lang) {
    _selectedLanguage = lang;
    notifyListeners();
  }

  // ----------------------------------------------------
  // 1. Send OTP via Firebase Phone Auth
  // ----------------------------------------------------
  Future<bool> sendOtp(
    String phoneNumber, {
    required Function(String verificationId) onCodeSent,
    required Function(String error) onError,
  }) async {
    try {
      _isLoading = true;
      notifyListeners();

      String formattedPhoneNumber = phoneNumber.trim();
      if (!formattedPhoneNumber.startsWith('+91')) {
        formattedPhoneNumber = "+91$formattedPhoneNumber";
      }

      if (kIsWeb) {
        _webConfirmationResult = await _auth.signInWithPhoneNumber(formattedPhoneNumber);
        _isLoading = false;
        notifyListeners();
        onCodeSent("WEB_VERIFICATION");
        return true;
      } else {
        await _auth.verifyPhoneNumber(
          phoneNumber: formattedPhoneNumber,
          forceResendingToken: _resendToken,
          timeout: const Duration(seconds: 60),

          // Android లో Automatic SMS Detection జరిగినప్పుడు
          verificationCompleted: (PhoneAuthCredential credential) async {
            try {
              UserCredential userCredential = await _auth.signInWithCredential(credential);
              if (userCredential.user != null) {
                await _saveOrFetchUser(userCredential.user!.uid, formattedPhoneNumber);
              }
            } catch (e) {
              debugPrint("Auto verification error: $e");
            }
          },

          // Verification Error వచ్చినప్పుడు
          verificationFailed: (FirebaseAuthException e) {
            _isLoading = false;
            notifyListeners();
            onError(e.message ?? "Phone verification failed");
          },

          // SMS విజయవంతంగా వెళ్ళినప్పుడు
          codeSent: (String verificationId, int? resendToken) {
            _verificationId = verificationId;
            _resendToken = resendToken;
            _isLoading = false;
            notifyListeners();
            onCodeSent(verificationId);
          },

          codeAutoRetrievalTimeout: (String verificationId) {
            _verificationId = verificationId;
          },
        );
        return true;
      }
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      onError(e.toString());
      return false;
    }
  }

  // ----------------------------------------------------
  // 2. Verify OTP Code
  // ----------------------------------------------------
  Future<bool> verifyOtp(String otp, String phone) async {
    try {
      _isLoading = true;
      notifyListeners();

      UserCredential? userCredential;

      if (kIsWeb) {
        if (_webConfirmationResult != null) {
          userCredential = await _webConfirmationResult!.confirm(otp);
        }
      } else {
        if (_verificationId != null) {
          PhoneAuthCredential credential = PhoneAuthProvider.credential(
            verificationId: _verificationId!,
            smsCode: otp,
          );
          userCredential = await _auth.signInWithCredential(credential);
        }
      }

      User? user = userCredential?.user;

      if (user != null) {
        String formattedPhone = phone.trim();
        if (!formattedPhone.startsWith('+91')) {
          formattedPhone = "+91$formattedPhone";
        }
        await _saveOrFetchUser(user.uid, formattedPhone);
        _isLoading = false;
        notifyListeners();
        return true;
      }

      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      debugPrint("Verify OTP Error: $e");
      return false;
    }
  }

  // Helper: Save user profile in Firestore `users` collection using Firebase Auth UID
  Future<void> _saveOrFetchUser(String uid, String phone) async {
    DocumentReference userDocRef = _firestore.collection('users').doc(uid);
    DocumentSnapshot doc = await userDocRef.get();

    if (!doc.exists) {
      _currentUser = UserModel(
        id: uid,
        name: '',
        phone: phone,
        email: '',
        emergencyContact: '',
        walletBalance: 0.0,
      );

      await userDocRef.set({
        'id': uid,
        'name': '',
        'phone': phone,
        'email': '',
        'emergencyContact': '',
        'walletBalance': 0.0,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } else {
      _currentUser = UserModel.fromMap(doc.data() as Map<String, dynamic>);
    }
    _isLoggedIn = true;
    notifyListeners();
  }

  // Update Profile
  Future<bool> updateProfile(String name, String email, String emergency) async {
    if (_currentUser == null) return false;
    try {
      _isLoading = true;
      notifyListeners();

      await _firestore.collection('users').doc(_currentUser!.id).update({
        'name': name,
        'email': email,
        'emergencyContact': emergency,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      _currentUser = _currentUser!.copyWith(
        name: name,
        email: email,
        emergencyContact: emergency,
      );
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      debugPrint("Update Profile Error: $e");
      return false;
    }
  }

  // Logout
  Future<void> logout() async {
    await _auth.signOut();
    _currentUser = null;
    _isLoggedIn = false;
    _verificationId = null;
    _webConfirmationResult = null;
    notifyListeners();
  }
}