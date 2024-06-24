import 'package:flutter/material.dart';
import 'package:mozz_test_task/main.dart';
import 'package:mozz_test_task/provider/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:mozz_test_task/pages/chat_rooms_page/chat_rooms_page.dart';

const List<String> list = <String>['User1', 'User2', 'User3', 'User4'];

class DropDownMenuButton extends StatefulWidget {
  const DropDownMenuButton({super.key});

  @override
  State<DropDownMenuButton> createState() => _DropDownMenuButtonState();
}

class _DropDownMenuButtonState extends State<DropDownMenuButton> {
  String dropdownValue = list.first;

  @override
  Widget build(BuildContext context) {
    return DropdownMenu<String>(
      initialSelection: list.first,
      onSelected: (String? value) {
        // This is called when the user selects an item.
        // if (value != null) {
        Provider.of<UserProvider>(context, listen: false).changeUser(value!);
        // }
        setState(() {
          dropdownValue = value!;
        });
      },
      dropdownMenuEntries: list.map<DropdownMenuEntry<String>>((String value) {
        return DropdownMenuEntry<String>(value: value, label: value);
      }).toList(),
    );
  }
}
