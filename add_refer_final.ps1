# ==========================================================
# Flash2Ride - Final Direct Insertion above Book Ride
# ==========================================================
Write-Host "Inserting Refer and Earn into home_screen.dart..." -ForegroundColor Cyan

$targetFile = "lib\screens\home\home_screen.dart"

if (Test-Path $targetFile) {
    $lines = Get-Content $targetFile
    $targetIdx = -1
    
    for ($i = 0; $i -lt $lines.Length; $i++) {
        if ($lines[$i] -match "Book\s+Ride") {
            $targetIdx = $i
            break
        }
    }
    
    if ($targetIdx -ne -1) {
        # Find the start of ListTile for Book Ride
        $insertIdx = $targetIdx
        for ($j = $targetIdx; $j -ge 0; $j--) {
            if ($lines[$j] -match "ListTile\(") {
                $insertIdx = $j
                break
            }
        }
        
        $tileText = @(
            "            // 🎁 Refer & Earn",
            "            ListTile(",
            "              leading: const Icon(Icons.card_giftcard_rounded, color: AppColors.primary),",
            "              title: const Text('Refer & Earn', style: TextStyle(fontWeight: FontWeight.bold)),",
            "              subtitle: const Text('Get Rs 50 Wallet Bonus', style: TextStyle(fontSize: 12, color: AppColors.primary)),",
            "              trailing: Container(",
            "                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),",
            "                decoration: BoxDecoration(",
            "                  color: AppColors.primaryLight,",
            "                  borderRadius: BorderRadius.circular(12),",
            "                ),",
            "                child: const Text('Rs 50', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 12)),",
            "              ),",
            "              onTap: () {",
            "                Navigator.pop(context);",
            "                Navigator.pushNamed(context, '/refer-earn');",
            "              },",
            "            ),"
        )
        
        # Safe array combination
        $newLines = @()
        if ($insertIdx -gt 0) {
            $newLines += $lines[0..($insertIdx - 1)]
        }
        $newLines += $tileText
        $newLines += $lines[$insertIdx..($lines.Length - 1)]
        
        Set-Content -Path $targetFile -Value $newLines -Encoding UTF8
        Write-Host "[OK] Successfully inserted Refer and Earn directly above Book Ride!" -ForegroundColor Green
    } else {
        Write-Host "[WARNING] Book Ride not found in $targetFile" -ForegroundColor Yellow
    }
}

Write-Host "`nRunning flutter analyze verification..." -ForegroundColor Cyan
flutter analyze