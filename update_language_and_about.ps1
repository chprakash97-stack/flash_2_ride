# ==============================================================================
# Flash2Ride - Poster-Accurate Language & About Us Screens Setup
# 1. Creates lib\views\profile\language_screen.dart (Choose Language: English, Telugu, Hindi)
# 2. Creates lib\views\profile\about_us_screen.dart (Terms, Privacy Policy, Contact Us)
# 3. Links them inside Profile Settings and routes.dart
# ==============================================================================

Write-Host "1. Creating Poster-Accurate Language Screen..." -ForegroundColor Cyan

$profileDir = "lib\views\profile"
if (!(Test-Path $profileDir)) {
    New-Item -ItemType Directory -Path $profileDir -Force | Out-Null
}

$langCode = @'
import 'package:flutter/material.dart';

class LanguageSelectionScreen extends StatefulWidget {
  final dynamic data;
  const LanguageSelectionScreen({super.key, this.data});

  @override
  State<LanguageSelectionScreen> createState() => _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState extends State<LanguageSelectionScreen> {
  String _selectedLanguage = 'English';

  final List<Map<String, String>> _languages = [
    {
      'code': 'en',
      'name': 'English',
      'native': 'English',
      'subtitle': 'Default app language',
    },
    {
      'code': 'te',
      'name': 'Telugu',
      'native': 'తెలుగు',
      'subtitle': 'నెల్లూరు స్థానిక భాష',
    },
    {
      'code': 'hi',
      'name': 'Hindi',
      'native': 'हिंदी',
      'subtitle': 'राष्ट्रीय भाषा',
    },
  ];

  void _saveLanguage() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('App language set to $_selectedLanguage successfully!'),
        backgroundColor: const Color(0xFF10B981),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
    Navigator.pop(context, _selectedLanguage);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text(
          'Language',
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Choose Language',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0F172A),
                letterSpacing: -0.3,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Select your preferred language for ride booking, notifications & voice alerts.',
              style: TextStyle(
                fontSize: 13,
                color: Color(0xFF64748B),
              ),
            ),
            const SizedBox(height: 20),

            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE2E8F0)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.02),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: List.generate(_languages.length, (index) {
                  final lang = _languages[index];
                  final isSelected = _selectedLanguage == lang['name'] || _selectedLanguage == lang['native'];

                  return Column(
                    children: [
                      ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        leading: CircleAvatar(
                          radius: 20,
                          backgroundColor: isSelected
                              ? const Color(0xFF2563EB).withOpacity(0.12)
                              : const Color(0xFFF1F5F9),
                          child: Text(
                            lang['native']!.substring(0, 1),
                            style: TextStyle(
                              color: isSelected ? const Color(0xFF2563EB) : const Color(0xFF64748B),
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                            ),
                          ),
                        ),
                        title: Row(
                          children: [
                            Text(
                              lang['name']!,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                                color: const Color(0xFF0F172A),
                              ),
                            ),
                            if (lang['name'] != lang['native']) ...[
                              const SizedBox(width: 8),
                              Text(
                                '(${lang['native']})',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: isSelected ? const Color(0xFF2563EB) : const Color(0xFF64748B),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ],
                        ),
                        subtitle: Text(
                          lang['subtitle']!,
                          style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                        ),
                        trailing: Radio<String>(
                          value: lang['name']!,
                          groupValue: _selectedLanguage,
                          activeColor: const Color(0xFF2563EB),
                          onChanged: (val) {
                            setState(() => _selectedLanguage = val!);
                          },
                        ),
                        onTap: () {
                          setState(() => _selectedLanguage = lang['name']!);
                        },
                      ),
                      if (index < _languages.length - 1)
                        const Divider(height: 1, indent: 64),
                    ],
                  );
                }),
              ),
            ),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saveLanguage,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2563EB),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Save',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
'@

[System.IO.File]::WriteAllText("lib\views\profile\language_screen.dart", $langCode, [System.Text.Encoding]::UTF8)
Write-Host "[1/3] Language Selection Screen created at lib\views\profile\language_screen.dart!" -ForegroundColor Green

Write-Host "`n2. Creating Poster-Accurate About Us Screen..." -ForegroundColor Cyan

$aboutCode = @'
import 'package:flutter/material.dart';

