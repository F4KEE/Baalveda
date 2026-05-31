import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';
import 'dashboard_header.dart';
import 'stats_card.dart';
import 'search_bar.dart';
import 'appointment_card.dart';
import 'review_card.dart';
import 'empty_state.dart';
import 'loading_state.dart';
import '../themes/app_theme.dart';

enum DashboardSection { appointments, reviews }
enum CalendarViewMode { calendar, fullList }

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final supabase = Supabase.instance.client;
  DashboardSection activeSection = DashboardSection.appointments;
  CalendarViewMode calendarMode = CalendarViewMode.calendar;
  
  String searchQuery = '';
  DateTime selectedDate = DateTime.now();
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

  List<Map<String, dynamic>> _processAppointments(List<Map<String, dynamic>> appointments) {
    List<Map<String, dynamic>> workingList = List.from(appointments);

    if (searchQuery.isNotEmpty) {
      workingList = workingList.where((a) =>
          a['patient_name']?.toString().toLowerCase().contains(searchQuery.toLowerCase()) ?? false).toList();
    }

    if (calendarMode == CalendarViewMode.calendar) {
      final targetDateStr = DateFormat('yyyy-MM-dd').format(selectedDate);
      return workingList.where((a) => a['appointment_date'] == targetDateStr).toList();
    } else {
      workingList.sort((a, b) {
        String dateA = a['appointment_date'] ?? '';
        String dateB = b['appointment_date'] ?? '';
        int comp = dateA.compareTo(dateB);
        if (comp != 0) return comp;
        return (a['appointment_time'] ?? '').toString().compareTo((b['appointment_time'] ?? '').toString());
      });
      return workingList;
    }
  }

  Map<String, dynamic> _calculateReviewMetrics(List<Map<String, dynamic>> reviews) {
    if (reviews.isEmpty) return {'avg': 0.0, 'count': 0};
    double total = 0;
    for (var r in reviews) {
      total += (r['rating'] as num?)?.toDouble() ?? 0.0;
    }
    return {'avg': total / reviews.length, 'count': reviews.length};
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
          // Ambient Paint Wash Overlay Background Layers
          Positioned.fill(child: Container(color: AppTheme.backgroundLight)),
          Positioned(
            top: -120, left: -120,
            child: Container(
              width: 380, 
              height: 380, 
              decoration: BoxDecoration(
                shape: BoxShape.circle, 
                color: AppTheme.accentPink.withValues(alpha: 0.07),
              ),
            ),
          ),
          Positioned(
            top: 220, right: -160,
            child: Container(
              width: 520, 
              height: 520, 
              decoration: BoxDecoration(
                shape: BoxShape.circle, 
                color: AppTheme.primaryBlue.withValues(alpha: 0.05),
              ),
            ),
          ),
          
          // Using a single top-level CustomScrollView to handle layout rendering beautifully
          SafeArea(
            bottom: false,
            child: RefreshIndicator(
              key: _refreshIndicatorKey,
              onRefresh: _refresh,
              color: AppTheme.primaryBlue,
              child: CustomScrollView(
                slivers: [
                  // 1. App Header Layout Module
                  const SliverToBoxAdapter(
                    child: DashboardHeader(doctorName: 'Doctor'),
                  ),
                  
                  // 2. Navigation Switcher Module (Tab Switcher)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacing24, vertical: AppTheme.spacing12),
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEAECEF), 
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: _NavigationTab(
                                label: 'Appointments',
                                icon: Icons.assignment_outlined,
                                isActive: activeSection == DashboardSection.appointments,
                                onTap: () => setState(() => activeSection = DashboardSection.appointments),
                              ),
                            ),
                            Expanded(
                              child: _NavigationTab(
                                label: 'Patient Reviews',
                                icon: Icons.star_outline_rounded,
                                isActive: activeSection == DashboardSection.reviews,
                                onTap: () => setState(() => activeSection = DashboardSection.reviews),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // 3. Dynamic Section Routing
                  if (activeSection == DashboardSection.appointments)
                    ..._buildSliverAppointmentsSection()
                  else
                    ..._buildSliverReviewsSection(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildSliverAppointmentsSection() {
    return [
      StreamBuilder<List<Map<String, dynamic>>>(
        stream: supabase.from('appointments').stream(primaryKey: ['id']).order('created_at', ascending: false),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SliverFillRemaining(hasScrollBody: false, child: LoadingStateWidget());
          }
          if (snapshot.hasError) {
            return SliverFillRemaining(
              hasScrollBody: false,
              child: EmptyStateWidget(title: 'Sync Error', subtitle: 'Unable to access live queue data.', icon: Icons.cloud_off, onRetry: _refresh),
            );
          }
          
          final allAppointments = snapshot.data ?? [];
          final todayCount = _getTodayAppointmentCount(allAppointments);
          final filteredList = _processAppointments(allAppointments);

          return SliverMainAxisGroup(
            slivers: [
              // Responsive Statistics Dashboard Area
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacing24, vertical: AppTheme.spacing8),
                  child: Row(
                    children: [
                      Expanded(
                        child: StatsCard(
                          title: 'Patients',
                          value: allAppointments.length.toString(),
                          icon: Icons.people_outline_rounded,
                          accentColor: AppTheme.primaryBlue,
                          subtitle: 'Total registered',
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: StatsCard(
                          title: "Today's Load",
                          value: todayCount.toString(),
                          icon: Icons.today_rounded,
                          accentColor: AppTheme.accentPink,
                          subtitle: 'Pending slots',
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Calendar Mode Toggles
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacing24, vertical: AppTheme.spacing8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Scheduler Scope', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppTheme.primaryBlue, fontWeight: FontWeight.w700)),
                      TextButton.icon(
                        onPressed: () => setState(() {
                          calendarMode = calendarMode == CalendarViewMode.calendar ? CalendarViewMode.fullList : CalendarViewMode.calendar;
                        }),
                        icon: Icon(calendarMode == CalendarViewMode.calendar ? Icons.format_list_bulleted_rounded : Icons.calendar_today_rounded, size: 16, color: AppTheme.accentPink),
                        label: Text(calendarMode == CalendarViewMode.calendar ? 'View Full List' : 'View Matrix', style: const TextStyle(color: AppTheme.accentPink, fontSize: 12, fontWeight: FontWeight.w700)),
                      )
                    ],
                  ),
                ),
              ),

              // Horizontal Interactive Calendar Slider Strip
              if (calendarMode == CalendarViewMode.calendar)
                SliverToBoxAdapter(
                  child: Container(
                    height: 85,
                    margin: const EdgeInsets.only(bottom: AppTheme.spacing8),
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
                              color: isSelected ? AppTheme.primaryBlue : AppTheme.surfaceWhite,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: isSelected ? AppTheme.primaryBlue : AppTheme.dividerColor, width: 1),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(DateFormat('E').format(day).toUpperCase(), style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: isSelected ? Colors.white70 : AppTheme.textLight)),
                                const SizedBox(height: 2),
                                Text(day.day.toString(), style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: isSelected ? Colors.white : AppTheme.textDark)),
                                if (dayHasData) ...[
                                  const SizedBox(height: 4),
                                  Container(width: 4, height: 4, decoration: BoxDecoration(shape: BoxShape.circle, color: AppTheme.accentPink,)),
                                ]
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),

              // Modern Floating Search Bar
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacing24, vertical: AppTheme.spacing8),
                  child: ModernSearchBar(
                    controller: _searchController,
                    hintText: 'Search patient registrations...',
                    onChanged: (val) => setState(() => searchQuery = val),
                  ),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: AppTheme.spacing16)),

              // Patient Appointment Ingestion Stream Queue List
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacing24),
                sliver: filteredList.isEmpty
                    ? const SliverFillRemaining(
                        hasScrollBody: false,
                        child: EmptyStateWidget(title: 'Queue Clear', subtitle: 'No matching upcoming appointments recorded.', icon: Icons.assignment_turned_in_outlined),
                      )
                    : SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) => AppointmentCard(appointment: filteredList[index], onRefresh: _refresh),
                          childCount: filteredList.length,
                        ),
                      ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: AppTheme.spacing32)),
            ],
          );
        },
      ),
    ];
  }

  List<Widget> _buildSliverReviewsSection() {
    return [
      StreamBuilder<List<Map<String, dynamic>>>(
        stream: supabase.from('reviews').stream(primaryKey: ['id']).order('created_at', ascending: false),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SliverFillRemaining(hasScrollBody: false, child: LoadingStateWidget());
          }
          if (snapshot.hasError) {
            return const SliverFillRemaining(
              hasScrollBody: false,
              child: EmptyStateWidget(title: 'Reviews Offline', subtitle: 'Could not resolve the patient feedback stream.', icon: Icons.rate_review_outlined),
            );
          }
          
          final reviews = snapshot.data ?? [];
          final metrics = _calculateReviewMetrics(reviews);

          return SliverMainAxisGroup(
            slivers: [
              // Overall Analytics Card Block
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(AppTheme.spacing24),
                  child: Container(
                    padding: const EdgeInsets.all(AppTheme.spacing20),
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceWhite,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: AppTheme.shadowsSmall,
                      border: Border.all(color: AppTheme.dividerColor),
                    ),
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Reputation Score', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppTheme.textLight)),
                            const SizedBox(height: 4),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.baseline,
                              textBaseline: TextBaseline.alphabetic,
                              children: [
                                Text((metrics['avg'] as double).toStringAsFixed(1), style: const TextStyle(fontSize: 36, fontWeight: FontWeight.w800, color: AppTheme.primaryBlue)),
                                const SizedBox(width: 4),
                                const Text('/ 5.0', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppTheme.textLight)),
                              ],
                            ),
                          ],
                        ),
                        const Spacer(),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Row(
                              children: List.generate(5, (i) {
                                double currentRating = metrics['avg'] as double;
                                return Icon(
                                  i < currentRating.floor() ? Icons.star_rounded : Icons.star_border_rounded,
                                  color: AppTheme.warningOrange,
                                  size: 20,
                                );
                              }),
                            ),
                            const SizedBox(height: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(color: AppTheme.primaryBlue.withValues(alpha: 0.06), borderRadius: BorderRadius.circular(8)),
                              child: Text('${metrics['count']} Patient Reviews', style: const TextStyle(fontSize: 11, color: AppTheme.primaryBlue, fontWeight: FontWeight.w700)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Reviews Ingestion Stream Stack Cards
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacing24),
                sliver: reviews.isEmpty
                    ? const SliverFillRemaining(hasScrollBody: false, child: EmptyStateWidget(title: 'No Reviews Yet', subtitle: 'Patient community feedback reports will gather here.', icon: Icons.rate_review_outlined))
                    : SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) => ReviewCard(review: reviews[index], index: index),
                          childCount: reviews.length,
                        ),
                      ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: AppTheme.spacing32)),
            ],
          );
        },
      ),
    ];
  }
}

class _NavigationTab extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isActive;
  final VoidCallback onTap;

  const _NavigationTab({required this.label, required this.icon, required this.isActive, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isActive ? AppTheme.surfaceWhite : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          boxShadow: isActive ? [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 4, offset: const Offset(0, 2))] : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 16, color: isActive ? AppTheme.primaryBlue : AppTheme.textLight),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                label,
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: isActive ? AppTheme.primaryBlue : AppTheme.textMedium),
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