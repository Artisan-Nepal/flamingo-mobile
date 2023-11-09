import 'package:flamingo/shared/util/util.dart';
import 'package:flamingo/widget/text/text.dart';
import 'package:flutter/material.dart';

class ContactCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.white,
      elevation: 0,
      margin: const EdgeInsets.all(0),
      child: Padding(
        padding: const EdgeInsets.all(0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextWidget(
              'Contact Us',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            TextWidget(
              'Contact description',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Handle Phone button press
                  },
                  child: TextWidget('Phone'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Handle Email button press
                  },
                  child: TextWidget('Email'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
