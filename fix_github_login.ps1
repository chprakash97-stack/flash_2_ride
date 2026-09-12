Write-Host "Removing old GitHub saved login (flashtomart-dev1)..." -ForegroundColor Yellow

# Delete cached old credentials from Windows Credential Manager
cmdkey /delete:git:https://github.com 2>$null

Write-Host "Old credentials cleared!" -ForegroundColor Green
Write-Host "Now connecting to GitHub with chprakash97-stack..." -ForegroundColor Cyan
Write-Host "A browser window will pop up. Please click 'Sign in with your browser' and authorize chprakash97-stack!" -ForegroundColor Green

git push -u origin main