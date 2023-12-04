class RequestBean{
  final int id;
  final String lib;

  // M e t h o d s
  const RequestBean({required this.id, required this.lib});


  factory RequestBean.fromJson(Map<String, dynamic> json) {
    return RequestBean(
        id: json['id'],
        lib: json['lib'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'lib': lib
    };
  }
}