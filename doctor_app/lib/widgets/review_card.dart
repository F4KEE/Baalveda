import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../themes/app_theme.dart';

class ReviewCard extends StatelessWidget {
  final Map<String, dynamic> review;
  final int index;

  const ReviewCard({super.key, required this.review, required this.index});

  @override
  Widget build(BuildContext context) {
    final name = review['name'] ?? 'Verified Patient';
    final service = review['service'] ?? 'General Consultation';
    final reviewText = review['review_text'] ?? '';
    final rating = (review['rating'] as num?)?.toDouble() ?? 5.0;
    final createdAt = review['created_at'] ?? '';

    String formattedDate = '';
    if (createdAt.isNotEmpty) {
      try {
        formattedDate = DateFormat('MMM d, yyyy').format(DateTime.parse(createdAt));
      } catch (_) {
        formattedDate = createdAt;
      }
    }

    return AnimatedOpacity(
      opacity: 1.0,
      duration: Duration(milliseconds: 300 + (index * 50)),
      curve: Curves.easeOut,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: AppTheme.spacing8),
        decoration: BoxDecoration(
          color: AppTheme.surfaceWhite,
          borderRadius: BorderRadius.circular(16),
          boxShadow: AppTheme.shadowsSmall,
          border: Border.all(color: AppTheme.dividerColor),
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.spacing16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Segment Row
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 40, height: 40,
                    decoration: BoxDecoration(
                      color: AppTheme.primaryBlue.withValues(alpha: 0.06),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        name.isNotEmpty ? name[0].toUpperCase() : 'P',
                        style: const TextStyle(color: AppTheme.primaryBlue, fontSize: 15, fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppTheme.spacing12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(name, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppTheme.textDark), maxLines: 1, overflow: TextOverflow.ellipsis),
                        const SizedBox(height: 2),
                        Text(service, style: const TextStyle(fontSize: 12, color: AppTheme.textLight, fontWeight: FontWeight.w500), maxLines: 1, overflow: TextOverflow.ellipsis),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        children: List.generate(5, (i) {
                          return Icon(
                            i < rating.floor() ? Icons.star_rounded : Icons.star_border_rounded,
                            color: AppTheme.warningOrange,
                            size: 14,
                          );
                        }),
                      ),
                      if (formattedDate.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(formattedDate, style: const TextStyle(fontSize: 10, color: AppTheme.textLight, fontWeight: FontWeight.w400)),
                      ],
                    ],
                  ),
                ],
              ),
              
              // Review Narrative Block Content
              if (reviewText.isNotEmpty) ...[
                const SizedBox(height: AppTheme.spacing12),
                Text(
                  reviewText,
                  style: const TextStyle(fontSize: 13, color: AppTheme.textMedium, height: 1.4, fontWeight: FontWeight.w400),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}