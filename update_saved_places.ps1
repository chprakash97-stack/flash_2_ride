# ==============================================================================
# Flash2Ride - Poster-Accurate Saved Places Screen Setup
# 1. Updates lib\screens\home\saved_places_screen.dart
# 2. Updates lib\views\profile\saved_places_screen.dart
# Matching Section 7 Poster Image (Home, Work, Gym, + Add New Place)
# ==============================================================================

Write-Host "1. Creating Poster-Accurate Saved Places Screen..." -ForegroundColor Cyan

$spCode = @'
import 'package:flutter/material.dart';

class SavedPlacesScreen extends StatefulWidget {
  final dynamic data;
  const SavedPlacesScreen({super.key, this.data});

  @override
  State<SavedPlacesScreen> createState() => _SavedPlacesScreenState();
}

class _SavedPlacesScreenState extends State<SavedPlacesScreen> {
  final List<Map<String, dynamic>> _places = [
    {
      'title': 'Home',
      'address': 'Nellore, Andhra Pradesh',
      'icon': Icons.home_rounded,
      'color': const Color(0xFF2563EB),
    },
    {
      'title': 'Work',
      'address': 'SPSR Nellore',
      'icon': Icons.work_rounded,
      'color': const Color(0xFF6366F1),
    },
    {
      'title': 'Gym',
      'address': 'Narayana College',
      'icon': Icons.fitness_center_rounded,
      'color': const Color(0xFF10B981),
    },
  ];

  void _showAddPlaceDialog() {
    final nameController = TextEditingController();
    final addressController = TextEditingController();
    IconData selectedIcon = Icons.location_on_rounded;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) => Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 44,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              const Text(
                'Add New Place',
                style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Place Name',
                  hintText: 'e.g. Parents House, Temple, College',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  prefixIcon: const Icon(Icons.bookmark_outline_rounded),
                ),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: addressController,
                decoration: InputDecoration(
                  labelText: 'Address in Nellore',
                  hintText: 'e.g. Magunta Layout, Nellore',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  prefixIcon: const Icon(Icons.location_on_outlined),
                ),
              ),
              const SizedBox(height: 16),
              const Text('Select Icon:', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Icons.home_rounded,
                  Icons.work_rounded,
                  Icons.fitness_center_rounded,
                  Icons.school_rounded,
                  Icons.favorite_rounded,
                  Icons.local_hospital_rounded,
                ].map((icon) {
                  final isSel = selectedIcon == icon;
                  return InkWell(
                    onTap: () => setModalState(() => selectedIcon = icon),
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: isSel ? const Color(0xFF2563EB).withOpacity(0.12) : const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSel ? const Color(0xFF2563EB) : Colors.transparent,
                          width: 1.5,
                        ),
                      ),
                      child: Icon(icon, color: isSel ? const Color(0xFF2563EB) : const Color(0xFF64748B), size: 22),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    final name = nameController.text.trim();
                    final addr = addressController.text.trim();
                    if (name.isNotEmpty && addr.isNotEmpty) {
                      setState(() {
                        _places.add({
                          'title': name,
                          'address': addr,
                          'icon': selectedIcon,
                          'color': const Color(0xFF2563EB),
                        });
                      });
                      Navigator.pop(ctx);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('$name added to Saved Places!'),
                          backgroundColor: const Color(0xFF10B981),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2563EB),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Save Place', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _deletePlace(int index) {
    final item = _places[index];
    setState(() {
      _places.removeAt(index);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${item['title']} removed from Saved Places'),
        action: SnackBarAction(
          label: 'UNDO',
          textColor: Colors.white,
          onPressed: () {
            setState(() {
              _places.insert(index, item);
            });
          },
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text(
          'Saved Places',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Saved Places List matching Poster
            ...List.generate(_places.length, (index) {
              final place = _places[index];
              final IconData iconData = place['icon'] as IconData;
              final Color iconColor = place['color'] as Color;

              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.02),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  leading: CircleAvatar(
                    radius: 22,
                    backgroundColor: iconColor.withOpacity(0.12),
                    child: Icon(iconData, color: iconColor, size: 22),
                  ),
                  title: Text(
                    place['title'] as String,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                  subtitle: Text(
                    place['address'] as String,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF64748B),
                    ),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline_rounded, color: Color(0xFF94A3B8), size: 20),
                    onPressed: () => _deletePlace(index),
                  ),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Selected: ${place['title']} (${place['address']})'),
                        behavior: SnackBarBehavior.floating,
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                ),
              );
            }),

            const SizedBox(height: 8),

            // + Add New Place Button matching Poster
            InkWell(
              onTap: _showAddPlaceDialog,
              borderRadius: BorderRadius.circular(16),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: const Color(0xFF2563EB).withOpacity(0.4),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF2563EB).withOpacity(0.04),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add_rounded, color: Color(0xFF2563EB), size: 22),
                    SizedBox(width: 8),
                    Text(
                      'Add New Place',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2563EB),
                      ),
                    ),
                  ],
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

