class Article{
  final int idart;
  final int iddet;
  final int prix;
  final int reduction;
  final int note;
  final int articlerestant;
  final String libelle;
  final String lienweb;

  // M e t h o d s  :
  const Article({required this.idart, required this.iddet, required this.prix, required this.reduction, required this.note, required this.articlerestant, required this.libelle, required this.lienweb});
  factory Article.fromJson(Map<String, dynamic> data) => Article(
    idart: data['idart'],
    iddet: data['iddet'],
    prix: data['prix'],
    reduction: data['reduction'],
    note: data['note'],
    articlerestant: data['articlerestant'],
    libelle: data['libelle'],
    lienweb: data['lienweb'],
  );

  Map<String, dynamic> toJson() => {
    //This will be used to convert Todo objects that
    //are to be stored into the datbase in a form of JSON
    "idart": idart,
    "iddet": iddet,
    "prix": prix,
    "reduction": reduction,
    "note": note,
    "articlerestant": articlerestant,
    "libelle": libelle,
    "lienweb": lienweb,
  };
}