import '../models/user.dart';
import 'beancommentairecontenu.dart';
import 'beanresumearticle.dart';
import 'commune.dart';
import 'imagesupplement.dart';

class BeanCustomerAuth{

  // A T T R I B U T S
  final int flag;
  final User clt;
  final List<Commune> commune;


  // M e t h o d s
  BeanCustomerAuth({required this.flag, required this.clt, required this.commune});

  factory BeanCustomerAuth.fromJson(Map<String, dynamic> json) {
    return BeanCustomerAuth(
      flag: json['flag'],
      clt: User.fromDatabaseJson(json['clt']),
      commune: List<dynamic>.from(json['commune']).map((i) => Commune.fromJson(i)).toList(),
    );
  }
}