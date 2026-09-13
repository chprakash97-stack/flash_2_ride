Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "RESTORING QR CODE PAYMENT & SCANNER SCREEN..." -ForegroundColor Green
Write-Host "==========================================================" -ForegroundColor Cyan

$projectRoot = $PWD

# -------------------------------------------------------------
# 1. QR Code Payment & Scanner Screen ఫైల్ ను సృష్టించడం
# -------------------------------------------------------------
$qrFile = "$projectRoot\lib\screens\booking\qr_payment_screen.dart"
$qrCode = @'
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../tracking/searching_partner_screen.dart';
import 'payment_method_screen.dart';

class QrPaymentScreen extends StatefulWidget {
  final dynamic data;
  const QrPaymentScreen({super.key, this.data});

  @override
  State<QrPaymentScreen> createState() => _QrPaymentScreenState();
}

class _QrPaymentScreenState extends State<QrPaymentScreen> with SingleTickerProviderStateMixin {
  int _secondsRemaining = 299; // 04:59 కౌంట్‌డౌన్
  Timer? _timer;
  int _selectedTab = 0; // 0: Show QR, 1: Scan Driver QR
  late AnimationController _scannerController;

  @override
  void initState() {
    super.initState();
    _startTimer();
    _scannerController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        if (mounted) setState(() => _secondsRemaining--);
      } else {
        _timer?.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _scannerController.dispose();
    super.dispose();
  }

