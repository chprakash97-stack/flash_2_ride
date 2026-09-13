Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "NORMALIZING FLASH WALLET IN MENU & FIXING ALL SYMBOLS..." -ForegroundColor Green
Write-Host "==========================================================" -ForegroundColor Cyan

$projectRoot = $PWD

# 1. lib\screens\home\home_screen.dart లో Flash Wallet ను నార్మల్ గా మార్చడం (ఆటో సెలెక్ట్ లుక్ తీసేయడం)
$homeFile = "$projectRoot\lib\screens\home\home_screen.dart"
if (Test-Path $homeFile) {
    $lines = Get-Content $homeFile
    $walletIdx = -1
    for ($i = 0; $i -lt $lines.Count; $i++) {
        if ($lines[$i] -match "Text\('Flash Wallet'") {
            $walletIdx = $i
            break
        }
    }
    if ($walletIdx -ne -1) {
        $startIdx = $walletIdx
        while ($startIdx -gt 0 -and $lines[$startIdx] -notmatch "ListTile\(") {
            $startIdx--
        }
        $endIdx = $walletIdx
        while ($endIdx -lt $lines.Count -and $lines[$endIdx].Trim() -ne "),") {
            $endIdx++
        }

        # సాధారణ లిస్ట్ టైల్ (నో బ్లూ కలర్, నో సబ్ టైటిల్ - మిగతా వాటిలాగే నార్మల్ గా ఉంటుంది)
        $cleanTile = "            ListTile(leading: const Icon(Icons.account_balance_wallet_outlined), title: const Text('Flash Wallet'), onTap: () { Navigator.pop(context); Navigator.push(context, MaterialPageRoute(builder: (_) => const WalletScreen())); }),"

        $newLines = @()
        for ($k = 0; $k -lt $startIdx; $k++) { $newLines += $lines[$k] }
        $newLines += $cleanTile
        for ($k = $endIdx + 1; $k -lt $lines.Count; $k++) { $newLines += $lines[$k] }

        [System.IO.File]::WriteAllLines($homeFile, $newLines, [System.Text.Encoding]::UTF8)
        Write-Host "1. Menu item normalized: Flash Wallet is now unselected (normal look)." -ForegroundColor Green
    }
}

# 2. lib\screens\features\wallet_screen.dart లో రూపాయి సింబల్స్ & బాటమ్ షీట్ అప్‌డేట్
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
      'amount': '+ \u20B925.00',
      'isCredit': true,
      'icon': Icons.arrow_downward_rounded,
    },
    {
      'title': 'Paid for Auto Ride',
      'date': 'Today, 02:15 PM',
      'amount': '- \u20B965.00',
      'isCredit': false,
      'icon': Icons.arrow_upward_rounded,
    },
    {
      'title': 'Wallet Top-up via UPI (GPay)',
      'date': 'Yesterday, 10:00 AM',
      'amount': '+ \u20B9200.00',
      'isCredit': true,
      'icon': Icons.account_balance_wallet_rounded,
    },
    {
      'title': 'Parcel Delivery Fee',
      'date': '10 Sep, 06:45 PM',
      'amount': '- \u20B940.00',
      'isCredit': false,
      'icon': Icons.inventory_2_outlined,
    },
    {
      'title': 'Welcome Bonus - Nellore Launch',
      'date': '08 Sep, 09:00 AM',
      'amount': '+ \u20B9130.00',
      'isCredit': true,
      'icon': Icons.card_giftcard_rounded,
    },
  ];

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _showAddMoneySheet() {
    final rootContext = context;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Padding(
              padding: EdgeInsets.only(bottom: MediaQuery.of(sheetContext).viewInsets.bottom),
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
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.of(sheetContext).pop(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _amountController,
                      keyboardType: TextInputType.number,
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      decoration: InputDecoration(
                        prefixText: '\u20B9 ',
                        prefixStyle: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF0058FF)),
                        hintText: 'Enter amount',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Color(0xFF0058FF), width: 2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [100, 200, 500, 1000].map((amt) {
                        final isSelected = _amountController.text == amt.toString();
                        return ActionChip(
                          label: Text(
                            '+\u20B9$amt',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: isSelected ? Colors.white : const Color(0xFF0058FF),
                            ),
                          ),
                          backgroundColor: isSelected ? const Color(0xFF0058FF) : const Color(0xFFE5EEFF),
                          side: const BorderSide(color: Color(0xFF0058FF)),
                          onPressed: () {
                            setSheetState(() {
                              _amountController.text = amt.toString();
                            });
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0058FF),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: () {
                          final val = double.tryParse(_amountController.text.trim());
                          if (val != null && val > 0) {
                            setState(() {
                              _balance += val;
                              _transactions.insert(0, {
                                'title': 'Wallet Top-up via UPI',
                                'date': 'Just Now',
                                'amount': '+ \u20B9${val.toStringAsFixed(2)}',
                                'isCredit': true,
                                'icon': Icons.account_balance_wallet_rounded,
                              });
                            });
                            _amountController.clear();
                            Navigator.of(sheetContext).pop();
                            ScaffoldMessenger.of(rootContext).showSnackBar(
                              SnackBar(
                                content: Text('Added \u20B9${val.toStringAsFixed(2)} to Flash Wallet!'),
                                backgroundColor: const Color(0xFF00A859),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(rootContext).showSnackBar(
                              const SnackBar(
                                content: Text('Please enter a valid amount'),
                                backgroundColor: Colors.orange,
                              ),
                            );
                          }
                        },
                        child: const Text('Proceed to Pay via UPI', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
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
            // బ్యాలెన్స్ కార్డ్
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
                  Text('\u20B9${_balance.toStringAsFixed(2)}', style: const TextStyle(color: Colors.white, fontSize: 34, fontWeight: FontWeight.bold)),
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
                            const SnackBar(content: Text('Offer Applied: Flat \u20B925 cashback on next ride!')),
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
Write-Host "2. Updated WalletScreen with proper Rupee symbols (\u20B9) and reactive chips." -ForegroundColor Green

Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "SUCCESS! Press 'R' in flutter run terminal to refresh." -ForegroundColor Green
Write-Host "==========================================================" -ForegroundColor Cyan