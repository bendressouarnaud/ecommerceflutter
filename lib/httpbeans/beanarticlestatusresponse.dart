class BeanArticlestatusresponse {
  final int idart;
  final int totalcomment, restant;
  final double note;

  const BeanArticlestatusresponse({
    required this.idart,
    required this.totalcomment,
    required this.restant,
    required this.note
  });

  factory BeanArticlestatusresponse.fromJson(Map<String, dynamic> json) {
    return BeanArticlestatusresponse(
        idart: json['idart'],
        totalcomment: json['totalcomment'],
        restant: json['restant'],
        note: json['note']
    );
  }
}