class AboutUsScreen extends StatelessWidget {
  final dynamic data;
  const AboutUsScreen({super.key, this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text(
          'About Us',
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
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 16),
            Center(
              child: Column(
                children: [
                  Container(
                    width: 76,
                    height: 76,
                    decoration: BoxDecoration(
                      color: const Color(0xFF2563EB),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF2563EB).withOpacity(0.3),
                          blurRadius: 16,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: const Icon(Icons.bolt_rounded, color: Colors.white, size: 48),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Flash2Ride',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF0F172A),
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Version 1.0.0 (Nellore Edition)',
                    style: TextStyle(fontSize: 13, color: Color(0xFF64748B), fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Ride Smart • Travel Easy',
                    style: TextStyle(fontSize: 13, color: Color(0xFF2563EB), fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.description_outlined, color: Color(0xFF2563EB)),
                    title: const Text('Terms of Service', style: TextStyle(fontWeight: FontWeight.w600)),
                    trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Color(0xFF94A3B8)),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Opening Flash2Ride Terms of Service...')),
                      );
                    },
                  ),
                  const Divider(height: 1, indent: 56),
                  ListTile(
                    leading: const Icon(Icons.privacy_tip_outlined, color: Color(0xFF10B981)),
                    title: const Text('Privacy Policy', style: TextStyle(fontWeight: FontWeight.w600)),
                    trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Color(0xFF94A3B8)),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Opening Flash2Ride Privacy Policy...')),
                      );
                    },
                  ),
                  const Divider(height: 1, indent: 56),
                  ListTile(
                    leading: const Icon(Icons.mail_outline_rounded, color: Color(0xFFF59E0B)),
                    title: const Text('Contact Us', style: TextStyle(fontWeight: FontWeight.w600)),
                    subtitle: const Text('support@flash2ride.com', style: TextStyle(fontSize: 12)),
                    trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Color(0xFF94A3B8)),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Contact: support@flash2ride.com')),
                      );
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),
            const Text(
              'Your Ride • Our Priority',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color(0xFF94A3B8),
                letterSpacing: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
'@

[System.IO.File]::WriteAllText("lib\views\profile\about_us_screen.dart", $aboutCode, [System.Text.Encoding]::UTF8)
Write-Host "[2/3] About Us Screen created at lib\views\profile\about_us_screen.dart!" -ForegroundColor Green

Write-Host "`n3. Linking in Profile Settings and Routes..." -ForegroundColor Cyan

# Link in UserProfileScreen
$profileFiles = @(
    "lib\screens\profile\user_profile_screen.dart",
    "lib\views\profile\profile_screen.dart"
)

foreach ($pf in $profileFiles) {
    if (Test-Path $pf) {
        $pText = [System.IO.File]::ReadAllText($pf, [System.Text.Encoding]::UTF8)
        $importAdd = "import '../../views/profile/language_screen.dart';`nimport '../../views/profile/about_us_screen.dart';"
        if ($pf -match "views[\\/]profile") {
            $importAdd = "import 'language_screen.dart';`nimport 'about_us_screen.dart';"
        }
        if ($pText -notmatch "language_screen\.dart") {
            $pText = "$importAdd`n" + $pText
        }
        if ($pText.Contains("onTap: _showLanguageDialog,")) {
            $pText = $pText.Replace("onTap: _showLanguageDialog,", @"
onTap: () async {
                      final res = await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const LanguageSelectionScreen()),
                      );
                      if (res != null) setState(() => _language = res as String);
                    },
"@)
        }
        [System.IO.File]::WriteAllText($pf, $pText, [System.Text.Encoding]::UTF8)
        Write-Host "  -> Linked Language in $($pf)!" -ForegroundColor Green
    }
}

# Register in routes.dart
$routesFile = "lib\core\config\routes.dart"
if (Test-Path $routesFile) {
    $rText = [System.IO.File]::ReadAllText($routesFile, [System.Text.Encoding]::UTF8)
    if ($rText -notmatch "language_screen\.dart") {
        $rText = "import '../../views/profile/language_screen.dart';`nimport '../../views/profile/about_us_screen.dart';`n" + $rText
    }
    if ($rText -notmatch "language = '/language'") {
        $rText = $rText -replace "(static const String helpSupport = '/help-support';)", "`$1`n  static const String language = '/language';`n  static const String aboutUs = '/about-us';"
    }
    if ($rText -notmatch "case language:") {
        $rText = $rText -replace "(case helpSupport:\s*return _buildRoute\(settings, SupportScreen\(data: args\)\);)", "`$1`n      case language:`n        return _buildRoute(settings, LanguageSelectionScreen(data: args));`n      case aboutUs:`n        return _buildRoute(settings, AboutUsScreen(data: args));"
    }
    [System.IO.File]::WriteAllText($routesFile, $rText, [System.Text.Encoding]::UTF8)
    Write-Host "  -> Registered /language and /about-us in routes.dart!" -ForegroundColor Green
}

Write-Host "`nRunning flutter analyze verification..." -ForegroundColor Cyan
flutter analyze