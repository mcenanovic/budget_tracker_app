import 'package:budget_tracker_app/providers/items.dart';
import 'package:budget_tracker_app/styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BudgetChart extends StatefulWidget {
  final TimePeriod timePeriod;

  const BudgetChart(this.timePeriod);

  @override
  State<BudgetChart> createState() => _BudgetChartState();
}

class _BudgetChartState extends State<BudgetChart> {
  Widget _buildChart(BuildContext context, Items items) {
    final timePeriod = widget.timePeriod;
    final chartData = items.getChartData(timePeriod);
    final now = DateTime.now();
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SizedBox(
        height: 100.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (items.itemsCount > 0)
              ListView.builder(
                reverse: true,
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          width: 30.0,
                          height: items.itemsCount > 0
                              ? 80 * chartData.values.elementAt(index)
                              : 0,
                          decoration: BoxDecoration(
                            color:
                                (timePeriod == TimePeriod.week && index == 0) ||
                                        (timePeriod == TimePeriod.month &&
                                            index == now.day - 1) ||
                                        (timePeriod == TimePeriod.year &&
                                            index == now.month - 1)
                                    ? Styles.kSecondaryColor
                                    : index % 2 == 0
                                        ? Colors.grey[300]
                                        : Colors.grey,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        const SizedBox(height: 5.0),
                        Text(
                          chartData.keys.elementAt(index),
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 10.0,
                          ),
                        ),
                      ],
                    ),
                  );
                },
                itemCount: chartData.length,
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final timePeriod = widget.timePeriod;
    final Items items = Provider.of<Items>(context);
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${timePeriod == TimePeriod.week ? 'Weekly' : timePeriod == TimePeriod.month ? 'Monhtly' : 'Yearly'} Outcome',
                  style: const TextStyle(
                    fontSize: 16.0,
                    color: Styles.kLightColor,
                  ),
                ),
                Text(
                  '\$${items.getTotalSpending(timePeriod).toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 25.0,
                    color: Styles.kLightColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 15.0),
        _buildChart(context, items),
      ],
    );
  }
}
