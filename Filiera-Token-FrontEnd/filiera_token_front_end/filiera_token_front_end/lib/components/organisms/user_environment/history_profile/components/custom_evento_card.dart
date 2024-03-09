import 'package:filiera_token_front_end/models/Evento.dart';
import 'package:flutter/material.dart';

class EventoCard extends StatelessWidget {
  final Evento evento;

  EventoCard({required this.evento});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(evento.tipoEvento),
        subtitle: Text(evento.timestamp),
        trailing: Text(evento.dati['valore']),
      ),
    );
  }
}