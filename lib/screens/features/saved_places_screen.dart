import 'package:flutter/material.dart';

class SavedPlacesScreen extends StatefulWidget {
  final dynamic data;
  const SavedPlacesScreen({super.key, this.data});

  @override
  State<SavedPlacesScreen> createState() => _SavedPlacesScreenState();
}

class _SavedPlacesScreenState extends State<SavedPlacesScreen> {
  final List<Map<String, String>> _places = [
    {'title': 'Home', 'address': 'Trunk Road, Nellore, Andhra Pradesh', 'icon': 'home'},
    {'title': 'Work', 'address': 'Current Office Centre, Dargamitta, Nellore', 'icon': 'work'},
    {'title': 'Gym', 'address': 'Narayana College Road, Nellore', 'icon': 'fitness'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text('Saved Places', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
        backgroundColor: const Color(0xFF0058FF),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ..._places.map((place) => Container(
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: const Color(0xFFE5EEFF),
                  child: Icon(
                    place['icon'] == 'home' ? Icons.home_rounded : place['icon'] == 'work' ? Icons.work_rounded : Icons.fitness_center_rounded,
                    color: const Color(0xFF0058FF),
                  ),
                ),
                title: Text(place['title']!, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(place['address']!, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                trailing: const Icon(Icons.more_vert, color: Colors.grey),
              ),
            )),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFF0058FF), width: 1.5),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Tap any location on Nellore map to save')),
                  );
                },
                icon: const Icon(Icons.add, color: Color(0xFF0058FF)),
                label: const Text('Add New Place', style: TextStyle(color: Color(0xFF0058FF), fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}