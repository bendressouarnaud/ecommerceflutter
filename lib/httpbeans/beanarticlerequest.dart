import 'beanactif.dart';

class Beanarticlerequest {
  final int idcli, choixpaiement;
  final List<BeanActif> liste;

  const Beanarticlerequest({
    required this.idcli,
    required this.choixpaiement,
    required this.liste
  });

  factory Beanarticlerequest.fromJson(Map<String, dynamic> json) {
    return Beanarticlerequest(
      idcli: json['idcli'],
      choixpaiement: json['choixpaiement'],
      liste: List<dynamic>.from(json['liste']).map((i) => BeanActif.fromJson(i)).toList(),
    );
  }
}