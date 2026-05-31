import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../themes/app_theme.dart';

class AppointmentCard extends StatefulWidget {
  final Map<String, dynamic> appointment;
  final VoidCallback? onRefresh;

  const AppointmentCard({super.key, required this.appointment, this.onRefresh});

  @override
  State<AppointmentCard> createState() => _AppointmentCardState();
}

class _AppointmentCardState extends State<AppointmentCard> {
  bool _isCalling = false;

  Future<void> _makeCall() async {
    final phone = widget.appointment['phone'] ?? '';
    if (phone.isEmpty) return;
    setState(() => _isCalling = true);

    try {
      await launchUrl(Uri.parse('tel:$phone'));
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Could not launch dialer'), backgroundColor: AppTheme.primaryNavy));
      }
    } finally {
      if (mounted) setState(() => _isCalling = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final appointment = widget.appointment;
    final patientName = appointment['patient_name'] ?? 'Unknown Patient';
    final phone = appointment['phone'] ?? 'N/A';
    final doctor = appointment['doctor'] ?? 'Not assigned';
    final appointmentTime = appointment['appointment_time'] ?? '--:--';
    final appointmentDate = appointment['appointment_date'] ?? '';

    DateTime? parsedDate = DateTime.tryParse(appointmentDate);
    final formattedDate = parsedDate != null ? DateFormat('MMM d, yyyy').format(parsedDate) : appointmentDate;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: AppTheme.spacing8),
      decoration: BoxDecoration(
        color: AppTheme.surfacePure,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppTheme.premiumShadow,
        border: Border.all(color: AppTheme.borderMuted),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacing16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 44, height: 44,
                  decoration: BoxDecoration(color: AppTheme.primaryNavy.withValues(alpha: 0.06), borderRadius: BorderRadius.circular(12)),
                  child: Center(child: Text(patientName.isNotEmpty ? patientName[0].toUpperCase() : 'P', style: const TextStyle(color: AppTheme.primaryNavy, fontSize: 16, fontWeight: FontWeight.w700))),
                ),
                const SizedBox(width: AppTheme.spacing12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(patientName, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 16, color: AppTheme.primaryNavy), maxLines: 1, overflow: TextOverflow.ellipsis),
                      const SizedBox(height: 2),
                      Text('Pediatric & Neonatology Care', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppTheme.textLight, fontSize: 12)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppTheme.spacing16),
            Container(height: 1, color: AppTheme.borderMuted),
            const SizedBox(height: AppTheme.spacing16),
            Row(
              children: [
                Expanded(child: _DetailRow(icon: Icons.access_time_rounded, label: 'Time', value: appointmentTime, color: AppTheme.accentRose)),
                Expanded(child: _DetailRow(icon: Icons.calendar_today_rounded, label: 'Date', value: formattedDate, color: AppTheme.primaryNavy)),
              ],
            ),
            const SizedBox(height: AppTheme.spacing12),
            Row(
              children: [
                Expanded(child: _DetailRow(icon: Icons.person_outline_rounded, label: 'Doctor', value: 'Dr. $doctor', color: AppTheme.textMedium)),
                Expanded(child: _DetailRow(icon: Icons.phone_enabled_outlined, label: 'Phone', value: phone, color: AppTheme.textMedium)),
              ],
            ),
            const SizedBox(height: AppTheme.spacing16),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _isCalling ? null : _makeCall,
                icon: _isCalling 
                    ? const SizedBox(height: 16, width: 16, child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation<Color>(Colors.white)))
                    : const Icon(Icons.call, size: 16),
                label: Text(_isCalling ? 'Calling...' : 'Call Patient'),
                style: FilledButton.styleFrom(backgroundColor: AppTheme.primaryNavy, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), padding: const EdgeInsets.symmetric(vertical: 14), elevation: 0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  const _DetailRow({required this.icon, required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontSize: 10, color: AppTheme.textLight, fontWeight: FontWeight.w500)),
              Text(value, style: const TextStyle(fontSize: 13, color: AppTheme.textDark, fontWeight: FontWeight.w600), maxLines: 1, overflow: TextOverflow.ellipsis),
            ],
          ),
        ),
      ],
    );
  }
}