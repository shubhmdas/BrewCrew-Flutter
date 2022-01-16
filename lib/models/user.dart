class MyUser {

  late final String uid;

  MyUser({ required this.uid });

}

class UserData {
  late final String uid;
  late final String name;
  late final String sugars;
  late final int strength;

  UserData({ required this.uid, required this.name, required this.sugars, required this.strength });
}