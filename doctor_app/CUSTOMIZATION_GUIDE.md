# Baalveda Doctor Dashboard - Customization Guide

Quick reference for common customizations and configurations.

## 🎨 Design Customizations

### Changing Brand Colors

Edit `lib/themes/app_theme.dart`:

```dart
// Primary blue - change this
static const Color primaryBlue = Color(0xFF1A2F7F);

// Accent pink - change this
static const Color accentPink = Color(0xFFEF4A64);

// Background - change this
static const Color backgroundLight = Color(0xFFF8F9FA);
```

### Changing Doctor Name

Edit `lib/widgets/dashboard_page.dart`:

```dart
// Line 200 (approximately)
const DashboardHeader(doctorName: 'Your Name Here')
```

### Adjusting Spacing

All spacing uses the centralized system in `app_theme.dart`:

```dart
// Current spacing values
spacing2, spacing4, spacing6, spacing8, spacing12, 
spacing16, spacing20, spacing24, spacing32
```

To change global spacing, modify these constants.

### Adjusting Animation Duration

**Stats Card Animation:**
```dart
// In lib/widgets/stats_card.dart, line 30
AnimationController(
  duration: const Duration(milliseconds: 600),  // Change here
  vsync: this,
);
```

**Appointment Card Animation:**
```dart
// In lib/widgets/appointment_card.dart, line 30
AnimationController(
  duration: const Duration(milliseconds: 500),  // Change here
  vsync: this,
);
```

**Search Bar Animation:**
```dart
// In lib/widgets/search_bar.dart, line 34
AnimationController(
  duration: const Duration(milliseconds: 300),  // Change here
  vsync: this,
);
```

### Changing Border Radius

Edit `lib/themes/app_theme.dart`:

```dart
// Border Radius values
static const double radiusSmall = 8;      // Change to 4 for less rounded
static const double radiusMedium = 12;    // Change for cards
static const double radiusLarge = 16;     // Change for main cards
static const double radiusXL = 20;        // Change for large elements
```

### Changing Typography

Edit `lib/themes/app_theme.dart`, `textTheme:` section:

```dart
displayLarge: TextStyle(
  fontSize: 32,           // Change size
  fontWeight: FontWeight.w700,  // Change weight
  letterSpacing: -1,      // Change letter spacing
),
```

## 🔧 Feature Customizations

### Change Search Placeholder

Edit `lib/widgets/dashboard_page.dart`:

```dart
ModernSearchBar(
  hintText: 'Search by patient name...',  // Change this
  // ... rest of parameters
);
```

### Change Appointment Card Details

Edit `lib/widgets/appointment_card.dart`, in the `_DetailItem` row:

```dart
// Add or remove detail items here
// Currently shows: Phone, Doctor, Date, Time
```

### Change Stats Card Metrics

Edit `lib/widgets/dashboard_page.dart`:

```dart
StatsCard(
  title: 'Total',        // Change title
  value: appointments.length.toString(),
  icon: Icons.calendar_month,  // Change icon
  accentColor: AppTheme.primaryBlue,  // Change color
  subtitle: 'appointments',  // Change subtitle
),
```

### Customize Header Gradient

Edit `lib/widgets/dashboard_header.dart`:

```dart
decoration: BoxDecoration(
  gradient: LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      AppTheme.primaryBlue,
      AppTheme.primaryBlue.withValues(alpha: 0.85),  // Adjust alpha
    ],
  ),
),
```

## 📱 Responsive Adjustments

### Add Tablet-Specific Layout

Wrap your content in:

```dart
if (MediaQuery.of(context).size.width > 600) {
  // Tablet layout (3 columns instead of 2)
} else {
  // Mobile layout (current)
}
```

### Adjust Card Size

Edit card widths in `lib/widgets/dashboard_page.dart`:

```dart
Row(
  children: [
    Expanded(flex: 1, child: ...),  // Change flex to adjust ratio
  ],
)
```

## 🔌 Integration Customizations

### Change Supabase Table Name

Edit `lib/widgets/dashboard_page.dart`:

```dart
stream: supabase
    .from('your_table_name')  // Change from 'appointments'
    .stream(primaryKey: ['id'])
    .order('created_at', ascending: false),
```

### Add New Appointment Fields

1. Add field to detail grid in `lib/widgets/appointment_card.dart`
2. Update `_DetailItem` widget to display new field
3. Update type hints in `lib/widgets/dashboard_page.dart`

Example:
```dart
// Add new detail item
Expanded(
  child: _DetailItem(
    icon: Icons.location_on,
    label: 'Location',
    value: appointment['location'] ?? 'Not set',
    iconColor: AppTheme.primaryBlue,
  ),
),
```

