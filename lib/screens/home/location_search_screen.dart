import 'package:flutter/material.dart';
import 'map_pin_picker_screen.dart';

class LocationSearchScreen extends StatefulWidget {
  final dynamic data;
  const LocationSearchScreen({super.key, this.data});

  @override
  State<LocationSearchScreen> createState() => _LocationSearchScreenState();
}

class _LocationSearchScreenState extends State<LocationSearchScreen> {
  final TextEditingController _pickupController = TextEditingController(text: 'Current Location (VRC Centre)');
  final TextEditingController _dropController = TextEditingController();

  final List<Map<String, String>> _allPlaces = [
    {
      'title': 'Nellore Bus Stand',
      'address': 'Grand Trunk Road, RTC Central Zone, Nellore',
    },
    {
      'title': 'VRC Centre',
      'address': 'Trunk Road, Commercial Hub, Nellore',
    },
    {
      'title': 'Nellore Railway Station',
      'address': 'Railway Station Road, Santhapet, Nellore',
    },
    {
      'title': 'Current Office Centre',
      'address': 'Dargamitta, Near Current Office, Nellore',
    },
    {
      'title': 'Magunta Layout',
      'address': 'Main Road, Magunta Layout, Nellore',
    },
    {
      'title': 'Narayana Medical College',
      'address': 'Chinthareddypalem, Nellore',
    },
  ];

  late List<Map<String, String>> _filteredPlaces;

  @override
  void initState() {
    super.initState();
    _filteredPlaces = _allPlaces;
  }

  void _filterLocations(String query) {
    if (query.isEmpty) {
      setState(() => _filteredPlaces = _allPlaces);
    } else {
      setState(() {
        _filteredPlaces = _allPlaces
            .where((p) =>
                p['title']!.toLowerCase().contains(query.toLowerCase()) ||
                p['address']!.toLowerCase().contains(query.toLowerCase()))
            .toList();
      });
    }
  }

  void _selectDestination(Map<String, String> place) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MapPinPickerScreen(
          data: {
            'title': place['title'],
            'address': place['address'],
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text(
          'Pickup Location',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        backgroundColor: const Color(0xFF0058FF),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Column(
              children: [
                Row(
                  children: [
                    const Icon(Icons.my_location, color: Color(0xFF00A859), size: 22),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        controller: _pickupController,
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                        decoration: const InputDecoration(
                          hintText: 'Pickup Location',
                          border: InputBorder.none,
                          isDense: true,
                        ),
                      ),
                    ),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 34),
                  child: Divider(height: 16),
                ),
                Row(
                  children: [
                    const Icon(Icons.location_on, color: Colors.red, size: 22),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        controller: _dropController,
                        autofocus: true,
                        onChanged: _filterLocations,
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                        decoration: const InputDecoration(
                          hintText: 'Where to? (e.g. Nellore Bus Stand, Magunta)',
                          border: InputBorder.none,
                          isDense: true,
                        ),
                      ),
                    ),
                    if (_dropController.text.isNotEmpty)
                      IconButton(
                        icon: const Icon(Icons.clear, size: 18),
                        onPressed: () {
                          _dropController.clear();
                          _filterLocations('');
                        },
                      ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                ActionChip(
                  avatar: const Icon(Icons.home, size: 16, color: Color(0xFF0058FF)),
                  label: const Text('Home'),
                  backgroundColor: Colors.white,
                  onPressed: () => _selectDestination(_allPlaces.first),
                ),
                const SizedBox(width: 8),
                ActionChip(
                  avatar: const Icon(Icons.work, size: 16, color: Color(0xFFFF9500)),
                  label: const Text('Work'),
                  backgroundColor: Colors.white,
                  onPressed: () => _selectDestination(_allPlaces.first),
                ),
                const SizedBox(width: 8),
                ActionChip(
                  avatar: const Icon(Icons.map, size: 16, color: Color(0xFF00A859)),
                  label: const Text('Set on Map'),
                  backgroundColor: Colors.white,
                  onPressed: () => _selectDestination(_allPlaces.first),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: ListView.separated(
              itemCount: _filteredPlaces.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final place = _filteredPlaces[index];
                return ListTile(
                  tileColor: Colors.white,
                  leading: const CircleAvatar(
                    backgroundColor: Color(0xFFE5EEFF),
                    child: Icon(Icons.location_city, color: Color(0xFF0058FF), size: 20),
                  ),
                  title: Text(place['title']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  subtitle: Text(place['address']!, style: const TextStyle(fontSize: 13, color: Colors.grey)),
                  trailing: const Icon(Icons.north_west, size: 16, color: Colors.grey),
                  onTap: () => _selectDestination(place),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, -2))],
            ),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0058FF),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  elevation: 2,
                ),
                onPressed: () {
                  final sel = _filteredPlaces.isNotEmpty ? _filteredPlaces.first : _allPlaces.first;
                  _selectDestination(sel);
                },
                child: const Text('Confirm', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
