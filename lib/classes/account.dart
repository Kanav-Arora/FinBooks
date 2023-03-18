import 'package:flutter/foundation.dart';

class Account {
  final String id;
  final String acc_name;
  final String acc_type;
  final String address;
  final String city;
  final String state;
  final String pincode;
  final String gst_no;
  final String pan_no;
  final String email;
  final String mobile_no;
  final String credit_days;
  final String interest_rate;

  Account(
      {required this.id,
      required this.acc_name,
      required this.acc_type,
      required this.address,
      required this.city,
      required this.state,
      required this.pincode,
      required this.gst_no,
      required this.pan_no,
      required this.email,
      required this.mobile_no,
      required this.credit_days,
      required this.interest_rate});
}
