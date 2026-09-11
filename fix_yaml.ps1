Write-Host "Restoring and fixing pubspec.yaml..." -ForegroundColor Green

# 1. Restore the original working pubspec.yaml from Git
git checkout pubspec.yaml

# 2. Add assets cleanly with exact YAML indentation
$content = Get-Content pubspec.yaml -Raw
$content = $content -replace "uses-material-design: true", "uses-material-design: true`n  assets:`n    - assets/images/"
Set-Content -Path pubspec.yaml -Value $content -Encoding UTF8

# 3. Get dependencies and analyze
Write-Host "Running flutter pub get..." -ForegroundColor Green
flutter pub get

Write-Host "Verifying with flutter analyze..." -ForegroundColor Green
flutter analyze

Write-Host "==============================================================================" -ForegroundColor Green
Write-Host " pubspec.yaml Fixed! Ready to Run!                                            " -ForegroundColor Green
Write-Host "==============================================================================" -ForegroundColor Green