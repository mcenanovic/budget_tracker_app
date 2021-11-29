// ignore_for_file: avoid_print, invalid_return_type_for_catch_error

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';

import '../models/item.dart';
import 'package:flutter/material.dart';

enum TimePeriod {
  week,
  month,
  year,
}

class Items with ChangeNotifier {
  final _database = FirebaseDatabase.instance.reference();
  String _userId = '';

  Items() {
    FirebaseAuth.instance.userChanges().listen((user) async {
      if (user == null) {
        return;
      }

      _userId = user.uid;
      await fetchItems();
      notifyListeners();
    });
  }

  Future<void> fetchItems() async {
    _items.clear();

    _database.child('items/$_userId').once().then((snapshot) {
      if (!snapshot.exists) {
        return;
      }

      final data = Map<String, dynamic>.from(snapshot.value);

      data.forEach((key, value) {
        _items.add(Item(
            id: key,
            name: value['name'],
            category: Category.values[value['category']],
            price: value['price'].toDouble(),
            dateTime: DateTime.parse(value['dateTime'])));
      });
      notifyListeners();
    });
  }

  final List<Item> _items = [];

  TimePeriod _selectedTimePeriod = TimePeriod.week;

  // Map<String, double> _chartData = {};

  List<Item> get items {
    final DateTime now = DateTime.now();

    return _selectedTimePeriod == TimePeriod.week
        ? _items
            .where((element) =>
                element.dateTime.isAfter(now.add(const Duration(days: -7))))
            .toList()
        : _selectedTimePeriod == TimePeriod.month
            ? _items
                .where((element) =>
                    element.dateTime.month == now.month &&
                    element.dateTime.year == now.year)
                .toList()
            : _items
                .where((element) => element.dateTime.year == now.year)
                .toList();
  }

  Map<String, List<Item>> get activeItems {
    return _selectedTimePeriod == TimePeriod.week
        ? _getWeeklyActiveItems()
        : _selectedTimePeriod == TimePeriod.month
            ? _getMonthlyActiveItems()
            : _getYearlyActiveItems();
  }

  int get itemsCount {
    return items.length;
  }

  TimePeriod get selectedTimePeriod {
    return _selectedTimePeriod;
  }

  double get totalSpending {
    return items.fold(
        0.0, (previousValue, element) => previousValue + element.price);
  }

  double getTotalSpending(TimePeriod timePeriod) {
    final DateTime now = DateTime.now();

    var data = timePeriod == TimePeriod.week
        ? _items
            .where((element) =>
                element.dateTime.isAfter(now.add(const Duration(days: -7))))
            .toList()
        : timePeriod == TimePeriod.month
            ? _items
                .where((element) =>
                    element.dateTime.month == now.month &&
                    element.dateTime.year == now.year)
                .toList()
            : _items
                .where((element) => element.dateTime.year == now.year)
                .toList();

    return data.fold(
        0.0, (previousValue, element) => previousValue + element.price);
  }

  void setTimePeriod(TimePeriod newTimePeriod) {
    _selectedTimePeriod = newTimePeriod;
    notifyListeners();
  }

  void addNewItem(Item newItem) {
    final reference = _database.child('items/$_userId').push();
    final uniqueKey = reference.key;

    reference.set(newItem.toJson()).then((_) {
      newItem.id = uniqueKey;
      _items.add(newItem);
      notifyListeners();
    }).catchError((error) => print(error));
  }

  void deleteItem(Item item, {int? index}) {
    _database.child('items/$_userId/${item.id}').remove().then((_) {
      if (index != null) {
        _items.removeAt(index);
        notifyListeners();
      }
    }).catchError((error) => print(error));
  }

  void updateItem(Item item, int index) {
    _database
        .child('items/$_userId/${item.id}')
        .update(item.toJson())
        .then((_) {
      _items[index] = item;
      notifyListeners();
    }).catchError((error) => print(error));
  }

  List<Item> searchItems(String searchTerms) {
    return _items
        .where((element) =>
            element.name.toLowerCase().contains(searchTerms.toLowerCase()))
        .toList();
  }

  Map<String, double> getChartData(TimePeriod timePeriod) =>
      timePeriod == TimePeriod.week
          ? _getWeeklyChartData()
          : timePeriod == TimePeriod.month
              ? _getMonthlyChartData()
              : _getYearlyChartData();

  Map<String, double> _getWeeklyChartData() {
    var result = <String, double>{};
    final DateTime now = DateTime.now();

    for (int i = 0; i < 7; i++) {
      final date = now.subtract(Duration(days: i));
      final double activeDaySpending = items
          .where((element) =>
              element.dateTime.year == date.year &&
              element.dateTime.month == date.month &&
              element.dateTime.day == date.day)
          .fold(0.0, (previousValue, element) => previousValue + element.price);

      result[DateFormat('EEE').format(date)] =
          activeDaySpending / totalSpending;
    }

    return result;
  }

