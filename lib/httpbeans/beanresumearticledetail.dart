import 'beanarticledetail.dart';

class BeanResumeArticleDetail{
  final int totalcomment;
  final double noteart;
  final Beanarticledetail beanarticle;

  // M e t h o d s
  BeanResumeArticleDetail({required this.totalcomment, required this.noteart, required this.beanarticle});

  factory BeanResumeArticleDetail.fromJson(Map<String, dynamic> json) {
    return BeanResumeArticleDetail(
        totalcomment: json['totalcomment'],
        noteart: json['noteart'],
        beanarticle: Beanarticledetail.fromJson(json['beanarticle'])
    );
  }
}