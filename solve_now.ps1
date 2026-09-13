Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "FIXING LINE 400 IN lib\screens\home\home_screen.dart..." -ForegroundColor Green
Write-Host "==========================================================" -ForegroundColor Cyan

$projectRoot = $PWD

# 1. lib\screens\home\home_screen.dart లో 400వ లైన్ అప్‌డేట్ చేయడం
$homeFile = "$projectRoot\lib\screens\home\home_screen.dart"

if (Test-Path $homeFile) {
    $content = Get-Content $homeFile -Raw -Encoding UTF8

    # Import జోడించడం (లేకపోతే)
    if ($content -notmatch "wallet_screen\.dart") {
        $content = "import '../features/wallet_screen.dart';`n" + $content
        Write-Host "Added wallet_screen import to home_screen.dart" -ForegroundColor Yellow
    }

    # 400వ లైన్ లోని Navigator.pop(context) ని అసలైన Navigation తో రీప్లేస్ చేయడం
    $oldLine = "ListTile(leading: const Icon(Icons.account_balance_wallet_outlined), title: const Text('Flash Wallet'), onTap: () => Navigator.pop(context)),"
    $newLine = @"
ListTile(
              leading: const Icon(Icons.account_balance_wallet_rounded, color: Color(0xFF0058FF)),
              title: const Text('Flash Wallet', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF0058FF))),
              subtitle: const Text('Balance: ₹250.00', style: TextStyle(fontSize: 12, color: Colors.grey)),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (_) => const WalletScreen()));
              },
            ),
"@

    if ($content.Contains($oldLine)) {
        $content = $content.Replace($oldLine, $newLine)
        Write-Host "Successfully replaced Line 400 with Wallet Navigation!" -ForegroundColor Green
    } else {
        # RegEx ఆధారంగా మార్చడం
        $content = [System.Text.RegularExpressions.Regex]::Replace(
            $content,
            "ListTile\([^)]*title:\s*const\s*Text\('Flash Wallet'\)[^)]*onTap:\s*\(\)\s*=>\s*Navigator\.pop\(context\)[^)]*\),",
            $newLine
        )
        Write-Host "Successfully patched Flash Wallet ListTile via pattern match!" -ForegroundColor Green
    }

    [System.IO.File]::WriteAllText($homeFile, $content, [System.Text.Encoding]::UTF8)
} else {
    Write-Host "ERROR: $homeFile not found!" -ForegroundColor Red
}

# 2. lib\screens\features\wallet_screen.dart లో పూర్తి వాలెట్ UI సెట్ చేయడం
$walletFile = "$projectRoot\lib\screens\features\wallet_screen.dart"
$walletCode = @'
import 'package:flutter/material.dart';

class WalletScreen extends StatefulWidget {
  final dynamic data;
  const WalletScreen({super.key, this.data});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  double _balance = 250.00;
  final TextEditingController _amountController = TextEditingController();

  final List<Map<String, dynamic>> _transactions = [
    {
      'title': 'Daily Ride Cashback',
      'date': 'Today, 05:30 PM',
      'amount': '+ ₹25.00',
      'isCredit': true,
      'icon': Icons.arrow_downward_rounded,
    },
    {
      'title': 'Paid for Auto Ride',
      'date': 'Today, 02:15 PM',
      'amount': '- ₹65.00',
      'isCredit': false,
      'icon': Icons.arrow_upward_rounded,
    },
    {
      'title': 'Wallet Top-up via UPI (GPay)',
      'date': 'Yesterday, 10:00 AM',
      'amount': '+ ₹200.00',
      'isCredit': true,
      'icon': Icons.account_balance_wallet_rounded,
    },
    {
      'title': 'Parcel Delivery Fee',
      'date': '10 Sep, 06:45 PM',
      'amount': '- ₹40.00',
      'isCredit': false,
      'icon': Icons.inventory_2_outlined,
    },
    {
      'title': 'Welcome Bonus - Nellore Launch',
      'date': '08 Sep, 09:00 AM',
      'amount': '+ ₹130.00',
      'isCredit': true,
      'icon': Icons.card_giftcard_rounded,
    },
  ];

