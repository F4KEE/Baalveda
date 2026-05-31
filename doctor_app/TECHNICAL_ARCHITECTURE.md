# Baalveda Doctor Dashboard - Technical Architecture

**Purpose**: Comprehensive technical documentation for developers and maintainers.

---

## 📐 Architecture Overview

```
┌─────────────────────────────────────────────────────────────┐
│                     MyApp (Main)                             │
│                   MaterialApp with Theme                      │
└────────────────────┬────────────────────────────────────────┘
                     │
         ┌───────────▼────────────┐
         │   DashboardPage        │ ← Main container
         │   (StatefulWidget)     │
         └───────────┬────────────┘
                     │
        ┌────────────┼────────────┐
        │            │            │
     ┌──▼──┐    ┌───▼───┐   ┌───▼────┐
     │Header    │ Stats  │   │ Search │
     │Component │ Cards  │   │ Bar    │
     └──────┘   └───────┘   └────────┘
                     │
            ┌────────▼────────┐
            │ Appointment     │
            │ Cards (List)    │
            └─────────────────┘
```

---

## 🏗️ Component Hierarchy

### DashboardPage (Root Container)
- **Purpose**: Main orchestrator, handles data flow
- **Type**: StatefulWidget
- **State Management**: setState()
- **Key Methods**:
  - `_refresh()`: Triggers refresh indicator
  - `_getTodayAppointmentCount()`: Calculates today's stats
  - `_filterAppointments()`: Filters by search query

### DashboardHeader
- **Purpose**: Premium header with branding
- **Type**: StatelessWidget
- **Props**:
  - `doctorName`: String for personalization
- **Sub-components**:
  - Brand logo and name
  - Time-based greeting
  - Current date

### StatsCard
- **Purpose**: Animated statistics display
- **Type**: StatefulWidget
- **State Management**: AnimationController
- **Features**:
  - Number animation (0 → value)
  - Scale animation
  - Icon badge
  - Configurable colors
- **Props**:
  - `title`: String
  - `value`: String
  - `icon`: IconData
  - `accentColor`: Color
  - `subtitle`: String

### ModernSearchBar
- **Purpose**: Animated search input
- **Type**: StatefulWidget
- **Features**:
  - Focus animation
  - Clear button
  - Border color animation
- **Props**:
  - `controller`: TextEditingController?
  - `hintText`: String
  - `onChanged`: ValueChanged<String>

### AppointmentCard
- **Purpose**: Premium appointment display
- **Type**: StatefulWidget
- **Features**:
  - Patient avatar
  - Slide + fade animations
  - Call button with loading
  - Today indicator
  - Color-coded detail icons
- **Props**:
  - `appointment`: Map<String, dynamic>
  - `onRefresh`: VoidCallback?
- **Sub-components**:
  - `_DetailItem`: Icon + label + value

### EmptyStateWidget
- **Purpose**: No data display
- **Type**: StatelessWidget
- **Use Cases**:
  - No appointments
  - Search returned 0 results
  - Error occurred
- **Props**:
  - `title`: String
  - `subtitle`: String
  - `icon`: IconData
  - `onRetry`: VoidCallback?

### LoadingStateWidget
- **Purpose**: Data loading display
- **Type**: StatefulWidget
- **Features**:
  - Animated pulsing circle
  - Loading text
  - Smooth transitions

---

## 🔄 Data Flow

```
Supabase Stream
    │
    ▼
StreamBuilder (connection handling)
    │
    ├─ Waiting → LoadingStateWidget
    ├─ Error → EmptyStateWidget (error state)
    ├─ Empty → EmptyStateWidget (no data)
    │
    ▼
AppointmentData (list)
    │
    ├─ _getTodayAppointmentCount() → Today count
    ├─ _filterAppointments() → Filtered list
    │
    ▼
DashboardPage (render)
    │
    ├─ DashboardHeader (display)
    ├─ StatsCard × 2 (show counts)
    ├─ ModernSearchBar (search input)
    │
    ▼
AppointmentCard × N (list items)
    │
    ▼
User Actions
    │
    ├─ Search → Update searchQuery state
    ├─ Call → Launch tel: URL
    ├─ Refresh → StreamBuilder refreshes
```

---

## 🎨 State Management

### DashboardPage State Variables
```dart
final supabase = Supabase.instance.client;      // Supabase client
String searchQuery = '';                         // Current search
final TextEditingController _searchController;   // Search input
final GlobalKey<RefreshIndicatorState> key;      // Refresh control
```

