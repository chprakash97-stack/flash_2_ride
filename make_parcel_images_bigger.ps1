Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "ENLARGING 3D PARCEL IMAGES TO FIT CARDS PERFECTLY..." -ForegroundColor Green
Write-Host "==========================================================" -ForegroundColor Cyan

$projectRoot = $PWD
Add-Type -AssemblyName System.Drawing

# 1. WhatsApp ఇమేజ్ నుండి క్లోజ్-అప్ గా బొమ్మలను మాత్రమే పెద్దగా కట్ చేయడం
$searchDirs = @(
    "$env:USERPROFILE\Downloads",
    "$env:USERPROFILE\Desktop",
    "$PWD",
    "$PWD\assets"
)

$srcImgPath = $null
foreach ($dir in $searchDirs) {
    if (Test-Path $dir) {
        $found = Get-ChildItem -Path $dir -Filter "*7.08.33*" -File -ErrorAction SilentlyContinue | Select-Object -First 1
        if ($found) {
            $srcImgPath = $found.FullName
            break
        }
    }
}

$destDir = "$projectRoot\assets\images\parcel"
if (-not (Test-Path $destDir)) { New-Item -ItemType Directory -Path $destDir -Force | Out-Null }

if ($srcImgPath) {
    Write-Host "Re-cropping with tight margins from: $srcImgPath" -ForegroundColor Green
    $bmp = [System.Drawing.Bitmap]::FromFile($srcImgPath)
    $w = $bmp.Width
    $h = $bmp.Height

    $cw = [int]($w / 3)
    $ch = [int]($h / 2)

    # చుట్టూ ఉన్న తెల్లటి ఖాళీ స్థలాన్ని తీసేసి బొమ్మను మాత్రమే పెద్దగా క్రాప్ చేయడం
    $cropW = [int]($cw * 0.88)
    $cropH = [int]($ch * 0.72)
    $padX  = [int]($cw * 0.06)
    $padY  = [int]($ch * 0.04)

    $items = @(
        @{ File = "medicines.png";   Col = 0; Row = 0 },
        @{ File = "documents.png";   Col = 1; Row = 0 },
        @{ File = "food.png";        Col = 2; Row = 0 },
        @{ File = "clothes.png";     Col = 0; Row = 1 },
        @{ File = "electronics.png"; Col = 1; Row = 1 },
        @{ File = "others.png";      Col = 2; Row = 1 }
    )

    foreach ($item in $items) {
        $x = [int]($item.Col * $cw + $padX)
        $y = [int]($item.Row * $ch + $padY)
        $rect = New-Object System.Drawing.Rectangle($x, $y, $cropW, $cropH)
        $cropped = $bmp.Clone($rect, $bmp.PixelFormat)
        $outPath = "$destDir\$($item.File)"
        $cropped.Save($outPath, [System.Drawing.Imaging.ImageFormat]::Png)
        $cropped.Dispose()
        Write-Host "Saved enlarged: $($item.File)" -ForegroundColor Cyan
    }
    $bmp.Dispose()
}

# 2. స్క్రీన్ కోడ్ లో ఇమేజ్ సైజును 72x72 కి పెంచడం
$parcelCode = @'
import 'package:flutter/material.dart';

class FlashParcelScreen extends StatefulWidget {
  final dynamic data;
  const FlashParcelScreen({super.key, this.data});

  @override
  State<FlashParcelScreen> createState() => _FlashParcelScreenState();
}

class _FlashParcelScreenState extends State<FlashParcelScreen> {
  final TextEditingController _nameController = TextEditingController(text: 'Suresh Kumar');
  final TextEditingController _phoneController = TextEditingController(text: '+91 98765 43210');
  String _selectedType = 'Documents';

