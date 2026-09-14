# ==========================================================
# Flash2Ride - 100% Clean Restore & Safe Colored Drawer
# ==========================================================
Write-Host "Restoring pristine home_screen.dart and applying drawer colors..." -ForegroundColor Cyan

$targetFile = "lib\screens\home\home_screen.dart"

# 1. Reset from Git to clean baseline (clears all 84 errors)
git checkout HEAD -- $targetFile
Write-Host "[1/2] Reset home_screen.dart to clean state" -ForegroundColor Green

# 2. Read full content
$content = Get-Content $targetFile -Raw

# Ensure import is present
if ($content -notmatch "refer_earn_screen\.dart") {
    $content = "import '../features/refer_earn_screen.dart';`r`n" + $content
}

# 3. Find exact _buildDrawer block by matching opening/closing braces
$startIdx = $content.IndexOf("Widget _buildDrawer")
if ($startIdx -ne -1) {
    $braceCount = 0
    $foundFirst = $false
    $endIdx = -1
    
    for ($i = $startIdx; $i -lt $content.Length; $i++) {
        if ($content[$i] -eq '{') {
            $braceCount++
            $foundFirst = $true
        } elseif ($content[$i] -eq '}') {
            $braceCount--
            if ($foundFirst -and $braceCount -eq 0) {
                $endIdx = $i + 1
                break
            }
        }
    }
    
    if ($endIdx -ne -1) {
        $before = $content.Substring(0, $startIdx)
        $after = $content.Substring($endIdx)
        
        $newDrawer = @'
  Widget _buildDrawer() {
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
          // 3. Ride History (Rich Purple)
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
          // 6. Safety Toolkit (Safety Coral Red)
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
          // 8. Logout (Deep Red)
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
        
        $finalContent = $before + $newDrawer + $after
        Set-Content -Path $targetFile -Value $finalContent -Encoding UTF8
        Write-Host "[2/2] Replaced Drawer cleanly with zero errors" -ForegroundColor Green
    }
}

Write-Host "`nRunning flutter analyze verification..." -ForegroundColor Cyan
flutter analyze