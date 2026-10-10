import 'package:flutter/material.dart';
import 'hourly_rentals_screen.dart';

class ScheduleRideScreen extends StatefulWidget {
  final String destination;
  final String rideType;
  final int fare;

  const ScheduleRideScreen({
    super.key,
    this.destination = 'Nellore Bus Stand, Nellore',
    this.rideType = 'Flash Auto',
    this.fare = 26,
  });

  @override
  State<ScheduleRideScreen> createState() => _ScheduleRideScreenState();
}

class _ScheduleRideScreenState extends State<ScheduleRideScreen> {
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 1));
  TimeOfDay _selectedTime = const TimeOfDay(hour: 9, minute: 0);

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(primary: Color(0xFF0058FF)),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(primary: Color(0xFF0058FF)),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => _selectedTime = picked);
    }
  }

  void _handleConfirmSchedule() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const HourlyRentalsScreen(),
      ),
    );
  }

  String _formatDate(DateTime dt) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return 'Tomorrow, ${dt.day} ${months[dt.month - 1]} ${dt.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0058FF),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Schedule Ride',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Select Date & Time',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF0F172A),
                        letterSpacing: -0.4,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Book your ride in advance for a hassle-free trip.',
                      style: TextStyle(fontSize: 13, color: Color(0xFF64748B)),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Pickup Date',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF475569)),
                    ),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: _pickDate,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.04),
                              blurRadius: 10,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: const Color(0xFF0058FF).withValues(alpha: 0.1),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.calendar_month_rounded, color: Color(0xFF0058FF), size: 22),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Text(
                                _formatDate(_selectedDate),
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF0F172A),
                                ),
                              ),
                            ),
                            const Icon(Icons.chevron_right_rounded, color: Color(0xFF94A3B8)),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Pickup Time',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF475569)),
                    ),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: _pickTime,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.04),
                              blurRadius: 10,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: const Color(0xFF0058FF).withValues(alpha: 0.1),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.access_time_rounded, color: Color(0xFF0058FF), size: 22),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Text(
                                _selectedTime.format(context),
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF0F172A),
                                ),
                              ),
                            ),
                            const Icon(Icons.chevron_right_rounded, color: Color(0xFF94A3B8)),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEFF6FF),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFBFDBFE)),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.info_outline_rounded, color: Color(0xFF0058FF), size: 22),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Guaranteed On-Time Arrival',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF1E3A8A),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Your ${widget.rideType} Partner will arrive 5-10 minutes prior to your scheduled time at Nellore.',
                                  style: const TextStyle(fontSize: 12, color: Color(0xFF3B82F6), height: 1.4),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              width: double.infinity,
              color: Colors.white,
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0058FF),
                    foregroundColor: Colors.white,
                    elevation: 4,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
                  ),
                  onPressed: _handleConfirmSchedule,
                  child: const Text(
                    'Schedule Ride',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, letterSpacing: 0.5),
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
