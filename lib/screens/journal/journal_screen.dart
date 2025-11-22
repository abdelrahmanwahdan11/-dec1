import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../app.dart';
import '../../localization/app_localizations.dart';
import '../../models/journal_entry.dart';

class JournalScreen extends StatefulWidget {
  const JournalScreen({super.key});

  @override
  State<JournalScreen> createState() => _JournalScreenState();
}

class _JournalScreenState extends State<JournalScreen> {
  final _titleController = TextEditingController();
  final _noteController = TextEditingController();
  String _mood = 'calm';

  @override
  void dispose() {
    _titleController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    final t = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(t.t('journal')),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddEntry(context, t, app),
          ),
        ],
      ),
      body: ValueListenableBuilder<List<JournalEntry>>(
        valueListenable: app.journalController.entries,
        builder: (context, entries, _) {
          if (entries.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.menu_book_outlined, size: 64),
                  const SizedBox(height: 12),
                  Text(t.t('empty_journal')),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    onPressed: () => _showAddEntry(context, t, app),
                    icon: const Icon(Icons.add),
                    label: Text(t.t('add_entry')),
                  )
                      .animate()
                      .fadeIn(duration: 300.ms)
                      .scale(begin: const Offset(0.95, 0.95)),
                ],
              ),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemBuilder: (context, index) {
              final entry = entries[index];
              return _entryCard(context, entry, locale);
            },
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemCount: entries.length,
          );
        },
      ),
    );
  }

  Widget _entryCard(BuildContext context, JournalEntry entry, Locale locale) {
    final app = AppScope.of(context);
    final t = AppLocalizations.of(context);
    final code = locale.languageCode;
    return Dismissible(
      key: ValueKey(entry.id),
      background: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.errorContainer,
          borderRadius: BorderRadius.circular(16),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: const Icon(Icons.delete_forever),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => app.journalController.removeEntry(entry.id),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.4),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              child: Image.network(entry.imageUrl, height: 180, width: double.infinity, fit: BoxFit.cover)
                  .animate()
                  .fadeIn(duration: 260.ms)
                  .slide(begin: const Offset(0, 0.04)),
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
                          entry.localizedTitle(code),
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                      IconButton(
                        icon: Icon(entry.favorite ? Icons.favorite : Icons.favorite_border,
                            color: Theme.of(context).colorScheme.primary),
                        onPressed: () => app.journalController.toggleFavorite(entry.id),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(entry.localizedNote(code)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Chip(
                        label: Text(t.t(entry.mood)),
                        backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.12),
                      ),
                      const SizedBox(width: 8),
                      Chip(
                        label: Text(t.formatDate(entry.createdAt)),
                        backgroundColor: Theme.of(context).colorScheme.surfaceTint.withOpacity(0.12),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ).animate().fadeIn(duration: 220.ms).slide(begin: const Offset(0, 0.03)),
    );
  }

  Future<void> _showAddEntry(BuildContext context, AppLocalizations t, AppScope app) async {
    _titleController.clear();
    _noteController.clear();
    _mood = 'calm';
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) {
        final padding = MediaQuery.of(context).viewInsets.bottom;
        return Padding(
          padding: EdgeInsets.fromLTRB(16, 16, 16, padding + 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(t.t('new_entry'), style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 12),
              TextField(
                controller: _titleController,
                decoration: InputDecoration(labelText: t.t('title_hint')),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _noteController,
                decoration: InputDecoration(labelText: t.t('note_hint')),
                maxLines: 3,
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: ['calm', 'thriving', 'sensitive', 'glossy']
                    .map((m) => ChoiceChip(
                          label: Text(t.t(m)),
                          selected: _mood == m,
                          onSelected: (_) => setState(() => _mood = m),
                        ))
                    .toList(),
              ),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: () async {
                  if (_titleController.text.isEmpty || _noteController.text.isEmpty) return;
                  await app.journalController.addEntry(
                    titleEn: _titleController.text,
                    titleAr: _titleController.text,
                    noteEn: _noteController.text,
                    noteAr: _noteController.text,
                    imageUrl:
                        'https://images.unsplash.com/photo-1501004318641-b39e6451bec6?auto=format&fit=crop&w=900&q=80',
                    mood: _mood,
                  );
                  if (mounted) Navigator.pop(context);
                },
                icon: const Icon(Icons.check),
                label: Text(t.t('save_entry')),
              ).animate().slideY(begin: 0.06).fadeIn(),
            ],
          ),
        );
      },
    );
  }
}
