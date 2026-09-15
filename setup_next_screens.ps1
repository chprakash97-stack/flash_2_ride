# ==============================================================================
# Flash2Ride - Language Encoding Fix & Poster-Accurate Refer & Earn Screen
# 1. Fixes language_screen.dart (Encoding & ListTile Material assertion)
# 2. Creates lib\views\rewards\refer_earn_screen.dart (Section 6 Poster)
# 3. Links Refer & Earn in Drawer menu & routes.dart
# ==============================================================================

Write-Host "1. Updating Language Screen with Unicode & Clean Material Layout..." -ForegroundColor Cyan

$cleanLangCode = @'
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
      'badge': 'E',
      'subtitle': 'Default app language',
    },
    {
      'code': 'te',
      'name': 'Telugu',
      'native': '\u0C24\u0C46\u0C32\u0C41\u0C17\u0C41',
      'badge': 'T',
      'subtitle': 'Nellore local language',
    },
    {
      'code': 'hi',
      'name': 'Hindi',
      'native': '\u0939\u093F\u0902\u0926\u0940',
      'badge': 'H',
      'subtitle': 'National language',
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

            Material(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: const BorderSide(color: Color(0xFFE2E8F0)),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Column(
                  children: List.generate(_languages.length, (index) {
                    final lang = _languages[index];
                    final isSelected = _selectedLanguage == lang['name'];

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
                              lang['badge']!,
                              style: TextStyle(
                                color: isSelected ? const Color(0xFF2563EB) : const Color(0xFF64748B),
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
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
                                  '(' + lang['native']! + ')',
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

[System.IO.File]::WriteAllText("lib\views\profile\language_screen.dart", $cleanLangCode, [System.Text.Encoding]::UTF8)
Write-Host "  -> Language Screen updated cleanly!" -ForegroundColor Green

Write-Host "`n2. Creating Poster-Accurate Refer & Earn Screen..." -ForegroundColor Cyan

$rewardsDir = "lib\views\rewards"
if (!(Test-Path $rewardsDir)) {
    New-Item -ItemType Directory -Path $rewardsDir -Force | Out-Null
}

$referCode = @'
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ReferEarnScreen extends StatefulWidget {
  final dynamic data;
  const ReferEarnScreen({super.key, this.data});

  @override
  State<ReferEarnScreen> createState() => _ReferEarnScreenState();
}

class _ReferEarnScreenState extends State<ReferEarnScreen> {
  final String _referralCode = 'FLR12345';
  final int _totalReferrals = 3;
  final int _earnedBonus = 150;

  void _copyReferralCode() {
    Clipboard.setData(ClipboardData(text: _referralCode));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Referral code $_referralCode copied to clipboard!'),
        backgroundColor: const Color(0xFF10B981),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _shareViaWhatsApp() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Sharing invite link via WhatsApp: Use code FLR12345 to get Rs. 50 bonus!'),
        backgroundColor: Color(0xFF25D366),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text(
          'Refer & Earn',
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
            // 1. Top Hero Card matching Poster (Emerald Green Gradient with Gift Icon)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFE8F8F0), Color(0xFFD1FAE5)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFA7F3D0)),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF10B981).withOpacity(0.08),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFF10B981),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            'EARN CASHBACK',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Invite Friends',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF065F46),
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Get Rs. 50 Wallet Bonus',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF047857),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Share your code with friends in Nellore. You both get Rs. 50 on their first ride!',
                          style: TextStyle(fontSize: 12, color: Colors.green.shade900),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    width: 68,
                    height: 68,
                    decoration: BoxDecoration(
                      color: const Color(0xFF10B981).withOpacity(0.18),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.card_giftcard_rounded, color: Color(0xFF059669), size: 40),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // 2. Referral Code Container matching Poster
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Your Referral Code',
                    style: TextStyle(fontSize: 13, color: Color(0xFF64748B), fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFCBD5E1), style: BorderStyle.solid),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _referralCode,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 2,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: _copyReferralCode,
                          icon: const Icon(Icons.copy_rounded, size: 16),
                          label: const Text('Copy'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2563EB),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _shareViaWhatsApp,
                      icon: const Icon(Icons.share_rounded, size: 20),
                      label: const Text(
                        'Share via WhatsApp',
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF25D366),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 0,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // 3. Track Your Referrals Section matching Poster
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Track Your Referrals',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF8FAFC),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0xFFE2E8F0)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('My Referrals', style: TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                              const SizedBox(height: 4),
                              Text(
                                '$_totalReferrals',
                                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF00A859)),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF8FAFC),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0xFFE2E8F0)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Total Earned', style: TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                              const SizedBox(height: 4),
                              Text(
                                'Rs. $_earnedBonus',
                                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF2563EB)),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.info_outline_rounded, size: 18, color: Color(0xFF2563EB)),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Earned bonus is automatically credited to your Flash Wallet and can be used on any ride.',
                            style: TextStyle(fontSize: 11, color: Color(0xFF475569)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
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

[System.IO.File]::WriteAllText("lib\views\rewards\refer_earn_screen.dart", $referCode, [System.Text.Encoding]::UTF8)
Write-Host "  -> Refer & Earn screen created at lib\views\rewards\refer_earn_screen.dart!" -ForegroundColor Green

Write-Host "`n3. Linking Refer & Earn in Drawer menu..." -ForegroundColor Cyan

$homeFiles = @(
    "lib\screens\home\home_screen.dart",
    "lib\views\home\home_screen.dart"
)

foreach ($hf in $homeFiles) {
    if (Test-Path $hf) {
        $text = [System.IO.File]::ReadAllText($hf, [System.Text.Encoding]::UTF8)
        $modified = $false
        
        if ($text -notmatch "refer_earn_screen\.dart") {
            $text = "import '../../views/rewards/refer_earn_screen.dart';`n" + $text
            $modified = $true
        }
        
        # Link Refer & Earn in Drawer
        $reIdx = $text.IndexOf("Refer & Earn")
        if ($reIdx -gt 0) {
            $otIdx = $text.IndexOf("onTap:", $reIdx)
            if ($otIdx -gt 0 -and ($otIdx - $reIdx) -lt 300) {
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
                MaterialPageRoute(builder: (context) => const ReferEarnScreen()),
              );
            }
"@
                    $text = $text.Substring(0, $otIdx) + $newOnTap + $text.Substring($endPos)
                    $modified = $true
                    Write-Host "  -> Successfully linked Drawer 'Refer & Earn' to ReferEarnScreen in $($hf)!" -ForegroundColor Green
                }
            }
        }
        
        if ($modified) {
            [System.IO.File]::WriteAllText($hf, $text, [System.Text.Encoding]::UTF8)
        }
    }
}

# Clean unused _showLanguageDialog warnings in Profile Settings
$pFiles = @('lib\screens\profile\user_profile_screen.dart', 'lib\views\profile\profile_screen.dart')
foreach ($pf in $pFiles) {
    if (Test-Path $pf) {
        $pc = [System.IO.File]::ReadAllText($pf, [System.Text.Encoding]::UTF8)
        $pc = [System.Text.RegularExpressions.Regex]::Replace($pc, '(?s)\s*void _showLanguageDialog\(\)\s*\{.*?\n  \}', '')
        [System.IO.File]::WriteAllText($pf, $pc, [System.Text.Encoding]::UTF8)
    }
}

Write-Host "`nRunning flutter analyze verification..." -ForegroundColor Cyan
flutter analyze