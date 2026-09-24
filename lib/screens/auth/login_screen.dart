import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import 'otp_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _phoneController = TextEditingController();
  bool _agreedToTerms = true;

  void _handleLogin() {
    if (!_agreedToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.redAccent,
          content: Text('Please agree to Terms & Conditions and Privacy Policy'),
        ),
      );
      return;
    }

    final phone = _phoneController.text.trim();
    if (phone.length == 10) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      authProvider.sendOtp(
        phone,
        onCodeSent: (verificationId) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OtpScreen(phoneNumber: phone),
            ),
          );
        },
        onError: (errorMessage) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.redAccent,
              content: Text(errorMessage),
            ),
          );
        },
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.redAccent,
          content: Text('Please enter a valid 10-digit mobile number'),
        ),
      );
    }
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const Color brandBlue = Color(0xFF0645D8);
    const Color brandYellow = Color(0xFFFFD21C);
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/login.png',
              fit: BoxFit.fill,
              errorBuilder: (context, error, stackTrace) {
                return Container(color: Colors.grey[200]);
              },
            ),
          ),
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: constraints.maxHeight),
                    child: IntrinsicHeight(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Spacer(flex: 10),
                            const Text(
                              'Login to your account',
                              style: TextStyle(
                                color: Color(0xFF0F172A),
                                fontSize: 24,
                                fontWeight: FontWeight.w900,
                                letterSpacing: -0.5,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Container(
                              height: 56,
                              decoration: BoxDecoration(
                                color: const Color(0xFFF1F5F9),
                                borderRadius: BorderRadius.circular(30),
                                border: Border.all(color: const Color(0xFFE2E8F0), width: 1.2),
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: Row(
                                children: [
                                  const Icon(Icons.phone_rounded, color: brandBlue, size: 22),
                                  const SizedBox(width: 8),
                                  const Text(
                                    '+91',
                                    style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF0F172A),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Container(width: 1.5, height: 24, color: const Color(0xFFCBD5E1)),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: TextField(
                                      controller: _phoneController,
                                      keyboardType: TextInputType.phone,
                                      maxLength: 10,
                                      style: const TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 1.5,
                                        color: Color(0xFF0F172A),
                                      ),
                                      decoration: const InputDecoration(
                                        hintText: 'Enter mobile number',
                                        counterText: '',
                                        border: InputBorder.none,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 14),
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: () => setState(() => _agreedToTerms = !_agreedToTerms),
                                  child: Container(
                                    width: 22,
                                    height: 22,
                                    decoration: BoxDecoration(
                                      color: _agreedToTerms ? brandYellow : Colors.transparent,
                                      borderRadius: BorderRadius.circular(6),
                                      border: Border.all(
                                        color: _agreedToTerms ? brandYellow : const Color(0xFF94A3B8),
                                        width: 2,
                                      ),
                                    ),
                                    child: _agreedToTerms
                                        ? const Icon(Icons.check, size: 16, color: Colors.black)
                                        : null,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: RichText(
                                    text: const TextSpan(
                                      style: TextStyle(color: Color(0xFF334155), fontSize: 13),
                                      children: [
                                        TextSpan(text: 'I agree to the '),
                                        TextSpan(
                                          text: 'Terms & Conditions',
                                          style: TextStyle(fontWeight: FontWeight.bold, color: brandBlue),
                                        ),
                                        TextSpan(text: ' and '),
                                        TextSpan(
                                          text: 'Privacy Policy',
                                          style: TextStyle(fontWeight: FontWeight.bold, color: brandBlue),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            SizedBox(
                              width: double.infinity,
                              height: 52,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: brandBlue,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(35)),
                                ),
                                onPressed: authProvider.isLoading ? null : _handleLogin,
                                child: authProvider.isLoading
                                    ? const SizedBox(
                                        height: 24,
                                        width: 24,
                                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                                      )
                                    : const Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text('Login', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                          SizedBox(width: 8),
                                          Icon(Icons.arrow_forward_rounded, size: 20, color: Colors.white),
                                        ],
                                      ),
                              ),
                            ),
                            const Spacer(flex: 2),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}