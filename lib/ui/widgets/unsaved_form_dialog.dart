import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:offline_first/ui/widgets/primary_dialog.dart';

class UnsavedFormDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PrimaryDialog(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Text(
                'Form has been changed and not saved yet.',
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
            SizedBox(
              height: 16,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                FlatButton(
                  onPressed: () {
                    Get.back(result: true);
                  },
                  child: Text('Discard changes'),
                ),
                RaisedButton(
                  elevation: 0,
                  onPressed: () {
                    Get.back(result: false);
                  },
                  child: Text('Keep editing'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
