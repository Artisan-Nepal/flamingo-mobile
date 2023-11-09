import 'package:flamingo/widget/cards/bottom_slider.dart';
import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

class DropSelector extends StatelessWidget {
  final List<String> selections;
  final String? chosenselection;
  final ValueChanged<String> onSelectionchange;

  DropSelector({
    required this.selections,
    required this.chosenselection,
    required this.onSelectionchange,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        _showSizeOptions(context);
      },
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: 'Size',
          suffixIcon: Icon(Icons.arrow_drop_down),
        ),
        child: Text(chosenselection ?? 'Choose Size'),
      ),
    );
  }

  void _showSizeOptions(BuildContext context) {
    bottomSlider(
        context,
        Container(
          height: MediaQuery.of(context).size.height * 0.4,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              Container(
                height: 200,
                child: ListView.builder(
                  itemCount: selections.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      title: Text(selections[index]),
                      onTap: () {
                        Navigator.pop(context);
                        onSelectionchange(selections[index]);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ));
  }
}

class FieldBar extends StatelessWidget {
  final String labelText;
  final String selected;
  final ValueChanged<String> onchange;

  FieldBar({
    required this.labelText,
    required this.selected,
    required this.onchange,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      readOnly: true,
      controller: TextEditingController(text: selected),
      decoration: InputDecoration(
        labelText: labelText,
        suffixIcon: Icon(Icons.arrow_drop_down),
      ),
      onTap: () {
        // You can implement a bottom sheet or any other method to choose the size
        // For simplicity, let's print a message for now
        print('Size cannot be changed for this product.');
      },
    );
  }
}
