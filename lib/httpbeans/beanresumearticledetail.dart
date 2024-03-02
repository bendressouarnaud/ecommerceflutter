import 'beanarticledetail.dart';
import 'beanarticledetailnew.dart';

class BeanResumeArticleDetail{
  final int totalcomment;
  final double noteart;
  final Beanarticledetailnew beanarticle;

  // M e t h o d s
  BeanResumeArticleDetail({required this.totalcomment, required this.noteart, required this.beanarticle});

  factory BeanResumeArticleDetail.fromJson(Map<String, dynamic> json) {
    return BeanResumeArticleDetail(
        totalcomment: json['totalcomment'],
        noteart: json['noteart'],
        beanarticle: Beanarticledetailnew.fromJson(json['beanarticle'])
    );
  }
}