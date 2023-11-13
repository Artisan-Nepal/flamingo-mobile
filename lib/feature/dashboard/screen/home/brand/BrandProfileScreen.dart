import 'package:flamingo/di/di.dart';
import 'package:flamingo/feature/dashboard/screen/home/brand/brandprofilescreenmodel.dart';
import 'package:flamingo/feature/dashboard/screen/home/product/product/productscreen.dart';
import 'package:flamingo/feature/product/data/model/product.dart';

import 'package:flamingo/feature/profile/model/profile.dart';
import 'package:flamingo/shared/util/colors.dart';
import 'package:flamingo/widget/arrowdown/arrowdown.dart';
import 'package:flamingo/widget/button/button.dart';

import 'package:flamingo/widget/cards/productcatalogcard.dart';
import 'package:flamingo/widget/screen/default_screen.dart';
import 'package:flamingo/widget/space/space.dart';
import 'package:flamingo/widget/stack/stack.dart';
import 'package:flamingo/widget/text-field/text_field.dart';
import 'package:flamingo/widget/text/text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BrandProfileScreen extends StatefulWidget {
  final Profile user;
  const BrandProfileScreen({super.key, required this.user});

  @override
  State<BrandProfileScreen> createState() => ProfileEditScreenState();
}

class ProfileEditScreenState extends State<BrandProfileScreen> {
  final TextEditingController _textEditingController = TextEditingController();

  final _viewmodel = locator<BrandProfileScreenmodel>();
  int _selectedTabIndex = 0; // 0 for Profile, 1 for Reviews

