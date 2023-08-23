import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

cancelButton(context) => GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        margin: const EdgeInsets.only(right: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: Theme.of(context).primaryColor.withOpacity(0.15),
        ),
        child: Text(
          "Cancel",
          style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      ),
    );

saveButton(context, function) => GestureDetector(
      onTap: function,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: Theme.of(context).primaryColor,
        ),
        child: const Text(
          "Save",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      ),
    );

formatDateTime(DateTime date) => DateFormat('dd MMM yyyy').format(date);

showSnackBar(context, msg, {actions}) =>
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        action: actions,
      ),
    );
