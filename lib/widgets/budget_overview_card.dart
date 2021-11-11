import 'package:budget_tracker_app/providers/items.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../widgets/budget_chart.dart';
import '../styles.dart';

class BudgetOverviewCard extends StatefulWidget {
  const BudgetOverviewCard({Key? key}) : super(key: key);

  @override
  State<BudgetOverviewCard> createState() => _BudgetOverviewCardState();
}

class _BudgetOverviewCardState extends State<BudgetOverviewCard> {
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    final Size deviceSize = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.8),
            spreadRadius: 3,
            blurRadius: 3,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30.0),
        child: Container(
          width: deviceSize.width,
          height: 200.0,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                Styles.kDarkPrimaryColor,
                Styles.kPrimaryColor,
              ],
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                top: -40,
                right: -40,
                child: ClipRRect(
                  child: Container(
                    width: 120.0,
                    height: 120.0,
                    decoration: const BoxDecoration(
                      color: Styles.kDarkPrimaryColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 30,
                right: 50,
                child: Container(
                  width: 50.0,
                  height: 50.0,
                  decoration: BoxDecoration(
                    color: Styles.kPrimaryColor.withOpacity(0.7),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 20.0,
                  left: 20.0,
                  right: 20.0,
                ),
                child: PageView(
                  controller: _pageController,
                  scrollDirection: Axis.vertical,
                  onPageChanged: (int index) {
                    final newTimePeriod = index == 0
                        ? TimePeriod.week
                        : index == 1
                            ? TimePeriod.month
                            : TimePeriod.year;
                    Provider.of<Items>(context, listen: false)
                        .setTimePeriod(newTimePeriod);
                  },
                  children: const [
                    BudgetChart(TimePeriod.week),
                    BudgetChart(TimePeriod.month),
                    BudgetChart(TimePeriod.year),
                  ],
                ),
              ),
              Positioned(
                top: 80,
                right: 5,
                child: SmoothPageIndicator(
                  axisDirection: Axis.vertical,
                  controller: _pageController,
                  count: 3,
                  effect: const WormEffect(
                    activeDotColor: Styles.kSecondaryColor,
                    dotWidth: 10.0,
                    dotHeight: 10.0,
                    spacing: 5.0,
                  ),
                  onDotClicked: (index) => _pageController.animateToPage(
                    index,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.bounceOut,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
