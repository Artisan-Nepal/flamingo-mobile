import 'package:flamingo/di/di.dart';
import 'package:flamingo/feature/dashboard/screen/profile_screen/edit_profile/edit_Profile_model.dart';
import 'package:flamingo/feature/profile/model/profile.dart';
import 'package:flamingo/widget/button/button.dart';
import 'package:flamingo/widget/screen/default_screen.dart';
import 'package:flamingo/widget/space/space.dart';
import 'package:flamingo/widget/stack/stack.dart';
import 'package:flamingo/widget/text-field/text_field.dart';
import 'package:flamingo/widget/text/text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileEditScreen extends StatefulWidget {
  final Profile user;
  const ProfileEditScreen({super.key, required this.user});

  @override
  State<ProfileEditScreen> createState() => ProfileEditScreenState();
}

class ProfileEditScreenState extends State<ProfileEditScreen> {
  final _viewmodel = locator<EditProfileModel>();
  final TextEditingController _namecontroller = TextEditingController();
  final TextEditingController _biocontroller = TextEditingController();
  final TextEditingController _addresscontroller = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => _viewmodel,
      builder: (context, child) => DefaultScreen(
        appBarTitle: TextWidget(
          "Edit ${widget.user.name}'s profile",
          textAlign: TextAlign.left,
          style: const TextStyle(fontSize: 20),
        ),
        bottomNavigationBar: const VerticalSpaceWidget(height: 0),
        child: SafeArea(
          child: Consumer<EditProfileModel>(
            builder: (context, viewModel, child) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomStack(
                      profilePicture: GestureDetector(
                        key: const Key('profilePicture'),
                        onTap: () {
                          _editProfilePicture();
                        },
                        child: Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 3),
                          ),
                          child: ClipOval(
                            child: Image.network(
                              widget.user.profilePicture,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      coverPicture: GestureDetector(
                        key: const Key('coverPhoto'),
                        onTap: () {
                          _editCoverPhoto();
                        },
                        child: Image.network(
                          widget.user.coverPicture,
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * 0.27,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const VerticalSpaceWidget(height: 10),
                    const TextWidget(
                      'Username:',
                      textAlign: TextAlign.left,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    TextFieldWidget(
                      hintText: widget.user.name,
                      controller: _namecontroller,
                    ),
                    const VerticalSpaceWidget(height: 10),
                    const TextWidget(
                      'Address:',
                      textAlign: TextAlign.left,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    TextFieldWidget(
                      hintText: widget.user.address,
                      controller: _addresscontroller,
                    ),
                    const VerticalSpaceWidget(height: 10),
                    const TextWidget(
                      'Bio:',
                      textAlign: TextAlign.left,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    TextFieldWidget(
                      hintText: widget.user.bio,
                      controller: _biocontroller,
                      textInputType: TextInputType.multiline,
                    ),
                    const VerticalSpaceWidget(height: 30),
                    ButtonWidget(
                        fontSize: 20,
                        label: 'Save',
                        onPressed: () {
                          print(_namecontroller.text);
                          print(_addresscontroller.text);
                          print(_biocontroller.text);
                        })
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  // Function to handle editing cover photo
  void _editCoverPhoto() {
    print('change cover photo');
  }

// Function to handle editing profile picture
  void _editProfilePicture() {
    print('change profile photo');
  }
}
