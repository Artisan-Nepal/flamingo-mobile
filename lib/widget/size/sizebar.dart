import 'package:flamingo/widget/cards/bottom_slider.dart';
import 'package:flamingo/widget/text/text.dart';
import 'package:flutter/material.dart';

class DropSelector extends StatelessWidget {
  final List<String> selections;
  final String? chosenselection;
  final ValueChanged<String> onSelectionchange;
  final double? height;
  final double width;
  final String hinttext;

  DropSelector(
      {required this.selections,
      required this.chosenselection,
      required this.onSelectionchange,
      required this.height,
      required this.width,
      required this.hinttext});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        _showSizeOptions(context, hinttext);
      },
      child: Material(
        color: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
          side: const BorderSide(color: Colors.blue, width: 2.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: height,
            width: width,
            child: Center(
                child: Row(
              children: [
                Expanded(
                  child: TextWidget(
                    chosenselection != null
                        ? '${hinttext}: ${chosenselection}'
                        : hinttext,
                    textAlign: TextAlign.left,
                    textOverflow: TextOverflow.clip,
                  ),
                ),
                Icon(Icons.arrow_drop_down_outlined),
              ],
            )),
          ),
        ),
      ),
    );
  }

  void _showSizeOptions(BuildContext context, String label) {
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
              Center(
                child: TextWidget(
                  'Available ${label}:',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                height: 200,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: selections.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Center(
                            child: ListTile(
                              title: TextWidget(
                                selections[index],
                                textAlign: TextAlign.center,
                              ),
                              onTap: () {
                                onSelectionchange(selections[index]);
                                Navigator.pop(context);
                              },
                            ),
                          );
                        },
                      ),
                    ],
                  ),
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
  final double? height;
  final double width;

  FieldBar({
    required this.labelText,
    required this.selected,
    required this.onchange,
    required this.height,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
        side: const BorderSide(color: Colors.blue, width: 2.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          height: height,
          width: width,
          child: Center(
              child: Row(
            children: [
              Expanded(
                child: TextWidget(
                  labelText,
                  textAlign: TextAlign.left,
                  textOverflow: TextOverflow.clip,
                ),
              ),
              Icon(Icons.arrow_drop_down_outlined),
            ],
          )),
        ),
      ),
    );
  }
}
