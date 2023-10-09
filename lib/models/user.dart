class User {

  // https://vaygeth.medium.com/reactive-flutter-todo-app-using-bloc-design-pattern-b71e2434f692
  // https://pythonforge.com/dart-classes-heritage/

  // A t t r i b u t e s  :
  int? idcli;
  int? commune;
  int? genre;
  String? nom;
  String? prenom;
  String? email;
  String? numero;
  String? adresse;
  String? fcmtoken;
  String? pwd;

  // M e t h o d s  :
  User({required idcli, required commune, required genre, required nom, required prenom, required email, required numero, required adresse, required fcmtoken, required pwd});
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