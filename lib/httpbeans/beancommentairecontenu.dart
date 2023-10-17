class BeanCommentaireContenu {
  final int note;
  final String dates, commentaire, client;

  const BeanCommentaireContenu({
    required this.note,
    required this.dates,
    required this.commentaire,
    required this.client,
  });

  factory BeanCommentaireContenu.fromJson(Map<String, dynamic> json) {
    return BeanCommentaireContenu(
      note: json['note'],
      dates: json['dates'],
      commentaire: json['commentaire'],
      client: json['client'],
    );
  }
}