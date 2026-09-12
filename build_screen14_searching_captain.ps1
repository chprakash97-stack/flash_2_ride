Write-Host "Building Screen 14: Searching Partner Screen..." -ForegroundColor Green

$code = @'
import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/config/routes.dart';

class FindingDriverScreen extends StatefulWidget {
  final dynamic data;
  const FindingDriverScreen({super.key, this.data});

  @override
  State<FindingDriverScreen> createState() => _FindingDriverScreenState();
}

class _FindingDriverScreenState extends State<FindingDriverScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Searching Partner',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        backgroundColor: AppColors.primary,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: const BoxDecoration(
                        color: AppColors.primaryLight,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.flash_on_rounded,
                        color: AppColors.primary,
                        size: 40,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Searching Partner',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Connecting to nearby Flash 2 Partner...',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Status & Activity',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 12),
                    ListTile(
                      leading: Icon(Icons.location_on, color: AppColors.primary),
                      title: Text('Nellore Service Zone'),
                      subtitle: Text('Looking for nearby Partners'),
                      dense: true,
                    ),
                    Divider(),
                    ListTile(
                      leading: Icon(Icons.verified, color: AppColors.success),
                      title: Text('Operational'),
                      subtitle: Text('Flash 2 Partner Connected'),
                      dense: true,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
'@

# lib/screens/ride ఫోల్డర్ లో అప్‌డేట్ చేస్తుంది
$screenDir = "$PWD\lib\screens\ride"
if (!(Test-Path $screenDir)) { New-Item -ItemType Directory -Path $screenDir -Force | Out-Null }
$filePath1 = "$screenDir\finding_driver_screen.dart"
[System.IO.File]::WriteAllText($filePath1, $code, [System.Text.Encoding]::UTF8)

# ఒకవేళ ప్రాజెక్ట్ లో lib/views/ride ఉంటే అందులో కూడా అప్‌డేట్ చేస్తుంది
$viewDir = "$PWD\lib\views\ride"
if (Test-Path "$PWD\lib\views") {
    if (!(Test-Path $viewDir)) { New-Item -ItemType Directory -Path $viewDir -Force | Out-Null }
    $filePath2 = "$viewDir\finding_driver_screen.dart"
    [System.IO.File]::WriteAllText($filePath2, $code, [System.Text.Encoding]::UTF8)
}

Write-Host "Screen 14: Searching Partner Screen successfully updated!" -ForegroundColor Cyan