### StatsCard State Variables
```dart
late AnimationController _animationController;   // Animation control
late Animation<double> _scaleAnimation;          // Scale animation
late Animation<int> _countAnimation;            // Number animation
```

### ModernSearchBar State Variables
```dart
late AnimationController _animationController;   // Animation control
late Animation<double> _focusAnimation;         // Focus animation
late FocusNode _focusNode;                      // Focus tracking
bool _isFocused = false;                        // Focus state
```

### AppointmentCard State Variables
```dart
late AnimationController _animationController;   // Animation control
late Animation<double> _slideAnimation;         // Slide animation
bool _isCalling = false;                        // Call state
```

---

## 🔌 External Dependencies

### Core Packages
- **flutter**: UI framework
- **supabase_flutter**: Real-time database
- **intl**: Date/time formatting
- **url_launcher**: Phone call integration

### No External UI Packages
- All UI built with Material 3
- No GetX, Provider, or Riverpod (kept simple)
- State management via StatefulWidget (suitable for current scope)

---

## 📊 Data Models

### Appointment Model (Not explicit, but expected)
```dart
{
  'id': String,                    // UUID
  'patient_name': String,          // Name display
  'phone': String,                 // Call target
  'doctor': String,                // Doctor assignment
  'appointment_date': String,      // YYYY-MM-DD format
  'appointment_time': String,      // HH:MM format
  'created_at': String,            // Timestamp
}
```

---

## 🎬 Animation System

### Animation Pattern
```dart
AnimationController _controller = AnimationController(
  duration: Duration(milliseconds: 600),
  vsync: this,  // Important: prevents memory leaks
);

Animation<double> _animation = Tween<double>(
  begin: 0.0,
  end: 1.0,
).animate(CurvedAnimation(
  parent: _controller,
  curve: Curves.easeOutCubic,  // Smooth deceleration
));

@override
void dispose() {
  _controller.dispose();  // Critical for memory management
  super.dispose();
}

@override
void initState() {
  super.initState();
  _controller.forward();  // Start animation
}
```

### Animation Types Used
1. **Scale**: Stats card entrance (0.8 → 1.0)
2. **Count**: Number animation (0 → value)
3. **Slide**: Appointment card entrance
4. **Fade**: Appointment card entrance
5. **Color**: Search bar focus state
6. **Border**: Search bar focus state

---

## 🎯 Theme System

### Theme Architecture
```
AppTheme
├── Colors (constants)
│   ├── Primary (Blue)
│   ├── Accent (Pink)
│   ├── Background
│   └── Text variants
├── Spacing (constants)
│   ├── 2px - 32px
│   └── Used for padding/margins
├── Radius (constants)
│   ├── Small (8px)
│   ├── Medium (12px)
│   ├── Large (16px)
│   └── XL (20px)
├── Shadows (static)
│   ├── Small
│   ├── Medium
│   └── Large
└── ThemeData (getter)
    ├── Typography
    ├── Component themes
    ├── Color scheme
    └── Input decoration
```

### Theme Usage
```dart
// In any widget
Theme.of(context).textTheme.titleLarge
AppTheme.primaryBlue
AppTheme.spacing16
AppTheme.shadowsMedium
```

---

## 🔍 Error Handling

### Connection States
```dart
ConnectionState.waiting   → LoadingStateWidget()
ConnectionState.error     → EmptyStateWidget (error)
snapshot.data == null     → EmptyStateWidget (no data)
snapshot.data.isEmpty     → EmptyStateWidget (no data)
```

### Call Error Handling
```dart
try {
  await launchUrl(Uri.parse('tel:$phone'));
} catch (e) {
  // Show snackbar error message
  ScaffoldMessenger.of(context).showSnackBar(...);
} finally {
  // Reset loading state
  setState(() => _isCalling = false);
}
```

---

## 📱 Responsive Behavior

### Breakpoints
```dart
Desktop: > 1200px
Tablet:  600px - 1200px
Mobile:  < 600px
```

### Current Implementation
- All sizes use same layout
- 2-column stat cards adapt to available space
- SingleChildScrollView enables scroll on overflow
- Padding adjusts proportionally

### Future: Tablet Layout
```dart
if (MediaQuery.of(context).size.width > 800) {
  // Show 3-column layout
  // Larger card sizes
} else {
  // Current mobile layout
}
```

