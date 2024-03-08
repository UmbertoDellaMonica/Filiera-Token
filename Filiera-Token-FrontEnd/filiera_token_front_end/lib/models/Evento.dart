import 'dart:math';

class Evento {
  final String timestamp;
  final String tipoEvento;
  final Map<String, dynamic> dati;

  Evento({
    required this.timestamp,
    required this.tipoEvento,
    required this.dati,
  });

  factory Evento.fromJson(Map<String, dynamic> json) {
    return Evento(
      timestamp: json['timestamp'],
      tipoEvento: json['tipoEvento'],
      dati: json['dati'],
    );
  }

  @override
  String toString() {
    return 'Evento{timestamp: $timestamp, tipoEvento: $tipoEvento, dati: $dati}';
  }

  static Evento generateRandomEvent() {
    final timestamp = DateTime.now().toIso8601String();
    final tipoEvento = 'Evento casuale ${Random().nextInt(100)}';
    final dati = {'valore': '${Random().nextInt(1000)}'};
    return Evento(timestamp: timestamp, tipoEvento: tipoEvento, dati: dati);
  }
}
