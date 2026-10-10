import 'package:flutter/material.dart';

class HelpSupportScreen extends StatefulWidget {
  final dynamic data;
  const HelpSupportScreen({super.key, this.data});

  @override
  State<HelpSupportScreen> createState() => _HelpSupportScreenState();
}

class _HelpSupportScreenState extends State<HelpSupportScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  final List<Map<String, String>> _faqs = [
    {
      'question': 'How is ride fare calculated in Nellore?',
      'answer':
          'Fares are calculated based on base fare + per-km rate + ride time. Flash 2 Ride offers transparent zero-surge pricing across Nellore city routes.',
      'category': 'Fares & Payments',
    },
    {
      'question': 'How do I use my Refer & Earn bonus?',
      'answer':
          'When you refer friends with your code FLR12345, the Rs. 50 bonus is instantly added to your Flash Wallet and auto-applied on your next ride.',
      'category': 'Rewards',
    },
    {
      'question': 'What if the driver cancels after accepting?',
      'answer':
          'If a partner cancels, our dispatch system immediately reassigns your ride to the nearest available driver within 60 seconds with no cancellation charge.',
      'category': 'Ride Issues',
    },
    {
      'question': 'Lost an item in the vehicle? (Lost & Found)',
      'answer':
          'Contact support via the "Call Support" button or your ride history receipt within 24 hours. We immediately reach out to the driver to recover your item.',
      'category': 'Safety & Items',
    },
    {
      'question': 'How to enable 24x7 SOS and Emergency Contacts?',
      'answer':
          'Go to Safety Center from the side menu to add up to 3 trusted family members and enable 1-tap live location sharing.',
      'category': 'Safety',
    },
  ];

  void _showRaiseTicketDialog() {
    String selectedCategory = 'Ride Issue';
    final TextEditingController descController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Raise Support Ticket',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(ctx),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text('Category', style: TextStyle(fontSize: 13, color: Color(0xFF64748B))),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xFFCBD5E1)),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: selectedCategory,
                        isExpanded: true,
                        items: ['Ride Issue', 'Fare Discrepancy', 'Driver Behavior', 'App Bug', 'Other']
                            .map((cat) => DropdownMenuItem(value: cat, child: Text(cat)))
                            .toList(),
                        onChanged: (val) {
                          if (val != null) setModalState(() => selectedCategory = val);
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  const Text('Explain your issue', style: TextStyle(fontSize: 13, color: Color(0xFF64748B))),
                  const SizedBox(height: 6),
                  TextField(
                    controller: descController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: 'Describe details (Ride ID, Location, etc.)...',
                      hintStyle: const TextStyle(fontSize: 13, color: Color(0xFF94A3B8)),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      contentPadding: const EdgeInsets.all(12),
                    ),
                  ),
                  const SizedBox(height: 18),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(ctx);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Ticket #F2R-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)} created! Our Nellore desk will resolve it within 2 hours.'),
                            backgroundColor: const Color(0xFF10B981),
                            behavior: SnackBarBehavior.floating,
                            duration: const Duration(seconds: 4),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2563EB),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('Submit Ticket', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredFaqs = _faqs.where((faq) {
      final q = _searchQuery.toLowerCase();
      return faq['question']!.toLowerCase().contains(q) ||
          faq['answer']!.toLowerCase().contains(q) ||
          faq['category']!.toLowerCase().contains(q);
    }).toList();

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
            // Search Input
            TextField(
              controller: _searchController,
              onChanged: (val) => setState(() => _searchQuery = val),
              decoration: InputDecoration(
                hintText: 'Search help topics (e.g. fare, lost item, cancel)...',
                hintStyle: const TextStyle(fontSize: 13, color: Color(0xFF94A3B8)),
                prefixIcon: const Icon(Icons.search, color: Color(0xFF64748B)),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                ),
              ),
            ),
            const SizedBox(height: 18),

            // Quick Contact Options
            const Text(
              '24x7 Direct Assistance',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Dialing Flash 2 Ride Nellore Desk: +91 861 234 5678'),
                          backgroundColor: Color(0xFF2563EB),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                    borderRadius: BorderRadius.circular(14),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: Column(
                        children: const [
                          CircleAvatar(
                            radius: 20,
                            backgroundColor: Color(0xFFEFF6FF),
                            child: Icon(Icons.call_rounded, color: Color(0xFF2563EB), size: 20),
                          ),
                          SizedBox(height: 8),
                          Text('Call Us', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                          SizedBox(height: 2),
                          Text('Toll Free 24x7', style: TextStyle(fontSize: 11, color: Color(0xFF64748B))),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: InkWell(
                    onTap: _showRaiseTicketDialog,
                    borderRadius: BorderRadius.circular(14),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: Column(
                        children: const [
                          CircleAvatar(
                            radius: 20,
                            backgroundColor: Color(0xFFECFDF5),
                            child: Icon(Icons.confirmation_number_outlined, color: Color(0xFF059669), size: 20),
                          ),
                          SizedBox(height: 8),
                          Text('Raise Ticket', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                          SizedBox(height: 2),
                          Text('2h Resolution', style: TextStyle(fontSize: 11, color: Color(0xFF64748B))),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Connecting to Flash Live Chat Executive...'),
                          backgroundColor: Color(0xFF10B981),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                    borderRadius: BorderRadius.circular(14),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: Column(
                        children: const [
                          CircleAvatar(
                            radius: 20,
                            backgroundColor: Color(0xFFFEF3C7),
                            child: Icon(Icons.chat_bubble_outline_rounded, color: Color(0xFFD97706), size: 20),
                          ),
                          SizedBox(height: 8),
                          Text('Live Chat', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                          SizedBox(height: 2),
                          Text('Instant reply', style: TextStyle(fontSize: 11, color: Color(0xFF64748B))),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // FAQs List
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Frequently Asked Questions',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                ),
                Text(
                  '${filteredFaqs.length} Articles',
                  style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                ),
              ],
            ),
            const SizedBox(height: 12),

            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Column(
                  children: List.generate(filteredFaqs.length, (index) {
                    final item = filteredFaqs[index];
                    return Column(
                      children: [
                        Theme(
                          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                          child: ExpansionTile(
                            tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                            childrenPadding: const EdgeInsets.only(left: 16, right: 16, bottom: 14),
                            title: Text(
                              item['question']!,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF0F172A),
                              ),
                            ),
                            subtitle: Text(
                              item['category']!,
                              style: const TextStyle(fontSize: 11, color: Color(0xFF2563EB), fontWeight: FontWeight.w500),
                            ),
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  item['answer']!,
                                  style: const TextStyle(fontSize: 13, color: Color(0xFF475569), height: 1.4),
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (index < filteredFaqs.length - 1)
                          const Divider(height: 1, indent: 16, endIndent: 16),
                      ],
                    );
                  }),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}