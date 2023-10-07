String? validatePhoneNumber(String? text) {
  if (text == null || text.isEmpty) {
    return 'Phone number required.';
  } else if (text.length != 10) {
    return 'Enter a valid phone number.';
  }
  return null;
}
