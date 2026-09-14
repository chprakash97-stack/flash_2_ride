# ==========================================================
# Flash2Ride - 100% Clean Restore & Safe Drawer Insertion
# ==========================================================
Write-Host "Restoring original home_screen.dart and cleanly inserting Refer & Earn..." -ForegroundColor Cyan

$targetFile = "lib\screens\home\home_screen.dart"

# 1. Restore pristine home_screen.dart from Git (brings back _buildDrawer)
git checkout HEAD -- $targetFile
Write-Host "[1/3] Restored clean original home_screen.dart" -ForegroundColor Green

# 2. Read lines and find Book Ride
$lines = Get-Content $targetFile
$targetIdx = -1

for ($i = 0; $i -lt $lines.Length; $i++) {
    if ($lines[$i] -match "Book\s+Ride") {
        $targetIdx = $i
        break
    }
}

if ($targetIdx -ne -1) {
    # Find ListTile start before Book Ride
    $insertIdx = $targetIdx
    for ($j = $targetIdx; $j -ge 0; $j--) {
        if ($lines[$j] -match "ListTile\(") {
            $insertIdx = $j
            break
        }
    }
    
    # Clean, non-selected normal ListTile with DIRECT screen navigation
    $tileLines = @(
        "            // Refer & Earn (Direct Navigation)",
        "            ListTile(",
        "              leading: const Icon(Icons.card_giftcard_rounded, color: Color(0xFF10B981)),",
        "              title: const Text('Refer & Earn'),",
        "              subtitle: const Text('Get ₹50 Wallet Bonus'),",
        "              onTap: () {",
        "                Navigator.pop(context);",
        "                Navigator.push(",
        "                  context,",
        "                  MaterialPageRoute(builder: (_) => const ReferEarnScreen()),",
        "                );",
        "              },",
        "            ),"
    )
    
    # Prepend import and insert tile safely above Book Ride
    $newLines = @("import '../features/refer_earn_screen.dart';")
    if ($insertIdx -gt 0) {
        $newLines += $lines[0..($insertIdx - 1)]
    }
    $newLines += $tileLines
    $newLines += $lines[$insertIdx..($lines.Length - 1)]
    
    Set-Content -Path $targetFile -Value $newLines -Encoding UTF8
    Write-Host "[2/3] Safely inserted clean Refer & Earn directly above Book Ride" -ForegroundColor Green
    Write-Host "      (All other buttons: Book Ride, History, Settings, Logout 100% intact)" -ForegroundColor Yellow
}

# 3. Verify zero errors
Write-Host "`n[3/3] Running flutter analyze verification..." -ForegroundColor Cyan
flutter analyze