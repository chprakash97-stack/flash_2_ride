# ==========================================================
# Flash2Ride - Set Unique Attractive Colors for Each Drawer Item
# ==========================================================
Write-Host "Applying unique colors to all drawer menu items..." -ForegroundColor Cyan

$targetFile = "lib\screens\home\home_screen.dart"

if (Test-Path $targetFile) {
    $lines = [System.Collections.Generic.List[string]](Get-Content $targetFile)
    
    # Beautiful unique color for each item
    $colorMap = @{
        "Ride History"   = "Color(0xFF8B5CF6)";  # Purple
        "Flash Wallet"   = "Color(0xFFF59E0B)";  # Amber Gold
        "Power Pass"     = "Color(0xFFFF9800)";  # Electric Orange
        "Safety Toolkit" = "Color(0xFFEF4444)";  # Safety Coral Red
        "Settings"       = "Color(0xFF0EA5E9)";  # Ocean Cyan
        "Book Ride"      = "Color(0xFF2563EB)";  # Royal Blue
        "Refer & Earn"   = "Color(0xFF10B981)"   # Emerald Green
    }
    
    for ($i = 0; $i -lt $lines.Count; $i++) {
        # Fix Rupee symbol encoding in Refer & Earn subtitle
        if ($lines[$i] -match "Wallet\s+Bonus") {
            $lines[$i] = "              subtitle: const Text('Get \u20B950 Wallet Bonus'),"
        }
        
        # Match each drawer item title
        foreach ($title in $colorMap.Keys) {
            if ($lines[$i] -match "['""]$title") {
                # Look backwards up to 6 lines for leading icon
                for ($j = $i; $j -ge [Math]::Max(0, $i - 6); $j--) {
                    if ($lines[$j] -match "leading:") {
                        $col = $colorMap[$title]
                        $l = $lines[$j]
                        if ($l -match "color:") {
                            $lines[$j] = $l -replace "color:\s*[^,\)]+", "color: $col"
                        } else {
                            $lines[$j] = $l -replace "(Icon\([^\)]+)", "`$1, color: $col"
                        }
                        $lines[$j] = $lines[$j] -replace "const\s+Icon\(", "Icon("
                        break
                    }
                }
            }
        }
    }
    
    Set-Content -Path $targetFile -Value $lines -Encoding UTF8
    Write-Host "[OK] Successfully set distinct colors for all drawer options in $targetFile" -ForegroundColor Green
}

Write-Host "`nRunning flutter analyze verification..." -ForegroundColor Cyan
flutter analyze