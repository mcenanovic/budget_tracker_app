import 'package:budget_tracker_app/models/item.dart';
import 'package:budget_tracker_app/providers/items.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

import '../styles.dart';

class ItemGroup extends StatelessWidget {
  final String name;
  final List<Item> items;

  const ItemGroup(this.name, this.items);

  IconData getIcon(Category category) {
    return category == Category.clothing
        ? Icons.store_mall_directory
        : category == Category.electronics
            ? Icons.laptop
            : Icons.emoji_transportation;
  }

  String getCategory(Category category) {
    return category == Category.clothing
        ? 'Clothing'
        : category == Category.electronics
            ? 'Electronics'
            : 'Transportation';
  }

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(5.0),
          child: Row(
            children: [
              Text(
                name,
                textAlign: TextAlign.start,
                style: TextStyle(
                  color: Theme.of(context).textTheme.headline3!.color,
                  fontWeight: FontWeight.w500,
                  fontSize: 15.0,
                ),
              ),
              const Expanded(
                child: SizedBox(),
              ),
            ],
          ),
        ),
        ListView.builder(
          reverse: true,
          padding: EdgeInsets.zero,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: items.length,
          itemBuilder: (context, index) => Slidable(
            actionPane: const SlidableDrawerActionPane(),
            secondaryActions: [
              IconSlideAction(
                caption: 'Update',
                color: Styles.kSecondaryColor,
                icon: Icons.update,
                onTap: () =>
                    Provider.of<Items>(context).updateItem(items[index]),
              ),
              IconSlideAction(
                caption: 'Delete',
                color: Colors.red,
                icon: Icons.delete,
                onTap: () =>
                    Provider.of<Items>(context).deleteItem(items[index]),
              ),
            ],
            child: ListTile(
              visualDensity: const VisualDensity(
                vertical: -2,
              ),
              leading: Container(
                padding: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  color: isDarkTheme
                      ? Styles.kPrimaryColor
                      : Styles.kLightGreyColor,
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Icon(
                  getIcon(items[index].category),
                  size: 30.0,
                  color: isDarkTheme
                      ? Styles.kLightGreyColor
                      : Styles.kPrimaryColor,
                ),
              ),
              title: Text(
                items[index].name,
                style: TextStyle(
                  fontSize: 16.0,
                  color: Theme.of(context).textTheme.headline4!.color,
                ),
              ),
              subtitle: Text(getCategory(items[index].category),
                  style: TextStyle(
                    fontSize: 12.0,
                    color: Theme.of(context).textTheme.headline3!.color,
                  )),
              trailing: Text(
                '\$${items[index].price}',
                style: TextStyle(
                  color: Theme.of(context).textTheme.headline4!.color,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
