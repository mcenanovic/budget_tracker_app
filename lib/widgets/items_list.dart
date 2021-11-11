import 'package:budget_tracker_app/providers/items.dart';
import 'package:budget_tracker_app/widgets/item_group.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ItemsList extends StatelessWidget {
  const ItemsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Consumer<Items>(
        builder: (context, items, child) => SingleChildScrollView(
          child: ListView.builder(
            reverse: items.selectedTimePeriod != TimePeriod.week,
            shrinkWrap: true,
            physics: const ScrollPhysics(),
            itemBuilder: (context, index) {
              var titles = items.activeItems.keys.elementAt(index);
              var itemList = items.activeItems.values.elementAt(index);

              return itemList.isNotEmpty
                  ? ItemGroup(
                      titles,
                      itemList,
                    )
                  : const SizedBox.shrink();
            },
            itemCount: items.activeItems.length,
          ),
        ),
      ),
    );
  }
}
