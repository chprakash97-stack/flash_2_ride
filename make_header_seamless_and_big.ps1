Write-Host "Creating 100% Seamless Transparent & Big Prominent Flash2Ride Logo Header..." -ForegroundColor Green

$projectDir = "C:\Users\DELL\Desktop\flash_2_ride"
Set-Location $projectDir

$assetsDir = Join-Path $projectDir "assets\images"
$webDir = Join-Path $projectDir "web"

Add-Type -AssemblyName System.Drawing
Add-Type -AssemblyName System.Windows.Forms

# 1. Search for user's uploaded banner image
$searchDirs = @(
    "$env:USERPROFILE\Downloads",
    "$env:USERPROFILE\Desktop",
    $projectDir,
    "$env:USERPROFILE\Pictures"
)

$found = $null
$recent = Get-ChildItem -Path $searchDirs -File -Recurse -Depth 2 -ErrorAction SilentlyContinue | 
          Where-Object { ($_.Extension -match "\.(png|jpg|jpeg|webp)$") -and $_.Name -notmatch "splash|login|test" -and $_.LastWriteTime -gt (Get-Date).AddHours(-6) } | 
          Sort-Object LastWriteTime -Descending

foreach ($f in $recent) {
    try {
        $img = [System.Drawing.Image]::FromFile($f.FullName)
        $ratio = $img.Width / $img.Height
        $img.Dispose()
        if ($ratio -gt 2.0) {
            $found = $f.FullName
            break
        }
    } catch {}
}

if (-not $found) {
    $dialog = New-Object System.Windows.Forms.OpenFileDialog
    $dialog.InitialDirectory = "$env:USERPROFILE\Downloads"
    $dialog.Filter = "Image Files (*.png;*.jpeg;*.jpg)|*.png;*.jpeg;*.jpg"
    $dialog.Title = "Select Header Image (image_a25547)"
    $form = New-Object System.Windows.Forms.Form
    $form.TopMost = $true
    if ($dialog.ShowDialog($form) -eq [System.Windows.Forms.DialogResult]::OK) {
        $found = $dialog.FileName
    }
}

if ($found) {
    Write-Host "Processing Banner: $found" -ForegroundColor Cyan
    $src = [System.Drawing.Bitmap]::FromFile($found)
    $w = $src.Width
    $h = $src.Height

    # Sample exact background blue from top-left
    $bgP = $src.GetPixel(4, 4)
    $bgR = $bgP.R
    $bgG = $bgP.G
    $bgB = $bgP.B

    # Find tight bounding box of center logo (excluding left menu and right bell)
    $minX = $w
    $maxX = 0
    $minY = $h
    $maxY = 0

    for ($y = 0; $y -lt $h; $y++) {
        for ($x = [int]($w * 0.16); $x -lt [int]($w * 0.84); $x++) {
            $p = $src.GetPixel($x, $y)
            $diff = [Math]::Abs($p.R - $bgR) + [Math]::Abs($p.G - $bgG) + [Math]::Abs($p.B - $bgB)
            if ($diff -gt 38) {
                if ($x -lt $minX) { $minX = $x }
                if ($x -gt $maxX) { $maxX = $x }
                if ($y -lt $minY) { $minY = $y }
                if ($y -gt $maxY) { $maxY = $y }
            }
        }
    }

    # Add 4px breathing padding
    $pad = 4
    $cropX = [Math]::Max(0, $minX - $pad)
    $cropY = [Math]::Max(0, $minY - $pad)
    $cropW = [Math]::Min($w - $cropX, ($maxX - $minX) + ($pad * 2))
    $cropH = [Math]::Min($h - $cropY, ($maxY - $minY) + ($pad * 2))

    # Create 32-bit transparent ARGB bitmap
    $cropped = New-Object System.Drawing.Bitmap($cropW, $cropH, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)

    # Convert all background blue to 100% TRANSPARENT
    for ($cy = 0; $cy -lt $cropH; $cy++) {
        for ($cx = 0; $cx -lt $cropW; $cx++) {
            $p = $src.GetPixel($cropX + $cx, $cropY + $cy)
            $diff = [Math]::Abs($p.R - $bgR) + [Math]::Abs($p.G - $bgG) + [Math]::Abs($p.B - $bgB)
            if ($diff -lt 45) {
                $cropped.SetPixel($cx, $cy, [System.Drawing.Color]::FromArgb(0, 0, 0, 0))
            } else {
                $cropped.SetPixel($cx, $cy, $p)
            }
        }
    }

    $destLogoAsset = Join-Path $assetsDir "logo_center.png"
    $destLogoWeb = Join-Path $webDir "logo_center.png"

    $cropped.Save($destLogoAsset, [System.Drawing.Imaging.ImageFormat]::Png)
    $cropped.Save($destLogoWeb, [System.Drawing.Imaging.ImageFormat]::Png)

    $src.Dispose()
    $cropped.Dispose()
    Write-Host "Logo converted to Transparent PNG & Tight-cropped successfully!" -ForegroundColor Green
}

