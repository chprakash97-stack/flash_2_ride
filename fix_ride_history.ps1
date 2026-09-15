Write-Host "Opening Ride History Screen in Notepad..." -ForegroundColor Cyan
notepad lib\views\history\ride_history_screen.dart
Write-Host "Please fix line 139 (change const EdgeInsets.top to EdgeInsets.only(top:...) or remove const), save and close Notepad." -ForegroundColor Yellow
Pause
Write-Host "Running flutter analyze..." -ForegroundColor Cyan
flutter analyze