---

## 🚀 Performance Considerations

### Memory Management
- AnimationControllers properly disposed
- StreamBuilder cancels subscription on dispose
- FocusNodes properly managed
- TextEditingControllers properly disposed

### Build Optimization
- StreamBuilder only rebuilds when data changes
- Individual AnimationBuilders for animations
- Const constructors where possible
- Efficient filtering (map, where, toList)

### Data Fetching
- Supabase streaming (not polling)
- Real-time updates without delay
- Order by created_at for natural order

---

## 🧪 Testing Strategy

### Unit Tests (Future)
```dart
// Test data filtering
test('filterAppointments filters by patient name', () {
  // Arrange
  // Act
  // Assert
});
```

### Widget Tests (Future)
```dart
testWidgets('StatsCard animates on creation', (tester) async {
  // Build widget
  // Verify animations
});
```

### Integration Tests (Future)
```dart
testIntegration('Full appointment flow', (driver) async {
  // Navigate
  // Search
  // Call patient
  // Verify
});
```

---

## 🔐 Security Considerations

### Current Implementation
- Supabase authentication (configured elsewhere)
- URL launcher for safe phone calls
- No sensitive data in logs
- No hardcoded secrets (env vars use constants)

### Future Improvements
- Add JWT token refresh
- Implement app-level authentication
- Add role-based access control
- Audit logging for calls

---

## 📈 Scalability Path

### Phase 1: Current (Single Doctor)
- One dashboard per doctor
- Real-time appointment updates
- Simple filtering

### Phase 2: Multi-Doctor (Future)
- Doctor selection dropdown
- Multiple dashboard instances
- Doctor-specific filtering

### Phase 3: Advanced (Future)
- Clinic/clinic admin dashboard
- Analytics and reporting
- Automated reminders
- Video consultation integration

### Phase 4: Enterprise (Future)
- Multi-clinic support
- Advanced analytics
- AI-powered recommendations
- Mobile app for patients

---

## 🛠️ Debugging Tips

### Enable Debug Logs
```dart
// In main.dart
debugPrint('Debug info here');
```

### Stream Debugging
```dart
// Check what's coming from Supabase
stream: supabase
    .from('appointments')
    .stream(...)
    .handleError((error) {
      debugPrint('Stream error: $error');
    })
```

### Animation Debugging
```dart
// Add animation listener
_animationController.addListener(() {
  debugPrint('Animation value: ${_animation.value}');
});
```

---

## 📚 Code Organization Principles

1. **Single Responsibility**: Each widget does one thing
2. **DRY (Don't Repeat Yourself)**: Shared code in utils/themes
3. **Composition**: Build complex UIs from simple widgets
4. **Constants**: No magic numbers
5. **Documentation**: Clear comments for complex logic
6. **Naming**: Clear, descriptive variable names

---

## 🔄 CI/CD Pipeline (Recommended)

```yaml
.github/workflows/flutter.yml
├── Install dependencies
├── Analyze code (flutter analyze)
├── Run tests (flutter test)
├── Build APK
├── Build IPA
└── Deploy to stores
```

---

## 📞 Support & Maintenance

### Known Limitations
- No offline mode (requires internet)
- No local caching
- No push notifications
- Single-doctor only

### Future Enhancements
- [ ] Dark theme
- [ ] Multi-language support
- [ ] Offline mode
- [ ] Patient profile
- [ ] Appointment history
- [ ] Call recording
- [ ] SMS reminders
- [ ] Video consultation

---

## 📝 Version History

**2.0.0** (May 31, 2026)
- Complete premium redesign
- Material 3 implementation
- Added animations
- Improved UX significantly

**1.0.0** (Initial)
- Basic functionality
- Simple UI

---

## 👨‍💻 Developer Guidelines

### Code Style
- Follow Flutter best practices
- Use meaningful variable names
- Add documentation comments
- Use const constructors
- Prefer composition over inheritance

### Commit Messages
```
fix: phone call button loading state
feat: add dark theme support
refactor: extract header to separate widget
docs: update customization guide
```

### Pull Request Process
1. Create feature branch
2. Make changes with tests
3. Run flutter analyze
4. Create PR with description
5. Request review
6. Merge after approval

---

**Last Updated**: May 31, 2026
**Version**: 2.0.0
**Maintainers**: Flutter Team
