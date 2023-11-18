import 'package:flamingo/shared/shared.dart';
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
  final bool forcart;

  DropSelector(
      {required this.selections,
      this.forcart = false,
      required this.chosenselection,
      required this.onSelectionchange,
      required this.height,
      required this.width,
      required this.hinttext});

  @override
  Widget build(BuildContext context) {
    return forcart == false
        ? GestureDetector(
            onTap: () {
              _showSizeOptions(context, hinttext);
            },
            child: Container(
              height: height,
              width: width,
              decoration: BoxDecoration(
                color: AppColors.grayLight,
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        chosenselection != null
                            ? '$hinttext: $chosenselection'
                            : hinttext,
                        textAlign: TextAlign.left,
                        overflow: TextOverflow.clip,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        : InkWell(
            onTap: () {
              _showSizeOptions(context, hinttext);
            },
            child: Material(
              color: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
                side: const BorderSide(color: Colors.black, width: 2.0),
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
                '${label}:',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              height: 200,
              child: Stack(
                children: [
                  SingleChildScrollView(
                    child: Column(
                      children: List.generate(
                        selections.length,
                        (index) => Center(
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
                        ),
                      ),
                    ),
                  ),
                  // Top semi-transparent overlay
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    height: 100,
                    child: IgnorePointer(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.white.withOpacity(0.8),
                              Colors.white.withOpacity(0.1),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Bottom semi-transparent overlay
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    height: 100,
                    child: IgnorePointer(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.white.withOpacity(0.1),
                              Colors.white.withOpacity(0.8),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FieldBar extends StatelessWidget {
  final String labelText;
  final String selected;
  final ValueChanged<String> onchange;
  final double? height;
  final double width;
  final bool forcart;

  FieldBar({
    this.forcart = false,
    required this.labelText,
    required this.selected,
    required this.onchange,
    required this.height,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return forcart == false
        ? GestureDetector(
            onTap: () {},
            child: Container(
              width: width,
              height: height,
              decoration: BoxDecoration(
                color: AppColors.grayLight,
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        labelText,
                        textAlign: TextAlign.left,
                        overflow: TextOverflow.clip,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        : InkWell(
            onTap: () {},
            child: Material(
              color: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
                side: const BorderSide(color: Colors.black, width: 2.0),
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
            ),
          );
  }
}
