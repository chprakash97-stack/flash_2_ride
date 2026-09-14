# ==========================================================
# Flash2Ride - 100% Clean Drawer with Dedicated Colors & Navigation
# ==========================================================
Write-Host "Restoring original home_screen.dart from Git..." -ForegroundColor Cyan

$targetFile = "lib\screens\home\home_screen.dart"

# 1. Restore pristine home_screen.dart from Git
git checkout HEAD -- $targetFile
Write-Host "[1/2] Reset home_screen.dart to clean state" -ForegroundColor Green

# 2. Read content
$content = Get-Content $targetFile -Raw

# Ensure import is present
if ($content -notmatch "refer_earn_screen\.dart") {
    $content = "import '../features/refer_earn_screen.dart';`r`n" + $content
}

# Complete, perfectly colored _buildDrawer method
$perfectDrawer = @'
  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const UserAccountsDrawerHeader(
            decoration: BoxDecoration(color: Color(0xFF00A859)),
            accountName: Text('Ramesh Kumar', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            accountEmail: Text('ramesh@gmail.com'),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.person, color: Color(0xFF00A859), size: 40),
            ),
          ),
          // 1. Refer & Earn (Emerald Green)
          ListTile(
            leading: const Icon(Icons.card_giftcard_rounded, color: Color(0xFF10B981)),
            title: const Text('Refer & Earn'),
            subtitle: const Text('Get \u20B950 Wallet Bonus'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ReferEarnScreen()),
              );
            },
          ),
          // 2. Book Ride (Royal Blue)
          ListTile(
            leading: const Icon(Icons.directions_car_rounded, color: Color(0xFF2563EB)),
            title: const Text('Book Ride'),
            onTap: () => Navigator.pop(context),
          ),
          // 3. Ride History (Purple)
          ListTile(
            leading: const Icon(Icons.history_rounded, color: Color(0xFF8B5CF6)),
            title: const Text('Ride History'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/ride-history');
            },
          ),
          // 4. Flash Wallet (Golden Amber)
          ListTile(
            leading: const Icon(Icons.account_balance_wallet_outlined, color: Color(0xFFF59E0B)),
            title: const Text('Flash Wallet'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/wallet');
            },
          ),
          // 5. Power Pass (Subscriptions) (Vibrant Orange)
          ListTile(
            leading: const Icon(Icons.bolt_rounded, color: Color(0xFFFF9800)),
            title: const Text('Power Pass (Subscriptions)'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/power-pass');
            },
          ),
          // 6. Safety Toolkit (Coral Red)
          ListTile(
            leading: const Icon(Icons.shield_outlined, color: Color(0xFFEF4444)),
            title: const Text('Safety Toolkit'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/safety-toolkit');
            },
          ),
          // 7. Settings (Ocean Blue)
          ListTile(
            leading: const Icon(Icons.settings_outlined, color: Color(0xFF0EA5E9)),
            title: const Text('Settings'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/profile-settings');
            },
          ),
          const Divider(),
          // 8. Logout (Red)
          ListTile(
            leading: const Icon(Icons.logout_rounded, color: Color(0xFFDC2626)),
            title: const Text('Logout', style: TextStyle(color: Color(0xFFDC2626))),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
            },
          ),
        ],
      ),
    );
  }
'@

$pattern = "(?s)Widget\s+_buildDrawer\s*\([^\)]*\)\s*\{.+?return\s+Drawer\(.+?\);\s*\}"
$content = [System.Text.RegularExpressions.Regex]::Replace($content, $pattern, [System.Text.RegularExpressions.MatchEvaluator]{ return $perfectDrawer })

Set-Content -Path $targetFile -Value $content -Encoding UTF8
Write-Host "[2/2] Replaced Drawer with clean colored icons & direct navigation" -ForegroundColor Green

Write-Host "`nRunning flutter analyze verification..." -ForegroundColor Cyan
flutter analyze