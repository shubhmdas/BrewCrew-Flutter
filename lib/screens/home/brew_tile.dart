import 'package:flutter/material.dart';
import 'package:brew_crew/models/brew.dart';

class BrewTile extends StatelessWidget {

  late final Brew brew;
  BrewTile({ required this.brew });

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(5.0),
        child: Card(
          margin: const EdgeInsets.all(2),
          elevation: 2.0,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.brown[brew.strength],
              backgroundImage: const AssetImage('assets/coffee_icon.png'),
            ),
            title: Text(brew.name),
            subtitle: Text("Takes ${brew.sugars} sugar(s)"),
          ),
        ),
    );
  }
}
