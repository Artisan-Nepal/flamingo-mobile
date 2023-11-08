import 'package:flamingo/feature/dashboard/screen/home/Brand_screen.dart';
import 'package:flamingo/feature/dashboard/screen/home/search/Searchscreen.dart';
import 'package:flamingo/feature/dashboard/screen/home/main_home_screen.dart';
import 'package:flamingo/feature/dashboard/screen/home/me_screen.dart';
import 'package:flamingo/feature/dashboard/screen/home/wishlist_screen.dart';
import 'package:flutter/material.dart';

List<Widget> homescreenitems = [
  const MainHomeScreen(),
  const SearchScreen(),
  const BrandScreen(),
  const WishlistScreen(),
  const MeScreen(),
];
