import 'package:flamingo/data/remote/rest/api_client.dart';

import 'package:flamingo/feature/profile/model/profile.dart';

import 'package:flamingo/feature/profile/remote/profile_remote.dart';

class ProfileRemoteImpl implements ProfileRemote {
  // ignore: unused_field
  final ApiClient _apiClient;

  ProfileRemoteImpl({required ApiClient apiClient}) : _apiClient = apiClient;

  @override
  Future<Profile> getProfile() async {
    return Profile(
        cart: [
          '1',
          '6',
          '8',
          '7',
        ],
        wishlist: [
          '3',
          '6',
          '9',
          '11',
          '4'
        ],
        profileid: 'Testid1',
        bio: 'Hello. Its a me',
        profilePicture:
            'https://images.unsplash.com/photo-1683009427619-a1a11b799e05?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDF8MHxlZGl0b3JpYWwtZmVlZHwxfHx8ZW58MHx8fHx8',
        coverPicture:
            'https://images.unsplash.com/photo-1682686580036-b5e25932ce9a?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDF8MHxlZGl0b3JpYWwtZmVlZHw2fHx8ZW58MHx8fHx8',
        address: 'Budhanilkantha',
        name: 'Clyde Wyncham');
  }

  @override
  Future<List<Profile>> getbrandProfile() async {
    //if wishlist already in card add to cart no work popup
    return [
      Profile(
        cart: [],
        wishlist: [],
        profileid: 'Gucci123',
        bio: 'Fashion and style!',
        profilePicture:
            'https://images.unsplash.com/photo-1683009427619-a1a11b799e05?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDF8MHxlZGl0b3JpYWwtZmVlZHwxfHx8ZW58MHx8fHx8',
        coverPicture:
            'https://images.unsplash.com/photo-1682686580036-b5e25932ce9a?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDF8MHxlZGl0b3JpYWwtZmVlZHw2fHx8ZW58MHx8fHx8',
        address: 'Milan, Italy',
        name: 'Gucci',
      ),
      Profile(
        cart: [],
        wishlist: [],
        profileid: 'BrandX789',
        bio: 'The world of elegance!',
        profilePicture:
            'https://images.unsplash.com/photo-1683009427619-a1a11b799e05?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDF8MHxlZGl0b3JpYWwtZmVlZHwxfHx8ZW58MHx8fHx8',
        coverPicture:
            'https://images.unsplash.com/photo-1682686580036-b5e25932ce9a?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDF8MHxlZGl0b3JpYWwtZmVlZHw2fHx8ZW58MHx8fHx8',
        address: 'Paris, France',
        name: 'Brand X',
      ),
      Profile(
        cart: [],
        wishlist: [],
        profileid: 'Brand1',
        bio: 'Bringing innovation to your life!',
        profilePicture:
            'https://images.unsplash.com/photo-1682686580036-b5e25932ce9a?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDF8MHxlZGl0b3JpYWwtZmVlZHw2fHx8ZW58MHx8fHx8',
        coverPicture:
            'https://images.unsplash.com/photo-1683009427619-a1a11b799e05?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDF8MHxlZGl0b3JpYWwtZmVlZHwxfHx8ZW58MHx8fHx8',
        address: 'Location for Brand 1',
        name: 'Brand 1',
      ),
      Profile(
        cart: [],
        wishlist: [],
        profileid: 'Brand2',
        bio: 'A lifestyle you deserve!',
        profilePicture:
            'https://images.unsplash.com/photo-1682686580036-b5e25932ce9a?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDF8MHxlZGl0b3JpYWwtZmVlZHw2fHx8ZW58MHx8fHx8',
        coverPicture:
            'https://images.unsplash.com/photo-1683009427619-a1a11b799e05?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDF8MHxlZGl0b3JpYWwtZmVlZHwxfHx8ZW58MHx8fHx8',
        address: 'Location for Brand 2',
        name: 'Brand 2',
      )
    ];
  }

  @override
  String getProfileid() {
    String profileid = 'Testid1';
    return profileid;
  }

  @override
  List<String> getaddress() {
    List<String> address = ['Sukedhara', 'Ktm, 46500', 'Nepal'];
    return address;
  }
}
