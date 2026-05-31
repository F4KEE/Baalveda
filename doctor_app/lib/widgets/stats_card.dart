import 'package:flutter/material.dart';
import '../themes/app_theme.dart';

class StatsCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color accentColor;
  final String subtitle;

  const StatsCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.accentColor,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfacePure,
        borderRadius: BorderRadius.circular(20), // Kept consistent with design system
        boxShadow: AppTheme.premiumShadow,
        border: Border.all(color: AppTheme.borderMuted, width: 1),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            // Soft Background Ambient Corner Glow
            Positioned(
              right: -15,
              top: -15,
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: accentColor.withValues(alpha: 0.03),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(14.0), // Marginally optimized padding for high-density mobile
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Constrain the title text so it never pushes the icon out of layout bounds
                      Expanded(
                        child: Text(
                          title,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: AppTheme.textLight,
                                fontSize: 13,
                              ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: accentColor.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(icon, color: accentColor, size: 16),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    value,
                    style: Theme.of(context).textTheme.displayMedium?.copyWith(
                          fontSize: 28,
                          height: 1,
                        ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.textMedium,
                          fontWeight: FontWeight.w500,
                          fontSize: 11,
                        ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}