import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/app_theme.dart';
import '../../providers/ride_provider.dart';

class ScheduleRideScreen extends StatefulWidget {
  const ScheduleRideScreen({super.key});

  @override
  State<ScheduleRideScreen> createState() => _ScheduleRideScreenState();
}

class _ScheduleRideScreenState extends State<ScheduleRideScreen> {
  DateTime _selectedDate = DateTime.now().add(const Duration(hours: 2));
  TimeOfDay _selectedTime = const TimeOfDay(hour: 9, minute: 0);

  @override
  Widget build(BuildContext context) {
    final ride = Provider.of<RideProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Schedule for Later')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Book in Advance', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('Your Flash Captain will arrive at the scheduled time in Nellore.', style: TextStyle(color: AppTheme.textGrey, fontSize: 14)),
            const SizedBox(height: 30),
            ListTile(
              tileColor: AppTheme.cardBlack,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              leading: const Icon(Icons.calendar_month, color: AppTheme.primaryGreen),
              title: const Text('Date', style: TextStyle(color: Colors.white)),
              subtitle: Text('${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}', style: const TextStyle(color: AppTheme.primaryGreen, fontWeight: FontWeight.bold)),
              trailing: const Icon(Icons.edit, color: AppTheme.textGrey, size: 18),
              onTap: () async {
                final d = await showDatePicker(context: context, initialDate: _selectedDate, firstDate: DateTime.now(), lastDate: DateTime.now().add(const Duration(days: 7)));
                if (d != null) setState(() => _selectedDate = d);
              },
            ),
            const SizedBox(height: 16),
            ListTile(
              tileColor: AppTheme.cardBlack,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              leading: const Icon(Icons.access_time_filled, color: AppTheme.primaryGreen),
              title: const Text('Pickup Time', style: TextStyle(color: Colors.white)),
              subtitle: Text(_selectedTime.format(context), style: const TextStyle(color: AppTheme.primaryGreen, fontWeight: FontWeight.bold)),
              trailing: const Icon(Icons.edit, color: AppTheme.textGrey, size: 18),
              onTap: () async {
                final t = await showTimePicker(context: context, initialTime: _selectedTime);
                if (t != null) setState(() => _selectedTime = t);
              },
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  ride.setScheduledTime(_selectedDate);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Ride Scheduled for ${_selectedTime.format(context)} successfully!')));
                  Navigator.pop(context);
                },
                child: const Text('Confirm Schedule'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
