Write-Host "Building Poster Screen 4: Safety Toolkit & SOS Screen..." -ForegroundColor Green

$safetyCode = @'
import 'package:flutter/material.dart';

class SafetyToolkitScreen extends StatefulWidget {
  final dynamic data;
  const SafetyToolkitScreen({super.key, this.data});

  @override
  State<SafetyToolkitScreen> createState() => _SafetyToolkitScreenState();
}

class _SafetyToolkitScreenState extends State<SafetyToolkitScreen> with SingleTickerProviderStateMixin {
  late AnimationController _sosPulse;
  bool _audioRecording = false;

  @override
  void initState() {
    super.initState();
    _sosPulse = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _sosPulse.dispose();
    super.dispose();
  }

  void _triggerSosDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.red, size: 28),
            SizedBox(width: 8),
            Text('Trigger Emergency SOS?', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          ],
        ),
        content: const Text(
          'This will immediately alert Police (112) and send your live location and partner details to your Emergency Contacts.',
          style: TextStyle(fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  backgroundColor: Colors.red,
                  content: Text('EMERGENCY SOS ACTIVATED: Police (112) and Contacts alerted!'),
                ),
              );
            },
            child: const Text('Confirm SOS', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
          onPressed: () => Navigator.maybePop(context),
        ),
        title: const Text(
          'Safety Toolkit',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF0066FF),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // 1. పోస్టర్ లోని పెద్ద రెడ్ ఎమర్జెన్సీ SOS బటన్
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 15,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: _triggerSosDialog,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // పల్స్ రింగ్
                        AnimatedBuilder(
                          animation: _sosPulse,
                          builder: (context, child) {
                            return Container(
                              width: 100 + (_sosPulse.value * 30),
                              height: 100 + (_sosPulse.value * 30),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.red.withOpacity(0.2 * (1 - _sosPulse.value)),
                              ),
                            );
                          },
                        ),
                        // రెడ్ సెంట్రల్ బటన్
                        Container(
                          width: 90,
                          height: 90,
                          decoration: BoxDecoration(
                            gradient: const RadialGradient(
                              colors: [Color(0xFFFF4D4D), Color(0xFFDC2626)],
                            ),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.red.withOpacity(0.4),
                                blurRadius: 20,
                                spreadRadius: 3,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: const Center(
                            child: Text(
                              'SOS',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 26,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 1.5,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Emergency SOS',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Press to alert 112 Police & Emergency Contacts',
                    style: TextStyle(fontSize: 12, color: Colors.black54),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // 2. యాక్టివ్ పార్ట్నర్ సేఫ్టీ వివరాలు
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFEBF3FF),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFCCE0FF)),
              ),
              child: const Row(
                children: [
                  Icon(Icons.verified_user_rounded, color: Color(0xFF0066FF), size: 28),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Verified Flash 2 Partner',
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF0066FF)),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Ramesh Babu • AP 26 TX 2344 (Flash Auto)',
                          style: TextStyle(fontSize: 12, color: Colors.black87),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // 3. సేఫ్టీ ఫీచర్ల లిస్ట్
            _buildSafetyActionTile(
              icon: Icons.share_location_rounded,
              iconColor: const Color(0xFF0066FF),
              title: 'Share Live Trip',
              subtitle: 'Share live location with family & friends via WhatsApp',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Live trip link copied to clipboard!')),
                );
              },
            ),

            const SizedBox(height: 12),

            _buildSafetyActionTile(
              icon: Icons.local_police_rounded,
              iconColor: Colors.red,
              title: 'Call 112 (Police Helpline)',
              subtitle: 'Direct emergency call to Nellore Police Control Room',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Calling Emergency Police 112...')),
                );
              },
            ),

            const SizedBox(height: 12),

            _buildSafetyActionTile(
              icon: Icons.medical_services_rounded,
              iconColor: const Color(0xFF00A859),
              title: 'Call 108 (Ambulance)',
              subtitle: 'Instant emergency medical assistance',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Calling Medical Ambulance 108...')),
                );
              },
            ),

            const SizedBox(height: 12),

            // ఆడియో రికార్డింగ్ స్విచ్
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: _audioRecording ? const Color(0xFFFEE2E2) : const Color(0xFFF4F7FC),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.mic_rounded,
                      color: _audioRecording ? Colors.red : const Color(0xFF0066FF),
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 14),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Ride Audio Recording',
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black87),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Encrypted trip recording for safety',
                          style: TextStyle(fontSize: 12, color: Colors.black54),
                        ),
                      ],
                    ),
                  ),
                  Switch(
                    value: _audioRecording,
                    activeColor: Colors.red,
                    onChanged: (val) {
                      setState(() => _audioRecording = val);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(val ? 'Safety Audio Recording Started' : 'Audio Recording Stopped'),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            _buildSafetyActionTile(
              icon: Icons.support_agent_rounded,
              iconColor: Colors.deepPurple,
              title: 'Flash 2 Ride 24x7 Safety Helpline',
              subtitle: 'Call our dedicated safety team for immediate support',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Connecting to Flash 2 Ride 24x7 Safety Desk...')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSafetyActionTile({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: iconColor, size: 22),
        ),
        title: Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black87)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 12, color: Colors.black54)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.black38),
      ),
    );
  }
}

