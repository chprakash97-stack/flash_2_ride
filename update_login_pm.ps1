Write-Host "Updating Login Screen with 'WhatsApp Image 2026-09-10 at 1.44.42 PM'..." -ForegroundColor Green

$projectDir = "C:\Users\DELL\Desktop\flash_2_ride"
Set-Location $projectDir

$assetsDir = Join-Path $projectDir "assets\images"
$webDir = Join-Path $projectDir "web"
if (!(Test-Path $assetsDir)) { New-Item -ItemType Directory -Path $assetsDir -Force | Out-Null }
if (!(Test-Path $webDir)) { New-Item -ItemType Directory -Path $webDir -Force | Out-Null }

$destAsset = Join-Path $assetsDir "login.png"
$destWeb = Join-Path $webDir "login.png"

# 1. Search specifically for the 1.44.42 PM WhatsApp Image
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
             Where-Object { $_.Name -like "*1.44.42*" -or $_.Name -like "*1_44_42*" -or ($_.Name -like "*WhatsApp*2026-09-10*1*") } | 
             Sort-Object LastWriteTime -Descending | 
             Select-Object -First 1
        if ($m) {
            $found = $m.FullName
            break
        }
    }
}

if ($found) {
    Write-Host "FOUND 1.44.42 PM IMAGE:" -ForegroundColor Green
    Write-Host $found -ForegroundColor Cyan
    Copy-Item -Path $found -Destination $destAsset -Force
    Copy-Item -Path $found -Destination $destWeb -Force
    Write-Host "Copied to assets/images/login.png and web/login.png successfully!" -ForegroundColor Green
} else {
    Write-Host "File not auto-found. Opening selector to click 'WhatsApp Image 2026-09-10 at 1.44.42 PM'..." -ForegroundColor Yellow
    Add-Type -AssemblyName System.Windows.Forms
    $dialog = New-Object System.Windows.Forms.OpenFileDialog
    $dialog.InitialDirectory = "$env:USERPROFILE\Downloads"
    $dialog.Filter = "Image Files (*.jpeg;*.jpg;*.png)|*.jpeg;*.jpg;*.png"
    $dialog.Title = "Select WhatsApp Image (1.44.42 PM)"
    $form = New-Object System.Windows.Forms.Form
    $form.TopMost = $true
    if ($dialog.ShowDialog($form) -eq [System.Windows.Forms.DialogResult]::OK) {
        Copy-Item -Path $dialog.FileName -Destination $destAsset -Force
        Copy-Item -Path $dialog.FileName -Destination $destWeb -Force
        Write-Host "Selected file linked successfully: $($dialog.FileName)" -ForegroundColor Green
    }
}

# 2. Keep Splash Screen UNTOUCHED, Update ONLY Login Screen Controls
@'
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/app_theme.dart';
import '../../providers/auth_provider.dart';
import 'otp_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _phoneController = TextEditingController(text: '9876543210');
  bool _agreedToTerms = true;

  void _handleLogin() {
    if (!_agreedToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.redAccent,
          content: Text('Please agree to Terms & Conditions and Privacy Policy'),
        ),
      );
      return;
    }

    final phone = _phoneController.text.trim();
    if (phone.length == 10) {
      Provider.of<AuthProvider>(context, listen: false).sendOtp(phone);
      // Navigate smoothly to Screen 3: Verify OTP
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => OtpScreen(phoneNumber: phone)),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.redAccent,
          content: Text('Please enter a valid 10-digit mobile number'),
        ),
      );
    }
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.mainBlue,
      body: Stack(
        children: [
          // 1. Fullscreen Login Image Background
          Positioned.fill(
            child: Image.asset(
              'assets/images/login.png',
              fit: BoxFit.fill,
              width: double.infinity,
              height: double.infinity,
              errorBuilder: (context, error, stackTrace) {
                return Image.network(
                  'login.png',
                  fit: BoxFit.fill,
                  width: double.infinity,
                  height: double.infinity,
                );
              },
            ),
          ),

          // 2. Fully Activated Interactive Controls Layer
          SafeArea(
            child: Column(
              children: [
                const Spacer(flex: 7),

                // Active Mobile Number Input Box (Editable)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withValues(alpha: 0.25), blurRadius: 10, offset: const Offset(0, 4)),
                      ],
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    child: Row(
                      children: [
                        const Icon(Icons.phone_rounded, color: AppTheme.mainBlue, size: 20),
                        const SizedBox(width: 10),
                        const Text(
                          '+91',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                        ),
                        const SizedBox(width: 10),
                        Container(width: 1, height: 22, color: const Color(0xFFCBD5E1)),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            controller: _phoneController,
                            keyboardType: TextInputType.phone,
                            maxLength: 10,
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 1.5, color: Color(0xFF0F172A)),
                            decoration: const InputDecoration(
                              hintText: '9876543210',
                              counterText: '',
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              contentPadding: EdgeInsets.zero,
                              fillColor: Colors.transparent,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 14),

                // Active Checkbox (Clickable)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 24,
                        height: 24,
                        child: Checkbox(
                          value: _agreedToTerms,
                          activeColor: AppTheme.brandYellow,
                          checkColor: Colors.black,
                          side: const BorderSide(color: Colors.white70, width: 1.5),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                          onChanged: (val) => setState(() => _agreedToTerms = val ?? false),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: RichText(
                          text: const TextSpan(
                            style: TextStyle(fontSize: 12, color: Colors.white, height: 1.4),
                            children: [
                              TextSpan(text: 'I agree to the '),
                              TextSpan(text: 'Terms & Conditions', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, decoration: TextDecoration.underline)),
                              TextSpan(text: ' and '),
                              TextSpan(text: 'Privacy Policy', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, decoration: TextDecoration.underline)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Active Login Button (Navigates to OTP Screen!)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.darkBlue,
                        foregroundColor: Colors.white,
                        elevation: 5,
                        shadowColor: Colors.black54,
                        side: const BorderSide(color: Colors.white38, width: 1.2),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      ),
                      onPressed: _handleLogin,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text('Login', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                          SizedBox(width: 8),
                          Icon(Icons.arrow_forward_rounded, size: 20, color: Colors.white),
                        ],
                      ),
                    ),
                  ),
                ),

                const Spacer(flex: 2),

                // Active Sign Up Link (Clickable)
                Padding(
                  padding: const EdgeInsets.only(bottom: 24.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have an account? ", style: TextStyle(color: Colors.white70, fontSize: 13)),
                      GestureDetector(
                        onTap: _handleLogin,
                        child: const Text(
                          'Sign Up',
                          style: TextStyle(color: AppTheme.brandYellow, fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
'@ | Set-Content -Path (Join-Path $projectDir 'lib\screens\auth\login_screen.dart') -Encoding UTF8

flutter pub get
flutter analyze

Write-Host "==============================================================================" -ForegroundColor Green
Write-Host " Login Photo (1.44.42 PM) Updated! Splash Screen Untouched. Press 'R'!        " -ForegroundColor Green
Write-Host "==============================================================================" -ForegroundColor Green