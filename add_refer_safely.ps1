# ==========================================================
# Flash2Ride - Safe Insert: Refer and Earn strictly above Booking Rides
# ==========================================================
Write-Host "Safely inserting Refer and Earn above Booking Rides..." -ForegroundColor Cyan

$targetFiles = @(
    "lib\screens\home\customer_home_screen.dart",
    "lib\screens\home\home_screen.dart",
    "lib\views\home\home_screen.dart"
)

foreach ($file in $targetFiles) {
    if (Test-Path $file) {
        $lines = [System.Collections.Generic.List[string]](Get-Content $file)
        $contentStr = [string]::Join("`n", $lines)
        
        # Check if already present
        if ($contentStr -notmatch "Refer & Earn") {
            # Find the line with Booking Rides
            $bookingLineIdx = -1
            for ($i = 0; $i -lt $lines.Count; $i++) {
                if ($lines[$i] -match "Booking Rides|booking_rides|rideSelection") {
                    $bookingLineIdx = $i
                    break
                }
            }
            
            if ($bookingLineIdx -ne -1) {
                # Find start of that ListTile
                $insertIdx = $bookingLineIdx
                for ($j = $bookingLineIdx; $j -ge 0; $j--) {
                    if ($lines[$j] -match "ListTile\(") {
                        $insertIdx = $j
                        break
                    }
                }
                
                # Create safety backup
                Copy-Item $file "$file.bak" -Force
                
                # ListTile lines to insert
                $tileLines = @(
                    "            // Refer and Earn",
                    "            ListTile(",
                    "              leading: const Icon(Icons.card_giftcard_rounded, color: AppColors.primary),",
                    "              title: const Text('Refer & Earn', style: TextStyle(fontWeight: FontWeight.bold)),",
                    "              subtitle: const Text('Get Rs 50 Wallet Bonus'),",
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
                
                # Insert strictly above Booking Rides ListTile
                $lines.InsertRange($insertIdx, $tileLines)
                Set-Content -Path $file -Value $lines -Encoding UTF8
                Write-Host "[OK] Inserted Refer and Earn directly above Booking Rides in $file" -ForegroundColor Green
                Write-Host "     Settings, Logout, and all other buttons remain untouched." -ForegroundColor Yellow
            }
        } else {
            Write-Host "[OK] Refer and Earn already exists in $file" -ForegroundColor Green
        }
    }
}

Write-Host "`nRunning flutter analyze verification..." -ForegroundColor Cyan
flutter analyze