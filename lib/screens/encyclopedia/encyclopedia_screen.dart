import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../data/mock_plants.dart';
import '../../models/plant.dart';
import '../../widgets/plant_card.dart';
import '../../widgets/filter_chip_widget.dart';
import '../../localization/app_localizations.dart';
import '../../app.dart';

class EncyclopediaScreen extends StatefulWidget {
  const EncyclopediaScreen({super.key});

  @override
  State<EncyclopediaScreen> createState() => _EncyclopediaScreenState();
}

class _EncyclopediaScreenState extends State<EncyclopediaScreen> {
  final TextEditingController _searchController = TextEditingController();
  PlantCategory? _selectedCategory;
  PlantDifficulty? _selectedDifficulty;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Plant> _filtered(String query) {
    final lower = query.toLowerCase();
    return mockPlants.where((plant) {
      final matchesSearch = lower.isEmpty ||
          plant.nameEn.toLowerCase().contains(lower) ||
          plant.nameAr.toLowerCase().contains(lower) ||
          plant.tags.any((t) => t.toLowerCase().contains(lower)) ||
          plant.shortDescriptionEn.toLowerCase().contains(lower) ||
          plant.shortDescriptionAr.toLowerCase().contains(lower) ||
          plant.longDescriptionEn.toLowerCase().contains(lower) ||
          plant.longDescriptionAr.toLowerCase().contains(lower);
      final matchesCategory = _selectedCategory == null || plant.category == _selectedCategory;
      final matchesDifficulty = _selectedDifficulty == null || plant.difficulty == _selectedDifficulty;
      return matchesSearch && matchesCategory && matchesDifficulty;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context);
    final results = _filtered(_searchController.text);
    final featured = mockPlants.take(4).toList();
    final spacing = MediaQuery.of(context).size.width < 700 ? 1 : 2;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(t.t('encyclopedia')),
            Text(
              t.t('encyclopedia_hint'),
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list_rounded),
            onPressed: () {
              final sheetTheme = Theme.of(context).copyWith(canvasColor: Theme.of(context).cardColor);
              showModalBottomSheet(
                context: context,
                showDragHandle: true,
                isScrollControlled: true,
                backgroundColor: Theme.of(context).colorScheme.surface,
                builder: (_) => Theme(
                  data: sheetTheme,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(t.t('filters'), style: Theme.of(context).textTheme.titleMedium),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            FilterChipWidget(
                              label: t.t('all'),
                              selected: _selectedCategory == null,
                              onSelected: (_) => setState(() => _selectedCategory = null),
                            ),
                            ...PlantCategory.values.map(
                              (c) => FilterChipWidget(
                                label: c.localized(t),
                                selected: _selectedCategory == c,
                                onSelected: (_) => setState(() => _selectedCategory = c),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            FilterChipWidget(
                              label: t.t('all'),
                              selected: _selectedDifficulty == null,
                              onSelected: (_) => setState(() => _selectedDifficulty = null),
                            ),
                            ...PlantDifficulty.values.map(
                              (d) => FilterChipWidget(
                                label: d.localized(t),
                                selected: _selectedDifficulty == d,
                                onSelected: (_) => setState(() => _selectedDifficulty = d),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Align(
                          alignment: Alignment.centerRight,
                          child: ElevatedButton.icon(
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(Icons.check_circle_outline),
                            label: Text(t.t('apply')),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: t.t('search'),
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _searchController.text.isEmpty
                  ? null
                  : IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        _searchController.clear();
                        setState(() {});
                      },
                    ),
            ),
            onChanged: (_) => setState(() {}),
          ).animate().fadeIn(duration: 300.ms).slide(begin: const Offset(0, 0.05)),
          const SizedBox(height: 16),
          Text(t.t('encyclopedia_featured'), style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          SizedBox(
            height: 200,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: featured.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final plant = featured[index];
                return SizedBox(
                  width: 240,
                  child: Card(
                    clipBehavior: Clip.antiAlias,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                    child: InkWell(
                      onTap: () => Navigator.pushNamed(context, '/plant', arguments: plant.id),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Hero(
                            tag: 'encyclopedia-${plant.id}',
                            child: Image.network(plant.imageUrl, height: 120, width: double.infinity, fit: BoxFit.cover),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(plant.localizedName(locale), style: Theme.of(context).textTheme.titleMedium),
                                const SizedBox(height: 4),
                                Text(
                                  plant.localizedShortDescription(locale),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ).animate().scale(begin: const Offset(0.97, 0.97), duration: 220.ms),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          if (results.isEmpty)
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Theme.of(context).colorScheme.surfaceVariant,
              ),
              child: Row(
                children: [
                  const Icon(Icons.local_florist_outlined),
                  const SizedBox(width: 12),
                  Expanded(child: Text(t.t('encyclopedia_empty'))),
                ],
              ),
            ).animate().fadeIn(duration: 250.ms),
          if (results.isNotEmpty)
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: spacing,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.74,
              ),
              itemCount: results.length,
              itemBuilder: (context, index) {
                final plant = results[index];
                return PlantCard(
                  plant: plant,
                  locale: locale,
                  onTap: () => Navigator.pushNamed(context, '/plant', arguments: plant.id),
                ).animate().fadeIn(duration: 280.ms, delay: (index * 30).ms);
              },
            ),
          const SizedBox(height: 24),
          _encyclopediaFooter(context, t),
        ],
      ),
    );
  }

  Widget _encyclopediaFooter(BuildContext context, AppLocalizations t) {
    final app = AppScope.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: Theme.of(context).colorScheme.primaryContainer,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(t.t('encyclopedia_cta'), style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Text(t.t('encyclopedia_cta_body')),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ElevatedButton.icon(
                onPressed: () => Navigator.pushNamed(context, '/guides'),
                icon: const Icon(Icons.menu_book_rounded),
                label: Text(t.t('guides')),
              ),
              OutlinedButton.icon(
                onPressed: () => Navigator.pushNamed(context, '/care/calendar'),
                icon: const Icon(Icons.calendar_today_rounded),
                label: Text(t.t('care_calendar')),
              ),
              TextButton.icon(
                onPressed: () {
                  final heroPlant = mockPlants.first;
                  app.cartController.addToCart(heroPlant);
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text(t.t('added_to_cart'))));
                },
                icon: const Icon(Icons.shopping_bag_outlined),
                label: Text(t.t('add_to_cart')),
              )
            ],
          )
        ],
      ),
    ).animate().fadeIn(duration: 300.ms).slide(begin: const Offset(0, 0.02));
  }
}

extension on PlantCategory {
  String localized(AppLocalizations t) {
    switch (this) {
      case PlantCategory.indoor:
        return t.t('indoor');
      case PlantCategory.outdoor:
        return t.t('outdoor');
      case PlantCategory.flower:
        return t.t('flower');
      case PlantCategory.cactus:
        return t.t('cactus');
      case PlantCategory.tool:
        return t.t('tool');
    }
  }
}

extension on PlantDifficulty {
  String localized(AppLocalizations t) {
    switch (this) {
      case PlantDifficulty.easy:
        return t.t('easy');
      case PlantDifficulty.medium:
        return t.t('medium');
      case PlantDifficulty.hard:
        return t.t('hard');
    }
  }
}
