import 'package:brew_crew/models/user.dart';
import 'package:brew_crew/services/database.dart';
import 'package:brew_crew/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:brew_crew/shared/constants.dart';
import 'package:provider/provider.dart';

class SettingsForm extends StatefulWidget {
  const SettingsForm({Key? key}) : super(key: key);

  @override
  _SettingsFormState createState() => _SettingsFormState();
}

class _SettingsFormState extends State<SettingsForm> {

  final _formKey = GlobalKey<FormState>();
  final List<String> sugars = ['0', '1', '2', '3', '4'];

  // form variables
  String? _currentName;
  String? _currentSugars;
  int? _currentStrength;

  @override
  Widget build(BuildContext context) {

    final user = Provider.of<MyUser?>(context);

    return StreamBuilder<UserData>(
      stream: DatabaseService(uid: user!.uid).getUserData,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          UserData userData = snapshot.data!;

          return Form(
              key: _formKey,
              child: Column(
                children: [
                  const Text('Edit your brew preferences', style: TextStyle(fontSize: 18.0),),
                  const SizedBox(height: 40.0),
                  TextFormField(
                    initialValue: _currentName ?? userData.name,
                    decoration: textInputDecoration.copyWith(hintText: 'Name'),
                    validator: (val) => val!.isEmpty ? "Name can't be null" : null,
                    onChanged: (val) => setState(() => _currentName = val),
                  ),
                  const SizedBox(height: 20.0),
                  DropdownButtonFormField(
                      decoration: textInputDecoration,
                      value: _currentSugars ?? userData.sugars,
                      items: sugars.map((sugar) => DropdownMenuItem(value: sugar,child: Text('$sugar sugars'))).toList(),
                      onChanged: (val) => setState(() => _currentSugars = val.toString())),
                  const SizedBox(height: 20.0),
                  Slider(
                      min: 100,
                      max: 900,
                      divisions: 8,
                      activeColor: Colors.brown[_currentStrength ?? userData.strength],
                      inactiveColor: Colors.brown[_currentStrength ?? userData.strength],
                      value: (_currentStrength ?? userData.strength).toDouble(),
                      onChanged: (val) =>  setState(() => _currentStrength = val.round())),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(primary: Colors.pink),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          await DatabaseService(uid: user.uid).updateUserData(
                              sugars: _currentSugars ?? userData.sugars,
                              name: _currentName ?? userData.name,
                              strength: _currentStrength ?? userData.strength
                          );
                          Navigator.pop(context);
                        }
                      },
                      child: const Text('Update', style: TextStyle(color: Colors.white)))
                ],
              ));
        } else {
          return const Loading();
        }

      }
    );
  }
}
