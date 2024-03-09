// ... your existing code

import 'package:filiera_token_front_end/components/organisms/user_environment/history_profile/components/custom_evento_card.dart';
import 'package:filiera_token_front_end/models/Evento.dart';
import 'package:flutter/material.dart';

class EventList extends StatefulWidget {
  const EventList({Key? key}) : super(key: key);

  @override
  State<EventList> createState() => EventListState();

}

class EventListState extends State<EventList> {
  
  final List<Evento> eventi = [];

  void generateAndAddEvent() {
    setState(() {
      eventi.add(Evento.generateRandomEvent());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(55.0),
      child: ListView.builder(
        itemCount: eventi.length,
        itemBuilder: (context, index) {
          return EventoCard(evento: eventi[index]);
        },
      ),
    );
  }
}
