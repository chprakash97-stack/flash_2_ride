Write-Host "Building Poster Section 5 Screen 1: Trip Completed & Rating Screen..." -ForegroundColor Green

$tripCode = @'
import 'package:flutter/material.dart';

class RatingTipScreen extends StatefulWidget {
  final dynamic data;
  const RatingTipScreen({super.key, this.data});

  @override
  State<RatingTipScreen> createState() => _RatingTipScreenState();
}

class _RatingTipScreenState extends State<RatingTipScreen> {
  int _rating = 5;
  int _selectedTip = 0;
  final TextEditingController _feedbackController = TextEditingController();

  final List<int> _tipOptions =;

  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const totalFare = 180;
    final finalAmount = totalFare + _selectedTip;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close_rounded, color: Colors.white, size: 24),
          onPressed: () => Navigator.maybePop(context),
        ),
        title: const Text(
          'Trip Summary',
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
            // 1. పోస్టర్ మోడల్ సక్సెస్ హెడర్
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
                  Container(
                    width: 76,
                    height: 76,
                    decoration: const BoxDecoration(
                      color: Color(0xFFE8F8F0),
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.check_circle_rounded,
                        color: Color(0xFF00A859),
                        size: 52,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Trip Completed!',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Thank you for riding with Flash 2 Ride',
                    style: TextStyle(fontSize: 13, color: Colors.black54),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // 2. పార్ట్నర్ ప్రొఫైల్ & ఇంటరాక్టివ్ 5 స్టార్ రేటింగ్
            Container(
              padding: const EdgeInsets.all(20),
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
                children: [
                  const Row(
                    children: [
                      CircleAvatar(
                        radius: 24,
                        backgroundColor: Color(0xFFEBF3FF),
                        child: Icon(Icons.person, color: Color(0xFF0066FF), size: 30),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Ramesh Babu',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'AP 26 TX 2344 \u2022 Flash Auto',
                              style: TextStyle(fontSize: 12, color: Colors.black54),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  const Divider(height: 1),
                  const SizedBox(height: 14),

                  const Text(
                    'How was your ride with Flash 2 Partner?',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black87),
                  ),
                  const SizedBox(height: 10),

                  // 5 Star రేటింగ్ బార్
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      final starIndex = index + 1;
                      return IconButton(
                        iconSize: 36,
                        onPressed: () => setState(() => _rating = starIndex),
                        icon: Icon(
                          starIndex <= _rating ? Icons.star_rounded : Icons.star_outline_rounded,
                          color: starIndex <= _rating ? Colors.amber : Colors.grey.shade300,
                        ),
                      );
                    }),
                  ),

                  // ఫీడ్‌బ్యాక్ టెక్స్ట్‌ఫీల్డ్
                  const SizedBox(height: 8),
                  TextField(
                    controller: _feedbackController,
                    decoration: InputDecoration(
                      hintText: 'Write a compliment or feedback (Optional)...',
                      hintStyle: const TextStyle(fontSize: 13, color: Colors.black38),
                      filled: true,
                      fillColor: const Color(0xFFF8F9FA),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade200),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade200),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // 3. టిప్ యువర్ పార్ట్నర్ (Tip your Partner)
            Container(
              padding: const EdgeInsets.all(18),
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Tip your Flash 2 Partner',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87),
                  ),
                  const SizedBox(height: 2),
                  const Text(
                    '100% of the tip goes directly to your partner',
                    style: TextStyle(fontSize: 12, color: Colors.black54),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: _tipOptions.map((tip) {
                      final isSelected = _selectedTip == tip;
                      final label = tip == 0 ? 'No Tip' : '+\u20B9$tip';
                      return InkWell(
                        onTap: () => setState(() => _selectedTip = tip),
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: isSelected ? const Color(0xFF0066FF) : const Color(0xFFF4F7FC),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isSelected ? const Color(0xFF0066FF) : const Color(0xFFE0E6ED),
                            ),
                          ),
                          child: Text(
                            label,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: isSelected ? Colors.white : Colors.black87,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // 4. ఫేర్ బ్రేకప్ కార్డ్
            Container(
              padding: const EdgeInsets.all(18),
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
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Ride Fare', style: TextStyle(fontSize: 14, color: Colors.black54)),
                      Text('\u20B9180', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                    ],
                  ),
                  if (_selectedTip > 0) ...[
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Partner Tip', style: TextStyle(fontSize: 14, color: Colors.black54)),
                        Text('+\u20B9$_selectedTip', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF00A859))),
                      ],
                    ),
                  ],
                  const SizedBox(height: 12),
                  const Divider(height: 1),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Total Paid', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
                          Text('Paid via Cash', style: TextStyle(fontSize: 12, color: Color(0xFF00A859), fontWeight: FontWeight.w600)),
                        ],
                      ),
                      Text(
                        '\u20B9$finalAmount',
                        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Color(0xFF0066FF)),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // 5. సబ్మిట్ & డౌన్‌లోడ్ బటన్లు
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Thank you! Feedback submitted successfully.')),
                  );
                  Navigator.maybePop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0066FF),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  elevation: 0,
                ),
                child: const Text(
                  'Submit Feedback',
                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),

            const SizedBox(height: 12),

            SizedBox(
              width: double.infinity,
              height: 48,
              child: OutlinedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Downloading Tax Invoice PDF...')),
                  );
                },
                icon: const Icon(Icons.download_rounded, size: 18),
                label: const Text('Download Invoice / Receipt'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF0066FF),
                  side: const BorderSide(color: Color(0xFF0066FF), width: 1.5),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

