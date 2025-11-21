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
              decoration: InputDecoration(
                prefixIcon: const Icon(IconlyLight.search),
                hintText: t.t('search'),
                filled: true,
                fillColor: Theme.of(context).cardColor,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
              ),
            ),
            const SizedBox(height: 12),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  FilterChipWidget(
                    label: 'All',
                    selected: catalog.category == null,
                    onTap: () => catalog.setCategory(null),
                  ),
                  ...PlantCategory.values.map(
                    (c) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: FilterChipWidget(
                        label: c.name,
                        selected: catalog.category == c,
                        onTap: () => catalog.setCategory(c),
                      ),
                    ),
                  ),
                  ...PlantDifficulty.values.map(
                    (d) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: FilterChipWidget(
                        label: d.name,
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
              child: StreamBuilder<PlantCatalogState>(
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
                                  t.t('empty_cart'),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                          ],
                        );
                      },
                    ),
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
}
