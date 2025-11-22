import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:iconly/iconly.dart';
import '../../app.dart';
import '../../localization/app_localizations.dart';
import '../../models/plant_care_task.dart';

class CareCalendarScreen extends StatefulWidget {
  const CareCalendarScreen({super.key});

  @override
  State<CareCalendarScreen> createState() => _CareCalendarScreenState();
}

class _CareCalendarScreenState extends State<CareCalendarScreen> {
  late DateTime _visibleMonth;
  late DateTime _selectedDay;

  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime.now();
    _visibleMonth = DateTime(_selectedDay.year, _selectedDay.month);
  }

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    final t = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(t.t('care_calendar')),
        actions: [
          IconButton(
            icon: const Icon(IconlyLight.time_circle),
            onPressed: () => setState(() => _selectedDay = DateTime.now()),
          ),
        ],
      ),
      body: ValueListenableBuilder<List<PlantCareTask>>(
        valueListenable: app.careController.tasks,
        builder: (context, tasks, _) {
          final dates = _buildMonthDays();
          final locale = Localizations.localeOf(context).languageCode;
          final selectedTasks = app.careController.tasksForDay(_selectedDay);
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _header(context, t, tasks),
              const SizedBox(height: 16),
              _monthSwitcher(t),
              const SizedBox(height: 12),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 7,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 1,
                ),
                itemCount: dates.length,
                itemBuilder: (context, index) {
                  final date = dates[index];
                  final due = app.careController.tasksForDay(date);
                  final isSelected = _sameDay(date, _selectedDay);
                  final isToday = _sameDay(date, DateTime.now());
                  return GestureDetector(
                    onTap: () => setState(() => _selectedDay = date),
                    child: AnimatedContainer(
                      duration: 250.ms,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Theme.of(context).colorScheme.primary.withOpacity(0.18)
                            : Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isToday
                              ? Theme.of(context).colorScheme.primary
                              : Colors.transparent,
                          width: 1.6,
                        ),
                      ),
                      child: Stack(
                        children: [
                          Center(
                            child: Text(
                              date.day.toString(),
                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                                  ),
                            ),
                          ),
                          if (due.isNotEmpty)
                            Positioned(
                              bottom: 6,
                              left: 0,
                              right: 0,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(
                                  due.length.clamp(1, 3),
                                  (i) => Container(
                                    margin: const EdgeInsets.symmetric(horizontal: 1.5),
                                    width: 6,
                                    height: 6,
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).colorScheme.primary,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ).animate().scale(begin: const Offset(0.96, 0.96), duration: 200.ms),
                  );
                },
              ),
              const SizedBox(height: 20),
              Text(
                t.t('due_tasks_for').replaceFirst('{date}', _formatDate(_selectedDay, locale)),
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              if (selectedTasks.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Text(t.t('no_tasks_day'), style: Theme.of(context).textTheme.bodyMedium),
                )
              else
                ...selectedTasks
                    .map((task) => _taskTile(context, task, app.careController, t))
                    .toList(),
            ],
          );
        },
      ),
    );
  }

  Widget _header(BuildContext context, AppLocalizations t, List<PlantCareTask> tasks) {
    final dueToday = tasks.where((t) => _sameDay(t.dueDate, DateTime.now())).length;
    final next = tasks.where((t) => t.dueDate.isAfter(DateTime.now())).length;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primary.withOpacity(0.15),
            Theme.of(context).colorScheme.primary.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(t.t('care_overview'), style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 4),
                Text(
                  t.t('care_overview_subtitle'),
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 12,
                  runSpacing: 8,
                  children: [
                    _pill(context, IconlyBold.time_circle, t.t('due_today').replaceFirst('{count}', '$dueToday')),
                    _pill(context, IconlyBold.calendar, t.t('upcoming_tasks').replaceFirst('{count}', '$next')),
                  ],
                )
              ],
            ),
          ),
          Icon(IconlyBold.calendar, size: 48, color: Theme.of(context).colorScheme.primary)
              .animate()
              .slide(begin: const Offset(0.1, 0), duration: 320.ms)
              .scale(duration: 320.ms, curve: Curves.easeOutBack),
        ],
      ),
    ).animate().fadeIn(duration: 320.ms);
  }

  Widget _pill(BuildContext context, IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 6),
          Text(label),
        ],
      ),
    );
  }

  Widget _taskTile(BuildContext context, PlantCareTask task, dynamic controller, AppLocalizations t) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: ListTile(
        leading: Icon(
          task.completed ? IconlyBold.tick_square : IconlyBold.activity,
          color: Theme.of(context).colorScheme.primary,
        ),
        title: Text(task.localizedTitle(Localizations.localeOf(context).languageCode)),
        subtitle: Text(_relativeLabel(task, t)),
        trailing: IconButton(
          icon: Icon(task.completed ? IconlyBold.close_square : IconlyBold.more_square),
          onPressed: () => controller.toggleComplete(task.id),
        ),
      ),
    ).animate().slideX(begin: -0.05, duration: 250.ms).fadeIn(duration: 250.ms);
  }

  String _relativeLabel(PlantCareTask task, AppLocalizations t) {
    final now = DateTime.now();
    final diff = task.dueDate.difference(now).inHours;
    if (diff <= 0) return t.t('due_now');
    if (diff < 24) return t.t('due_in_hours').replaceFirst('{hours}', diff.toString());
    final days = (diff / 24).ceil();
    return t.t('due_in_days').replaceFirst('{days}', days.toString());
  }

  List<DateTime> _buildMonthDays() {
    final first = DateTime(_visibleMonth.year, _visibleMonth.month, 1);
    final daysBefore = first.weekday % 7;
    final totalDays = DateUtils.getDaysInMonth(_visibleMonth.year, _visibleMonth.month);
    final dates = <DateTime>[];
    for (int i = 0; i < daysBefore; i++) {
      dates.add(first.subtract(Duration(days: daysBefore - i)));
    }
    for (int i = 0; i < totalDays; i++) {
      dates.add(DateTime(_visibleMonth.year, _visibleMonth.month, i + 1));
    }
    while (dates.length % 7 != 0) {
      final last = dates.last;
      dates.add(last.add(const Duration(days: 1)));
    }
    return dates;
  }

  Widget _monthSwitcher(AppLocalizations t) {
    final monthLabel = t.t('month_label').replaceFirst(
          '{month}',
          _visibleMonth.month.toString().padLeft(2, '0'),
        ).replaceFirst('{year}', _visibleMonth.year.toString());
    return Row(
      children: [
        IconButton(
          icon: const Icon(IconlyLight.arrow_left_circle),
          onPressed: () => setState(() {
            _visibleMonth = DateTime(_visibleMonth.year, _visibleMonth.month - 1);
            _selectedDay = DateTime(_visibleMonth.year, _visibleMonth.month, 1);
          }),
        ),
        Expanded(
          child: Center(
            child: Text(
              monthLabel,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
        ),
        IconButton(
          icon: const Icon(IconlyLight.arrow_right_circle),
          onPressed: () => setState(() {
            _visibleMonth = DateTime(_visibleMonth.year, _visibleMonth.month + 1);
            _selectedDay = DateTime(_visibleMonth.year, _visibleMonth.month, 1);
          }),
        ),
      ],
    );
  }

  bool _sameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  String _formatDate(DateTime date, String localeCode) {
    final months = const [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    final arMonths = const [
      'يناير',
      'فبراير',
      'مارس',
      'أبريل',
      'مايو',
      'يونيو',
      'يوليو',
      'أغسطس',
      'سبتمبر',
      'أكتوبر',
      'نوفمبر',
      'ديسمبر'
    ];
    final name = localeCode == 'ar' ? arMonths[date.month - 1] : months[date.month - 1];
    return '$name ${date.day}';
  }
}