# 2. Update ONLY lib/screens/home/home_screen.dart (Screens 1 to 4 are 100% UNTOUCHED!)
@'
import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentNavIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: _buildDrawer(),
      body: Stack(
        children: [
          // -------------------------------------------------------------
          // LAYER 1: Map Background (Google Map / Placeholder Container)
          // -------------------------------------------------------------
          Positioned.fill(
            child: _buildMapBackground(),
          ),

          // -------------------------------------------------------------
          // LAYER 2: 100% Seamless Official Header (Native Menu/Bell + Big Logo)
          // -------------------------------------------------------------
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: _buildTopHeader(),
          ),

          // -------------------------------------------------------------
          // LAYER 3: Content Placeholder Area at Bottom
          // -------------------------------------------------------------
          Positioned(
            left: 16,
            right: 16,
            bottom: 16,
            child: _buildContentPlaceholder(),
          ),
        ],
      ),

      // -------------------------------------------------------------
      // LAYER 4: Bottom Navigation Bar
      // -------------------------------------------------------------
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  // Official, Seamless, Big Logo Top Header
  Widget _buildTopHeader() {
    // Official vibrant Royal Blue matching the brand
    const Color brandRoyalBlue = Color(0xFF0058FF);

    return Container(
      width: double.infinity,
      color: brandRoyalBlue,
      child: SafeArea(
        bottom: false,
        child: Container(
          height: 72, // Generous height for prominent, bold logo
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 1. Left: Flutter Native Hamburger Menu (☰)
              Builder(
                builder: (ctx) => IconButton(
                  icon: const Icon(Icons.menu_rounded, color: Colors.white, size: 32),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: () => Scaffold.of(ctx).openDrawer(),
                ),
              ),

              // 2. Center: Prominent, Big, 100% Seamless Flash2Ride Logo with Eagle
              Expanded(
                child: Center(
                  child: Image.asset(
                    'assets/images/logo_center.png',
                    height: 58, // Prominent, big, filling middle space
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Image.network(
                        'logo_center.png',
                        height: 58,
                        fit: BoxFit.contain,
                        errorBuilder: (ctx, err, st) => const Text(
                          'Flash2Ride',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),

              // 3. Right: Flutter Native Notification Bell (🔔)
              IconButton(
                icon: const Icon(Icons.notifications_none_rounded, color: Colors.white, size: 28),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Notifications: No new alerts')),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Map Background Widget
  Widget _buildMapBackground() {
    return Container(
      color: const Color(0xFFE8EEF5),
      child: Stack(
        children: [
          const CustomPaint(
            size: Size.infinite,
            painter: _MapGridPainter(),
          ),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppTheme.mainBlue.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.location_on_rounded,
                    color: AppTheme.mainBlue,
                    size: 32,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Text(
                    'Nellore, AP',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Content Placeholder Card
  Widget _buildContentPlaceholder() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: const [
          Text(
            'Official Seamless Header Active',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0F172A),
            ),
          ),
          SizedBox(height: 4),
          Text(
            'Big prominent logo is seamlessly blended with zero boxes. Next: Add "Where to?" Destination Card & Vehicle Options.',
            style: TextStyle(fontSize: 13, color: Color(0xFF64748B), height: 1.4),
          ),
        ],
      ),
    );
  }

  // Standard Bottom Navigation Bar
  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: _currentNavIndex,
        onTap: (index) => setState(() => _currentNavIndex = index),
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: AppTheme.mainBlue,
        unselectedItemColor: const Color(0xFF94A3B8),
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 11),
        elevation: 0,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.history_rounded), label: 'History'),
          BottomNavigationBarItem(icon: Icon(Icons.account_balance_wallet_rounded), label: 'Wallet'),
          BottomNavigationBarItem(icon: Icon(Icons.person_rounded), label: 'Profile'),
        ],
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(color: AppTheme.mainBlue),
            currentAccountPicture: const CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.person, size: 40, color: AppTheme.mainBlue),
            ),
            accountName: const Text('Ramesh Kumar', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
            accountEmail: const Text('ramesh@gmail.com', style: TextStyle(color: Colors.white70)),
          ),
          ListTile(leading: const Icon(Icons.local_taxi_rounded, color: AppTheme.mainBlue), title: const Text('Book Ride'), onTap: () => Navigator.pop(context)),
          ListTile(leading: const Icon(Icons.history_rounded), title: const Text('Ride History'), onTap: () => Navigator.pop(context)),
          ListTile(leading: const Icon(Icons.account_balance_wallet_outlined), title: const Text('Flash Wallet'), onTap: () => Navigator.pop(context)),
          ListTile(leading: const Icon(Icons.security_rounded), title: const Text('Safety Toolkit'), onTap: () => Navigator.pop(context)),
          ListTile(leading: const Icon(Icons.settings_outlined), title: const Text('Settings'), onTap: () => Navigator.pop(context)),
          const Divider(),
          ListTile(leading: const Icon(Icons.logout_rounded, color: Colors.redAccent), title: const Text('Logout', style: TextStyle(color: Colors.redAccent)), onTap: () => Navigator.pop(context)),
        ],
      ),
    );
  }
}

// Map grid lines painter
class _MapGridPainter extends CustomPainter {
  const _MapGridPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = const Color(0xFFCBD5E1).withValues(alpha: 0.5)
      ..strokeWidth = 2.0;

    for (double y = 40; y < size.height; y += 80) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), linePaint);
    }
    for (double x = 40; x < size.width; x += 80) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), linePaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
'@ | Set-Content -Path (Join-Path $projectDir 'lib\screens\home\home_screen.dart') -Encoding UTF8

dart fix --apply | Out-Null
flutter analyze

Write-Host "==============================================================================" -ForegroundColor Green
Write-Host " 100% Seamless, Big, Prominent Logo Header Ready! Press 'R' or Ctrl+R!        " -ForegroundColor Green
Write-Host "==============================================================================" -ForegroundColor Green