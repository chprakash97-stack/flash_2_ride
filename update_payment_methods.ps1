# ==============================================================================
# Flash2Ride - Poster-Accurate Payment Methods Screen Setup
# 1. Creates lib\views\payment\payment_methods_screen.dart
# 2. Registers in lib\core\config\routes.dart
# 3. Connects 'Payment Methods' in Drawer Menu (Three Dots)
# Matching Section 7 Poster Image (UPIs, ramesh@okaxis, Cards, + Add UPI, + Add Card)
# ==============================================================================

Write-Host "1. Creating Poster-Accurate Payment Methods Screen..." -ForegroundColor Cyan

$pmDir = "lib\views\payment"
if (!(Test-Path $pmDir)) {
    New-Item -ItemType Directory -Path $pmDir -Force | Out-Null
}

$pmCode = @'
import 'package:flutter/material.dart';

class PaymentMethodsScreen extends StatefulWidget {
  final dynamic data;
  const PaymentMethodsScreen({super.key, this.data});

  @override
  State<PaymentMethodsScreen> createState() => _PaymentMethodsScreenState();
}

class _PaymentMethodsScreenState extends State<PaymentMethodsScreen> {
  int _selectedMethodIndex = 0;

  final List<Map<String, dynamic>> _upiList = [
    {
      'id': 'ramesh@okaxis',
      'bank': 'Axis Bank UPI',
      'isDefault': true,
    },
  ];

  final List<Map<String, dynamic>> _cardList = [
    {
      'number': '•••• •••• •••• 1234',
      'bank': 'HDFC Bank • Debit Card',
      'expiry': 'Expires 08/28',
      'isDefault': false,
    },
  ];

