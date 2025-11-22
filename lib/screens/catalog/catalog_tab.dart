import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import '../../app.dart';
import '../../controllers/plant_catalog_controller.dart';
import '../../localization/app_localizations.dart';
import '../../models/plant.dart';
import '../../widgets/filter_chip_widget.dart';
import '../../widgets/plant_card.dart';
import '../../widgets/skeleton_plant_card.dart';

class CatalogTab extends StatefulWidget {
  const CatalogTab({super.key});

  @override
  State<CatalogTab> createState() => _CatalogTabState();
}

class _CatalogTabState extends State<CatalogTab> {
  final searchCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    final catalog = app.catalogController;
    final t = AppLocalizations.of(context);
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: searchCtrl,
              onChanged: catalog.search,
              onSubmitted: (value) {
                catalog.search(value);
                catalog.rememberSearch(value);
              },
              decoration: InputDecoration(
                prefixIcon: const Icon(IconlyLight.search),
                hintText: t.t('search'),
                filled: true,
                fillColor: Theme.of(context).cardColor,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
              ),
            ),
            const SizedBox(height: 8),
            ValueListenableBuilder<List<String>>(
              valueListenable: catalog.recentSearches,
              builder: (context, recents, _) {
                if (recents.isEmpty) return const SizedBox.shrink();
                return Row(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: recents
                              .map(
                                (q) => Padding(
                                  padding: const EdgeInsets.only(right: 8),
                                  child: ActionChip(
                                    label: Text(q),
                                    onPressed: () {
                                      searchCtrl.text = q;
                                      catalog.search(q);
                                    },
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: catalog.clearRecent,
                      child: Text(t.t('clear')),
                    )
                  ],
                );
              },
            ),
            const SizedBox(height: 12),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  FilterChipWidget(
                    label: t.t('all'),
                    selected: catalog.category == null,
                    onTap: () => catalog.setCategory(null),
                  ),
                  ...PlantCategory.values.map(
                    (c) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: FilterChipWidget(
                        label: _categoryLabel(c, t),
                        selected: catalog.category == c,
                        onTap: () => catalog.setCategory(c),
                      ),
                    ),
                  ),
                  ...PlantDifficulty.values.map(
                    (d) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: FilterChipWidget(
                        label: _difficultyLabel(d, t),
                        selected: catalog.difficulty == d,
                        onTap: () => catalog.setDifficulty(d),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ValueListenableBuilder<Set<String>>(
                valueListenable: app.favoritesController.favorites,
                builder: (context, favorites, _) {
                  return StreamBuilder<PlantCatalogState>(
                    stream: catalog.stream,
                    builder: (context, snapshot) {
                      final state = snapshot.data;
                      if (state == null || state.isLoading && (state.items.isEmpty)) {
                        return ListView.builder(
                          itemCount: 4,
                          itemBuilder: (_, __) => const SkeletonPlantCard(),
                        );
                      }
                      return RefreshIndicator(
                        onRefresh: () => catalog.loadPage(reset: true),
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            final isGrid = constraints.maxWidth > 700;
                            final items = state.items;
                            final children = items.map((plant) {
                              final compared = app.compareController.compared.value
                                  .any((p) => p.id == plant.id);
                              return PlantCard(
                                plant: plant,
                                compared: compared,
                                favorite: favorites.contains(plant.id),
                                onFavoriteToggle: () => app.favoritesController.toggle(plant),
                                onAddToCart: () => app.cartController.addToCart(plant),
                                onCompare: () => app.compareController.toggle(plant),
                                onAiInfo: () => _showAiInfo(context, plant),
                                onTap: () => Navigator.pushNamed(context, '/plant/${plant.id}'),
                              );
                            }).toList();
                            return ListView(
                              children: [
                                isGrid
                                    ? GridView.count(
                                        physics: const NeverScrollableScrollPhysics(),
                                        crossAxisCount: 2,
                                        shrinkWrap: true,
                                        childAspectRatio: 0.8,
                                        children: children,
                                      )
                                    : SizedBox(
                                        height: 320,
                                        child: ListView(
                                          scrollDirection: Axis.horizontal,
                                          children: children,
                                        ),
                                      ),
                                if (state.hasMore)
                                  TextButton(
                                    onPressed: () => catalog.loadPage(reset: false),
                                    child: Text(t.t('load_more')),
                                  ),
                                if (children.isEmpty)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 32),
                                    child: Text(
                                      t.t('empty_catalog'),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                              ],
                            );
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAiInfo(BuildContext context, Plant plant) {
    final t = AppLocalizations.of(context);
    showModalBottomSheet(
      context: context,
      builder: (_) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(t.t('ai_mock_title')),
            const SizedBox(height: 8),
            Text(t.t('ai_mock_body')),
          ],
        ),
      ),
    );
  }

  String _categoryLabel(PlantCategory category, AppLocalizations t) {
    switch (category) {
      case PlantCategory.indoor:
        return t.t('indoor');
      case PlantCategory.outdoor:
        return t.t('outdoor');
      case PlantCategory.flower:
        return t.t('flowers');
      case PlantCategory.cactus:
        return t.t('cactus');
      case PlantCategory.tool:
        return t.t('tools');
    }
  }

  String _difficultyLabel(PlantDifficulty difficulty, AppLocalizations t) {
    switch (difficulty) {
      case PlantDifficulty.easy:
        return t.t('easy');
      case PlantDifficulty.medium:
        return t.t('medium');
      case PlantDifficulty.hard:
        return t.t('hard');
    }
  }
}
