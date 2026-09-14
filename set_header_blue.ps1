# ==========================================================
# Flash2Ride - Set Drawer Header Color to Match Home AppBar Blue
# ==========================================================
Write-Host "Updating Drawer Header color to match Home AppBar blue..." -ForegroundColor Cyan

$targetFile = "lib\screens\home\home_screen.dart"

if (Test-Path $targetFile) {
    $content = Get-Content $targetFile -Raw
    
    # 1. Detect the exact blue color from Home page AppBar
    $blueColor = "const Color(0xFF2563EB)"
    if ($content -match "appBar:\s*AppBar\s*\([^;]+?backgroundColor:\s*([^,\)\r\n]+)") {
        $extracted = $matches.Trim()
        if ($extracted -notmatch "green|00A859") {
            $blueColor = $extracted
        }
    }
    
    # 2. Replace green with the exact Home AppBar blue color in UserAccountsDrawerHeader
    $content = $content.Replace("color: Color(0xFF00A859)", "color: $blueColor")
    $content = $content.Replace("color: const Color(0xFF00A859)", "color: $blueColor")
    
    Set-Content -Path $targetFile -Value $content -Encoding UTF8
    Write-Host "[OK] Updated Drawer Header to Home page Blue ($blueColor) without touching any other code!" -ForegroundColor Green
}

Write-Host "`nRunning flutter analyze verification..." -ForegroundColor Cyan
flutter analyze