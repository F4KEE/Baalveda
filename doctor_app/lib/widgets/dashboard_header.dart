import 'package:flutter/material.dart';
import '../themes/app_theme.dart';
import '../utils/datetime_utils.dart';

class DashboardHeader extends StatelessWidget {
  final String doctorName;

  const DashboardHeader({super.key, this.doctorName = 'Doctor'});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final dateString = DateTimeUtils.formatDateFull(now);
    final timeGreeting = _getTimeGreeting();

    return Padding(
      padding: const EdgeInsets.only(
        left: AppTheme.spacing24,
        right: AppTheme.spacing24,
        top: AppTheme.spacing32,
        bottom: AppTheme.spacing16,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Elegant Branding Bar
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppTheme.accentRose, Color(0xFFF472B6)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.accentRose.withValues(alpha: 0.25),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        )
                      ],
                    ),
                    child: const Center(
                      child: Text(
                        '|| B ||',
                        style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w900, letterSpacing: -0.5),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppTheme.spacing12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'baalveda',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w900,
                          color: AppTheme.primaryNavy,
                          letterSpacing: 0.5,
                        ),
                      ),
                      Text(
                        'HEALTHCARE',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontSize: 9,
                          fontWeight: FontWeight.w800,
                          color: AppTheme.textLight,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              // User Avatar Context
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppTheme.surfacePure,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppTheme.borderMuted, width: 1.5),
                ),
                child: const Icon(Icons.person_outline, color: AppTheme.primaryNavy, size: 20),
              )
            ],
          ),
          const SizedBox(height: AppTheme.spacing32),
          
          // Greeting Set
          Text(
            '$timeGreeting,',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: AppTheme.textMedium,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            'Dr. $doctorName',
            style: Theme.of(context).textTheme.displayMedium,
          ),
          const SizedBox(height: AppTheme.spacing8),
          
          // Sub-bar Date
          Row(
            children: [
              const Icon(Icons.calendar_today_outlined, color: AppTheme.accentRose, size: 14),
              const SizedBox(width: AppTheme.spacing8),
              Text(
                dateString,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.textMedium,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _getTimeGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }
}