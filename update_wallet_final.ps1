# ==============================================================================
# Flash2Ride - Poster-Accurate Flash Wallet Setup & Integration
# 1. Creates lib\views\wallet\wallet_screen.dart matching Section 6 Poster Image
# 2. Connects 'Wallet' (index 2) on Bottom Navigation Bar
# 3. Connects 'Flash Wallet' inside Drawer (Three Dots menu)
# All search bars, location pills, and ride flows remain 100% UNTOUCHED!
# ==============================================================================

Write-Host "1. Creating Poster-Accurate Flash Wallet Screen..." -ForegroundColor Cyan

$walletDir = "lib\views\wallet"
if (!(Test-Path $walletDir)) {
    New-Item -ItemType Directory -Path $walletDir -Force | Out-Null
}

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

  final List<Map<String, dynamic>> _transactions = [
    {
      'title': 'Ride Payment',
      'date': '25 Aug, 10:15 AM',
      'amount': '- ₹145',
      'isCredit': false,
      'icon': Icons.directions_car_rounded,
      'color': const Color(0xFFEF4444),
    },
    {
      'title': 'Cashback',
      'date': '25 Aug, 04:22 PM',
      'amount': '+ ₹50',
      'isCredit': true,
      'icon': Icons.card_giftcard_rounded,
      'color': const Color(0xFF10B981),
    },
    {
      'title': 'UPI Add',
      'date': '20 Aug, 11:30 AM',
      'amount': '+ ₹250',
      'isCredit': true,
      'icon': Icons.account_balance_wallet_rounded,
      'color': const Color(0xFF2563EB),
    },
  ];

  void _addMoney(double amount) {
    setState(() {
      _balance += amount;
      _transactions.insert(0, {
        'title': 'UPI Top-up',
        'date': 'Just now',
        'amount': '+ ₹${amount.toStringAsFixed(0)}',
        'isCredit': true,
        'icon': Icons.add_circle_outline_rounded,
        'color': const Color(0xFF10B981),
      });
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('₹${amount.toStringAsFixed(0)} added to Flash Wallet successfully!'),
        backgroundColor: const Color(0xFF10B981),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: Column(
        children: [
          // 1. Poster-Accurate Solid Blue Curved Header (Section 6)
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF1E5BEE), Color(0xFF2563EB)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
              boxShadow: [
                BoxShadow(
                  color: Color(0x332563EB),
                  blurRadius: 12,
                  offset: Offset(0, 6),
                ),
              ],
            ),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                child: Column(
                  children: [
                    // Top Navigation Row
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back, color: Colors.white),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Flash Wallet',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Wallet Balance Label
                    const Text(
                      'Wallet Balance',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.3,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Large Bold Balance Amount
                    Text(
                      '₹${_balance.toStringAsFixed(2)}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Quick Top-up Chips (+100, +250, +500)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildQuickAddChip(100),
                        const SizedBox(width: 12),
                        _buildQuickAddChip(250),
                        const SizedBox(width: 12),
                        _buildQuickAddChip(500),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          // 2. Recent Transactions Section
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title + View All Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Recent Transactions',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1F2937),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Showing all past wallet transactions'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: const Size(50, 30),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: const Text(
                          'View All',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF2563EB),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Transactions Card List
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFE5E7EB)),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x08000000),
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      itemCount: _transactions.length,
                      separatorBuilder: (context, index) => const Divider(
                        height: 1,
                        indent: 68,
                        endIndent: 16,
                        color: Color(0xFFF3F4F6),
                      ),
                      itemBuilder: (context, index) {
                        final tx = _transactions[index];
                        final isCredit = tx['isCredit'] as bool;
                        final Color txColor = tx['color'] as Color;

                        return ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                          leading: CircleAvatar(
                            radius: 22,
                            backgroundColor: txColor.withOpacity(0.12),
                            child: Icon(
                              tx['icon'] as IconData,
                              color: txColor,
                              size: 22,
                            ),
                          ),
                          title: Text(
                            tx['title'] as String,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF1F2937),
                            ),
                          ),
                          subtitle: Text(
                            tx['date'] as String,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF6B7280),
                            ),
                          ),
                          trailing: Text(
                            tx['amount'] as String,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: isCredit ? const Color(0xFF10B981) : const Color(0xFFEF4444),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickAddChip(double amount) {
    return InkWell(
      onTap: () => _addMoney(amount),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withOpacity(0.4), width: 1),
        ),
        child: Text(
          '+ ₹${amount.toStringAsFixed(0)}',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
'@

[System.IO.File]::WriteAllText("lib\views\wallet\wallet_screen.dart", $walletCode, [System.Text.Encoding]::UTF8)
Write-Host "[1/3] Flash Wallet Screen created at lib\views\wallet\wallet_screen.dart!" -ForegroundColor Green

Write-Host "`n2. Updating Home Screen navigation..." -ForegroundColor Cyan

$homeFile = "lib\screens\home\home_screen.dart"
if (!(Test-Path $homeFile)) {
    $homeFile = "lib\views\home\home_screen.dart"
}

if (Test-Path $homeFile) {
    $text = [System.IO.File]::ReadAllText($homeFile, [System.Text.Encoding]::UTF8)
    
    # 2.1 Ensure WalletScreen import
    if ($text -notmatch "wallet_screen\.dart") {
        $text = "import '../../views/wallet/wallet_screen.dart';`n" + $text
        Write-Host "  -> Added WalletScreen import" -ForegroundColor Yellow
    }
    
    # 2.2 Update Bottom Navigation Bar (ONLY inside Widget _buildBottomNavigationBar)
    $bnbDefIdx = $text.IndexOf("Widget _buildBottomNavigationBar()")
    if ($bnbDefIdx -gt 0) {
        $onTapIdx = $text.IndexOf("onTap:", $bnbDefIdx)
        if ($onTapIdx -gt 0) {
            $semiOrComma = $text.IndexOf(",", $onTapIdx)
            $newBnbOnTap = @"
onTap: (index) {
          setState(() => _currentNavIndex = index);
          if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const WalletScreen()),
            ).then((_) {
              if (mounted) setState(() => _currentNavIndex = 0);
            });
          }
        }
"@
            $text = $text.Substring(0, $onTapIdx) + $newBnbOnTap + $text.Substring($semiOrComma)
            Write-Host "  -> Successfully linked Bottom Bar 'Wallet' (index 2) to Flash Wallet!" -ForegroundColor Green
        }
    }
    
    # 2.3 Update Drawer 'Flash Wallet' (ONLY inside Widget _buildDrawer)
    $drawerDefIdx = $text.IndexOf("Widget _buildDrawer()")
    if ($drawerDefIdx -gt 0) {
        $walletTileCode = @"

          // 4. Flash Wallet (Golden Amber)
          ListTile(
            leading: const Icon(Icons.account_balance_wallet_rounded, color: Color(0xFFF59E0B)),
            title: const Text('Flash Wallet'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const WalletScreen()),
              );
            },
          ),
