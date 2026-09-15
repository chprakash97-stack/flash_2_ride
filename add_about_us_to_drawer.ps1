# ==============================================================================
# Flash2Ride - Add 'About Us' directly into Side Drawer Menu
# Places 'About Us' right between 'Settings' and 'Logout'
# ==============================================================================

Write-Host "Adding 'About Us' option to the Home Screen Drawer..." -ForegroundColor Cyan

$homeFiles = @(
    "lib\screens\home\home_screen.dart",
    "lib\views\home\home_screen.dart"
)

$aboutTileCode = @'
            ListTile(
              leading: const Icon(Icons.info_outline_rounded, color: Color(0xFF2563EB)),
              title: const Text('About Us', style: TextStyle(fontWeight: FontWeight.w600)),
              subtitle: const Text('Version 1.0.0 & Legal Policy', style: TextStyle(fontSize: 11, color: Color(0xFF64748B))),
              trailing: const Icon(Icons.chevron_right, size: 20, color: Color(0xFF94A3B8)),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AboutUsScreen()),
                );
              },
            ),
'@

foreach ($hf in $homeFiles) {
    if (Test-Path $hf) {
        $text = [System.IO.File]::ReadAllText($hf, [System.Text.Encoding]::UTF8)
        $modified = $false
        
        # 1. Add Import if missing
        if ($text -notmatch "about_us_screen\.dart") {
            $text = "import '../../views/profile/about_us_screen.dart';`n" + $text
            $modified = $true
        }
        
        # 2. Insert About Us ListTile before Logout
        if ($text -notmatch "About Us") {
            $logoutIdx = $text.IndexOf("Logout")
            if ($logoutIdx -gt 0) {
                # Find the start of the Logout ListTile
                $tileStart = $text.LastIndexOf("ListTile", $logoutIdx)
                if ($tileStart -gt 0) {
                    $text = $text.Substring(0, $tileStart) + $aboutTileCode + "`n            " + $text.Substring($tileStart)
                    $modified = $true
                    Write-Host "  -> Successfully inserted 'About Us' into Drawer in $($hf)!" -ForegroundColor Green
                }
            }
        } else {
            Write-Host "  -> 'About Us' already exists in $($hf)" -ForegroundColor Yellow
        }
        
        if ($modified) {
            [System.IO.File]::WriteAllText($hf, $text, [System.Text.Encoding]::UTF8)
        }
    }
}

Write-Host "`nRunning flutter analyze verification..." -ForegroundColor Cyan
flutter analyze