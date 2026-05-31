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
            width: 72,
            height: 72,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.primaryNavy.withValues(alpha: 0.1), // Fixed name
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppTheme.primaryNavy.withValues(alpha: 0.3), width: 2), // Fixed name
            ),
            child: const CircularProgressIndicator(
              color: AppTheme.primaryNavy, // Fixed name
              strokeWidth: 3,
            ),
          ),
          const SizedBox(height: AppTheme.spacing16),
          Text(
            'Syncing clinical matrix...',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.textMedium,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }
}