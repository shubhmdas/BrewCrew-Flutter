import 'package:brew_crew/models/brew.dart';
import 'package:brew_crew/screens/home/brew_list.dart';
import 'package:brew_crew/screens/home/settings_form.dart';
import 'package:brew_crew/services/auth.dart';
import 'package:brew_crew/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Home extends StatelessWidget {
  Home({Key? key}) : super(key: key);

  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {

    void _showSettingsPanel() {
      showModalBottomSheet(
          backgroundColor: Colors.grey[300],
          context: context, builder: (context) {
        return Container(
          padding: const EdgeInsets.fromLTRB(60, 20, 60, 20),
          child: const SettingsForm(),
        );
      });
    }

    return StreamProvider<List<Brew>>.value(
      initialData: const [],
      value: DatabaseService.withoutUid().getBrews,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Brew Crew"),
          backgroundColor: Colors.brown[400],
          elevation: 0.0,
          actions: [
            TextButton.icon(
              onPressed: () async {
                await _authService.signOut();
              },
              icon: const Icon(Icons.person, color: Colors.black,),
              label: const Text("Logout", style: TextStyle(color: Colors.black),),
            ),
            TextButton.icon(
                onPressed: _showSettingsPanel,
                icon: const Icon(Icons.edit, color: Colors.black,),
                label: const Text("Edit", style: TextStyle(color: Colors.black),))
          ],
        ),
        body: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/beans.jpg'),
                fit: BoxFit.cover,
              )
            ),
            child: const BrewList()),
      ),
    );
  }
}