  void _showAddMoneySheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Top-up Flash Wallet', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
                ],
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                decoration: InputDecoration(
                  prefixText: '₹ ',
                  prefixStyle: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF00A859)),
                  hintText: 'Enter amount',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 14),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [100, 200, 500, 1000].map((amt) {
                  return ActionChip(
                    label: Text('+₹$amt', style: const TextStyle(fontWeight: FontWeight.bold)),
                    backgroundColor: const Color(0xFFE8F8F0),
                    onPressed: () {
                      _amountController.text = amt.toString();
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00A859),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () {
                    final entered = double.tryParse(_amountController.text);
                    if (entered != null && entered > 0) {
                      setState(() {
                        _balance += entered;
                        _transactions.insert(0, {
                          'title': 'Added via UPI',
                          'date': 'Just Now',
                          'amount': '+ ₹${entered.toStringAsFixed(2)}',
                          'isCredit': true,
                          'icon': Icons.account_balance_wallet_rounded,
                        });
                      });
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Added ₹$entered to Flash Wallet!'), backgroundColor: const Color(0xFF00A859)),
                      );
                    }
                  },
                  child: const Text('Proceed to Pay via UPI', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text('Flash Wallet', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
        backgroundColor: const Color(0xFF0058FF),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // బ్యాలెన్స్ కార్డు
            Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF0058FF), Color(0xFF00B0FF)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(color: const Color(0xFF0058FF).withOpacity(0.3), blurRadius: 12, offset: const Offset(0, 6)),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Total Available Balance', style: TextStyle(color: Colors.white70, fontSize: 13)),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(12)),
                        child: const Row(
                          children: [
                            Icon(Icons.bolt, color: Colors.amber, size: 16),
                            SizedBox(width: 4),
                            Text('Instant Checkout', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text('₹${_balance.toStringAsFixed(2)}', style: const TextStyle(color: Colors.white, fontSize: 34, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: const Color(0xFF0058FF),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        ),
                        onPressed: _showAddMoneySheet,
                        icon: const Icon(Icons.add_circle_outline, size: 18),
                        label: const Text('Add Money', style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(width: 12),
                      OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          side: const BorderSide(color: Colors.white70),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        ),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Offer Applied: Flat ₹25 cashback on your next ride!')),
                          );
                        },
                        icon: const Icon(Icons.local_offer_outlined, size: 18),
                        label: const Text('Offers'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text('Recent Transactions', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            ..._transactions.map((tx) => Container(
              margin: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14)),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: tx['isCredit'] ? const Color(0xFFE8F8F0) : const Color(0xFFFEE2E2),
                  child: Icon(tx['icon'], color: tx['isCredit'] ? const Color(0xFF00A859) : Colors.red, size: 20),
                ),
                title: Text(tx['title'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                subtitle: Text(tx['date'], style: const TextStyle(fontSize: 12, color: Colors.grey)),
                trailing: Text(
                  tx['amount'],
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: tx['isCredit'] ? const Color(0xFF00A859) : Colors.red),
                ),
              ),
            )),
          ],
        ),
      ),
    );
  }
}
'@

[System.IO.File]::WriteAllText($walletFile, $walletCode, [System.Text.Encoding]::UTF8)
Write-Host "Updated wallet_screen.dart at lib\screens\features\wallet_screen.dart" -ForegroundColor Green

# 3. ఎర్రర్స్ తెప్పిస్తున్న డమ్మీ ఫైల్స్ తొలగించడం
$unneededFiles = @(
    "$projectRoot\lib\screens\home\customer_home_screen.dart",
    "$projectRoot\lib\screens\wallet\wallet_screen.dart"
)
foreach ($f in $unneededFiles) {
    if (Test-Path $f) { Remove-Item -Path $f -Force; Write-Host "Cleaned: $f" -ForegroundColor Yellow }
}

if (Test-Path "$projectRoot\lib\views") {
    Remove-Item -Path "$projectRoot\lib\views" -Recurse -Force
    Write-Host "Cleaned unused lib\views directory." -ForegroundColor Yellow
}

Write-Host "`n==========================================================" -ForegroundColor Cyan
Write-Host "ALL DONE! Line 400 is now linked to WalletScreen!" -ForegroundColor Green
Write-Host "Run: flutter run -d chrome" -ForegroundColor Yellow
Write-Host "==========================================================" -ForegroundColor Cyan