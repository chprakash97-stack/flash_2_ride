import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/app_theme.dart';
import '../../providers/auth_provider.dart';

class LanguageScreen extends StatelessWidget {
  const LanguageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Choose Language / భాష')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            _buildLangTile('English', 'English', auth.selectedLanguage == 'English', () => auth.setLanguage('English')),
            const SizedBox(height: 12),
            _buildLangTile('తెలుగు', 'Telugu', auth.selectedLanguage == 'Telugu', () => auth.setLanguage('Telugu')),
            const SizedBox(height: 12),
            _buildLangTile('हिंदी', 'Hindi', auth.selectedLanguage == 'Hindi', () => auth.setLanguage('Hindi')),
          ],
        ),
      ),
    );
  }

  Widget _buildLangTile(String title, String sub, bool isSelected, VoidCallback onTap) {
    return ListTile(
      tileColor: isSelected ? AppTheme.primaryGreen.withValues(alpha: 0.15) : AppTheme.cardBlack,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14), side: BorderSide(color: isSelected ? AppTheme.primaryGreen : Colors.transparent)),
      title: Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
      subtitle: Text(sub, style: const TextStyle(color: AppTheme.textGrey, fontSize: 12)),
      trailing: isSelected ? const Icon(Icons.check_circle, color: AppTheme.primaryGreen) : null,
      onTap: onTap,
    );
  }
}
