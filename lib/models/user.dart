class User {

  // https://vaygeth.medium.com/reactive-flutter-todo-app-using-bloc-design-pattern-b71e2434f692
  // https://pythonforge.com/dart-classes-heritage/

  // A t t r i b u t e s  :
  final int idcli;
  final int commune;
  final int genre;
  final String nom;
  final String prenom;
  final String email;
  final String numero;
  final String adresse;
  final String fcmtoken;
  final String pwd;

  // M e t h o d s  :
  User({required this.idcli, required this.commune, required this.genre, required this.nom, required this.prenom, required this.email, required this.numero,
    required this.adresse, required this.fcmtoken, required this.pwd});
  factory User.fromDatabaseJson(Map<String, dynamic> data) => User(
    //This will be used to convert JSON objects that
    //are coming from querying the database and converting
    //it into a Todo object
    idcli: data['idcli'],
    commune: data['commune'],
    genre: data['genre'],
    nom: data['nom'],
    prenom: data['prenom'],
    email: data['email'],
    numero: data['numero'],
    adresse: data['adresse'],
    fcmtoken: data['fcmtoken'],
    pwd: data['pwd'],
  );

  Map<String, dynamic> toDatabaseJson() => {
    //This will be used to convert Todo objects that
    //are to be stored into the datbase in a form of JSON
    "idcli": idcli,
    "commune": commune,
    "genre": genre,
    "nom": nom,
    "prenom": prenom,
    "email": email,
    "numero": numero,
    "adresse": adresse,
    "fcmtoken": fcmtoken,
    "pwd": pwd,
  };
}