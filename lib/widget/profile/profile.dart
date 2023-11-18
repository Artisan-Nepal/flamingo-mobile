import 'package:flamingo/feature/dashboard/screen/profile_screen/edit_profile/edit_profile.dart';
import 'package:flamingo/feature/profile/model/profile.dart';
import 'package:flamingo/shared/shared.dart';
import 'package:flamingo/widget/arrowdown/arrowdown.dart';
import 'package:flamingo/widget/button/button.dart';
import 'package:flamingo/widget/space/space.dart';
import 'package:flamingo/widget/text/text.dart';
import 'package:flutter/material.dart';

Widget buildProfileLayout(Profile? profile, BuildContext context, String? id) {
  return profile != null && id != null
      ? Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height *
                    0.33, // Set container height
                child: Stack(
                  children: [
                    Image.network(
                      profile.coverPicture,
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height *
                          0.27, // Set cover photo height
                      fit: BoxFit.cover,
                    ),
                    Positioned(
                      top: MediaQuery.of(context).size.height / 5,
                      left: MediaQuery.of(context).size.width / 40,
                      child: Container(
                        width: MediaQuery.of(context).size.height / 8,
                        height: MediaQuery.of(context).size.height / 8,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 3),
                        ),
                        child: ClipOval(
                          child: Image.network(
                            profile.profilePicture,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Transform.translate(
                offset: Offset(-100 + profile.name.length * 1.95, 0),
                child: Column(
                  children: [
                    TextWidget(
                      profile.name,
                      textAlign: TextAlign.left,
                      style: const TextStyle(
                        fontSize: 22,
                        color: AppColors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextWidget(
                      profile.address,
                      textAlign: TextAlign.left,
                      style: const TextStyle(
                          fontSize: 14, color: AppColors.grayLight),
                    ),
                  ],
                ),
              ),
              const VerticalSpaceWidget(height: 20),
              const VerticalSpaceColoredWidget(
                height: 7,
                thickness: 2,
                color: AppColors.grayLight,
              ),
              id == profile.profileid
                  ? ButtonWidget(
                      fontSize: 20,
                      label: 'Edit Profile',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProfileEditScreen(
                              user: profile,
                            ),
                          ),
                        );
                      })
                  : const HorizontalSpaceWidget(width: 0),
              const VerticalSpaceWidget(height: 90),
              ArrowDown(title: 'Bio', body: Container()),
              const VerticalSpaceColoredWidget(
                height: 35,
                thickness: 1,
                color: AppColors.grayLight,
              ),
              ArrowDown(title: 'Listing', body: Container()),
              const VerticalSpaceColoredWidget(
                height: 35,
                thickness: 1,
                color: AppColors.grayLight,
              ),
            ],
          ),
        )
      : const CircularProgressIndicator();
}
