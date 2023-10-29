class BeanActif {
  final int idart, actif, total;

  const BeanActif({
    required this.idart,
    required this.actif,
    required this.total
  });

  factory BeanActif.fromJson(Map<String, dynamic> json) {
    return BeanActif(
        idart: json['idart'],
        actif: json['actif'],
        total: json['total']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idart': idart,
      'actif': actif,
      'total': total
    };
  }
}