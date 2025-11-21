import 'package:flutter/material.dart';
import '../../app.dart';
import '../../localization/app_localizations.dart';

class CompareScreen extends StatelessWidget {
  const CompareScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    final t = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(t.t('compare'))),
      body: ValueListenableBuilder(
        valueListenable: app.compareController.compared,
        builder: (context, items, _) {
          if (items.isEmpty) {
            return Center(child: Text(t.t('empty_compare')));
          }
          return Column(
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: [
                    const DataColumn(label: Text('Property')),
                    ...items.map((p) => DataColumn(label: Text(p.nameEn))),
                  ],
                  rows: [
                    DataRow(cells: [const DataCell(Text('Price'))] + items.map((p) => DataCell(Text('\$${p.price}'))).toList()),
                    DataRow(cells: [const DataCell(Text('Height'))] + items.map((p) => DataCell(Text(p.heightRange))).toList()),
                    DataRow(cells: [const DataCell(Text('Temperature'))] + items.map((p) => DataCell(Text(p.temperatureRange))).toList()),
                    DataRow(cells: [const DataCell(Text('Humidity'))] + items.map((p) => DataCell(Text(p.humidity))).toList()),
                  ],
                ),
              ),
              TextButton(onPressed: app.compareController.clear, child: Text(t.t('clear_all'))),
            ],
          );
        },
      ),
    );
  }
}
