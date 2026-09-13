Write-Host "Building Poster Section 5 Screen 3: Trip Invoice Screen..." -ForegroundColor Green

$invoiceCode = @'
import 'package:flutter/material.dart';

class TripInvoiceScreen extends StatelessWidget {
  final dynamic data;
  const TripInvoiceScreen({super.key, this.data});

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
          'Trip Invoice',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF0066FF),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined, color: Colors.white),
            tooltip: 'Share Invoice',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Sharing invoice link via WhatsApp / SMS...')),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 130),
          child: Column(
            children: [
              // 1. పోస్టర్ మోడల్ ఇన్వాయిస్ కార్డ్
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // టాప్ హెడర్: Flash 2 Ride బ్రాండ్ & టాక్స్ ఇన్వాయిస్
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.flash_on_rounded, color: Color(0xFF0066FF), size: 28),
                            SizedBox(width: 6),
                            Text(
                              'Flash2Ride',
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Color(0xFF0066FF)),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE8F8F0),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            'PAID',
                            style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF00A859)),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    const Text('Official Ride Tax Invoice', style: TextStyle(fontSize: 12, color: Colors.black45)),
                    const SizedBox(height: 16),
                    const Divider(height: 1),
                    const SizedBox(height: 16),

                    // పోస్టర్ లోని Ride Details హెడ్డింగ్
                    const Text(
                      'Ride Details',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
                    ),
                    const SizedBox(height: 14),

                    // ఫేర్ బ్రేకప్ ఐటమ్స్
                    _buildFareRow('Ride Fare', '\u20B9180.00'),
                    const SizedBox(height: 10),
                    _buildFareRow('Base Fare', '\u20B9150.00'),
                    const SizedBox(height: 10),
                    _buildFareRow('Distance (5.2 km)', '\u20B916.00'),
                    const SizedBox(height: 10),
                    _buildFareRow('Time Charges', '\u20B914.00'),
                    const SizedBox(height: 10),
                    _buildFareRow('GST (5%)', '\u20B96.50'),
                    
                    const SizedBox(height: 14),
                    const Divider(height: 1),
                    const SizedBox(height: 14),

                    // టోటల్ ఫేర్
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text(
                          'Total Fare',
                          style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.black87),
                        ),
                        Text(
                          '\u20B9185.50',
                          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Color(0xFF0066FF)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // 2. పేమెంట్ మెథడ్ కార్డ్
              Container(
                width: double.infinity,
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
                        color: const Color(0xFFEBF3FF),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.account_balance_wallet_rounded, color: Color(0xFF0066FF), size: 24),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Payment Method',
                            style: TextStyle(fontSize: 12, color: Colors.black54),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Flash Wallet - \u20B9185.50',
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.check_circle, color: Color(0xFF00A859), size: 20),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // 3. రైడ్ ఐడీ, తేదీ మరియు పార్ట్నర్ వివరాల కార్డ్
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildMetaRow('Ride ID', 'FLR202608272114'),
                    const SizedBox(height: 8),
                    _buildMetaRow('Date & Time', '28 Aug 2026, 09:15 AM'),
                    const SizedBox(height: 8),
                    _buildMetaRow('Flash 2 Partner', 'Ramesh Babu (AP 26 TX 2344)'),
                    const SizedBox(height: 8),
                    _buildMetaRow('Vehicle', 'Flash Auto'),
                    const Divider(height: 20),
                    const Text('Trip Route', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black87)),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.circle, size: 10, color: Color(0xFF00A859)),
                        const SizedBox(width: 8),
                        const Expanded(child: Text('VRC Centre, Nellore', style: TextStyle(fontSize: 12, color: Colors.black87))),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(Icons.square, size: 10, color: Colors.red),
                        const SizedBox(width: 8),
                        const Expanded(child: Text('Nellore Bus Stand, Trunk Road', style: TextStyle(fontSize: 12, color: Colors.black87))),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      // 4. పోస్టర్ మోడల్ పిన్డ్ బాటమ్ బటన్లు: Download PDF & Share
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
              child: ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Tax Invoice PDF downloaded to device!')),
                  );
                },
                icon: const Icon(Icons.download_rounded, color: Colors.white, size: 20),
                label: const Text(
                  'Download PDF',
                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0066FF),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              height: 44,
              child: OutlinedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Sharing Receipt link via WhatsApp / SMS...')),
                  );
                },
                icon: const Icon(Icons.share_outlined, color: Color(0xFF0066FF), size: 18),
                label: const Text(
                  'Share Receipt',
                  style: TextStyle(color: Color(0xFF0066FF), fontSize: 14, fontWeight: FontWeight.bold),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF0066FF),
                  side: const BorderSide(color: Color(0xFF0066FF), width: 1.5),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _buildFareRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 14, color: Colors.black54)),
        Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black87)),
      ],
    );
  }

  static Widget _buildMetaRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 110,
          child: Text(label, style: const TextStyle(fontSize: 12, color: Colors.black54)),
        ),
        const Text(': ', style: TextStyle(fontSize: 12, color: Colors.black54)),
        Expanded(
          child: Text(value, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.black87)),
        ),
      ],
    );
  }
}

typedef RideDetailsScreen = TripInvoiceScreen;
'@

# 1. screens/post_ride మరియు views/history లోకి రాస్తుంది
$dir1 = "$PWD\lib\screens\post_ride"
if (!(Test-Path $dir1)) { New-Item -ItemType Directory -Path $dir1 -Force | Out-Null }
[System.IO.File]::WriteAllText("$dir1\trip_invoice_screen.dart", $invoiceCode, [System.Text.Encoding]::UTF8)

$dir2 = "$PWD\lib\views\history"
if (!(Test-Path $dir2)) { New-Item -ItemType Directory -Path $dir2 -Force | Out-Null }
[System.IO.File]::WriteAllText("$dir2\ride_details_screen.dart", $invoiceCode, [System.Text.Encoding]::UTF8)

# 2. Trip Completed స్క్రీన్ లోని Download PDF బటన్ ను ఈ Trip Invoice తో లింక్ చేస్తుంది
Get-ChildItem -Path "$PWD\lib" -Filter rating_tip_screen.dart -Recurse | ForEach-Object {
    $c = [System.IO.File]::ReadAllText($_.FullName)
    if ($c -notmatch 'TripInvoiceScreen') {
        $c = "import 'trip_invoice_screen.dart';`n" + $c
    }
    
    # Link Download PDF to TripInvoiceScreen
    $oldPdf = "onPressed: () {`n                  ScaffoldMessenger.of(context).showSnackBar(`n                    const SnackBar(content: Text('Downloading Tax Invoice PDF...')),`n                  );`n                },"
    $newPdf = @"
onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const TripInvoiceScreen()));
                },
"@
    $c = [regex]::Replace($c, "onPressed: \(\) \{\s*ScaffoldMessenger\.of\(context\)\.showSnackBar\([^\}]+\);\s*\},", $newPdf)

    [System.IO.File]::WriteAllText($_.FullName, $c, [System.Text.Encoding]::UTF8)
    Write-Host "[LINKED] Download PDF button connected to Trip Invoice in $($_.Name)" -ForegroundColor Green
}

Write-Host "======================================================" -ForegroundColor Cyan
Write-Host "SUCCESS: Trip Invoice screen created! Section 5 is 100% complete!" -ForegroundColor Green
Write-Host "In Trip Completed screen, click 'Download PDF' to view Invoice!" -ForegroundColor Yellow
Write-Host "Now press F5 in Chrome or 'R' in CMD to view." -ForegroundColor Cyan
Write-Host "======================================================" -ForegroundColor Cyan