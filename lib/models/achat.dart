class Achat{
  final int idach;
  final int idart;
  final int actif;

  // M e t h o d s  :
  const Achat({required this.idach, required this.idart, required this.actif});
  factory Achat.fromJson(Map<String, dynamic> data) => Achat(
    idach: data['idach'],
    idart: data['idart'],
    actif: data['actif'],
  );

  Map<String, dynamic> toJson() => {
    //This will be used to convert Todo objects that
    //are to be stored into the datbase in a form of JSON
    "idach": idach,
    "idart": idart,
    "actif": actif,
  };
}