import 'package:flutter/material.dart';

class UserProfileScreen extends StatefulWidget {
  final dynamic data;
  const UserProfileScreen({super.key, this.data});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  String _name = 'Ramesh Kumar';
  String _email = 'ramesh@gmail.com';
  String _phone = '+91 98765 43210';
  String _emergencyContact = '+91 98765 43210';

  void _showEditProfileDialog() {
    final nameCtrl = TextEditingController(text: _name);
    final emailCtrl = TextEditingController(text: _email);
    final phoneCtrl = TextEditingController(text: _phone);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Edit Profile',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(ctx),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TextField(
                controller: nameCtrl,
                decoration: InputDecoration(
                  labelText: 'Full Name',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: emailCtrl,
                decoration: InputDecoration(
                  labelText: 'Email Address',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: phoneCtrl,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _name = nameCtrl.text;
                      _email = emailCtrl.text;
                      _phone = phoneCtrl.text;
                    });
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Profile updated successfully!'),
                        backgroundColor: Color(0xFF10B981),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2563EB),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                  ),
                  child: const Text('Save Changes', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showEmergencyContactDialog() {
    final contactCtrl = TextEditingController(text: _emergencyContact);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Emergency Contact',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(ctx),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TextField(
                controller: contactCtrl,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: 'Emergency Phone Number',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _emergencyContact = contactCtrl.text;
                    });
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Emergency contact saved successfully!'),
                        backgroundColor: Color(0xFF10B981),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2563EB),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                  ),
                  child: const Text('Save Contact', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Logout', style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Text('Are you sure you want to logout from Flash2Ride?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel', style: TextStyle(color: Color(0xFF64748B))),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Logged out successfully.'),
                  backgroundColor: Color(0xFFEF4444),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEF4444),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      // Solid Blue Header exactly like Flash Wallet
      appBar: AppBar(
        title: const Text(
          'Profile Settings',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        backgroundColor: const Color(0xFF2563EB), // Flash Wallet Blue
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true, // Centered like Flash Wallet
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. User Profile Card matching Poster
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.02),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 26,
                      backgroundColor: Color(0xFFEFF6FF),
                      child: Icon(Icons.person, color: Color(0xFF2563EB), size: 30),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _name,
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0F172A),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            _email,
                            style: const TextStyle(fontSize: 13, color: Color(0xFF64748B)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // 2. Middle Card with strictly 2 Options matching Poster:
              //    - Edit Profile
              //    - Emergency Contact
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.02),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Column(
                    children: [
                      // Option 1: Edit Profile
                      InkWell(
                        onTap: _showEditProfileDialog,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
                          child: Row(
                            children: const [
                              CircleAvatar(
                                radius: 18,
                                backgroundColor: Color(0xFFEFF6FF),
                                child: Icon(Icons.badge_outlined, color: Color(0xFF2563EB), size: 20),
                              ),
                              SizedBox(width: 14),
                              Expanded(
                                child: Text(
                                  'Edit Profile',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF0F172A),
                                  ),
                                ),
                              ),
                              Icon(Icons.chevron_right_rounded, color: Color(0xFF94A3B8)),
                            ],
                          ),
                        ),
                      ),
                      const Divider(height: 1, indent: 56),

                      // Option 2: Emergency Contact
                      InkWell(
                        onTap: _showEmergencyContactDialog,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
                          child: Row(
                            children: [
                              const CircleAvatar(
                                radius: 18,
                                backgroundColor: Color(0xFFEFF6FF),
                                child: Icon(Icons.shield_outlined, color: Color(0xFF2563EB), size: 20),
                              ),
                              const SizedBox(width: 14),
                              const Expanded(
                                child: Text(
                                  'Emergency Contact',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF0F172A),
                                  ),
                                ),
                              ),
                              Text(
                                _emergencyContact,
                                style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                              ),
                              const SizedBox(width: 6),
                              const Icon(Icons.chevron_right_rounded, color: Color(0xFF94A3B8)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // 3. Solid Red Logout Button matching original poster exactly
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _showLogoutDialog,
                  icon: const Icon(Icons.logout_rounded, color: Colors.white, size: 20),
                  label: const Text(
                    'Logout',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFEF4444),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    elevation: 0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProfileScreen extends UserProfileScreen {
  const ProfileScreen({super.key, super.data});
}