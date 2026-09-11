Write-Host "Connecting Local Project to GitHub Repository and Pushing Code..." -ForegroundColor Green

$projectDir = "C:\Users\DELL\Desktop\flash_2_ride"
Set-Location $projectDir

# 1. Ensure .gitignore excludes heavy cache folders (build, .dart_tool, gradle)
$gitignorePath = Join-Path $projectDir ".gitignore"
if (-not (Test-Path $gitignorePath)) {
@'
.dart_tool/
.packages
build/
android/.gradle/
android/app/build/
ios/.symlinks/
*.lock
.flutter-plugins
.flutter-plugins-dependencies
'@ | Set-Content -Path $gitignorePath -Encoding UTF8
    Write-Host "Configured .gitignore successfully." -ForegroundColor Gray
}

# 2. Initialize Git if needed
if (-not (Test-Path (Join-Path $projectDir ".git"))) {
    Write-Host "Initializing Git..." -ForegroundColor Cyan
    git init
}

# Set default branch to main
git branch -M main

# 3. Add clean files
Write-Host "Staging files for commit..." -ForegroundColor Cyan
git add .

# 4. Commit changes
$commitMsg = "Flash2Ride: Initial commit of Auth screens, Home screen with Live Map, and official launcher icons"
Write-Host "Committing project files..." -ForegroundColor Cyan
git commit -m $commitMsg

# 5. Link to your GitHub Repository URL
$repoUrl = "https://github.com/chprakash97-stack/flash_2_ride.git"

# Remove existing origin if any to avoid conflicts
git remote remove origin 2>$null
git remote add origin $repoUrl
Write-Host "Linked to GitHub: $repoUrl" -ForegroundColor Green

# 6. Push to GitHub
Write-Host "Pushing code to GitHub repository (main branch)..." -ForegroundColor Cyan
git push -u origin main

Write-Host "==============================================================================" -ForegroundColor Green
Write-Host " Project Successfully Uploaded to GitHub!                                     " -ForegroundColor Green
Write-Host " Check your repo: https://github.com/chprakash97-stack/flash_2_ride          " -ForegroundColor Green
Write-Host "==============================================================================" -ForegroundColor Green