typedef RideCompletedScreen = RatingTipScreen;
'@

# 1. rating_tip_screen.dart మరియు ride_completed_screen.dart లోకి రాస్తుంది
$p1 = "$PWD\lib\screens\post_ride\rating_tip_screen.dart"
if (!(Test-Path "$PWD\lib\screens\post_ride")) { New-Item -ItemType Directory -Path "$PWD\lib\screens\post_ride" -Force | Out-Null }
[System.IO.File]::WriteAllText($p1, $tripCode, [System.Text.Encoding]::UTF8)

$p2 = "$PWD\lib\views\tracking\ride_completed_screen.dart"
if (Test-Path "$PWD\lib\views\tracking") {
    [System.IO.File]::WriteAllText($p2, $tripCode, [System.Text.Encoding]::UTF8)
}

# 2. Live Tracking స్క్రీన్ లో "Complete Ride (Demo)" బటన్ ను లింక్ చేస్తుంది
Get-ChildItem -Path "$PWD\lib" -Filter live_tracking_screen.dart -Recurse | ForEach-Object {
    $c = [System.IO.File]::ReadAllText($_.FullName)
    if ($c -notmatch 'RatingTipScreen') {
        $c = "import '../post_ride/rating_tip_screen.dart';`n" + $c
    }

    # Add Demo Complete Ride Action to Top AppBar
    if ($c -notmatch 'Complete Ride') {
        $oldActions = "actions: ["
        $newActions = @"
actions: [
          TextButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const RatingTipScreen()));
            },
            child: const Text('Complete (Demo)', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
"@
        $c = $c.Replace($oldActions, $newActions)
    }

    [System.IO.File]::WriteAllText($_.FullName, $c, [System.Text.Encoding]::UTF8)
    Write-Host "[LINKED] Complete Trip button connected in $($_.Name)" -ForegroundColor Green
}

Write-Host "======================================================" -ForegroundColor Cyan
Write-Host "SUCCESS: Trip Completed & Rating Screen created!" -ForegroundColor Green
Write-Host "In Live Tracking, click 'Complete (Demo)' at top right to view!" -ForegroundColor Yellow
Write-Host "Now press F5 in Chrome or 'R' in CMD to view." -ForegroundColor Cyan
Write-Host "======================================================" -ForegroundColor Cyan