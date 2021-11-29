import 'package:budget_tracker_app/providers/authentication_state.dart';
import 'package:budget_tracker_app/widgets/add_item_dialog.dart';
import 'package:budget_tracker_app/widgets/budget_overview_card.dart';
import 'package:budget_tracker_app/widgets/items_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'styles.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);

  final GlobalKey<ScaffoldState> _key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: Theme.of(context).brightness == Brightness.dark
          ? SystemUiOverlayStyle.light
          : SystemUiOverlayStyle.dark,
      child: Scaffold(
        key: _key,
        backgroundColor: Theme.of(context).backgroundColor,
        drawer: Drawer(
          child: ListView(
            children: [
              ListTile(
                onTap: () =>
                    Provider.of<AuthenticationState>(context, listen: false)
                        .signOut(),
                leading: const Icon(Icons.logout),
                title: const Text('Logout'),
              )
            ],
          ),
        ),
        body: SafeArea(
          bottom: false,
          minimum: const EdgeInsets.only(
            left: 16.0,
            top: 50.0,
            right: 16.0,
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hello,',
                        style: Theme.of(context).textTheme.headline1,
                      ),
                      Text(
                        'Mustafa',
                        style: Theme.of(context).textTheme.headline1!.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Material(
                      type: MaterialType.circle,
                      color: Styles.kSecondaryColor,
                      elevation: 5,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          customBorder: const CircleBorder(),
                          onTap: () => showDialog<String>(
                            context: context,
                            builder: (context) => AddItemDialog(),
                          ),
                          splashColor: Colors.red,
                          child: const Icon(
                            Icons.add,
                            size: 40.0,
                            color: Styles.kLightGreyColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15.0),
              const BudgetOverviewCard(),
              const SizedBox(height: 15.0),
              const ItemsList(),
            ],
          ),
        ),
      ),
    );
  }
}
