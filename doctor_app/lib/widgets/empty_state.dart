import 'package:flutter/material.dart';
import '../themes/app_theme.dart';

class EmptyStateWidget extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback? onRetry;

  const EmptyStateWidget({super.key, this.title = 'No Appointments', this.subtitle = 'You have no scheduled appointments at the moment.', this.icon = Icons.calendar_today, this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacing24, vertical: AppTheme.spacing32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100, height: 100,
              decoration: BoxDecoration(color: AppTheme.primaryNavy.withValues(alpha: 0.06), shape: BoxShape.circle),
              child: Icon(icon, size: 44, color: AppTheme.primaryNavy),
            ),
            const SizedBox(height: AppTheme.spacing24),
            Text(title, style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: AppTheme.textDark, fontWeight: FontWeight.w700, fontSize: 18), textAlign: TextAlign.center),
            const SizedBox(height: AppTheme.spacing8),
            Text(subtitle, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppTheme.textLight, fontSize: 13), textAlign: TextAlign.center),
            if (onRetry != null) ...[
              const SizedBox(height: AppTheme.spacing16),
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh, size: 16),
                label: const Text('Refresh Workspace'),
                style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primaryNavy, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
              ),
            ],
          ],
        ),
      ),
    );
  }
}