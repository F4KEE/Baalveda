import 'package:flutter/material.dart';
import '../themes/app_theme.dart';

class EmptyStateWidget extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback? onRetry;

  const EmptyStateWidget({
    super.key, 
    this.title = 'No Appointments', 
    this.subtitle = 'You have no scheduled appointments at the moment.', 
    this.icon = Icons.calendar_today, 
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacing24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Styled Icon Container
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: AppTheme.primaryNavy.withValues(alpha: 0.08), // Fixed name
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 56, color: AppTheme.primaryNavy), // Fixed name
              ),
              const SizedBox(height: AppTheme.spacing24),
              // Title
              Text(
                title,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: AppTheme.textDark, fontWeight: FontWeight.w700),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppTheme.spacing12),
              // Subtitle
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppTheme.textLight),
                textAlign: TextAlign.center,
              ),
              if (onRetry != null) ...[
                const SizedBox(height: AppTheme.spacing24),
                ElevatedButton.icon(
                  onPressed: onRetry,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Retry'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryNavy,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacing24, vertical: AppTheme.spacing12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}