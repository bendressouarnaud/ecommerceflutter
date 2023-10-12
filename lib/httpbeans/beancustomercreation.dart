import '../models/user.dart';

class BeanCustomerCreation{
  final int flag;
  final User clt;

  // M e t h o d s
  BeanCustomerCreation({required this.flag, required this.clt});

  int get leFlag {
    return flag;
  }

  User get leUser {
    return clt;
  }

  factory BeanCustomerCreation.fromJson(Map<String, dynamic> json) {
    return BeanCustomerCreation(
        flag: json['flag'],
        clt: User.fromDatabaseJson(json['clt'])// json['clt']
    );
  }
}