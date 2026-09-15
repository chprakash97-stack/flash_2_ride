import 'package:flutter/material.dart';

class SupportScreen extends StatefulWidget {
  final dynamic data;
  const SupportScreen({super.key, this.data});

  @override
  State<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {
  int _selectedIssueIndex = 0;

  final List<Map<String, dynamic>> _issues = [
    {
      'title': 'Lost Item',
      'subtitle': 'Left an item or bag in Flash auto/bike/cab',
      'icon': Icons.luggage_rounded,
      'color': const Color(0xFFEF4444),
    },
    {
      'title': 'High Fare Charged',
      'subtitle': 'Charged more than estimated ride fare',
      'icon': Icons.receipt_long_rounded,
      'color': const Color(0xFFF59E0B),
    },
    {
      'title': 'Driver Behavior',
      'subtitle': 'Rude behavior, rash driving or route refusal',
      'icon': Icons.person_off_rounded,
      'color': const Color(0xFF8B5CF6),
    },
    {
      'title': 'Technical Issue',
      'subtitle': 'App glitch, GPS inaccuracy or payment failure',
      'icon': Icons.phonelink_setup_rounded,
      'color': const Color(0xFF2563EB),
    },
    {
      'title': 'General Query',
      'subtitle': 'Flash2Ride policies, discounts or Nellore service',
      'icon': Icons.help_outline_rounded,
      'color': const Color(0xFF10B981),
    },
  ];

  void _showRaiseTicketSheet() {
    final selectedIssue = _issues[_selectedIssueIndex]['title'];
    final descController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
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
            Row(
              children: [
                const Icon(Icons.confirmation_number_outlined, color: Color(0xFF2563EB)),
                const SizedBox(width: 8),
                Text(
                  'Raise Ticket: $selectedIssue',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: descController,
              maxLines: 4,
              autofocus: true,
              decoration: InputDecoration(
                labelText: 'Describe your issue in detail',
                hintText: 'Please share details (e.g. date, location in Nellore, what happened)...',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Our Nellore Support desk will review and contact you within 15 minutes.',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  final desc = descController.text.trim();
                  Navigator.pop(ctx);
                  _showTicketConfirmationDialog(selectedIssue, desc);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2563EB),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Submit Ticket', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showTicketConfirmationDialog(String issue, String desc) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Color(0xFFDCFCE7),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check_rounded, color: Color(0xFF16A34A), size: 40),
            ),
            const SizedBox(height: 16),
            const Text(
              'Ticket Submitted!',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'Ticket ID: #FLR-9842',
                style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF2563EB), fontSize: 13),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Issue: $issue\nWe have assigned an executive from Flash2Ride Nellore support team.',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 13, color: Color(0xFF64748B)),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(ctx),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2563EB),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Done', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ],
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
          'Help & Support',
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Heading matching Poster ("Need Help? Select an issue")
            const Text(
              'Need Help?',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0F172A),
                letterSpacing: -0.3,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Select an issue',
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF64748B),
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 16),

            // 2. Issue Categories List matching Poster
            Container(
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
              child: Column(
                children: List.generate(_issues.length, (index) {
                  final issue = _issues[index];
                  final Color itemColor = issue['color'] as Color;

                  return Column(
                    children: [
                      ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                        leading: CircleAvatar(
                          radius: 20,
                          backgroundColor: itemColor.withOpacity(0.12),
                          child: Icon(issue['icon'] as IconData, color: itemColor, size: 20),
                        ),
                        title: Text(
                          issue['title'] as String,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                        subtitle: Text(
                          issue['subtitle'] as String,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF64748B),
                          ),
                        ),
                        trailing: Radio<int>(
                          value: index,
                          groupValue: _selectedIssueIndex,
                          activeColor: const Color(0xFF2563EB),
                          onChanged: (val) => setState(() => _selectedIssueIndex = val!),
                        ),
                        onTap: () => setState(() => _selectedIssueIndex = index),
                      ),
                      if (index < _issues.length - 1)
                        const Divider(height: 1, indent: 64),
                    ],
                  );
                }),
              ),
            ),

            const SizedBox(height: 24),

            // 3. Raise Ticket Button matching Poster
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _showRaiseTicketSheet,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2563EB),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Raise Ticket',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // 4. Instant Help Channels (Call / WhatsApp)
            const Text(
              'Other Ways to Reach Us',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Calling Flash2Ride Nellore Helpline: +91 98765 43210'),
                          backgroundColor: Color(0xFF10B981),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                    borderRadius: BorderRadius.circular(14),
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: const Row(
                        children: [
                          CircleAvatar(
                            radius: 18,
                            backgroundColor: Color(0xFFDCFCE7),
                            child: Icon(Icons.phone_rounded, color: Color(0xFF16A34A), size: 18),
                          ),
                          SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Call Helpline', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                              Text('24x7 Support', style: TextStyle(color: Color(0xFF64748B), fontSize: 11)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Opening Live Chat with Flash2Ride Nellore Support...'),
                          backgroundColor: Color(0xFF2563EB),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                    borderRadius: BorderRadius.circular(14),
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: const Row(
                        children: [
                          CircleAvatar(
                            radius: 18,
                            backgroundColor: Color(0xFFDBEAFE),
                            child: Icon(Icons.chat_bubble_outline_rounded, color: Color(0xFF2563EB), size: 18),
                          ),
                          SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Live Chat', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                              Text('Instant Reply', style: TextStyle(color: Color(0xFF64748B), fontSize: 11)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}