$paths = @(
    "lib\screens\home\saved_places_screen.dart",
    "lib\views\profile\saved_places_screen.dart"
)

foreach ($p in $paths) {
    $dir = [System.IO.Path]::GetDirectoryName($p)
    if (!(Test-Path $dir)) {
        New-Item -ItemType Directory -Path $dir -Force | Out-Null
    }
    [System.IO.File]::WriteAllText($p, $spCode, [System.Text.Encoding]::UTF8)
    Write-Host "  -> Updated $($p)" -ForegroundColor Green
}

Write-Host "`n2. Ensuring Drawer has Saved Places..." -ForegroundColor Cyan

$homeFiles = @(
    "lib\\screens\\home\\home_screen.dart",
    "lib\\views\\home\\home_screen.dart"
)

foreach ($hf in $homeFiles) {
    if (Test-Path $hf) {
        $text = [System.IO.File]::ReadAllText($hf, [System.Text.Encoding]::UTF8)
        $modified = $false
        
        # Add import if missing
        if ($text -notmatch "saved_places_screen\.dart") {
            $importStr = "import '../../screens/home/saved_places_screen.dart';"
            if ($hf -match "views[\\/]home") {
                $importStr = "import '../profile/saved_places_screen.dart';"
            }
            $text = "$importStr`n" + $text
            $modified = $true
            Write-Host "  -> Added SavedPlacesScreen import in $($hf)" -ForegroundColor Yellow
        }
        
        # Link in Drawer if Saved Places tile exists
        $spIdx = $text.IndexOf("Saved Places")
        if ($spIdx -gt 0) {
            $otIdx = $text.IndexOf("onTap:", $spIdx)
            if ($otIdx -gt 0 -and ($otIdx - $spIdx) -lt 300) {
                $afterOnTap = $text.Substring($otIdx, [Math]::Min(150, $text.Length - $otIdx))
                $endPos = -1
                if ($afterOnTap -match "onTap:\s*\(\)\s*=>") {
                    $comma = $text.IndexOf(",", $otIdx)
                    if ($comma -gt 0) { $endPos = $comma }
                } else {
                    $cb = $text.IndexOf("},", $otIdx)
                    if ($cb -gt 0) { $endPos = $cb + 1 }
                }
                
                if ($endPos -gt 0) {
                    $newOnTap = @"
onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SavedPlacesScreen()),
              );
            }
"@
                    $text = $text.Substring(0, $otIdx) + $newOnTap + $text.Substring($endPos)
                    $modified = $true
                    Write-Host "  -> Successfully linked Drawer 'Saved Places' to SavedPlacesScreen!" -ForegroundColor Green
                }
            }
        } else {
            # If not in drawer, insert it before Settings in _buildDrawer
            $drawerDefIdx = $text.IndexOf("Widget _buildDrawer()")
            if ($drawerDefIdx -gt 0) {
                $settingsIdx = $text.IndexOf("Settings", $drawerDefIdx)
                if ($settingsIdx -gt 0) {
                    $ltStart = $text.LastIndexOf("ListTile(", $settingsIdx)
                    if ($ltStart -gt 0) {
                        $savedPlacesTile = @"
          // Saved Places (Royal Blue)
          ListTile(
            leading: const Icon(Icons.bookmark_border_rounded, color: Color(0xFF2563EB)),
            title: const Text('Saved Places'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SavedPlacesScreen()),
              );
            },
          ),
"@
                        $text = $text.Substring(0, $ltStart) + $savedPlacesTile + $text.Substring($ltStart)
                        $modified = $true
                        Write-Host "  -> Successfully added 'Saved Places' to Drawer menu!" -ForegroundColor Green
                    }
                }
            }
        }
        
        if ($modified) {
            [System.IO.File]::WriteAllText($hf, $text, [System.Text.Encoding]::UTF8)
        }
    }
}

Write-Host "`nRunning flutter analyze verification..." -ForegroundColor Cyan
flutter analyze