import 'package:flutter/material.dart';
import '../themes/app_theme.dart';

class LoadingStateWidget extends StatelessWidget {
  const LoadingStateWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 64, height: 64,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: AppTheme.surfacePure, borderRadius: BorderRadius.circular(16), boxShadow: AppTheme.premiumShadow),
            child: const CircularProgressIndicator(color: AppTheme.primaryNavy, strokeWidth: 3),
          ),
          const SizedBox(height: AppTheme.spacing16),
          const Text('Syncing data engines...', style: TextStyle(fontSize: 13, color: AppTheme.textMedium, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}