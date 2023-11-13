import 'package:flamingo/feature/dashboard/screen/home/brand/Brand_screen.dart';
import 'package:flamingo/feature/dashboard/screen/home/search/Searchscreen.dart';
import 'package:flamingo/feature/dashboard/screen/home/main/main_home_screen.dart';
import 'package:flamingo/feature/dashboard/screen/profile_screen/me_screen.dart';
import 'package:flamingo/feature/dashboard/screen/home/wishlist/wishlist_screen.dart';
import 'package:flutter/material.dart';

List<Widget> homescreenitems = [
  const MainHomeScreen(),
  const SearchScreen(),
  const BrandScreen(),
  const WishlistScreen(),
  const MeScreen(),
];
