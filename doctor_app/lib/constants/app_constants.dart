/// Application constants and configuration
class AppConstants {
  // Supabase Configuration
  static const String supabaseUrl = 'https://yafszzizbuojzdtvoprh.supabase.co';
  static const String supabaseAnonKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InlhZnN6eml6YnVvanpkdHZvcHJoIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Nzk2MjIwMzIsImV4cCI6MjA5NTE5ODAzMn0.U04l8OCMwm-2BXw8gE1gUMR5F7qUv-NhlfFcVM5etno';

  // Table names
  static const String appointmentsTable = 'appointments';

  // App branding
  static const String appName = 'Baalveda Healthcare';
  static const String brandName = 'Baalveda';
  static const String brandTagline = 'Premium Pediatric & Neonatology Care';

  // Durations for animations
  static const Duration animationDurationShort = Duration(milliseconds: 300);
  static const Duration animationDurationMedium = Duration(milliseconds: 500);
  static const Duration animationDurationLong = Duration(milliseconds: 800);

  // Appointment related
  static const int maxSearchResults = 100;
  static const String dateFormatPattern = 'yyyy-MM-dd';

  // Error messages
  static const String errorLoadingAppointments = 'Failed to load appointments';
  static const String errorMakingCall = 'Could not launch dialer';
  static const String errorNoAppointments = 'No appointments found';

  // Success messages
  static const String callInitiated = 'Call initiated';
  static const String refreshSuccess = 'Appointments refreshed';
}
