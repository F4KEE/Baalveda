import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';
import 'dashboard_header.dart';
import 'stats_card.dart';
import 'search_bar.dart';
import 'appointment_card.dart';
import 'empty_state.dart';
import 'loading_state.dart';
import '../themes/app_theme.dart';

enum CalendarViewMode { calendar, fullList }

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final supabase = Supabase.instance.client;
  String searchQuery = '';
  DateTime selectedDate = DateTime.now();
  CalendarViewMode viewMode = CalendarViewMode.calendar;
  
  final TextEditingController _searchController = TextEditingController();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

  final List<DateTime> _calendarDays = List.generate(14, (index) => DateTime.now().add(Duration(days: index - 3)));

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _refresh() async {
    setState(() {});
  }

  int _getTodayAppointmentCount(List<Map<String, dynamic>> appointments) {
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    return appointments.where((a) => a['appointment_date'] == today).length;
  }

  List<Map<String, dynamic>> _processAndSortAppointments(List<Map<String, dynamic>> appointments) {
    List<Map<String, dynamic>> workingList = List.from(appointments);

    if (searchQuery.isNotEmpty) {
      workingList = workingList.where((appointment) =>
          appointment['patient_name']?.toString().toLowerCase().contains(searchQuery.toLowerCase()) ?? false).toList();
    }

    if (viewMode == CalendarViewMode.calendar) {
      final targetDateStr = DateFormat('yyyy-MM-dd').format(selectedDate);
      return workingList.where((a) => a['appointment_date'] == targetDateStr).toList();
    } else {
      workingList.sort((a, b) {
        String dateA = a['appointment_date'] ?? '';
        String dateB = b['appointment_date'] ?? '';
        int dateCompare = dateA.compareTo(dateB);
        if (dateCompare != 0) return dateCompare;
        
        String timeA = a['appointment_time'] ?? '';
        String timeB = b['appointment_time'] ?? '';
        return timeA.compareTo(timeB);
      });
      return workingList;
    }
  }

  bool _dayHasAppointments(List<Map<String, dynamic>> appointments, DateTime date) {
    final dateStr = DateFormat('yyyy-MM-dd').format(date);
    return appointments.any((a) => a['appointment_date'] == dateStr);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Base Clean Canvas Workspace
          Positioned.fill(
            child: Container(
              color: const Color(0xFFF6F7FA),
            ),
          ),
          // Ambient Paint Wash Overlays
          Positioned(
            top: -120,
            left: -120,
            child: Container(
              width: 380,
              height: 380,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppTheme.accentRose.withValues(alpha: 0.07),
              ),
            ),
          ),
          Positioned(
            top: 220,
            right: -160,
            child: Container(
              width: 520,
              height: 520,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppTheme.primaryNavy.withValues(alpha: 0.05),
              ),
            ),
          ),
          Positioned(
            bottom: -60,
            left: -60,
            child: Container(
              width: 280,
              height: 280,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppTheme.accentRose.withValues(alpha: 0.04),
              ),
            ),
          ),
          
          // Foreground Scroll Workspace View
          SafeArea(
            bottom: false,
            child: StreamBuilder<List<Map<String, dynamic>>>(
              stream: supabase.from('appointments').stream(primaryKey: ['id']).order('created_at', ascending: false),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const LoadingStateWidget();
                }
                if (snapshot.hasError) {
                  return EmptyStateWidget(
                    title: 'Connection Latency',
                    subtitle: 'Unable to access your live clinic registry data right now.',
                    icon: Icons.cloud_off_rounded,
                    onRetry: () => setState(() {}),
                  );
                }

                final allAppointments = snapshot.data ?? [];
                final todayCount = _getTodayAppointmentCount(allAppointments);
                final displayAppointments = _processAndSortAppointments(allAppointments);

                return RefreshIndicator(
                  key: _refreshIndicatorKey,
                  onRefresh: _refresh,
                  color: AppTheme.primaryNavy,
                  child: CustomScrollView(
                    slivers: [
                      SliverToBoxAdapter(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const DashboardHeader(doctorName: 'Admin'),
                            const SizedBox(height: AppTheme.spacing12),
                            
                            // RESPONSIVE Metric Row Panel Implementation
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacing24),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: StatsCard(
                                      title: 'Patients', // Shortened label to guarantee mobile layout safety
                                      value: allAppointments.length.toString(),
                                      icon: Icons.people_outline_rounded,
                                      accentColor: AppTheme.primaryNavy,
                                      subtitle: 'Total registered', // Shortened sub-text
                                    ),
                                  ),
                                  const SizedBox(width: 12), // Tightly optimized flex spacing block
                                  Expanded(
                                    child: StatsCard(
                                      title: "Today's Load", 
                                      value: todayCount.toString(),
                                      icon: Icons.today_rounded,
                                      accentColor: AppTheme.accentRose,
                                      subtitle: 'Pending slots',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: AppTheme.spacing24),

                            // Segmented View Toggle Tab Controllers
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacing24),
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFEAECEF),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: _ToggleTab(
                                        label: 'Calendar Matrix',
                                        icon: Icons.calendar_view_month_rounded,
                                        isActive: viewMode == CalendarViewMode.calendar,
                                        onTap: () => setState(() => viewMode = CalendarViewMode.calendar),
                                      ),
                                    ),
                                    Expanded(
                                      child: _ToggleTab(
                                        label: 'Full Ascending List',
                                        icon: Icons.format_list_bulleted_rounded,
                                        isActive: viewMode == CalendarViewMode.fullList,
                                        onTap: () => setState(() => viewMode = CalendarViewMode.fullList),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: AppTheme.spacing24),

                            // Conditional Timeline Calendar Strip View Layer
                            if (viewMode == CalendarViewMode.calendar) ...[
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacing24),
                                child: Text(
                                  'Clinic Scheduler Matrix', 
                                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    color: AppTheme.primaryNavy, 
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              const SizedBox(height: AppTheme.spacing12),
                              SizedBox(
                                height: 85,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacing20),
                                  itemCount: _calendarDays.length,
                                  itemBuilder: (context, index) {
                                    final day = _calendarDays[index];
                                    final isSelected = day.year == selectedDate.year && day.month == selectedDate.month && day.day == selectedDate.day;
                                    final dayHasData = _dayHasAppointments(allAppointments, day);
                                    
                                    return GestureDetector(
                                      onTap: () => setState(() => selectedDate = day),
                                      child: AnimatedContainer(
                                        duration: const Duration(milliseconds: 200),
                                        width: 58,
                                        margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: isSelected ? AppTheme.primaryNavy : AppTheme.surfacePure,
                                          borderRadius: BorderRadius.circular(14),
                                          border: Border.all(color: isSelected ? AppTheme.primaryNavy : AppTheme.borderMuted, width: 1),
                                        ),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              DateFormat('E').format(day).toUpperCase(),
                                              style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: isSelected ? Colors.white70 : AppTheme.textLight),
                                            ),
                                            const SizedBox(height: 2),
                                            Text(
                                              day.day.toString(),
                                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: isSelected ? Colors.white : AppTheme.textDark),
                                            ),
                                            if (dayHasData) ...[
                                              const SizedBox(height: 4),
                                              Container(
                                                width: 4, 
                                                height: 4, 
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle, 
                                                  color: isSelected ? AppTheme.accentRose : AppTheme.accentRose.withValues(alpha: 0.5),
                                                ),
                                              ),
                                            ]
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(height: AppTheme.spacing24),
                            ],

                            // Search Filter Text Panel Component
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacing24),
                              child: ModernSearchBar(
                                controller: _searchController,
                                hintText: 'Search patients by name standard...',
                                onChanged: (value) => setState(() => searchQuery = value),
                              ),
                            ),
                            const SizedBox(height: AppTheme.spacing24),

                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacing24),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    viewMode == CalendarViewMode.calendar ? 'Day Queue Schedule' : 'All Bookings (Ascending)',
                                    style: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppTheme.primaryNavy, fontWeight: FontWeight.w700),
                                  ),
                                  Text(
                                    '${displayAppointments.length} matching',
                                    style: const TextStyle(fontSize: 12, color: AppTheme.textLight, fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: AppTheme.spacing8),
                          ],
                        ),
                      ),
                      
                      // Infinite Scrollable Queue Stream Cards List
                      SliverPadding(
                        padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacing24),
                        sliver: displayAppointments.isEmpty
                            ? const SliverFillRemaining(
                                hasScrollBody: false,
                                child: Padding(
                                  padding: EdgeInsets.symmetric(vertical: 40.0),
                                  child: EmptyStateWidget(
                                    title: 'Clear Patient Matrix',
                                    subtitle: 'No records match the current view criteria parameters.',
                                    icon: Icons.assignment_turned_in_outlined,
                                  ),
                                ),
                              )
                            : SliverList(
                                delegate: SliverChildBuilderDelegate(
                                  (context, index) {
                                    return AppointmentCard(
                                      appointment: displayAppointments[index],
                                      onRefresh: _refresh,
                                    );
                                  },
                                  childCount: displayAppointments.length,
                                ),
                              ),
                      ),
                      const SliverToBoxAdapter(child: SizedBox(height: AppTheme.spacing32)),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ToggleTab extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isActive;
  final VoidCallback onTap;

  const _ToggleTab({required this.label, required this.icon, required this.isActive, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isActive ? AppTheme.surfacePure : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          boxShadow: isActive ? [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 4, offset: const Offset(0, 2))] : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 16, color: isActive ? AppTheme.primaryNavy : AppTheme.textLight),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                label,
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: isActive ? AppTheme.primaryNavy : AppTheme.textMedium),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}