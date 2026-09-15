# ==============================================================================
# Flash2Ride - Final Poster Screen: Section 8 Screen 3 (About Us & Legal Policy)
# Completes 100% of all UI screens in the master poster!
# ==============================================================================

Write-Host "1. Creating About Us & Legal Policy Screen (Section 8 Screen 3)..." -ForegroundColor Cyan

$aboutCode = @'
import 'package:flutter/material.dart';

class AboutUsScreen extends StatelessWidget {
  final dynamic data;
  const AboutUsScreen({super.key, this.data});

  void _showTermsDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return DraggableScrollableSheet(
          initialChildSize: 0.7,
          minChildSize: 0.5,
          maxChildSize: 0.9,
          expand: false,
          builder: (_, scrollController) {
            return Padding(
              padding: const EdgeInsets.all(20),
              child: ListView(
                controller: scrollController,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Terms of Service',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    '1. Acceptance of Terms\nBy accessing or using the Flash 2 Ride application in Nellore and surrounding areas, you agree to be bound by these Terms of Service.\n\n'
                    '2. Transparent Pricing\nFlash 2 Ride maintains strict zero-hidden-charge pricing. Fare estimates are calculated based on transparent base fare and per-kilometer rates.\n\n'
                    '3. Safety & Conduct\nPassengers and captains are expected to treat each other with mutual respect. Zero tolerance policy against harassment or unsafe vehicle operation.\n\n'
                    '4. Cancellation Policy\nPassengers can cancel without penalty before driver arrival. Minimal cancellation fees apply only if the captain has already reached the pickup location.\n\n'
                    '5. Wallet & Refunds\nReferral bonuses and promotional cashback are credited to Flash Wallet and can be redeemed for rides.',
                    style: TextStyle(fontSize: 13, height: 1.6, color: Color(0xFF475569)),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(ctx),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2563EB),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('I Understand', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showPrivacyDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return DraggableScrollableSheet(
          initialChildSize: 0.7,
          minChildSize: 0.5,
          maxChildSize: 0.9,
          expand: false,
          builder: (_, scrollController) {
            return Padding(
              padding: const EdgeInsets.all(20),
              child: ListView(
                controller: scrollController,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Privacy Policy',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    '1. Information We Collect\nWe collect precise GPS location data during active rides to enable real-time routing, safety monitoring, and emergency SOS dispatch.\n\n'
                    '2. How We Use Information\nLocation, contact information, and ride logs are strictly utilized to coordinate pick-ups, process digital payments, and offer 24x7 customer support.\n\n'
                    '3. Data Protection\nYour personal details and phone numbers are encrypted. We never sell or share user personal data with third-party advertisers.\n\n'
                    '4. Emergency SOS Sharing\nWhen emergency SOS is triggered, real-time vehicle coordinates are securely transmitted to verified Nellore police helplines and registered emergency contacts.',
                    style: TextStyle(fontSize: 13, height: 1.6, color: Color(0xFF475569)),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(ctx),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2563EB),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('Close', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showContactDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.all(22),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Contact Us',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(ctx),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const CircleAvatar(
                  backgroundColor: Color(0xFFEFF6FF),
                  child: Icon(Icons.location_on_rounded, color: Color(0xFF2563EB)),
                ),
                title: const Text('Head Office (Nellore)', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                subtitle: const Text('Trunk Road / Dargamitta, Nellore, Andhra Pradesh - 524001', style: TextStyle(fontSize: 12)),
              ),
              const Divider(),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const CircleAvatar(
                  backgroundColor: Color(0xFFECFDF5),
                  child: Icon(Icons.email_rounded, color: Color(0xFF059669)),
                ),
                title: const Text('Customer Email Support', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                subtitle: const Text('support@flash2ride.com', style: TextStyle(fontSize: 12)),
              ),
              const Divider(),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const CircleAvatar(
                  backgroundColor: Color(0xFFFEF3C7),
                  child: Icon(Icons.phone_rounded, color: Color(0xFFD97706)),
                ),
                title: const Text('24x7 Helpline', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                subtitle: const Text('+91 861 234 5678 / 1800-FLASH-RIDE', style: TextStyle(fontSize: 12)),
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

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
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const SizedBox(height: 16),

                    // App Logo matching Poster
                    Container(
                      width: 84,
                      height: 84,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF2563EB), Color(0xFF1D4ED8)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(22),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF2563EB).withOpacity(0.25),
                            blurRadius: 16,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Icon(Icons.electric_bolt_rounded, size: 48, color: Color(0xFFFACC15)),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // App Brand Name & Tagline matching Poster
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Flash',
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF0F172A),
                            letterSpacing: -0.5,
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFF00A859),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text(
                            '2',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const Text(
                          'Ride',
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF2563EB),
                            letterSpacing: -0.5,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Ride Smart \u2022 Travel Easy',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF64748B),
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Version Badge matching Poster
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFFCBD5E1)),
                      ),
                      child: const Text(
                        'Version 1.0.0',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF475569),
                        ),
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Menu Options Container matching Poster
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Column(
                          children: [
                            ListTile(
                              leading: const Icon(Icons.description_outlined, color: Color(0xFF2563EB)),
                              title: const Text(
                                'Terms of Service',
                                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xFF0F172A)),
                              ),
                              trailing: const Icon(Icons.chevron_right_rounded, color: Color(0xFF94A3B8)),
                              onTap: () => _showTermsDialog(context),
                            ),
                            const Divider(height: 1, indent: 56),
                            ListTile(
                              leading: const Icon(Icons.privacy_tip_outlined, color: Color(0xFF059669)),
                              title: const Text(
                                'Privacy Policy',
                                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xFF0F172A)),
                              ),
                              trailing: const Icon(Icons.chevron_right_rounded, color: Color(0xFF94A3B8)),
                              onTap: () => _showPrivacyDialog(context),
                            ),
                            const Divider(height: 1, indent: 56),
                            ListTile(
                              leading: const Icon(Icons.contact_support_outlined, color: Color(0xFFD97706)),
                              title: const Text(
                                'Contact Us',
                                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xFF0F172A)),
                              ),
                              trailing: const Icon(Icons.chevron_right_rounded, color: Color(0xFF94A3B8)),
                              onTap: () => _showContactDialog(context),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Bottom Brand Slogans matching Poster exactly
            Padding(
              padding: const EdgeInsets.only(bottom: 24, top: 12),
              child: Column(
                children: const [
                  Text(
                    'Made with \u2764\uFE0F for Nellore',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF64748B),
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Your Ride \u2022 Our Priority',
                    style: TextStyle(
                      fontSize: 12,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF94A3B8),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
'@

$targetFile = "lib\views\profile\about_us_screen.dart"
[System.IO.File]::WriteAllText($targetFile, $aboutCode, [System.Text.Encoding]::UTF8)
Write-Host "  -> About Us screen created at $targetFile!" -ForegroundColor Green

Write-Host "`n2. Linking About Us in Drawer Menu..." -ForegroundColor Cyan

$homeFiles = @(
    "lib\screens\home\home_screen.dart",
    "lib\views\home\home_screen.dart"
)

foreach ($hf in $homeFiles) {
    if (Test-Path $hf) {
        $text = [System.IO.File]::ReadAllText($hf, [System.Text.Encoding]::UTF8)
        $modified = $false
        
        if ($text -notmatch "about_us_screen\.dart") {
            $text = "import '../../views/profile/about_us_screen.dart';`n" + $text
            $modified = $true
        }
        
        # Link About Us in Drawer
        $aboutIdx = $text.IndexOf("About Us")
        if ($aboutIdx -lt 0) {
            $aboutIdx = $text.IndexOf("About")
        }
        
        if ($aboutIdx -gt 0) {
            $otIdx = $text.IndexOf("onTap:", $aboutIdx)
            if ($otIdx -gt 0 -and ($otIdx - $aboutIdx) -lt 300) {
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
                MaterialPageRoute(builder: (context) => const AboutUsScreen()),
              );
            }
"@
                    $text = $text.Substring(0, $otIdx) + $newOnTap + $text.Substring($endPos)
                    $modified = $true
                    Write-Host "  -> Successfully linked Drawer 'About Us' to AboutUsScreen in $($hf)!" -ForegroundColor Green
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