import 'package:flutter/material.dart';

class CustomStack extends StatelessWidget {
  final GestureDetector profilePicture;
  final GestureDetector coverPicture;

  const CustomStack({
    required this.profilePicture,
    required this.coverPicture,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.33,
      child: Stack(
        children: [
          coverPicture,
          Positioned(
            top: MediaQuery.of(context).size.height / 5,
            left: MediaQuery.of(context).size.width / 40,
            child: profilePicture,
          ),
        ],
      ),
    );
  }
}