  final List<Map<String, dynamic>> _parcelTypes = [
    {
      'title': 'Documents',
      'image': 'assets/images/parcel/documents.png',
      'icon': Icons.description_rounded,
      'color': const Color(0xFF0058FF),
      'bgColor': const Color(0xFFEFF6FF),
    },
    {
      'title': 'Clothes',
      'image': 'assets/images/parcel/clothes.png',
      'icon': Icons.checkroom_rounded,
      'color': const Color(0xFF8B5CF6),
      'bgColor': const Color(0xFFF5F3FF),
    },
    {
      'title': 'Electronics',
      'image': 'assets/images/parcel/electronics.png',
      'icon': Icons.devices_other_rounded,
      'color': const Color(0xFFFF9500),
      'bgColor': const Color(0xFFFFF7ED),
    },
    {
      'title': 'Medicines',
      'image': 'assets/images/parcel/medicines.png',
      'icon': Icons.medical_services_rounded,
      'color': const Color(0xFF00A859),
      'bgColor': const Color(0xFFE8F8F0),
    },
    {
      'title': 'Food',
      'image': 'assets/images/parcel/food.png',
      'icon': Icons.restaurant_rounded,
      'color': const Color(0xFFEF4444),
      'bgColor': const Color(0xFFFEF2F2),
    },
    {
      'title': 'Others',
      'image': 'assets/images/parcel/others.png',
      'icon': Icons.inventory_2_rounded,
      'color': const Color(0xFF6366F1),
      'bgColor': const Color(0xFFEEF2FF),
    },
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Flash Parcel',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        backgroundColor: const Color(0xFF0058FF),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Receiver Name
                    const Text(
                      'Receiver Name',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF64748B)),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _nameController,
                      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15, color: Color(0xFF1E293B)),
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.person_outline, color: Color(0xFF0058FF)),
                        filled: true,
                        fillColor: const Color(0xFFF8FAFC),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(color: Color(0xFF0058FF), width: 1.5),
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),

                    // Mobile Number
                    const Text(
                      'Mobile Number',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF64748B)),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15, color: Color(0xFF1E293B)),
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.phone_outlined, color: Color(0xFF0058FF)),
                        filled: true,
                        fillColor: const Color(0xFFF8FAFC),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(color: Color(0xFF0058FF), width: 1.5),
                        ),
                      ),
                    ),
                    const SizedBox(height: 22),

                    // Parcel Type హెడర్
                    const Text(
                      'Parcel Type',
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                    ),
                    const SizedBox(height: 12),

                    // బాక్సులకు నిండుగా సరిపోయే పెద్ద 3D ఇమేజ్ కార్డ్స్
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        childAspectRatio: 0.82, // కార్డ్ ఎత్తు పెంచడం
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                      ),
                      itemCount: _parcelTypes.length,
                      itemBuilder: (context, index) {
                        final item = _parcelTypes[index];
                        final isSelected = _selectedType == item['title'];
                        final Color color = item['color'] as Color;
                        final Color bgColor = item['bgColor'] as Color;

                        return InkWell(
                          onTap: () {
                            setState(() {
                              _selectedType = item['title'] as String;
                            });
                          },
                          borderRadius: BorderRadius.circular(16),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
                            decoration: BoxDecoration(
                              color: isSelected ? bgColor.withOpacity(0.45) : Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: isSelected ? color : const Color(0xFFE2E8F0),
                                width: isSelected ? 2.0 : 1.0,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: isSelected ? color.withOpacity(0.15) : Colors.black.withOpacity(0.03),
                                  blurRadius: isSelected ? 8 : 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    // 3D ఇమేజ్ సైజును 72x72 కి పెంచడం
                                    SizedBox(
                                      height: 72,
                                      width: 72,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: Image.asset(
                                          item['image'] as String,
                                          fit: BoxFit.contain,
                                          errorBuilder: (ctx, err, stack) {
                                            return CircleAvatar(
                                              backgroundColor: bgColor,
                                              radius: 30,
                                              child: Icon(item['icon'] as IconData, color: color, size: 30),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                    if (isSelected)
                                      Positioned(
                                        top: -2,
                                        right: -2,
                                        child: Container(
                                          padding: const EdgeInsets.all(3),
                                          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
                                          child: const Icon(Icons.check, color: Colors.white, size: 12),
                                        ),
                                      ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  item['title'] as String,
                                  style: TextStyle(
                                    fontSize: 12.5,
                                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                                    color: isSelected ? color : const Color(0xFF1E293B),
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 20),

                    // Weight Limit
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEFF6FF),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFBFDBFE)),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.shield_outlined, color: Color(0xFF0058FF), size: 18),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Weight limit up to 5 kg \u2022 Secure doorstep delivery in Nellore',
                              style: TextStyle(fontSize: 11, color: Color(0xFF1E40AF), fontWeight: FontWeight.w500),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Book Parcel బటన్
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0058FF),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Flash Parcel order placed for $_selectedType to ${_nameController.text}!'),
                        backgroundColor: const Color(0xFF00A859),
                      ),
                    );
                  },
                  child: const Text(
                    'Book Parcel',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
'@

$filesToUpdate = @(
    "$projectRoot\lib\screens\booking\flash_parcel_screen.dart",
    "$projectRoot\lib\screens\booking\parcel_booking_screen.dart"
)
foreach ($f in $filesToUpdate) {
    if (Test-Path (Split-Path $f)) {
        [System.IO.File]::WriteAllText($f, $parcelCode, [System.Text.Encoding]::UTF8)
        Write-Host "Updated with enlarged 72x72 images in $f" -ForegroundColor Green
    }
}

Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "SUCCESS! 3D images enlarged to 72x72. Press 'R' to refresh!" -ForegroundColor Green
Write-Host "==========================================================" -ForegroundColor Cyan