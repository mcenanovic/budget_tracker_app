import 'package:budget_tracker_app/models/item.dart';
import 'package:budget_tracker_app/providers/items.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/item.dart' as item;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../styles.dart';

class AddItemDialog extends StatefulWidget {
  Item? item;
  int? index;

  AddItemDialog({Key? key, this.item, this.index}) : super(key: key);

  @override
  _AddItemDialogState createState() => _AddItemDialogState();
}

class _AddItemDialogState extends State<AddItemDialog> {
  final _formKey = GlobalKey<FormState>();
  var _title = '';
  var _price = 0.0;
  DateTime? _dateTime;
  late item.Category _category;
  var _isLoading = false;
  var _isUpdate = false;

  @override
  void initState() {
    super.initState();

    if (widget.item != null) {
      final item = widget.item;

      setState(() {
        _title = item!.name;
        _price = item.price;
        _dateTime = item.dateTime;
        _category = item.category;
      });

      _isUpdate = true;
    }
  }

  void _selectDate(BuildContext context) {
    final themeData = Theme.of(context).brightness == Brightness.light
        ? ThemeData.light()
        : ThemeData.dark();

    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2015),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: themeData.copyWith(
            colorScheme: ColorScheme.fromSwatch().copyWith(
              primary: Theme.of(context).colorScheme.primary,
              onSurface: Theme.of(context).colorScheme.primary,
            ),
          ),
          child: child!,
        );
      },
    ).then((value) {
      value != null
          ? setState(() {
              _dateTime = value;
            })
          : null;
    });
  }

  void _submitData() {
    final isValid = _formKey.currentState!.validate();

    if (!isValid || _dateTime == null) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    _formKey.currentState!.save();

    final Item newItem = Item(
        id: _isUpdate ? widget.item?.id : null,
        name: _title,
        category: _category,
        price: _price,
        dateTime: _dateTime!);

    _isUpdate
        ? Provider.of<Items>(context, listen: false)
            .updateItem(newItem, widget.index!)
        : Provider.of<Items>(context, listen: false).addNewItem(newItem);

    setState(() {
      _isLoading = false;
    });

    Navigator.of(context).pop();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Item ${_isUpdate ? 'updated' : 'added'} successfully',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Theme.of(context).backgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(32.0)),
      ),
      title: Text(
        _isUpdate ? 'Update existing item' : 'Add new item',
        style: TextStyle(color: Theme.of(context).textTheme.headline2!.color),
      ),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              initialValue: _title,
              style: TextStyle(
                  color: Theme.of(context).textTheme.headline1!.color),
              decoration: const InputDecoration(
                hintText: 'Title',
                hintStyle: TextStyle(color: Colors.grey),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Item name is required';
                }
                return null;
              },
              onSaved: (newValue) => _title = newValue!,
            ),
            DropdownButtonFormField(
              value: _isUpdate ? _category : null,
              style: TextStyle(
                  color: Theme.of(context).textTheme.headline1!.color),
              items: const [
                DropdownMenuItem(
                  child: Text('Clothing'),
                  value: item.Category.clothing,
                ),
                DropdownMenuItem(
                  child: Text('Electronics'),
                  value: item.Category.electronics,
                ),
                DropdownMenuItem(
                  child: Text('Transport'),
                  value: item.Category.transport,
                ),
              ],
              decoration: const InputDecoration(
                hintText: 'Category',
                hintStyle: TextStyle(color: Colors.grey),
              ),
              onChanged: (newValue) => _category = newValue as item.Category,
              validator: (value) {
                if (value == null) {
                  return 'Item category is required!';
                }
                return null;
              },
            ),
            TextFormField(
              initialValue: _price > 0.0 ? _price.toString() : null,
              style: TextStyle(
                  color: Theme.of(context).textTheme.headline1!.color),
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: 'Price',
                hintStyle: TextStyle(color: Colors.grey),
              ),
              onSaved: (newValue) => _price = double.parse(newValue!),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Item price is required';
                }
                return null;
              },
            ),
            const SizedBox(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _dateTime != null
                      ? DateFormat.yMd().format(_dateTime!)
                      : 'No date chosen',
                  style: const TextStyle(
                    fontSize: 14.0,
                    color: Colors.grey,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    _selectDate(context);
                  },
                  child: const Text(
                    'Choose date',
                    style: TextStyle(
                      color: Styles.kSecondaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _submitData,
          child: Text(
            _isUpdate ? 'Update' : 'Create',
            style: TextStyle(
              color: Theme.of(context).textTheme.headline4!.color,
              fontSize: 16.0,
            ),
          ),
        ),
        const SizedBox.shrink(),
      ],
    );
  }
}
