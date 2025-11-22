import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../app.dart';
import '../../localization/app_localizations.dart';
import '../../models/community_tip.dart';

class CommunityTipsScreen extends StatefulWidget {
  const CommunityTipsScreen({super.key});

  @override
  State<CommunityTipsScreen> createState() => _CommunityTipsScreenState();
}

class _CommunityTipsScreenState extends State<CommunityTipsScreen> {
  String _query = '';
  String? _category;

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    final t = AppLocalizations.of(context)!;
    final categories = app.guidesController.tips.value.map((e) => e.category).toSet().toList();
    final tips = app.guidesController.searchTips(_query, category: _category);
    return AnimatedBuilder(
      animation: Listenable.merge([
        app.guidesController.likedTips,
        app.guidesController.bookmarkedTips,
      ]),
      builder: (context, _) {
        return Scaffold(
          appBar: AppBar(title: Text(t.t('community_tips'))),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              TextField(
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  hintText: t.t('search_tips'),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(18)),
                ),
                onChanged: (v) => setState(() => _query = v),
              ),
              const SizedBox(height: 10),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    ChoiceChip(
                      label: Text(t.t('all')),
                      selected: _category == null,
                      onSelected: (_) => setState(() => _category = null),
                    ),
                    const SizedBox(width: 8),
                    ...categories.map((c) => Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: ChoiceChip(
                            label: Text(c),
                            selected: _category == c,
                            onSelected: (_) => setState(() => _category = c),
                          ),
                        )),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              AnimatedSwitcher(
                duration: 250.ms,
                child: tips.isEmpty
                    ? Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18),
                          color: Theme.of(context)
                              .colorScheme
                              .surfaceVariant
                              .withOpacity(0.4),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.eco_outlined),
                            const SizedBox(width: 10),
                            Expanded(child: Text(t.t('no_tips_found'))),
                          ],
                        ),
                      )
                    : Column(
                        children: tips
                            .map((tip) => _tipCard(context, app, t, tip)
                                .animate()
                                .slide(begin: const Offset(0.02, 0))
                                .fadeIn())
                            .toList(),
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _tipCard(BuildContext context, AppScope app, AppLocalizations t, CommunityTip tip) {
    final locale = t.locale.languageCode;
    final title = locale == 'ar' ? tip.titleAr : tip.titleEn;
    final body = locale == 'ar' ? tip.bodyAr : tip.bodyEn;
    final actionLabel = locale == 'ar' ? tip.actionLabelAr : tip.actionLabelEn;
    final liked = app.guidesController.isTipLiked(tip.id);
    final saved = app.guidesController.isTipSaved(tip.id);
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: Theme.of(context).colorScheme.surface,
        boxShadow: kElevationToShadow[1],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text('${tip.category} • ${tip.level}',
                    style: Theme.of(context).textTheme.labelMedium),
              ),
              const Spacer(),
              IconButton(
                icon: Icon(liked ? Icons.favorite : Icons.favorite_border,
                    color: liked ? Theme.of(context).colorScheme.primary : null),
                onPressed: () => app.guidesController.toggleTipLike(tip.id),
              ),
              IconButton(
                icon: Icon(saved ? Icons.bookmark : Icons.bookmark_border,
                    color: saved ? Theme.of(context).colorScheme.primary : null),
                onPressed: () => app.guidesController.toggleTipSave(tip.id),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 6),
          Text(body, style: Theme.of(context).textTheme.bodyMedium),
          if (actionLabel != null) ...[
            const SizedBox(height: 10),
            OutlinedButton(
              onPressed: () {
                if (tip.category == 'care') {
                  Navigator.pushNamed(context, '/care');
                } else if (tip.category == 'light') {
                  Navigator.pushNamed(context, '/guides');
                } else if (tip.category == 'propagation') {
                  Navigator.pushNamed(context, '/inspiration');
                } else if (tip.category == 'health') {
                  Navigator.pushNamed(context, '/diagnostics');
                } else {
                  Navigator.pushNamed(context, '/catalog');
                }
              },
              child: Text(actionLabel),
            ).animate().scale(duration: 240.ms),
          ],
          Wrap(
            spacing: 6,
            runSpacing: 4,
            children: tip.tags
                .map((tag) => Chip(
                      label: Text('#$tag'),
                      visualDensity: VisualDensity.compact,
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }
}
