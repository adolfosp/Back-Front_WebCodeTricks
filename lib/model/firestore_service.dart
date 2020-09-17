import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:webcodetricks/model/exercise.dart';

class FirestoreService {
  static final FirestoreService _firestoreService =
      FirestoreService._internal();
  Firestore _db = Firestore.instance;

  FirestoreService._internal();

  factory FirestoreService() {
    return _firestoreService;
  }

  Stream<List<Exercise>> getExercise() {
    return _db.collection('exercise').snapshots().map(
          (snapshot) => snapshot.documents
              .map(
                (doc) => Exercise.fromMap(doc.data, doc.documentID),
              )
              .toList(),
        );
  }

  Stream<List<Exercise>> getExerciseWhere(String resultado, String usuario) {
    print(resultado);
    return _db
        .collection('exercise')
        .where('tag', isGreaterThanOrEqualTo: resultado)
        .where('tag', isLessThan: resultado + 'z')
        .where('autor', isEqualTo: usuario)
        .snapshots()
        .map(
          (snapshot) => snapshot.documents
              .map(
                (doc) => Exercise.fromMap(doc.data, doc.documentID),
              )
              .toList(),
        );
  }

  Future<void> addExercise(Exercise exercise) {
    return _db.collection('exercise').add(exercise.toMap());
  }

  Future<void> deleteNode(String id) {
    return _db.collection('exercise').document(id).delete();
  }

  Future<void> updateExercise(Exercise exercise) {
    return _db
        .collection('exercise')
        .document(exercise.id)
        .updateData(exercise.toMap());
  }
}
