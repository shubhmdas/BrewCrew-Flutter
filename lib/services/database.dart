import 'package:brew_crew/models/brew.dart';
import 'package:brew_crew/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {

  late final String uid;

  DatabaseService({ required this.uid });

  DatabaseService.withoutUid() : uid = '';

  final CollectionReference brewCollection = FirebaseFirestore.instance.collection('brews');

  // setting user data in firestore
  Future updateUserData({ required String sugars, required String name, required int strength }) async {
    return await brewCollection.doc(uid).set({
      'sugars': sugars,
      'name': name,
      'strength': strength,
    });
  }

  // getting user doc snapshots
  Stream<UserData> get getUserData {
    return brewCollection.doc(uid).snapshots().map(_userDataFromSnapshots);
  }

  // function to convert user doc snapshots to UserData object
  UserData _userDataFromSnapshots(DocumentSnapshot snapshot) {
    return UserData(
        uid: uid,
        name: snapshot['name'],
        sugars: snapshot['sugars'],
        strength: snapshot['strength']);
  }

  // getting brew snapshots
  Stream<List<Brew>> get getBrews {
    return brewCollection.snapshots().map(_brewListFromSnapshot);
  }

  // function to convert snapshots to list
  List<Brew> _brewListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Brew(
          sugars: doc.get('sugars') ?? '0',
          name: doc.get('name') ?? 'new user',
          strength: doc.get('strength') ?? '100');
    }).toList();
  }
}