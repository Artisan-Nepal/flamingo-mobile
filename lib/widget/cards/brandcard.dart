import 'package:flamingo/shared/util/util.dart';
import 'package:flamingo/widget/text/text.dart';
import 'package:flutter/material.dart';

Widget createBrandCard({
  required String topText,
  required String bottomText,
  required String imageUrl,
  required double height,
  required double width,
  String? specialText,
  Color? specialColor,
}) {
  return Card(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10.0),
    ),
    elevation: 0,
    margin: const EdgeInsets.all(8.0),
    child: Stack(
      children: [
        ClipRRect(
          child: Image.network(
            imageUrl,
            width: width,
            height: height, // Adjust the height as per your requirement
            fit: BoxFit.fill,
          ),
        ),
        Positioned(
          bottom: 25,
          left: 0,
          child: specialText != null
              ? Container(
                  width: width,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: specialColor ??
                        Colors.orange, // Default color if not provided
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: TextWidget(
                    specialText,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                )
              : Container(
                  width: width,
                  color: AppColors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                  child: TextWidget(
                    topText,
                    textAlign: TextAlign.start,
                    textOverflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          child: Container(
            width: width,
            color: AppColors.white,
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
            child: TextWidget(
              bottomText,
              textAlign: TextAlign.start,
              textOverflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
