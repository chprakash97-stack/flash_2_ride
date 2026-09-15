# ==============================================================================
# Flash2Ride - Poster-Accurate Profile Settings Screen Setup
# 1. Updates lib\screens\profile\user_profile_screen.dart
# 2. Updates lib\views\profile\profile_screen.dart
# 3. Connects in Bottom Navigation Bar (Profile tab) and Drawer Menu (Settings)
# Matching Section 8 Poster Image (Ramesh Kumar, Emergency Contact, Preferences, Logout)
# ==============================================================================

Write-Host "1. Creating Poster-Accurate Profile Settings Screen..." -ForegroundColor Cyan

$profileCode = @'
import 'package:flutter/material.dart';
import '../home/saved_places_screen.dart';
import '../../views/payment/payment_methods_screen.dart';
import '../../views/profile/support_screen.dart';
import '../../views/wallet/power_pass_screen.dart';

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
  String _emergencyContact = '+91 98765 43210 (Family)';
  String _language = 'English';
  bool _notificationsEnabled = true;

  void _showEditProfileSheet() {
    final nameCtrl = TextEditingController(text: _name);
    final emailCtrl = TextEditingController(text: _email);
    final phoneCtrl = TextEditingController(text: _phone);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 20,
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 44,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 18),
            const Text(
              'Edit Profile',
              style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: nameCtrl,
              decoration: InputDecoration(
                labelText: 'Full Name',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                prefixIcon: const Icon(Icons.person_outline_rounded),
              ),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: emailCtrl,
              decoration: InputDecoration(
                labelText: 'Email Address',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                prefixIcon: const Icon(Icons.email_outlined),
              ),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: phoneCtrl,
              decoration: InputDecoration(
                labelText: 'Phone Number',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                prefixIcon: const Icon(Icons.phone_outlined),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    _name = nameCtrl.text.trim();
                    _email = emailCtrl.text.trim();
                    _phone = phoneCtrl.text.trim();
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
                ),
                child: const Text('Save Changes', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showEmergencyContactDialog() {
    final contactCtrl = TextEditingController(text: _emergencyContact);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.shield_rounded, color: Color(0xFFEF4444)),
            SizedBox(width: 8),
            Text('Emergency SOS Contact', style: TextStyle(fontSize: 17)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'This number will receive emergency alerts and live ride tracking if you trigger SOS.',
              style: TextStyle(fontSize: 13, color: Color(0xFF64748B)),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: contactCtrl,
              decoration: InputDecoration(
                labelText: 'Contact Number',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                prefixIcon: const Icon(Icons.phone_rounded),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() => _emergencyContact = contactCtrl.text.trim());
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Emergency contact updated!'),
                  backgroundColor: Color(0xFF10B981),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2563EB),
              foregroundColor: Colors.white,
            ),
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showLanguageDialog() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Choose Language', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            ...['English', 'తెలుగు (Telugu)', 'हिंदी (Hindi)'].map((lang) {
              return ListTile(
                title: Text(lang, style: const TextStyle(fontWeight: FontWeight.w600)),
                trailing: _language.contains(lang.split(' ')[0])
                    ? const Icon(Icons.check_circle_rounded, color: Color(0xFF2563EB))
                    : null,
                onTap: () {
                  setState(() => _language = lang);
                  Navigator.pop(ctx);
                },
              );
            }),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Logout'),
        content: const Text('Are you sure you want to log out from Flash2Ride?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Logged out successfully'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFDC2626),
              foregroundColor: Colors.white,
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
      appBar: AppBar(
        title: const Text(
          'Profile Settings',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Profile Header Card matching Poster
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFE2E8F0)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.02),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 32,
                        backgroundColor: const Color(0xFF2563EB).withOpacity(0.12),
                        child: const Icon(Icons.person_rounded, color: Color(0xFF2563EB), size: 38),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Color(0xFF2563EB),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.edit, color: Colors.white, size: 12),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _name,
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          _email,
                          style: const TextStyle(fontSize: 13, color: Color(0xFF64748B)),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          _phone,
                          style: const TextStyle(fontSize: 13, color: Color(0xFF64748B), fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit_outlined, color: Color(0xFF2563EB), size: 20),
                    onPressed: _showEditProfileSheet,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // 2. Safety & Emergency Contact (Section 8 Poster feature)
            const Text(
              'Safety & Emergency',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
            ),
            const SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: ListTile(
                leading: CircleAvatar(
                  radius: 20,
                  backgroundColor: const Color(0xFFFEE2E2),
                  child: const Icon(Icons.shield_rounded, color: Color(0xFFEF4444), size: 20),
                ),
                title: const Text('Emergency Contact (SOS)', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                subtitle: Text(_emergencyContact, style: const TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Color(0xFF94A3B8)),
                onTap: _showEmergencyContactDialog,
              ),
            ),

            const SizedBox(height: 20),

            // 3. Quick Account Links matching Poster
            const Text(
              'Preferences & Services',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
            ),
            const SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Column(
                children: [
                  ListTile(
                    leading: const CircleAvatar(
                      radius: 18,
                      backgroundColor: Color(0xFFF1F5F9),
                      child: Icon(Icons.bookmark_border_rounded, color: Color(0xFF2563EB), size: 18),
                    ),
                    title: const Text('Saved Places', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                    trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Color(0xFF94A3B8)),
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SavedPlacesScreen())),
                  ),
                  const Divider(height: 1, indent: 56),
                  ListTile(
                    leading: const CircleAvatar(
                      radius: 18,
                      backgroundColor: Color(0xFFF1F5F9),
                      child: Icon(Icons.payment_rounded, color: Color(0xFF10B981), size: 18),
                    ),
                    title: const Text('Payment Methods', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                    trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Color(0xFF94A3B8)),
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PaymentMethodsScreen())),
                  ),
                  const Divider(height: 1, indent: 56),
                  ListTile(
                    leading: const CircleAvatar(
                      radius: 18,
                      backgroundColor: Color(0xFFF1F5F9),
                      child: Icon(Icons.bolt_rounded, color: Color(0xFFFF9800), size: 18),
                    ),
                    title: const Text('Power Pass Subscription', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                    trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Color(0xFF94A3B8)),
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PowerPassScreen())),
                  ),
                  const Divider(height: 1, indent: 56),
                  ListTile(
                    leading: const CircleAvatar(
                      radius: 18,
                      backgroundColor: Color(0xFFF1F5F9),
                      child: Icon(Icons.language_rounded, color: Color(0xFF6366F1), size: 18),
                    ),
                    title: const Text('Language', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                    subtitle: Text(_language, style: const TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                    trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Color(0xFF94A3B8)),
                    onTap: _showLanguageDialog,
                  ),
                  const Divider(height: 1, indent: 56),
                  SwitchListTile(
                    secondary: const CircleAvatar(
                      radius: 18,
                      backgroundColor: Color(0xFFF1F5F9),
                      child: Icon(Icons.notifications_none_rounded, color: Color(0xFF0F172A), size: 18),
                    ),
                    title: const Text('Push Notifications', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                    value: _notificationsEnabled,
                    activeColor: const Color(0xFF2563EB),
                    onChanged: (val) => setState(() => _notificationsEnabled = val),
                  ),
                  const Divider(height: 1, indent: 56),
                  ListTile(
                    leading: const CircleAvatar(
                      radius: 18,
                      backgroundColor: Color(0xFFF1F5F9),
                      child: Icon(Icons.help_outline_rounded, color: Color(0xFF0284C7), size: 18),
                    ),
                    title: const Text('Help & Support', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                    trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Color(0xFF94A3B8)),
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SupportScreen())),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            // 4. Logout Button matching Poster
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _showLogoutDialog,
                icon: const Icon(Icons.logout_rounded, color: Color(0xFFDC2626)),
                label: const Text(
                  'Logout',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFDC2626),
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFFFCA5A5), width: 1.5),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  backgroundColor: const Color(0xFFFEF2F2),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
'@

