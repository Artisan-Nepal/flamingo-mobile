import 'package:flamingo/data/data.dart';

String? validatePhoneNumber(PhoneNumber? phoneNumber) {
  if (phoneNumber == null || phoneNumber.number.isEmpty) {
    return 'Phone number required.';
  } else if (phoneNumber.number.length != 10) {
    return 'Enter a valid phone number.';
  }
  return null;
}
