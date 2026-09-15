# ==============================================================================
# Flash2Ride - Link Profile Tab on Bottom Bar (Index 3) & Fix Import
# ==============================================================================

# 1. Fix profile_screen.dart import
$psFile = "lib\views\profile\profile_screen.dart"
if (Test-Path $psFile) {
    $psText = [System.IO.File]::ReadAllText($psFile, [System.Text.Encoding]::UTF8)
    if ($psText.Contains("import '../home/saved_places_screen.dart';")) {
        $psText = $psText.Replace("import '../home/saved_places_screen.dart';", "import 'saved_places_screen.dart';")
        [System.IO.File]::WriteAllText($psFile, $psText, [System.Text.Encoding]::UTF8)
        Write-Host "1. Fixed import in profile_screen.dart!" -ForegroundColor Green
    }
}

# 2. Link Bottom Bar Profile Tab (Index 3) in Home Screen
$homeFiles = @(
    "lib\screens\home\home_screen.dart",
    "lib\views\home\home_screen.dart"
)

foreach ($hf in $homeFiles) {
    if (Test-Path $hf) {
        $text = [System.IO.File]::ReadAllText($hf, [System.Text.Encoding]::UTF8)
        
        # Ensure import is present
        if ($text -notmatch "user_profile_screen\.dart" -and $text -notmatch "profile_screen\.dart") {
            $text = "import '../../screens/profile/user_profile_screen.dart';`n" + $text
        }
        
        # In BottomNavigationBar onTap, link index 3 (Profile)
        if ($text.Contains('if (index == 2) {') -and !$text.Contains('if (index == 3) {')) {
            $target = 'if (index == 2) {'
            $replacement = @"
if (index == 3) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const UserProfileScreen()),
            ).then((_) {
              if (mounted) setState(() => _currentNavIndex = 0);
            });
          }
          if (index == 2) {
"@
            $text = $text.Replace($target, $replacement)
            [System.IO.File]::WriteAllText($hf, $text, [System.Text.Encoding]::UTF8)
            Write-Host "2. Successfully linked Bottom Bar 'Profile' (index 3) to UserProfileScreen in $hf!" -ForegroundColor Green
        }
    }
}

Write-Host "`n3. Running flutter analyze..." -ForegroundColor Cyan
flutter analyze