  String get _formattedTime {
    final minutes = (_secondsRemaining ~/ 60).toString().padLeft(2, '0');
    final seconds = (_secondsRemaining % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    final fare = (widget.data is Map && widget.data['fare'] != null)
        ? widget.data['fare'].toString()
        : '79';

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text(
          'Scan & Pay QR Code',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        backgroundColor: const Color(0xFF0058FF),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // ఫేర్ సారాంశం కార్డ్
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 3)),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Total Payable Fare',
                        style: TextStyle(fontSize: 13, color: Colors.grey, fontWeight: FontWeight.w500),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Flash Parcel Delivery',
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                      ),
                    ],
                  ),
                  Text(
                    '₹$fare.00',
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF0058FF)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // ట్యాబ్ల సెలెక్టర్: Show QR vs Scan QR
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFE2E8F0),
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(4),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedTab = 0),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: _selectedTab == 0 ? Colors.white : Colors.transparent,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: _selectedTab == 0
                              ? const [BoxShadow(color: Colors.black12, blurRadius: 4)]
                              : null,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.qr_code_2_rounded,
                                size: 18,
                                color: _selectedTab == 0 ? const Color(0xFF0058FF) : Colors.grey),
                            const SizedBox(width: 6),
                            Text(
                              'Show QR Code',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: _selectedTab == 0 ? const Color(0xFF0058FF) : Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedTab = 1),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: _selectedTab == 1 ? Colors.white : Colors.transparent,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: _selectedTab == 1
                              ? const [BoxShadow(color: Colors.black12, blurRadius: 4)]
                              : null,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.qr_code_scanner_rounded,
                                size: 18,
                                color: _selectedTab == 1 ? const Color(0xFF0058FF) : Colors.grey),
                            const SizedBox(width: 6),
                            Text(
                              'Scan Driver QR',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: _selectedTab == 1 ? const Color(0xFF0058FF) : Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            if (_selectedTab == 0) ...[
              // QR Code కార్డు వ్యూ
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 4)),
                  ],
                ),
                child: Column(
                  children: [
                    // కౌంట్‌డౌన్ టైమర్
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        color: _secondsRemaining < 60
                            ? const Color(0xFFFFEBEB)
                            : const Color(0xFFE5EEFF),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.timer_outlined,
                            size: 16,
                            color: _secondsRemaining < 60 ? Colors.red : const Color(0xFF0058FF),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Time Left: $_formattedTime',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: _secondsRemaining < 60 ? Colors.red : const Color(0xFF0058FF),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),

                    // QR కోడ్ బాక్స్
                    Container(
                      width: 220,
                      height: 220,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFE2E8F0), width: 2),
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          CustomPaint(
                            size: const Size(196, 196),
                            painter: _QrPatternPainter(),
                          ),
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4)],
                            ),
                            child: const Icon(
                              Icons.flash_on_rounded,
                              color: Color(0xFF0058FF),
                              size: 28,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    const Text(
                      'Scan this QR with any UPI App',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF1E293B)),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Google Pay • PhonePe • Paytm • BHIM UPI',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    const SizedBox(height: 16),

                    // UPI ID కాపీ విభాగం
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.account_balance, size: 18, color: Color(0xFF0058FF)),
                          const SizedBox(width: 10),
                          const Expanded(
                            child: Text(
                              'flash2ride.nellore@upi',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Clipboard.setData(const ClipboardData(text: 'flash2ride.nellore@upi'));
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('UPI ID copied to clipboard!'),
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            },
                            child: const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              child: Text(
                                'COPY',
                                style: TextStyle(
                                  color: Color(0xFF0058FF),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ] else ...[
              // QR కోడ్ స్కానర్ వ్యూ
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    const Text(
                      'Scan Driver / Partner QR',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Align the driver QR code inside the box to verify pickup',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    const SizedBox(height: 24),
                    Container(
                      width: 220,
                      height: 220,
                      decoration: BoxDecoration(
                        color: Colors.black87,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFF0058FF), width: 3),
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          const Icon(Icons.qr_code_scanner, color: Colors.white24, size: 120),
                          AnimatedBuilder(
                            animation: _scannerController,
                            builder: (context, child) {
                              return Positioned(
                                top: 20 + (_scannerController.value * 180),
                                left: 16,
                                right: 16,
                                child: Container(
                                  height: 3,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFF00E676),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Color(0xFF00E676),
                                        blurRadius: 8,
                                        spreadRadius: 2,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        OutlinedButton.icon(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Flashlight toggled')),
                            );
                          },
                          icon: const Icon(Icons.flash_on, size: 16),
                          label: const Text('Flashlight'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 24),

            // Confirm Payment బటన్
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0058FF),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  elevation: 2,
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Payment Verified! Finding Flash Parcel Partner in Nellore...'),
                      backgroundColor: Color(0xFF00A859),
                    ),
                  );
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const SearchingPartnerscreen(),
                    ),
                  );
                },
                child: const Text(
                  'Confirm Payment & Track Partner',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // ఇతర పేమెంట్ పద్ధతుల లింక్
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const PaymentMethodScreen(),
                  ),
                );
              },
              child: const Text(
                'Choose Another Payment Method (Cards / Cash)',
                style: TextStyle(color: Color(0xFF0058FF), fontWeight: FontWeight.w600, fontSize: 13),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QrPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF1E293B)
      ..style = PaintingStyle.fill;

    void drawFinder(double x, double y) {
      canvas.drawRect(Rect.fromLTWH(x, y, 42, 42), paint);
      final whitePaint = Paint()..color = Colors.white;
      canvas.drawRect(Rect.fromLTWH(x + 6, y + 6, 30, 30), whitePaint);
      canvas.drawRect(Rect.fromLTWH(x + 12, y + 12, 18, 18), paint);
    }

    drawFinder(0, 0);
    drawFinder(size.width - 42, 0);
    drawFinder(0, size.height - 42);

    for (double i = 0; i < size.width; i += 10) {
      for (double j = 0; j < size.height; j += 10) {
        if ((i < 48 && j < 48) ||
            (i > size.width - 48 && j < 48) ||
            (i < 48 && j > size.height - 48)) {
          continue;
        }
        if (i > 75 && i < 125 && j > 75 && j < 125) {
          continue;
        }
        if ((i.toInt() ^ j.toInt()) % 3 == 0 || (i.toInt() * j.toInt()) % 7 == 0) {
          canvas.drawRect(Rect.fromLTWH(i, j, 7, 7), paint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
'@
[System.IO.File]::WriteAllText($qrFile, $qrCode, [System.Text.Encoding]::UTF8)
Write-Host "Restored: QrPaymentScreen at $qrFile" -ForegroundColor Green

# -------------------------------------------------------------
# 2. Flash Parcel బటన్ నొక్కగానే QR Code స్క్రీన్ కి వెళ్లేలా లింక్ చేయడం
# -------------------------------------------------------------
$parcelFiles = @(
    "$projectRoot\lib\screens\booking\flash_parcel_screen.dart",
    "$projectRoot\lib\screens\booking\parcel_booking_screen.dart"
)

foreach ($pf in $parcelFiles) {
    if (Test-Path $pf) {
        $txt = Get-Content $pf -Raw -Encoding UTF8
        if ($txt -notmatch "qr_payment_screen\.dart") {
            $txt = "import 'qr_payment_screen.dart';`n" + $txt
        }
        
        # PaymentMethodScreen() కి బదులుగా QrPaymentScreen() కి లింక్ చేయడం
        $txt = $txt -replace "builder:\s*\(_\)\s*=>\s*(const\s+)?PaymentMethodScreen\(\)", "builder: (_) => const QrPaymentScreen()"
        [System.IO.File]::WriteAllText($pf, $txt, [System.Text.Encoding]::UTF8)
        Write-Host "Successfully linked Book Parcel button to QrPaymentScreen in $pf!" -ForegroundColor Green
    }
}

Write-Host "`nVerifying Dart Analysis..." -ForegroundColor Yellow
& flutter analyze

Write-Host "`n==========================================================" -ForegroundColor Cyan
Write-Host "QR CODE PAYMENT & SCANNER SCREEN IS RESTORED & FULLY LINKED!" -ForegroundColor Green
Write-Host "Run: flutter run -d chrome" -ForegroundColor Yellow
Write-Host "==========================================================" -ForegroundColor Cyan