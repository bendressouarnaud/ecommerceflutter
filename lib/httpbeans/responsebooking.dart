class ResponseBooking{
  final String dates, heure;
  final int etat;

  const ResponseBooking({
    required this.dates,
    required this.heure,
    required this.etat
  });

  factory ResponseBooking.fromJson(Map<String, dynamic> json) {
    return ResponseBooking(
        dates: json['dates'],
        heure: json['heure'],
        etat: json['etat']
    );
  }
}