### Modify Filter Logic

Edit search filtering in `lib/widgets/dashboard_page.dart`:

```dart
List<Map<String, dynamic>> _filterAppointments(
  List<Map<String, dynamic>> appointments,
) {
  if (searchQuery.isEmpty) return appointments;
  
  // Change this filter logic
  return appointments.where((appointment) =>
      appointment['patient_name']
          ?.toString()
          .toLowerCase()
          .contains(searchQuery.toLowerCase()) ??
      false
  ).toList();
}
```

## 📊 Data Customizations

### Modify Statistics Calculation

Edit `lib/widgets/dashboard_page.dart`:

```dart
// Change how today's count is calculated
int _getTodayAppointmentCount(List<Map<String, dynamic>> appointments) {
  final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
  return appointments
      .where((a) => a['appointment_date'] == today)
      .length;
}
```

### Add New Statistic Card

Edit `lib/widgets/dashboard_page.dart`:

```dart
Row(
  children: [
    // Existing cards...
    
    // New card
    Expanded(
      child: StatsCard(
        title: 'Pending',
        value: pendingCount.toString(),
        icon: Icons.hourglass_empty,
        accentColor: AppTheme.warningOrange,
        subtitle: 'pending',
      ),
    ),
  ],
)
```

## 🎭 Theme Variants

### Create a Dark Theme

Add to `lib/themes/app_theme.dart`:

```dart
static ThemeData get darkTheme {
  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    // ... configure dark colors
  );
}
```

Use in `lib/main.dart`:

```dart
MaterialApp(
  theme: AppTheme.lightTheme,
  darkTheme: AppTheme.darkTheme,  // Add this
  themeMode: ThemeMode.system,    // Add this
  home: const DashboardPage(),
)
```

### Create Alternative Color Scheme

```dart
// In app_theme.dart
class AppTheme {
  // Original (Baalveda)
  static const Color primaryBlue = Color(0xFF1A2F7F);
  
  // Alternative option
  static const Color primaryGreen = Color(0xFF059669);
  
  // Use conditional logic to switch
}
```

## 🚀 Advanced Customizations

### Add Bottom Navigation

Create `lib/widgets/bottom_nav.dart` and add to DashboardPage.

### Add Profile Screen

Create `lib/screens/profile_page.dart` and navigate from header.

### Add Appointment Details Screen

Create `lib/screens/appointment_detail.dart` with onTap navigation in AppointmentCard.

### Add Filters

Create `lib/widgets/filter_bar.dart` above the search bar.

### Add Date Range Filter

Modify `_getTodayAppointmentCount` to accept date parameters.

## 🔄 State Management (Future Enhancement)

Current: StatefulWidget
Future: Consider Provider/Riverpod for complex state

```dart
// Future: Use Provider
final appointmentsProvider = StreamProvider((ref) {
  return ref.watch(supabaseProvider).appointments.stream();
});
```

## 🧪 Testing Customizations

### Change Mock Data

Create test data in a test file:

```dart
final mockAppointments = [
  {
    'id': '1',
    'patient_name': 'John Doe',
    'phone': '1234567890',
    'doctor': 'Dr. Smith',
    'appointment_date': '2026-05-31',
    'appointment_time': '10:00 AM',
  },
];
```

## 📝 Common Code Patterns

### Conditional Rendering

```dart
if (isToday) {
  // Show today badge
} else {
  // Show nothing
}
```

### Animation Pattern

```dart
AnimationController _controller = AnimationController(
  duration: Duration(milliseconds: 500),
  vsync: this,
);

Animation<double> _animation = Tween<double>(
  begin: 0,
  end: 1,
).animate(_controller);
```

### Stream Pattern

```dart
StreamBuilder<List<Map<String, dynamic>>>(
  stream: supabase.from('table').stream(...),
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return LoadingWidget();
    }
    final data = snapshot.data ?? [];
    return ListView(...);
  },
)
```

## 🐛 Common Issues & Fixes

### Animations not smooth
- Increase device performance capabilities
- Reduce animation duration
- Use `vsync` properly

### Search not working
- Verify data format
- Check case sensitivity
- Debug with print statements

### Colors not applying
- Clear cache: `flutter clean`
- Restart app completely
- Check color opacity values

### Widgets not rebuilding
- Ensure setState() is called
- Check stream subscription
- Verify listener attachment

## 📚 Additional Resources

- Material Design 3: https://m3.material.io
- Flutter Animations: https://flutter.dev/docs/development/ui/animations
- Supabase Docs: https://supabase.com/docs
- Date Formatting: https://pub.dev/packages/intl

---

**Last Updated**: May 31, 2026
**Version**: 2.0.0
