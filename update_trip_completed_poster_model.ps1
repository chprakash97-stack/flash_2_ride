Write-Host "Updating Trip Completed Screen to exact Poster Model (Download PDF & Share)..." -ForegroundColor Green

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

  // 5 స్టార్స్ రేటింగ్ విడ్జెట్
  Widget _buildStar(int starIndex) {
    final isFilled = starIndex <= _rating;
    return IconButton(
      iconSize: 36,
      onPressed: () => setState(() => _rating = starIndex),
      icon: Icon(
        isFilled ? Icons.star_rounded : Icons.star_outline_rounded,
        color: isFilled ? Colors.amber : Colors.grey.shade300,
      ),
    );
  }

  // టిప్ బటన్ల విడ్జెట్
  Widget _buildTipButton(int tip, String label) {
    final isSelected = _selectedTip == tip;
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
  }

  @override
  Widget build(BuildContext context) {
    final int totalFare = 180;
    final int finalAmount = totalFare + _selectedTip;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
          onPressed: () => Navigator.maybePop(context),
        ),
        title: const Text(
          'Trip Completed',
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

            // 2. పార్ట్నర్ ప్రొఫైల్ & 5 స్టార్ రేటింగ్
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
                    'Rate your experience with Flash 2 Partner',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black87),
                  ),
                  const SizedBox(height: 8),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildStar(1),
                      _buildStar(2),
                      _buildStar(3),
                      _buildStar(4),
                      _buildStar(5),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // 3. టిప్ యువర్ పార్ట్నర్
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
                    children: [
                      _buildTipButton(0, 'No Tip'),
                      _buildTipButton(10, '+\u20B910'),
                      _buildTipButton(20, '+\u20B920'),
                      _buildTipButton(50, '+\u20B950'),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // 4. ఫేర్ సారాంశం (Fare Summary)
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

            // 5. పోస్టర్ లోని 1వ బటన్: Download PDF
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Downloading Tax Invoice PDF...')),
                  );
                },
                icon: const Icon(Icons.picture_as_pdf_rounded, color: Colors.white, size: 20),
                label: const Text(
                  'Download PDF',
                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0066FF),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  elevation: 0,
                ),
              ),
            ),

            const SizedBox(height: 12),

            // 6. పోస్టర్ లోని 2వ బటన్: Share Receipt
            SizedBox(
              width: double.infinity,
              height: 48,
              child: OutlinedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Sharing Receipt link via WhatsApp / SMS...')),
                  );
                },
                icon: const Icon(Icons.share_outlined, color: Color(0xFF0066FF), size: 18),
                label: const Text(
                  'Share',
                  style: TextStyle(color: Color(0xFF0066FF), fontSize: 15, fontWeight: FontWeight.bold),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF0066FF),
                  side: const BorderSide(color: Color(0xFF0066FF), width: 1.5),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
              ),
            ),

            const SizedBox(height: 10),

            // 7. హోమ్ స్క్రీన్‌కు వెళ్ళడానికి బటన్
            TextButton(
              onPressed: () {
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
              child: const Text(
                'Back to Home',
                style: TextStyle(color: Colors.black54, fontSize: 14, fontWeight: FontWeight.w600),
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

# ఫైల్స్ లోకి రాస్తుంది
$p1 = "$PWD\lib\screens\post_ride\rating_tip_screen.dart"
if (!(Test-Path "$PWD\lib\screens\post_ride")) { New-Item -ItemType Directory -Path "$PWD\lib\screens\post_ride" -Force | Out-Null }
[System.IO.File]::WriteAllText($p1, $tripCode, [System.Text.Encoding]::UTF8)

$p2 = "$PWD\lib\views\tracking\ride_completed_screen.dart"
if (Test-Path "$PWD\lib\views\tracking") {
    [System.IO.File]::WriteAllText($p2, $tripCode, [System.Text.Encoding]::UTF8)
}

Write-Host "======================================================" -ForegroundColor Cyan
Write-Host "SUCCESS: Updated to exact Poster Model with 'Download PDF' & 'Share'!" -ForegroundColor Green
Write-Host "Now press F5 in Chrome or 'R' in CMD to view." -ForegroundColor Cyan
Write-Host "======================================================" -ForegroundColor Cyan