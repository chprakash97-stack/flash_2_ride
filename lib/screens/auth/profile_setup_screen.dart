import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../theme/app_theme.dart';
import '../home/home_screen.dart';

class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _emergencyController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // ఇప్పటికే Firestore లో ప్రొఫైల్ వివరాలు ఉంటే వాటంతట అవే ఫీల్డ్స్‌లో నిండుతాయి
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final user = authProvider.currentUser;
      if (user != null) {
        if (user.name.isNotEmpty) _nameController.text = user.name;
        if (user.email.isNotEmpty) _emailController.text = user.email;
        if (user.emergencyContact.isNotEmpty) {
          _emergencyController.text = user.emergencyContact;
        }
      }
    });
  }

  Future<void> _handleContinue() async {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final emergency = _emergencyController.text.trim();

    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.redAccent,
          content: Text('Please enter your full name'),
        ),
      );
      return;
    }

    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    // Save user details to Firestore `users` collection via AuthProvider
    bool isSuccess = await authProvider.updateProfile(name, email, emergency);

    if (!mounted) return;

    if (isSuccess) {
      // Navigate to Home & Live Map Screen on successful save
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
        (route) => false,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.redAccent,
          content: Text('Failed to update profile. Please try again.'),
        ),
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _emergencyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppTheme.mainBlue, AppTheme.darkBlue],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Back Button
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 22),
                  padding: EdgeInsets.zero,
                  alignment: Alignment.centerLeft,
                  onPressed: () => Navigator.pop(context),
                ),
                const SizedBox(height: 16),

                // 2. Heading
                const Text(
                  'Complete Your Profile',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 8),

                // 3. Subtitle
                const Text(
                  "Let's get started! Setup your profile\nfor quick rides.",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                    height: 1.4,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 32),

                // 4. Field 1: Full Name
                const Text(
                  'Full Name',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  height: 54,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(27),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  alignment: Alignment.centerLeft,
                  child: TextField(
                    controller: _nameController,
                    style: const TextStyle(
                      color: Color(0xFF0F172A),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    decoration: const InputDecoration(
                      hintText: 'Enter full name',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // 5. Field 2: Email Address
                const Text(
                  'Email Address',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  height: 54,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(27),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  alignment: Alignment.centerLeft,
                  child: TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    style: const TextStyle(
                      color: Color(0xFF0F172A),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    decoration: const InputDecoration(
                      hintText: 'Enter email address',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // 6. Field 3: Emergency Contact
                const Text(
                  'Emergency Contact',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  height: 54,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(27),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  alignment: Alignment.centerLeft,
                  child: TextField(
                    controller: _emergencyController,
                    keyboardType: TextInputType.phone,
                    style: const TextStyle(
                      color: Color(0xFF0F172A),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    decoration: const InputDecoration(
                      hintText: 'Enter emergency mobile number',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ),
                const SizedBox(height: 38),

                // 7. Continue Button with Loading State
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.darkBlue,
                      foregroundColor: Colors.white,
                      elevation: 5,
                      shadowColor: Colors.black45,
                      side: const BorderSide(color: Colors.white38, width: 1.2),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    ),
                    onPressed: authProvider.isLoading ? null : _handleContinue,
                    child: authProvider.isLoading
                        ? const SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                          )
                        : const Text(
                            'Continue',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 0.5),
                          ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}