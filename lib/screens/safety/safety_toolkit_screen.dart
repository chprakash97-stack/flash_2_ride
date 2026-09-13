import 'package:flutter/material.dart';

class SafetyToolkitScreen extends StatefulWidget {
  final dynamic data;
  const SafetyToolkitScreen({super.key, this.data});

  @override
  State<SafetyToolkitScreen> createState() => _SafetyToolkitScreenState();
}

class _SafetyToolkitScreenState extends State<SafetyToolkitScreen> {
  bool _audioRecording = false;

  void _triggerSosDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.red, size: 28),
            SizedBox(width: 8),
            Text('Trigger Emergency SOS?', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          ],
        ),
        content: const Text(
          'This will immediately alert Police (112) and send your live location and partner details to your Emergency Contacts.',
          style: TextStyle(fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  backgroundColor: Colors.red,
                  content: Text('EMERGENCY SOS ACTIVATED: Police (112) and Contacts alerted!'),
                ),
              );
            },
            child: const Text('Confirm SOS', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
          onPressed: () => Navigator.maybePop(context),
        ),
        title: const Text(
          'Safety Toolkit',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF0066FF),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // 1. à°¸à±à°Ÿà°¡à±€à°—à°¾ à°‰à°‚à°¡à±‡ à°Žà°®à°°à±à°œà±†à°¨à±à°¸à±€ SOS à°•à°¾à°°à±à°¡à± (No shaking / Completely Steady)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 15,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: _triggerSosDialog,
                    child: Container(
                      width: 96,
                      height: 96,
                      decoration: BoxDecoration(
                        gradient: const RadialGradient(
                          colors: [Color(0xFFFF4D4D), Color(0xFFDC2626)],
                        ),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.red.withOpacity(0.35),
                            blurRadius: 18,
                            spreadRadius: 3,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Text(
                          'SOS',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Emergency SOS',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Press to alert 112 Police & Emergency Contacts',
                    style: TextStyle(fontSize: 12, color: Colors.black54),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // 2. à°µà±†à°°à°¿à°«à±ˆà°¡à± à°ªà°¾à°°à±à°Ÿà±à°¨à°°à± à°µà°¿à°µà°°à°¾à°²à± (à°¸à°°à°¿à°šà±‡à°¸à°¿à°¨ à°¯à±‚à°¨à°¿à°•à±‹à°¡à± à°¤à±‹)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFEBF3FF),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFCCE0FF)),
              ),
              child: const Row(
                children: [
                  Icon(Icons.verified_user_rounded, color: Color(0xFF0066FF), size: 28),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Verified Flash 2 Partner',
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF0066FF)),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Ramesh Babu \u2022 AP 26 TX 2344 (Flash Auto)',
                          style: TextStyle(fontSize: 12, color: Colors.black87),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // 3. à°¸à±‡à°«à±à°Ÿà±€ à°«à±€à°šà°°à±à°²à± (à°¸à±‡à°®à± à°Ÿà± à°¸à±‡à°®à±)
            _buildSafetyActionTile(
              icon: Icons.share_location_rounded,
              iconColor: const Color(0xFF0066FF),
              title: 'Share Live Trip',
              subtitle: 'Share live location with family & friends via WhatsApp',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Live trip link copied to clipboard!')),
                );
              },
            ),

            const SizedBox(height: 12),

            _buildSafetyActionTile(
              icon: Icons.local_police_rounded,
              iconColor: Colors.red,
              title: 'Call 112 (Police Helpline)',
              subtitle: 'Direct emergency call to Nellore Police Control Room',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Calling Emergency Police 112...')),
                );
              },
            ),

            const SizedBox(height: 12),

            _buildSafetyActionTile(
              icon: Icons.medical_services_rounded,
              iconColor: const Color(0xFF00A859),
              title: 'Call 108 (Ambulance)',
              subtitle: 'Instant emergency medical assistance',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Calling Medical Ambulance 108...')),
                );
              },
            ),

            const SizedBox(height: 12),

            // à°†à°¡à°¿à°¯à±‹ à°°à°¿à°•à°¾à°°à±à°¡à°¿à°‚à°—à± à°¸à±à°µà°¿à°šà±
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: _audioRecording ? const Color(0xFFFEE2E2) : const Color(0xFFF4F7FC),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.mic_rounded,
                      color: _audioRecording ? Colors.red : const Color(0xFF0066FF),
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 14),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Ride Audio Recording',
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black87),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Encrypted trip recording for safety',
                          style: TextStyle(fontSize: 12, color: Colors.black54),
                        ),
                      ],
                    ),
                  ),
                  Switch(
                    value: _audioRecording,
                    activeThumbColor: Colors.red,
                    onChanged: (val) {
                      setState(() => _audioRecording = val);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(val ? 'Safety Audio Recording Started' : 'Audio Recording Stopped'),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            _buildSafetyActionTile(
              icon: Icons.support_agent_rounded,
              iconColor: Colors.deepPurple,
              title: 'Flash 2 Ride 24x7 Safety Helpline',
              subtitle: 'Call our dedicated safety team for immediate support',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Connecting to Flash 2 Ride 24x7 Safety Desk...')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSafetyActionTile({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: iconColor, size: 22),
        ),
        title: Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black87)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 12, color: Colors.black54)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.black38),
      ),
    );
  }
}

typedef SafetyToolkitScreenView = SafetyToolkitScreen;