  Map<String, double> _getMonthlyChartData() {
    var result = <String, double>{};
    final DateTime now = DateTime.now();

    for (int i = 1; i <= now.day; i++) {
      final date = now.subtract(Duration(days: now.day - i));
      final double activeDaySpending = items
          .where((element) =>
              element.dateTime.year == date.year &&
              element.dateTime.month == date.month &&
              element.dateTime.day == date.day)
          .fold(0.0, (previousValue, element) => previousValue + element.price);

      result[i.toString()] = activeDaySpending / totalSpending;
    }

    return result;
  }

  Map<String, double> _getYearlyChartData() {
    var result = <String, double>{};
    final DateTime now = DateTime.now();

    for (int i = 1; i <= now.month; i++) {
      final activeDate = DateTime.utc(now.year, i);
      final double activeMonthSpending = items
          .where((element) =>
              element.dateTime.year == activeDate.year &&
              element.dateTime.month == activeDate.month)
          .fold(0.0, (previousValue, element) => previousValue + element.price);

      result[i.toString()] = activeMonthSpending / totalSpending;
    }

    return result;
  }

  Map<String, List<Item>> _getWeeklyActiveItems() {
    var result = <String, List<Item>>{};
    final DateTime now = DateTime.now();

    for (int i = 0; i < 7; i++) {
      final date = now.subtract(Duration(days: i));
      result[i == 0
          ? 'Today'
          : i == 1
              ? 'Yesterday'
              : DateFormat('EEEE').format(date)] = items
          .where((element) =>
              element.dateTime.year == date.year &&
              element.dateTime.month == date.month &&
              element.dateTime.day == date.day)
          .toList();
    }

    return result;
  }

  Map<String, List<Item>> _getMonthlyActiveItems() {
    var result = <String, List<Item>>{};
    final DateTime now = DateTime.now();

    for (int i = 1; i <= now.day; i++) {
      final date = now.subtract(Duration(days: now.day - i));
      result[DateFormat.MMMMd().format(date)] = items
          .where((element) =>
              element.dateTime.year == date.year &&
              element.dateTime.month == date.month &&
              element.dateTime.day == date.day)
          .toList();
    }

    return result;
  }

  Map<String, List<Item>> _getYearlyActiveItems() {
    var result = <String, List<Item>>{};
    final DateTime now = DateTime.now();

    for (int i = 1; i <= now.month; i++) {
      final activeDate = DateTime.utc(now.year, i);
      result[DateFormat.MMMM().format(activeDate)] = items
          .where((element) =>
              element.dateTime.year == activeDate.year &&
              element.dateTime.month == activeDate.month)
          .toList();
    }

    return result;
  }

  static final _allItems = <Item>[
    Item(
      id: '1',
      name: 'Nike patike',
      category: Category.clothing,
      price: 97.00,
      dateTime: DateTime.utc(2021, 8, 12),
    ),
    Item(
      id: '2',
      name: 'Champion majica',
      category: Category.clothing,
      price: 76.00,
      dateTime: DateTime.utc(2021, 10, 12),
    ),
    Item(
      id: '3',
      name: 'Alma ras gace',
      category: Category.clothing,
      price: 7.00,
      dateTime: DateTime.utc(2021, 10, 15),
    ),
    Item(
      id: '4',
      name: 'Iphone 13',
      category: Category.electronics,
      price: 999.00,
      dateTime: DateTime.utc(2021, 10, 7),
    ),
    Item(
      id: '5',
      name: 'Slusalice',
      category: Category.electronics,
      price: 70.00,
      dateTime: DateTime.utc(2021, 9, 12),
    ),
    Item(
      id: '6',
      name: 'Cistac sminke',
      category: Category.electronics,
      price: 21.00,
      dateTime: DateTime.utc(2021, 10, 16),
    ),
    Item(
      id: '7',
      name: 'Daljinski',
      category: Category.electronics,
      price: 5.00,
      dateTime: DateTime.utc(2020, 12, 12),
    ),
    Item(
      id: '8',
      name: 'Taxi',
      category: Category.transport,
      price: 11.00,
      dateTime: DateTime.utc(2021, 10, 1),
    ),
    Item(
      id: '9',
      name: 'Gorivo',
      category: Category.transport,
      price: 100.00,
      dateTime: DateTime.utc(2021, 9, 12),
    ),
    Item(
      id: '10',
      name: 'Sijalice H7',
      category: Category.transport,
      price: 214.00,
      dateTime: DateTime.utc(2021, 10, 14),
    ),
    Item(
      id: '11',
      name: 'Sijalice H8',
      category: Category.transport,
      price: 514.00,
      dateTime: DateTime.utc(2021, 10, 21),
    ),
  ];
}