"@
        if ($text.IndexOf("Flash Wallet", $drawerDefIdx) -gt 0) {
            $fwIdx = $text.IndexOf("Flash Wallet", $drawerDefIdx)
            $fwOtIdx = $text.IndexOf("onTap:", $fwIdx)
            if ($fwOtIdx -gt 0) {
                $cbIdx = $text.IndexOf("},", $fwOtIdx)
                if ($cbIdx -gt 0) {
                    $newDrawerOnTap = @"
onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const WalletScreen()),
              );
            }
"@
                    $text = $text.Substring(0, $fwOtIdx) + $newDrawerOnTap + $text.Substring($cbIdx + 1)
                    Write-Host "  -> Successfully updated Drawer 'Flash Wallet' onTap!" -ForegroundColor Green
                }
            }
        } else {
            $rhIdx = $text.IndexOf("Ride History", $drawerDefIdx)
            if ($rhIdx -lt 0) { $rhIdx = $text.IndexOf("Refer & Earn", $drawerDefIdx) }
            if ($rhIdx -gt 0) {
                $ltStart = $text.LastIndexOf("ListTile(", $rhIdx)
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
                    $text = $text.Substring(0, $endPos) + $walletTileCode + $text.Substring($endPos)
                    Write-Host "  -> Successfully added 'Flash Wallet' to Drawer menu!" -ForegroundColor Green
                }
            }
        }
    }
    
    [System.IO.File]::WriteAllText($homeFile, $text, [System.Text.Encoding]::UTF8)
    Write-Host "[2/3] Home Screen navigation updated successfully!" -ForegroundColor Green
} else {
    Write-Host "[WARNING] Home screen file not found!" -ForegroundColor Red
}

Write-Host "`n3. Running flutter analyze verification..." -ForegroundColor Cyan
flutter analyze