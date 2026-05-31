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
        top: AppTheme.spacing24,
        bottom: AppTheme.spacing8,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Elegant Web Branding Sync Bar
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 36, height: 36,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(colors: [AppTheme.accentPink, Color(0xFFF472B6)]),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Center(
                      child: Text('|| B ||', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w900)),
                    ),
                  ),
                  const SizedBox(width: AppTheme.spacing12),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('baalveda', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: AppTheme.primaryBlue, letterSpacing: 0.2)),
                      Text('HEALTHCARE', style: TextStyle(fontSize: 8, fontWeight: FontWeight.w800, color: AppTheme.textLight, letterSpacing: 1.0)),
                    ],
                  ),
                ],
              ),
              Container(
                width: 38, height: 38,
                decoration: BoxDecoration(color: AppTheme.surfaceWhite, shape: BoxShape.circle, border: Border.all(color: AppTheme.dividerColor)),
                child: const Icon(Icons.person_outline_rounded, color: AppTheme.primaryBlue, size: 18),
              )
            ],
          ),
          const SizedBox(height: AppTheme.spacing24),
          
          Text('$timeGreeting,', style: const TextStyle(fontSize: 14, color: AppTheme.textMedium, fontWeight: FontWeight.w500)),
          
          // FIXED: Displays EXACTLY what is passed down ("Doctor") without adding any "Dr." prefix elements.
          Text(
            doctorName, 
            style: Theme.of(context).textTheme.displayMedium,
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(Icons.calendar_today_outlined, color: AppTheme.accentPink, size: 12),
              const SizedBox(width: 6),
              Text(dateString, style: const TextStyle(fontSize: 12, color: AppTheme.textMedium, fontWeight: FontWeight.w600)),
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