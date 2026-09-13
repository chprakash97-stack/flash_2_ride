Write-Host "Building Poster Section 5 Screen 2: Cancel Ride Screen..." -ForegroundColor Green

$cancelCode = @'
import 'package:flutter/material.dart';

class CancelRideDialog extends StatefulWidget {
  final dynamic data;
  const CancelRideDialog({super.key, this.data});

  @override
  State<CancelRideDialog> createState() => _CancelRideDialogState();
}

class _CancelRideDialogState extends State<CancelRideDialog> {
  int _selectedReasonIndex = 0;
  final TextEditingController _otherReasonController = TextEditingController();

  final List<String> _reasons = const [
    'Driver not coming / delayed',
    'Wrong pickup location picked',
    'Change in travel plan',
    'Expected shorter wait time',
    'High fare / Fare issue',
    'Others',
  ];

  @override
  void dispose() {
    _otherReasonController.dispose();
    super.dispose();
  }

  void _confirmCancellation() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: Colors.red,
        content: Text('Ride cancelled successfully. Zero fee applied.'),
      ),
    );
    // హోమ్ స్క్రీన్ కు వెళ్తుంది
    Navigator.of(context).popUntil((route) => route.isFirst);
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
          'Cancel Ride',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF0066FF),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. పోస్టర్ మోడల్ హెచ్చరిక కార్డు
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: const BoxDecoration(
                      color: Color(0xFFFEE2E2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.cancel_outlined,
                      color: Colors.red,
                      size: 40,
                    ),
                  ),
                  const SizedBox(height: 14),
                  const Text(
                    'Are you sure you want to cancel the ride?',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.black87),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F8F0),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.check_circle, color: Color(0xFF00A859), size: 16),
                        SizedBox(width: 6),
                        Text(
                          'No cancellation fee if cancelled now',
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF00A859)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // 2. క్యాన్సిలేషన్ కారణాల లిస్ట్ హెడ్డింగ్
            const Text(
              'Reason for cancellation',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            const SizedBox(height: 4),
            const Text(
              'Please select the reason to help us improve your experience',
              style: TextStyle(fontSize: 12, color: Colors.black54),
            ),
            const SizedBox(height: 14),

            // కారణాల రేడియో కార్డ్స్
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: List.generate(_reasons.length, (index) {
                  final reason = _reasons[index];
                  final isSelected = _selectedReasonIndex == index;
                  return InkWell(
                    onTap: () => setState(() => _selectedReasonIndex = index),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        border: index != _reasons.length - 1
                            ? Border(bottom: BorderSide(color: Colors.grey.shade100))
                            : null,
                      ),
                      child: Row(
                        children: [
                          Icon(
                            isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
                            color: isSelected ? const Color(0xFF0066FF) : Colors.grey.shade400,
                            size: 20,
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Text(
                              reason,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                                color: isSelected ? const Color(0xFF0066FF) : Colors.black87,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ),

            // ఒకవేళ "Others" సెలెక్ట్ చేస్తే టైప్ చేసే బాక్స్
            if (_selectedReasonIndex == _reasons.length - 1) ...[
              const SizedBox(height: 14),
              TextField(
                controller: _otherReasonController,
                decoration: InputDecoration(
                  hintText: 'Please describe the reason...',
                  hintStyle: const TextStyle(fontSize: 13, color: Colors.black38),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.all(14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: Color(0xFFCCE0FF)),
                  ),
                ),
              ),
            ],

            const SizedBox(height: 28),

            // 3. యాక్షన్ బటన్లు
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _confirmCancellation,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  elevation: 0,
                ),
                child: const Text(
                  'Cancel Ride',
                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),

            const SizedBox(height: 12),

            SizedBox(
              width: double.infinity,
              height: 48,
              child: OutlinedButton(
                onPressed: () => Navigator.maybePop(context),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF0066FF),
                  side: const BorderSide(color: Color(0xFF0066FF), width: 1.5),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                child: const Text(
                  'Don\'t Cancel / Keep Ride',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

typedef CancelRideScreen = CancelRideDialog;
'@

# 1. views/ride మరియు screens/ride లోకి రాస్తుంది
$dir1 = "$PWD\lib\views\ride"
if (!(Test-Path $dir1)) { New-Item -ItemType Directory -Path $dir1 -Force | Out-Null }
[System.IO.File]::WriteAllText("$dir1\cancel_ride_dialog.dart", $cancelCode, [System.Text.Encoding]::UTF8)

$dir2 = "$PWD\lib\screens\ride"
if (!(Test-Path $dir2)) { New-Item -ItemType Directory -Path $dir2 -Force | Out-Null }
[System.IO.File]::WriteAllText("$dir2\cancel_ride_dialog.dart", $cancelCode, [System.Text.Encoding]::UTF8)

# 2. Searching Partner స్క్రీన్ లోని Cancel Ride బటన్ ను లింక్ చేస్తుంది
Get-ChildItem -Path "$PWD\lib" -Filter searching_partner_screen.dart -Recurse | ForEach-Object {
    $c = [System.IO.File]::ReadAllText($_.FullName)
    if ($c -notmatch 'CancelRideDialog') {
        $c = "import '../ride/cancel_ride_dialog.dart';`n" + $c
    }
    
    # Replace Cancel Ride onPressed in Searching Partner
    $oldCancel = "onPressed: () {`n                        _autoTransitionTimer?.cancel();`n                        Navigator.maybePop(context);`n                      },"
    $newCancel = @"
onPressed: () {
                        _autoTransitionTimer?.cancel();
                        Navigator.push(context, MaterialPageRoute(builder: (_) => const CancelRideDialog()));
                      },
"@
    if ($c -match "Cancel Ride") {
        $c = [regex]::Replace($c, "onPressed: \(\) \{\s*_autoTransitionTimer\?\.cancel\(\);\s*Navigator\.maybePop\(context\);\s*\},", $newCancel)
    }

    [System.IO.File]::WriteAllText($_.FullName, $c, [System.Text.Encoding]::UTF8)
    Write-Host "[LINKED] Cancel Ride connected in Searching Partner Screen" -ForegroundColor Green
}

# 3. Live Tracking స్క్రీన్ లోని Cancel Ride బటన్ ను కూడా లింక్ చేస్తుంది
Get-ChildItem -Path "$PWD\lib" -Filter live_tracking_screen.dart -Recurse | ForEach-Object {
    $c = [System.IO.File]::ReadAllText($_.FullName)
    if ($c -notmatch 'CancelRideDialog') {
        $c = "import '../ride/cancel_ride_dialog.dart';`n" + $c
    }
    
    $c = [regex]::Replace($c, "onPressed: \(\) => Navigator\.maybePop\(context\),\s*icon: const Icon\(Icons\.cancel_outlined\)", "onPressed: () { Navigator.push(context, MaterialPageRoute(builder: (_) => const CancelRideDialog())); },`n                          icon: const Icon(Icons.cancel_outlined)")
    [System.IO.File]::WriteAllText($_.FullName, $c, [System.Text.Encoding]::UTF8)
    Write-Host "[LINKED] Cancel Ride connected in Live Tracking Screen" -ForegroundColor Green
}

Write-Host "======================================================" -ForegroundColor Cyan
Write-Host "SUCCESS: Cancel Ride screen created and connected to buttons!" -ForegroundColor Green
Write-Host "Now press F5 in Chrome or 'R' in CMD to view." -ForegroundColor Cyan
Write-Host "======================================================" -ForegroundColor Cyan