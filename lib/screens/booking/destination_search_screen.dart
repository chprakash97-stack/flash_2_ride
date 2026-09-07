import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/app_theme.dart';
import '../../models/ride_model.dart';
import '../../providers/ride_provider.dart';

class DestinationSearchScreen extends StatefulWidget {
  const DestinationSearchScreen({super.key});

  @override
  State<DestinationSearchScreen> createState() => _DestinationSearchScreenState();
}

class _DestinationSearchScreenState extends State<DestinationSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _pickupController = TextEditingController();

  final List<PlaceModel> popularPlaces = [
    PlaceModel(title: 'Nellore RTC Main Bus Stand', address: 'Grand Trunk Road, Nellore', distanceKm: 4.2),
    PlaceModel(title: 'Nellore Railway Station', address: 'Railway Feeder Rd, Nellore', distanceKm: 5.8),
    PlaceModel(title: 'VRC Centre Circle', address: 'VRC Circle, Trunk Road, Nellore', distanceKm: 3.1),
    PlaceModel(title: 'Magunta Layout Park', address: 'Magunta Layout, Nellore', distanceKm: 1.5),
    PlaceModel(title: 'Current Office Substation', address: 'Dargamitta, Nellore', distanceKm: 2.8),
    PlaceModel(title: 'MGB Felicity Mall', address: 'Grand Trunk Road, Nellore', distanceKm: 4.9),
  ];

  @override
  void initState() {
    super.initState();
    final ride = Provider.of<RideProvider>(context, listen: false);
    _pickupController.text = ride.pickup.address;
  }

  @override
  Widget build(BuildContext context) {
    final ride = Provider.of<RideProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('Search & Select Location')),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Column(
              children: [
                TextField(
                  controller: _pickupController,
                  style: const TextStyle(color: AppTheme.textBlack, fontWeight: FontWeight.bold),
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.circle, color: AppTheme.primaryGreen, size: 14),
                    hintText: 'Pickup Address...',
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.my_location, color: AppTheme.primaryGreen),
                      onPressed: () {
                        ride.fetchLiveLocation().then((_) {
                          _pickupController.text = ride.pickup.address;
                        });
                      },
                    ),
                  ),
                  onSubmitted: (val) => ride.setPickupManual(val),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _searchController,
                  autofocus: true,
                  style: const TextStyle(color: AppTheme.textBlack, fontWeight: FontWeight.bold),
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.location_on, color: Colors.redAccent, size: 20),
                    hintText: 'Type drop location in Nellore...',
                  ),
                  onSubmitted: (val) {
                    if (val.trim().isNotEmpty) {
                      ride.setDestinationManual(val.trim());
                      Navigator.pop(context);
                    }
                  },
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: AppTheme.borderGrey),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Align(alignment: Alignment.centerLeft, child: Text('Quick Select Places in Nellore', style: TextStyle(color: AppTheme.textGrey, fontWeight: FontWeight.bold))),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: popularPlaces.length,
              itemBuilder: (context, index) {
                final place = popularPlaces[index];
                return ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(10)),
                    child: const Icon(Icons.place_rounded, color: AppTheme.primaryGreen),
                  ),
                  title: Text(place.title, style: const TextStyle(color: AppTheme.textBlack, fontWeight: FontWeight.bold)),
                  subtitle: Text('${place.address} â€¢ ${place.distanceKm} km', style: const TextStyle(color: AppTheme.textGrey, fontSize: 12)),
                  trailing: Text('â‚¹${(25 + 9 * place.distanceKm).toInt()}', style: const TextStyle(color: AppTheme.primaryGreen, fontWeight: FontWeight.bold, fontSize: 15)),
                  onTap: () {
                    ride.setDestination(place);
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
