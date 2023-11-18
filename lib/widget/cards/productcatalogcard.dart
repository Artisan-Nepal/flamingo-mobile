import 'package:flamingo/shared/shared.dart';
import 'package:flamingo/widget/space/space.dart';
import 'package:flamingo/widget/text/text.dart';
import 'package:flutter/material.dart';

Widget createProductCard({
  required String topText,
  required String bottomText,
  required String imageUrl,
  required double height,
  required double width,
  bool crossbutton = false,
  bool border = false,
  bool selectedcolor = false,
  VoidCallback? onimgtap,
  String? specialText,
  Color? specialColor,
  Widget? widget,
  VoidCallback? close,
  bool? vertical = true,
}) {
  return vertical == true
      ? Column(
          children: [
            Card(
              color: AppColors.white,
              child: Column(
                children: [
                  Stack(
                    children: [
                      GestureDetector(
                        onTap: onimgtap,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image.network(
                            imageUrl,
                            width: width,
                            height: height *
                                .5, // Adjust the height as per your requirement
                            fit: BoxFit.contain,
                            alignment: Alignment.center,
                            loadingBuilder: (BuildContext context, Widget child,
                                ImageChunkEvent? loadingProgress) {
                              if (loadingProgress == null) {
                                return child;
                              } else {
                                return CircularProgressIndicator();
                              }
                            },
                          ),
                        ),
                      ),
                      if (specialText != null)
                        Positioned(
                          top: 2,
                          left: 0,
                          child: Container(
                            width: width,
                            padding: EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: specialColor ?? AppColors.orange,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: TextWidget(
                              specialText,
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                color: AppColors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                      if (crossbutton)
                        Positioned(
                          top: 4,
                          right: 4,
                          child: GestureDetector(
                            onTap: close,
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.black.withOpacity(0.7),
                              ),
                              child: Icon(
                                Icons.close,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    child: Container(
                      width: width,
                      color: AppColors.white,
                      padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextWidget(
                            topText,
                            textAlign: TextAlign.start,
                            textOverflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: AppColors.black,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(
                              height:
                                  8), // Add spacing between top and bottom text
                          TextWidget(
                            bottomText,
                            textAlign: TextAlign.start,
                            textOverflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.black,
                              fontSize: 16,
                            ),
                          ),
                          widget != null
                              ? Column(
                                  children: [
                                    VerticalSpaceWidget(height: 5),
                                    widget,
                                  ],
                                )
                              : VerticalSpaceWidget(height: 0)
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ) ////////cart
      : Stack(children: [
          Card(
            color: AppColors.white,
            // color: selectedcolor? AppColors.grayLight: AppColors.white,
            shape: RoundedRectangleBorder(
              side: BorderSide(
                  color: border ? Colors.black : Colors.transparent, width: 2),
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 0,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Stack(
                    children: [
                      GestureDetector(
                        onTap: onimgtap,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            imageUrl,
                            width: width,
                            height: height,
                            fit: BoxFit.fill,
                            // loadingBuilder: (BuildContext context, Widget child,
                            //     ImageChunkEvent? loadingProgress) {
                            //   if (loadingProgress == null) {
                            //     return child;
                            //   } else {
                            //     return CircularProgressIndicator();
                            //   }
                            // },
                          ),
                        ),
                      ),
                      Positioned(
                        left: 0,
                        top: 0,
                        child: specialText != null
                            ? Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: specialColor ?? AppColors.orange,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: TextWidget(
                                  specialText,
                                  style: TextStyle(
                                    color: AppColors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              )
                            : VerticalSpaceWidget(height: 0),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextWidget(
                          topText,
                          style: TextStyle(
                            color: AppColors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        SizedBox(height: 8),
                        TextWidget(
                          bottomText,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.black,
                            fontSize: 16,
                          ),
                        ),
                        if (widget != null)
                          Column(
                            children: [
                              VerticalSpaceWidget(height: 5),
                              widget,
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (crossbutton)
            Positioned(
              top: 7,
              right: 7,
              child: GestureDetector(
                onTap: close,
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black.withOpacity(0.7),
                  ),
                  child: Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ),
        ]);
}