  void _showAddUpiDialog() {
    final upiController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 20,
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 44,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 18),
            const Text(
              'Add New UPI ID',
              style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: upiController,
              autofocus: true,
              decoration: InputDecoration(
                labelText: 'UPI ID (VPA)',
                hintText: 'e.g. mobile@okhdfcbank or name@paytm',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                prefixIcon: const Icon(Icons.account_balance_wallet_outlined),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'A collect request or ₹1 verification may be initiated.',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  final text = upiController.text.trim();
                  if (text.isNotEmpty && text.contains('@')) {
                    setState(() {
                      _upiList.add({
                        'id': text,
                        'bank': 'Verified UPI ID',
                        'isDefault': false,
                      });
                    });
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('UPI ID $text added successfully!'),
                        backgroundColor: const Color(0xFF10B981),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please enter a valid UPI ID (e.g. name@bank)'),
                        backgroundColor: Color(0xFFEF4444),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2563EB),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Verify & Save UPI', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddCardDialog() {
    final numController = TextEditingController();
    final nameController = TextEditingController();
    final expController = TextEditingController();
    final cvvController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 20,
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 44,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 18),
            const Text(
              'Add Debit / Credit Card',
              style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: numController,
              keyboardType: TextInputType.number,
              maxLength: 16,
              decoration: InputDecoration(
                labelText: 'Card Number',
                hintText: '1234 5678 9012 3456',
                counterText: '',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                prefixIcon: const Icon(Icons.credit_card_rounded),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Cardholder Name',
                hintText: 'e.g. Ramesh Kumar',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                prefixIcon: const Icon(Icons.person_outline_rounded),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: expController,
                    keyboardType: TextInputType.datetime,
                    maxLength: 5,
                    decoration: InputDecoration(
                      labelText: 'Expiry Date',
                      hintText: 'MM/YY',
                      counterText: '',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      prefixIcon: const Icon(Icons.calendar_today_rounded),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: cvvController,
                    keyboardType: TextInputType.number,
                    obscureText: true,
                    maxLength: 3,
                    decoration: InputDecoration(
                      labelText: 'CVV',
                      hintText: '123',
                      counterText: '',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      prefixIcon: const Icon(Icons.lock_outline_rounded),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  final num = numController.text.trim();
                  if (num.length >= 12) {
                    final last4 = num.substring(num.length - 4);
                    setState(() {
                      _cardList.add({
                        'number': '•••• •••• •••• $last4',
                        'bank': 'Added Card • Visa/Master',
                        'expiry': 'Expires ${expController.text}',
                        'isDefault': false,
                      });
                    });
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Card ending in $last4 added successfully!'),
                        backgroundColor: const Color(0xFF10B981),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2563EB),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Save Card', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text(
          'Payment Methods',
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. UPIs Section matching Poster
            const Text(
              'UPIs',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 12),

            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE2E8F0)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.02),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  ...List.generate(_upiList.length, (index) {
                    final item = _upiList[index];

                    return Column(
                      children: [
                        ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                          leading: CircleAvatar(
                            radius: 20,
                            backgroundColor: const Color(0xFF2563EB).withOpacity(0.12),
                            child: const Icon(Icons.account_balance_wallet_rounded, color: Color(0xFF2563EB), size: 20),
                          ),
                          title: Text(
                            item['id'],
                            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                          ),
                          subtitle: Text(
                            item['bank'],
                            style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                          ),
                          trailing: Radio<int>(
                            value: index,
                            groupValue: _selectedMethodIndex,
                            activeColor: const Color(0xFF2563EB),
                            onChanged: (val) => setState(() => _selectedMethodIndex = val!),
                          ),
                          onTap: () => setState(() => _selectedMethodIndex = index),
                        ),
                        if (index < _upiList.length - 1) const Divider(height: 1, indent: 64),
                      ],
                    );
                  }),
                  const Divider(height: 1),
                  // + Add UPI Button Tile
                  ListTile(
                    leading: const CircleAvatar(
                      radius: 20,
                      backgroundColor: Color(0xFFF1F5F9),
                      child: Icon(Icons.add, color: Color(0xFF2563EB), size: 20),
                    ),
                    title: const Text(
                      'Add UPI',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2563EB),
                      ),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Color(0xFF94A3B8)),
                    onTap: _showAddUpiDialog,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // 2. Cards Section matching Poster
            const Text(
              'Cards',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 12),

            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE2E8F0)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.02),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  ...List.generate(_cardList.length, (index) {
                    final item = _cardList[index];
                    final cardValue = index + 10;

                    return Column(
                      children: [
                        ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                          leading: CircleAvatar(
                            radius: 20,
                            backgroundColor: const Color(0xFF6366F1).withOpacity(0.12),
                            child: const Icon(Icons.credit_card_rounded, color: Color(0xFF6366F1), size: 20),
                          ),
                          title: Text(
                            item['number'],
                            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                          ),
                          subtitle: Text(
                            '${item['bank']} • ${item['expiry']}',
                            style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                          ),
                          trailing: Radio<int>(
                            value: cardValue,
                            groupValue: _selectedMethodIndex,
                            activeColor: const Color(0xFF2563EB),
                            onChanged: (val) => setState(() => _selectedMethodIndex = val!),
                          ),
                          onTap: () => setState(() => _selectedMethodIndex = cardValue),
                        ),
                        if (index < _cardList.length - 1) const Divider(height: 1, indent: 64),
                      ],
                    );
                  }),
                  const Divider(height: 1),
                  // + Add Card Button Tile
                  ListTile(
                    leading: const CircleAvatar(
                      radius: 20,
                      backgroundColor: Color(0xFFF1F5F9),
                      child: Icon(Icons.add, color: Color(0xFF2563EB), size: 20),
                    ),
                    title: const Text(
                      'Add Card',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2563EB),
                      ),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Color(0xFF94A3B8)),
                    onTap: _showAddCardDialog,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // 3. Other Payment Options: Flash Wallet & Cash
            const Text(
              'Other Options',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 12),

            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE2E8F0)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.02),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    leading: CircleAvatar(
                      radius: 20,
                      backgroundColor: const Color(0xFF10B981).withOpacity(0.12),
                      child: const Icon(Icons.account_balance_wallet_outlined, color: Color(0xFF10B981), size: 20),
                    ),
                    title: const Text(
                      'Flash Wallet',
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                    ),
                    subtitle: const Text('Available Balance: ₹250.00', style: TextStyle(fontSize: 12, color: Color(0xFF10B981), fontWeight: FontWeight.w600)),
                    trailing: Radio<int>(
                      value: 20,
                      groupValue: _selectedMethodIndex,
                      activeColor: const Color(0xFF2563EB),
                      onChanged: (val) => setState(() => _selectedMethodIndex = val!),
                    ),
                    onTap: () => setState(() => _selectedMethodIndex = 20),
                  ),
                  const Divider(height: 1, indent: 64),
                  ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    leading: CircleAvatar(
                      radius: 20,
                      backgroundColor: const Color(0xFFF59E0B).withOpacity(0.12),
                      child: const Icon(Icons.money_rounded, color: Color(0xFFF59E0B), size: 20),
                    ),
                    title: const Text(
                      'Cash Payment',
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                    ),
                    subtitle: const Text('Pay driver directly in Cash after ride', style: TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                    trailing: Radio<int>(
                      value: 21,
                      groupValue: _selectedMethodIndex,
                      activeColor: const Color(0xFF2563EB),
                      onChanged: (val) => setState(() => _selectedMethodIndex = val!),
                    ),
                    onTap: () => setState(() => _selectedMethodIndex = 21),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // 4. Manage / Save Button matching Poster
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Payment preferences updated successfully!'),
                      backgroundColor: Color(0xFF10B981),
                      behavior: SnackBarBehavior.floating,
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2563EB),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  elevation: 0,
                ),
                child: const Text('Save & Manage', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
'@

[System.IO.File]::WriteAllText("lib\views\payment\payment_methods_screen.dart", $pmCode, [System.Text.Encoding]::UTF8)
Write-Host "[1/3] Payment Methods Screen created at lib\views\payment\payment_methods_screen.dart!" -ForegroundColor Green

Write-Host "`n2. Registering in Routes..." -ForegroundColor Cyan
$routesFile = "lib\\core\\config\\routes.dart"
if (Test-Path $routesFile) {
    $rText = [System.IO.File]::ReadAllText($routesFile, [System.Text.Encoding]::UTF8)
    if ($rText -notmatch "payment_methods_screen\.dart") {
        $rText = "import '../../views/payment/payment_methods_screen.dart';`n" + $rText
    }
    if ($rText -notmatch "paymentMethods = '/payment-methods'") {
        $rText = $rText -replace "(static const String safetyToolkit = '/safety-toolkit';)", "`$1`n  static const String paymentMethods = '/payment-methods';"
    }
    if ($rText -notmatch "case paymentMethods:") {
        $rText = $rText -replace "(case safetyToolkit:\s*return _buildRoute\(settings, SafetyToolkitScreen\(data: args\)\);)", "`$1`n      case paymentMethods:`n        return _buildRoute(settings, PaymentMethodsScreen(data: args));"
    }
    [System.IO.File]::WriteAllText($routesFile, $rText, [System.Text.Encoding]::UTF8)
    Write-Host "[2/3] Route /payment-methods registered in routes.dart!" -ForegroundColor Green
}

Write-Host "`n3. Linking in Drawer Menu..." -ForegroundColor Cyan

$homeFiles = @(
    "lib\\screens\\home\\home_screen.dart",
    "lib\\views\\home\\home_screen.dart"
)

foreach ($hf in $homeFiles) {
    if (Test-Path $hf) {
        $text = [System.IO.File]::ReadAllText($hf, [System.Text.Encoding]::UTF8)
        $modified = $false
        
        # Add import if missing
        if ($text -notmatch "payment_methods_screen\.dart") {
            $importStr = "import '../../views/payment/payment_methods_screen.dart';"
            if ($hf -match "views[\\/]home") {
                $importStr = "import '../payment/payment_methods_screen.dart';"
            }
            $text = "$importStr`n" + $text
            $modified = $true
            Write-Host "  -> Added PaymentMethodsScreen import in $($hf)" -ForegroundColor Yellow
        }
        
        # Check if Payment Methods is already in drawer
        $pmIdx = $text.IndexOf("Payment Methods")
        if ($pmIdx -gt 0) {
            $otIdx = $text.IndexOf("onTap:", $pmIdx)
            if ($otIdx -gt 0 -and ($otIdx - $pmIdx) -lt 300) {
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
                MaterialPageRoute(builder: (context) => const PaymentMethodsScreen()),
              );
            }
"@
                    $text = $text.Substring(0, $otIdx) + $newOnTap + $text.Substring($endPos)
                    $modified = $true
                    Write-Host "  -> Successfully updated Drawer 'Payment Methods' onTap!" -ForegroundColor Green
                }
            }
        } else {
            # Insert Payment Methods tile right after Saved Places or before Settings in _buildDrawer
            $drawerDefIdx = $text.IndexOf("Widget _buildDrawer()")
            if ($drawerDefIdx -gt 0) {
                $insertAnchor = "Saved Places"
                $anchorIdx = $text.IndexOf($insertAnchor, $drawerDefIdx)
                if ($anchorIdx -lt 0) {
                    $insertAnchor = "Settings"
                    $anchorIdx = $text.IndexOf($insertAnchor, $drawerDefIdx)
                }
                
                if ($anchorIdx -gt 0) {
                    $ltStart = $text.LastIndexOf("ListTile(", $anchorIdx)
                    if ($insertAnchor -eq "Saved Places") {
                        # Insert AFTER Saved Places
                        $openP = $text.IndexOf("(", $ltStart)
                        $cnt = 1
                        $closeP = -1
                        for ($i = $openP + 1; $i -lt $text.Length; $i++) {
                            if ($text[$i] -eq '(') { $cnt++ }
                            elseif ($text[$i] -eq ')') {
                                $cnt--
                                if ($cnt -eq 0) {
                                    $closeP = $i
                                    break
                                }
                            }
                        }
                        if ($closeP -gt 0) {
                            $endPos = $closeP + 1
                            if ($endPos -lt $text.Length -and $text[$endPos] -eq ',') { $endPos++ }
                            $pmTile = @"

          // Payment Methods (Royal Blue)
          ListTile(
            leading: const Icon(Icons.payment_rounded, color: Color(0xFF2563EB)),
            title: const Text('Payment Methods'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PaymentMethodsScreen()),
              );
            },
          ),
"@
                            $text = $text.Substring(0, $endPos) + $pmTile + $text.Substring($endPos)
                            $modified = $true
                            Write-Host "  -> Successfully added 'Payment Methods' to Drawer menu!" -ForegroundColor Green
                        }
                    } else {
                        # Insert BEFORE Settings
                        $pmTile = @"
          // Payment Methods (Royal Blue)
          ListTile(
            leading: const Icon(Icons.payment_rounded, color: Color(0xFF2563EB)),
            title: const Text('Payment Methods'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PaymentMethodsScreen()),
              );
            },
          ),
"@
                        $text = $text.Substring(0, $ltStart) + $pmTile + $text.Substring($ltStart)
                        $modified = $true
                        Write-Host "  -> Successfully added 'Payment Methods' to Drawer menu!" -ForegroundColor Green
                    }
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