  @override
  void initState() {
    _viewmodel.getbrandproducts(widget.user.name);
    _viewmodel.getid();
    _viewmodel.getuserprofile();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => _viewmodel,
      builder: (context, child) => DefaultScreen(
        appBarTitle: TextWidget(
          "${widget.user.name}",
          textAlign: TextAlign.left,
          style: TextStyle(fontSize: 20),
        ),
        bottomNavigationBar: const VerticalSpaceWidget(height: 0),
        child: Consumer<BrandProfileScreenmodel>(
          builder: (context, viewModel, child) {
            return SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      children: [
                        _buildTab('Profile', 0),
                        const HorizontalSpaceWidget(width: 20),
                        _buildTab('Reviews', 1),
                      ],
                    ),
                  ),
                  VerticalSpaceWidget(height: 10),
                  IndexedStack(
                    index: _selectedTabIndex,
                    children: [
                      Consumer<BrandProfileScreenmodel>(
                        builder: (context, viewModel, child) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                CustomStack(
                                  profilePicture: GestureDetector(
                                    key: Key('profilePicture'),
                                    onTap: () {},
                                    child: Container(
                                      width: 100,
                                      height: 100,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                            color: Colors.white, width: 3),
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
                                    key: Key('coverPhoto'),
                                    onTap: () {},
                                    child: Image.network(
                                      widget.user.coverPicture,
                                      width: MediaQuery.of(context).size.width,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.27,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                VerticalSpaceWidget(height: 1),
                                Transform.translate(
                                  offset: Offset(
                                      -100 + widget.user.name.length * 0.8, 0),
                                  child: Column(
                                    children: [
                                      TextWidget(
                                        widget.user.name,
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          fontSize: 22,
                                          color: AppColors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      TextWidget(
                                        widget.user.address,
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: AppColors.grayLight),
                                      ),
                                    ],
                                  ),
                                ),
                                VerticalSpaceWidget(height: 15),
                                ArrowDown(title: 'Listings', body: Container()),
                                VerticalSpaceColoredWidget(
                                  height: 19,
                                  thickness: 1,
                                  color: AppColors.grayLight,
                                ),
                                ArrowDown(
                                    title: 'Discounted Items',
                                    body: Container()),
                                VerticalSpaceColoredWidget(
                                  height: 19,
                                  thickness: 1,
                                  color: AppColors.grayLight,
                                ),

                                // Other profile-related content
                                const Align(
                                  alignment: Alignment.centerLeft,
                                  child: TextWidget(
                                    'Products:',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                  ),
                                ),
                                viewModel.listofproduct.data != null
                                    ? GridView.builder(
                                        physics: ScrollPhysics(),
                                        shrinkWrap: true,
                                        gridDelegate:
                                            SliverGridDelegateWithFixedCrossAxisCount(
                                                crossAxisCount: 2,
                                                crossAxisSpacing: 1,
                                                mainAxisSpacing: 1,
                                                childAspectRatio: 0.7),
                                        itemCount: viewModel
                                            .listofproduct.data!.length,
                                        itemBuilder: (context, index) {
                                          return GestureDetector(
                                            onTap: () {
                                              // Handle the brand box tap, maybe navigate to a brand detail screen
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      ProductScreen(
                                                    product: viewModel
                                                        .listofproduct
                                                        .data![index],
                                                  ),
                                                ),
                                              );
                                            },
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(2.0),
                                              child: createProductCard(
                                                  height: 220,
                                                  width: 200,
                                                  topText: viewModel
                                                      .listofproduct
                                                      .data![index]
                                                      .name,
                                                  bottomText: viewModel
                                                      .listofproduct
                                                      .data![index]
                                                      .price,
                                                  imageUrl: viewModel
                                                      .listofproduct
                                                      .data![index]
                                                      .imageurl[0],
                                                  specialText: viewModel
                                                      .listofproduct
                                                      .data![index]
                                                      .discount,
                                                  specialColor:
                                                      AppColors.orange),
                                            ),
                                          );
                                        },
                                      )
                                    : const CircularProgressIndicator(),
                              ],
                            ),
                          );
                        },
                      ),
                      _selectedTabIndex == 1
                          ? _buildReviewWidget()
                          : SizedBox(), // Reviews view
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildTab(String title, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTabIndex = index;
        });
      },
      child: Container(
        width: MediaQuery.of(context).size.width / 2.65,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: _selectedTabIndex == index
              ? AppColors.grayLighter // Selected tab color
              : AppColors.transparent,
          borderRadius: BorderRadius.circular(5),
        ),
        child: TextWidget(
          title,
          style: TextStyle(
            fontWeight: _selectedTabIndex == index
                ? FontWeight.bold
                : FontWeight.normal,
            color: _selectedTabIndex == index
                ? AppColors.black // Selected text color
                : AppColors.black, // Default text color
          ),
        ),
      ),
    );
  }

  Widget _buildReviewWidget() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          ArrowDown(title: 'Reviews', body: Container()),
          VerticalSpaceColoredWidget(
            height: 19,
            thickness: 2,
            color: AppColors.grayLight,
          ),
          TextFieldWidget(
            controller: _textEditingController,
            label: 'Write a review',
            onFieldSubmitted: (value) {
              print('Done');
            },
          ),
          VerticalSpaceWidget(height: 10),
          RoundedFilledButtonWidget(
            label: 'Submit',
            onPressed: () {
              print(_textEditingController.text);
            },
          ),
        ],
      ),
    );
  }
}





// class BrandProfileScreen extends StatefulWidget {
//   final Profile user;
//   const BrandProfileScreen({super.key, required this.user});

//   @override
//   State<BrandProfileScreen> createState() => ProfileEditScreenState();
// }

// class ProfileEditScreenState extends State<BrandProfileScreen> {
//   final _viewmodel = locator<BrandProfileScreenmodel>();

//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   void dispose() {
//     // TODO: implement dispose
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return ChangeNotifierProvider(
//       create: (context) => _viewmodel,
//       builder: (context, child) => DefaultScreen(
//         appBarTitle: TextWidget(
//           "${widget.user.name}",
//           textAlign: TextAlign.left,
//           style: TextStyle(fontSize: 20),
//         ),
//         bottomNavigationBar: const VerticalSpaceWidget(height: 0),
//         child: SafeArea(
//           child: Consumer<BrandProfileScreenmodel>(
//             builder: (context, viewModel, child) {
//               return buildProfileLayout(widget.user, context, 'id');
//             },
//           ),
//         ),
//       ),
//     );
//   }

  

// }
