import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: PhoneAuthScreen(),
    );
  }
}

class PhoneAuthScreen extends StatefulWidget {
  const PhoneAuthScreen({super.key});

  @override
  State<PhoneAuthScreen> createState() => _PhoneAuthScreenState();
}

class _PhoneAuthScreenState extends State<PhoneAuthScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? _verificationId;
  bool _isOtpSent = false;
  bool _isLoading = false;
  String _statusMessage = "";

  void _sendOtp() async {
    String phone = _phoneController.text.trim();
    if (phone.isEmpty) {
      setState(() => _statusMessage = "à°¦à°¯à°šà±‡à°¸à°¿ à°«à±‹à°¨à± à°¨à°‚à°¬à°°à± à°Žà°‚à°Ÿà°°à± à°šà±‡à°¯à°‚à°¡à°¿");
      return;
    }

    setState(() {
      _isLoading = true;
      _statusMessage = "OTP à°ªà°‚à°ªà±à°¤à±‹à°‚à°¦à°¿...";
    });

    await _auth.verifyPhoneNumber(
      phoneNumber: phone.startsWith('+') ? phone : '+91$phone',
      timeout: const Duration(seconds: 60),
      verificationCompleted: (PhoneAuthCredential credential) async {
        await _auth.signInWithCredential(credential);
        setState(() {
          _isLoading = false;
          _statusMessage = "Auto Login Success! UID: ${_auth.currentUser?.uid}";
        });
      },
      verificationFailed: (FirebaseAuthException e) {
        setState(() {
          _isLoading = false;
          _statusMessage = "Error: ${e.message}";
        });
      },
      codeSent: (String verificationId, int? resendToken) {
        setState(() {
          _verificationId = verificationId;
          _isOtpSent = true;
          _isLoading = false;
          _statusMessage = "OTP à°ªà°‚à°ªà°¬à°¡à°¿à°‚à°¦à°¿. à°¦à°¯à°šà±‡à°¸à°¿ à°Žà°‚à°Ÿà°°à± à°šà±‡à°¯à°‚à°¡à°¿.";
        });
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        _verificationId = verificationId;
      },
    );
  }

  void _verifyOtp() async {
    String otp = _otpController.text.trim();
    if (otp.isEmpty || _verificationId == null) {
      setState(() => _statusMessage = "à°¦à°¯à°šà±‡à°¸à°¿ à°¸à°°à±ˆà°¨ OTP à°Žà°‚à°Ÿà°°à± à°šà±‡à°¯à°‚à°¡à°¿");
      return;
    }

    setState(() {
      _isLoading = true;
      _statusMessage = "à°µà±†à°°à°¿à°«à±ˆ à°šà±‡à°¸à±à°¤à±‹à°‚à°¦à°¿...";
    });

    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId!,
        smsCode: otp,
      );

      UserCredential userCredential = await _auth.signInWithCredential(credential);
      setState(() {
        _isLoading = false;
        _statusMessage = "à°²à°¾à°—à°¿à°¨à± à°µà°¿à°œà°¯à°µà°‚à°¤à°®à±ˆà°‚à°¦à°¿! UID: ${userCredential.user?.uid}";
      });
    } on FirebaseAuthException catch (e) {
      setState(() {
        _isLoading = false;
        _statusMessage = "Invalid OTP: ${e.message}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Firebase Phone Login"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: "Phone Number (e.g. 9876543210)",
                border: OutlineInputBorder(),
                prefixText: "+91 ",
              ),
            ),
            const SizedBox(height: 15),
            if (!_isOtpSent)
              ElevatedButton(
                onPressed: _isLoading ? null : _sendOtp,
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Send OTP"),
              ),
            if (_isOtpSent) ...[
              TextField(
                controller: _otpController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Enter 6-digit OTP",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 15),
              ElevatedButton(
                onPressed: _isLoading ? null : _verifyOtp,
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Verify OTP"),
              ),
            ],
            const SizedBox(height: 20),
            Text(
              _statusMessage,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}