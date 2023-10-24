class BeanArticlestatusrequest {
  final List<int> articleid;

  const BeanArticlestatusrequest({
    required this.articleid,
  });

  factory BeanArticlestatusrequest.fromJson(Map<String, dynamic> json) {
    return BeanArticlestatusrequest(
        articleid: json['articleid']
    );
  }
}