Write-Host "Polishing Cancel Ride Screen to match high-end Poster Design..." -ForegroundColor Green

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
        content: Text('Ride cancelled successfully. Zero cancellation fee applied.'),
      ),
    );
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
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 120),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. పోస్టర్ మోడల్ టాప్ హెచ్చరిక కార్డ్
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: const BoxDecoration(
                        color: Color(0xFFFEE2E2),
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.cancel_outlined,
                          color: Colors.red,
                          size: 32,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Are you sure you want to cancel the ride?',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8F8F0),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.check_circle_rounded, color: Color(0xFF00A859), size: 15),
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

              const SizedBox(height: 20),

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

              // ప్రీమియం సెలెక్టబుల్ రీజన్స్ కార్డ్స్
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
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
                      borderRadius: BorderRadius.vertical(
                        top: index == 0 ? const Radius.circular(18) : Radius.zero,
                        bottom: index == _reasons.length - 1 ? const Radius.circular(18) : Radius.zero,
                      ),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        decoration: BoxDecoration(
                          color: isSelected ? const Color(0xFFF4F8FF) : Colors.transparent,
                          border: index != _reasons.length - 1
                              ? Border(bottom: BorderSide(color: Colors.grey.shade100))
                              : null,
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 22,
                              height: 22,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: isSelected ? const Color(0xFF0066FF) : Colors.grey.shade400,
                                  width: 2,
                                ),
                              ),
                              child: isSelected
                                  ? Center(
                                      child: Container(
                                        width: 12,
                                        height: 12,
                                        decoration: const BoxDecoration(
                                          color: Color(0xFF0066FF),
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                    )
                                  : null,
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
                            if (isSelected)
                              const Icon(Icons.check_rounded, color: Color(0xFF0066FF), size: 18),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
              ),

              if (_selectedReasonIndex == _reasons.length - 1) ...[
                const SizedBox(height: 14),
                TextField(
                  controller: _otherReasonController,
                  maxLines: 2,
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
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(color: Color(0xFFCCE0FF)),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
      // 3. పిన్డ్ బాటమ్ బటన్లు (స్క్రీన్ స్క్రోల్ చేసినా ఎప్పుడూ కిందే కనిపిస్తాయి)
      bottomSheet: Container(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 10,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: _confirmCancellation,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
                child: const Text(
                  'Cancel Ride',
                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 6),
            SizedBox(
              width: double.infinity,
              height: 40,
              child: TextButton(
                onPressed: () => Navigator.maybePop(context),
                child: const Text(
                  'Don\'t Cancel / Keep Ride',
                  style: TextStyle(color: Color(0xFF0066FF), fontSize: 14, fontWeight: FontWeight.bold),
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

# ఫైల్స్ లోకి అప్‌డేట్ చేస్తుంది
$dir1 = "$PWD\lib\views\ride"
if (!(Test-Path $dir1)) { New-Item -ItemType Directory -Path $dir1 -Force | Out-Null }
[System.IO.File]::WriteAllText("$dir1\cancel_ride_dialog.dart", $cancelCode, [System.Text.Encoding]::UTF8)

$dir2 = "$PWD\lib\screens\ride"
if (!(Test-Path $dir2)) { New-Item -ItemType Directory -Path $dir2 -Force | Out-Null }
[System.IO.File]::WriteAllText("$dir2\cancel_ride_dialog.dart", $cancelCode, [System.Text.Encoding]::UTF8)

Write-Host "======================================================" -ForegroundColor Cyan
Write-Host "SUCCESS: Cancel Ride screen polished with Pinned Buttons & Premium Design!" -ForegroundColor Green
Write-Host "Now press F5 in Chrome or 'R' in CMD to view." -ForegroundColor Cyan
Write-Host "======================================================" -ForegroundColor Cyan