typedef SafetyToolkitScreenView = SafetyToolkitScreen;
'@

# 1. views/safety మరియు screens/safety లోకి రాస్తుంది
$dir1 = "$PWD\lib\views\safety"
if (!(Test-Path $dir1)) { New-Item -ItemType Directory -Path $dir1 -Force | Out-Null }
[System.IO.File]::WriteAllText("$dir1\safety_toolkit_screen.dart", $safetyCode, [System.Text.Encoding]::UTF8)

$dir2 = "$PWD\lib\screens\safety"
if (!(Test-Path $dir2)) { New-Item -ItemType Directory -Path $dir2 -Force | Out-Null }
[System.IO.File]::WriteAllText("$dir2\safety_toolkit_screen.dart", $safetyCode, [System.Text.Encoding]::UTF8)

# 2. Live Tracking లోని Shield మరియు Share బటన్లను ఈ Safety Toolkit తో లింక్ చేస్తుంది
Get-ChildItem -Path "$PWD\lib" -Filter live_tracking_screen.dart -Recurse | ForEach-Object {
    $c = [System.IO.File]::ReadAllText($_.FullName)
    if ($c -notmatch 'SafetyToolkitScreen') {
        $c = "import '../../views/safety/safety_toolkit_screen.dart';`n" + $c
    }
    
    # Shield Icon link
    $oldShield = "tooltip: 'Safety Toolkit',"
    $newShield = @"
tooltip: 'Safety Toolkit',
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const SafetyToolkitScreen()));
            },
"@
    if ($c -match "tooltip: 'Safety Toolkit',\s*onPressed: \(\) \{[^\}]+\},") {
        $c = [regex]::Replace($c, "tooltip: 'Safety Toolkit',\s*onPressed: \(\) \{[^\}]+\},", $newShield)
    }

    # Share Trip link
    $oldShare = "label: const Text\('Share Trip'\),"
    if ($c -match $oldShare) {
        $c = [regex]::Replace($c, "onPressed: \(\) \{[^\}]+\},\s*icon: const Icon\(Icons\.share_outlined", "onPressed: () { Navigator.push(context, MaterialPageRoute(builder: (_) => const SafetyToolkitScreen())); },`n                          icon: const Icon(Icons.share_outlined")
    }

    [System.IO.File]::WriteAllText($_.FullName, $c, [System.Text.Encoding]::UTF8)
    Write-Host "[LINKED] Safety Toolkit connected to $($_.Name)" -ForegroundColor Green
}

Write-Host "======================================================" -ForegroundColor Cyan
Write-Host "SUCCESS: Safety Toolkit & Emergency SOS screen created!" -ForegroundColor Green
Write-Host "In Live Tracking, click the Shield icon or 'Share Trip' to open!" -ForegroundColor Yellow
Write-Host "Now press F5 in Chrome or 'R' in CMD to view." -ForegroundColor Cyan
Write-Host "======================================================" -ForegroundColor Cyan