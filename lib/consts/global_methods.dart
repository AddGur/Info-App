import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:intl/intl.dart';

class GlobalMethods {
  static String formattedDateText(String publishedAt) {
    final parseData = DateTime.parse(publishedAt);
    String formattedDate = DateFormat('hh:mm dd/MMM/yy').format(parseData);
    return formattedDate;
  }

  static Future<void> errorDialog(
      {required String errorMessage, required BuildContext context}) async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Row(children: const [
            Icon(
              IconlyBold.danger,
              color: Colors.red,
            ),
            SizedBox(
              width: 4,
            ),
            Text('An error occured'),
          ]),
          actions: [
            TextButton(
                onPressed: () {
                  if (Navigator.canPop(context)) {
                    Navigator.pop(context);
                  }
                },
                child: const Text('ok'))
          ],
        );
      },
    );
  }
}
