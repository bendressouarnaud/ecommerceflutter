import 'beancommentairecontenu.dart';
import 'beanresumearticle.dart';
import 'imagesupplement.dart';

class Beanarticledatahistory{

  // A T T R I B U T S
  final String article, entreprise, modaliteretour, descriptionproduit, contact;
  final int prix, reduction, nombrearticle, autorisecommentaire, commentaireexiste, iddet, note, trackVetement, taille;
  final List<Imagesupplement> images;
  final List<BeanCommentaireContenu> comments;


  // M e t h o d s
  Beanarticledatahistory({required this.article, required this.entreprise, required this.modaliteretour, required this.descriptionproduit, required this.contact
    , required this.prix, required this.reduction, required this.nombrearticle, required this.autorisecommentaire, required this.commentaireexiste, required this.iddet
    ,required this.note, required this.trackVetement, required this.taille, required this.images, required this.comments});

  factory Beanarticledatahistory.fromJson(Map<String, dynamic> json) {
    return Beanarticledatahistory(
        article: json['article'],
        entreprise: json['entreprise'],
        modaliteretour: json['modaliteretour'],
        descriptionproduit: json['descriptionproduit'],
        contact: json['contact'],
        prix: json['prix'],
        reduction: json['reduction'],
        nombrearticle: json['nombrearticle'],
        autorisecommentaire: json['autorisecommentaire'],
        commentaireexiste: json['commentaireexiste'],
        iddet: json['iddet'],
        note: json['note'],
        trackVetement: json['trackVetement'],
        taille: json['taille'],
        images: List<dynamic>.from(json['images']).map((i) => Imagesupplement.fromJson(i)).toList(),
        comments: List<dynamic>.from(json['comments']).map((i) => BeanCommentaireContenu.fromJson(i)).toList(),
    );
  }
}