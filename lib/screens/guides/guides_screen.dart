import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:iconly/iconly.dart';
import '../../app.dart';
import '../../localization/app_localizations.dart';
import '../../models/plant_guide.dart';
import '../../widgets/primary_button.dart';

class GuidesScreen extends StatefulWidget {
  const GuidesScreen({super.key});

  @override
  State<GuidesScreen> createState() => _GuidesScreenState();
}

class _GuidesScreenState extends State<GuidesScreen> {
  final TextEditingController _search = TextEditingController();
  GuideLevel? _selectedLevel;

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    final t = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(t.t('guides')),
        actions: [
          IconButton(
            icon: const Icon(IconlyLight.star),
            onPressed: () => Navigator.pushNamed(context, '/rewards'),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _search,
              decoration: InputDecoration(
                hintText: t.t('search_guides'),
                prefixIcon: const Icon(IconlyLight.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(18)),
              ),
              onChanged: (_) => setState(() {}),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Wrap(
              spacing: 8,
              children: [
                _chip(t.t('all'), _selectedLevel == null, () => setState(() => _selectedLevel = null)),
                _chip(t.t('beginner'), _selectedLevel == GuideLevel.beginner,
                    () => setState(() => _selectedLevel = GuideLevel.beginner)),
                _chip(t.t('intermediate'), _selectedLevel == GuideLevel.intermediate,
                    () => setState(() => _selectedLevel = GuideLevel.intermediate)),
                _chip(t.t('advanced'), _selectedLevel == GuideLevel.advanced,
                    () => setState(() => _selectedLevel = GuideLevel.advanced)),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ValueListenableBuilder<List<PlantGuide>>(
              valueListenable: app.guidesController.guides,
              builder: (context, guides, _) {
                final queryFiltered = app.guidesController.search(_search.text);
                final filtered = _selectedLevel == null
                    ? queryFiltered
                    : queryFiltered.where((g) => g.level == _selectedLevel).toList();
                if (filtered.isEmpty) {
                  return Center(child: Text(t.t('empty_guides')));
                }
                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final guide = filtered[index];
                    final completed = app.guidesController.isCompleted(guide.id);
                    final saved = app.guidesController.isSaved(guide.id);
                    return _GuideCard(
                      guide: guide,
                      locale: locale,
                      completed: completed,
                      saved: saved,
                      onRead: () async {
                        await app.guidesController.markCompleted(guide.id);
                        await app.rewardsController.addPoints(8);
                        if (mounted) {
                          _showGuideDetail(context, guide);
                        }
                      },
                      onSave: () => app.guidesController.toggleSave(guide.id),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _chip(String label, bool selected, VoidCallback onTap) {
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onTap(),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
    );
  }

  void _showGuideDetail(BuildContext context, PlantGuide guide) {
    final t = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.8,
          builder: (context, scrollController) => Padding(
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              controller: scrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(18),
                    child: Image.network(guide.imageUrl, height: 200, width: double.infinity, fit: BoxFit.cover)
                        .animate()
                        .fadeIn(duration: 300.ms)
                        .scale(begin: const Offset(0.98, 0.98)),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(guide.localizedTitle(locale), style: Theme.of(context).textTheme.titleLarge),
                      Row(
                        children: [
                          const Icon(IconlyLight.time_circle, size: 16),
                          const SizedBox(width: 6),
                          Text('${guide.durationMinutes} ${t.t('minutes')}'),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: guide.tags
                        .map((tag) => Chip(
                              label: Text(tag),
                              backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.12),
                            ))
                        .toList(),
                  ),
                  const SizedBox(height: 12),
                  Text(guide.localizedBody(locale), style: Theme.of(context).textTheme.bodyLarge),
                  const SizedBox(height: 16),
                  PrimaryButton(
                    label: t.t('close'),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _GuideCard extends StatelessWidget {
  final PlantGuide guide;
  final Locale locale;
  final bool completed;
  final bool saved;
  final VoidCallback onRead;
  final VoidCallback onSave;

  const _GuideCard({
    required this.guide,
    required this.locale,
    required this.completed,
    required this.saved,
    required this.onRead,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 8),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            child: Stack(
              children: [
                Image.network(guide.imageUrl, height: 180, width: double.infinity, fit: BoxFit.cover)
                    .animate()
                    .fadeIn(duration: 300.ms)
                    .slide(begin: const Offset(0, 0.08)),
                Positioned(
                  right: 12,
                  top: 12,
                  child: CircleAvatar(
                    backgroundColor: Colors.black.withOpacity(0.25),
                    child: IconButton(
                      icon: Icon(saved ? IconlyBold.bookmark : IconlyLight.bookmark, color: Colors.white),
                      onPressed: onSave,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        guide.localizedTitle(locale),
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(t.t(guide.levelLabel)),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(guide.localizedSummary(locale)),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(completed ? IconlyBold.check : IconlyLight.paper_plus, size: 18),
                    const SizedBox(width: 6),
                    Text(completed ? t.t('completed') : t.t('read_now')),
                    const Spacer(),
                    PrimaryButton(
                      label: t.t('open'),
                      onPressed: onRead,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 220.ms).scale(begin: const Offset(0.98, 0.98));
  }
}
