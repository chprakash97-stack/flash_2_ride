Write-Host "Updating ONLY Screen 5 (Home Screen) with WhatsApp Image (7.54.34 AM)..." -ForegroundColor Green

$projectDir = "C:\Users\DELL\Desktop\flash_2_ride"
Set-Location $projectDir

$assetsDir = Join-Path $projectDir "assets\images"
$webDir = Join-Path $projectDir "web"
if (!(Test-Path $assetsDir)) { New-Item -ItemType Directory -Path $assetsDir -Force | Out-Null }
if (!(Test-Path $webDir)) { New-Item -ItemType Directory -Path $webDir -Force | Out-Null }

$destAsset = Join-Path $assetsDir "home.png"
$destWeb = Join-Path $webDir "home.png"

# 1. Search specifically for the 7.54.34 AM WhatsApp Image
$searchDirs = @(
    "$env:USERPROFILE\Desktop",
    "$env:USERPROFILE\Downloads",
    $projectDir,
    "$env:USERPROFILE\Pictures"
)

$found = $null
foreach ($dir in $searchDirs) {
    if (Test-Path $dir) {
        $m = Get-ChildItem -Path $dir -File -Recurse -Depth 2 -ErrorAction SilentlyContinue | 
             Where-Object { $_.Name -like "*7.54.34*" -or $_.Name -like "*7_54_34*" -or ($_.Name -like "*WhatsApp*2026-09-11*7*") } | 
             Sort-Object LastWriteTime -Descending | 
             Select-Object -First 1
        if ($m) {
            $found = $m.FullName
            break
        }
    }
}

if ($found) {
    Write-Host "FOUND 7.54.34 AM HOME IMAGE:" -ForegroundColor Green
    Write-Host $found -ForegroundColor Cyan
    Copy-Item -Path $found -Destination $destAsset -Force
    Copy-Item -Path $found -Destination $destWeb -Force
    Write-Host "Copied to assets/images/home.png and web/home.png successfully!" -ForegroundColor Green
} else {
    Write-Host "File not auto-found. Opening selector to click 'WhatsApp Image 2026-09-11 at 7.54.34 AM'..." -ForegroundColor Yellow
    Add-Type -AssemblyName System.Windows.Forms
    $dialog = New-Object System.Windows.Forms.OpenFileDialog
    $dialog.InitialDirectory = "$env:USERPROFILE\Downloads"
    $dialog.Filter = "Image Files (*.jpeg;*.jpg;*.png)|*.jpeg;*.jpg;*.png"
    $dialog.Title = "Select WhatsApp Image (7.54.34 AM)"
    $form = New-Object System.Windows.Forms.Form
    $form.TopMost = $true
    if ($dialog.ShowDialog($form) -eq [System.Windows.Forms.DialogResult]::OK) {
        Copy-Item -Path $dialog.FileName -Destination $destAsset -Force
        Copy-Item -Path $dialog.FileName -Destination $destWeb -Force
        Write-Host "Selected file linked successfully: $($dialog.FileName)" -ForegroundColor Green
    }
}

# 2. Update ONLY lib/screens/home/home_screen.dart (Screens 1 to 4 are 100% UNTOUCHED!)
@'
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SizedBox.expand(
        child: Image.asset(
          'assets/images/home.png',
          fit: BoxFit.fill,
          width: double.infinity,
          height: double.infinity,
          errorBuilder: (context, error, stackTrace) {
            return Image.network(
              'home.png',
              fit: BoxFit.fill,
              width: double.infinity,
              height: double.infinity,
            );
          },
        ),
      ),
    );
  }
}
'@ | Set-Content -Path (Join-Path $projectDir 'lib\screens\home\home_screen.dart') -Encoding UTF8

flutter pub get
flutter analyze

Write-Host "==============================================================================" -ForegroundColor Green
Write-Host " Home Screen Image Updated! Screens 1 to 4 Untouched. Press 'R' or Ctrl+R!    " -ForegroundColor Green
Write-Host "==============================================================================" -ForegroundColor Green