$targets = @(
    "lib\\screens\\profile\\user_profile_screen.dart",
    "lib\\views\\profile\\profile_screen.dart"
)

foreach ($tp in $targets) {
    $dir = [System.IO.Path]::GetDirectoryName($tp)
    if (!(Test-Path $dir)) {
        New-Item -ItemType Directory -Path $dir -Force | Out-Null
    }
    [System.IO.File]::WriteAllText($tp, $profileCode, [System.Text.Encoding]::UTF8)
    Write-Host "  -> Updated $($tp)" -ForegroundColor Green
}

Write-Host "`n2. Linking in Bottom Navigation Bar (Profile) & Drawer (Settings)..." -ForegroundColor Cyan

$homeFiles = @(
    "lib\\screens\\home\\home_screen.dart",
    "lib\\views\\home\\home_screen.dart"
)

foreach ($hf in $homeFiles) {
    if (Test-Path $hf) {
        $text = [System.IO.File]::ReadAllText($hf, [System.Text.Encoding]::UTF8)
        $modified = $false
        
        # Ensure import
        if ($text -notmatch "user_profile_screen\.dart" -and $text -notmatch "profile_screen\.dart") {
            $importStr = "import '../../screens/profile/user_profile_screen.dart';"
            if ($hf -match "views[\\/]home") {
                $importStr = "import '../profile/profile_screen.dart';"
            }
            $text = "$importStr`n" + $text
            $modified = $true
            Write-Host "  -> Added UserProfileScreen import in $($hf)" -ForegroundColor Yellow
        }
        
        # Link BottomNavigationBar index 3 (Profile) inside Widget _buildBottomNavigationBar
        $bnbDefIdx = $text.IndexOf("Widget _buildBottomNavigationBar()")
        if ($bnbDefIdx -gt 0) {
            $onTapIdx = $text.IndexOf("onTap:", $bnbDefIdx)
            if ($onTapIdx -gt 0) {
                if ($text.IndexOf("index == 3", $onTapIdx) -lt 0 -and $text.IndexOf("index == 2", $onTapIdx) -gt 0) {
                    $insertTarget = "if (index == 2) {"
                    $targetIdx = $text.IndexOf($insertTarget, $onTapIdx)
                    if ($targetIdx -gt 0) {
                        $profileNavSnippet = @"
if (index == 3) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const UserProfileScreen()),
            ).then((_) {
              if (mounted) setState(() => _currentNavIndex = 0);
            });
          }
          "@
                        $text = $text.Substring(0, $targetIdx) + $profileNavSnippet + $text.Substring($targetIdx)
                        $modified = $true
                        Write-Host "  -> Successfully linked Bottom Bar 'Profile' (index 3) to UserProfileScreen!" -ForegroundColor Green
                    }
                }
            }
        }
        
        # Link Settings in Drawer
        $drawerDefIdx = $text.IndexOf("Widget _buildDrawer()")
        if ($drawerDefIdx -gt 0) {
            $setIdx = $text.IndexOf("Settings", $drawerDefIdx)
            if ($setIdx -gt 0) {
                $otIdx = $text.IndexOf("onTap:", $setIdx)
                if ($otIdx -gt 0 -and ($otIdx - $setIdx) -lt 300) {
                    $afterOnTap = $text.Substring($otIdx, [Math]::Min(150, $text.Length - $otIdx))
                    $endPos = -1
                    if ($afterOnTap -match "onTap:\s*\(\)\s*=>") {
                        $comma = $text.IndexOf(",", $otIdx)
                        if ($comma -gt 0) { $endPos = $comma }
                    } else {
                        $cb = $text.IndexOf("},", $otIdx)
                        if ($cb -gt 0) { $endPos = $cb + 1 }
                    }
                    
                    if ($endPos -gt 0) {
                        $newOnTap = @"
onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const UserProfileScreen()),
              );
            }
"@
                        $text = $text.Substring(0, $otIdx) + $newOnTap + $text.Substring($endPos)
                        $modified = $true
                        Write-Host "  -> Successfully updated Drawer 'Settings' onTap to UserProfileScreen!" -ForegroundColor Green
                    }
                }
            }
        }
        
        if ($modified) {
            [System.IO.File]::WriteAllText($hf, $text, [System.Text.Encoding]::UTF8)
        }
    }
}

Write-Host "`nRunning flutter analyze verification..." -ForegroundColor Cyan
flutter analyze