import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:project_1/entities/tarea.dart';
import 'package:uuid/uuid.dart';

class FirestoreData {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String taskUuid = "";
  String get taskUuidValue => taskUuid;
  String get userId => _auth.currentUser!.uid;

  Future<bool> createUser(String email) async {
    try {
      _firestore.collection('users').doc(_auth.currentUser!.uid).set({
        'id': _auth.currentUser!.uid,
        'email': email,
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> setName(String name) async {
    try {
      _firestore.collection('users').doc(_auth.currentUser!.uid).set({
        'name': name,
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> addTask(
    String name,
    String description,
    String tipo,
    int cantidad,
    String frecuencia,
    String fechaInicio,
    bool completada,
  ) async {
    try {
      var uuid = Uuid().v4();
      _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .collection('tasks')
          .doc(uuid)
          .set({
        'id': uuid,
        'nombre': name,
        'descripcion': description,
        'tipo': tipo,
        'cantidad': cantidad,
        'cantidadProgreso': 0,
        'frecuencia': frecuencia,
        'fechaInicio': fechaInicio,
        'completada': false,
        'racha': 0,
      });
      taskUuid = uuid;
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> updateTask(
    String id,
    int cantidadProgreso,
    bool completada,
    int racha,
  ) async {
    try {
      _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .collection('tasks')
          .doc(id)
          .update({
        'cantidadProgreso': cantidadProgreso,
        'completada': completada,
        'racha': racha,
      });
    } catch (e) {
      throw Exception('Error during update task: $e');
    }
  }

  Future<List<Tarea>> getTasks() async {
    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .collection('tasks')
          .get();
      final taskList = snapshot.docs.map((doc) {
        final data = doc.data();
        Tarea t = Tarea(
          titulo: data['nombre'],
          descripcion: data['descripcion'],
          tipo: data['tipo'],
          cantidad: data['cantidad'],
          cantidadProgreso: data['cantidadProgreso'],
          frecuencia: data['frecuencia'],
          fechaInicio: data['fechaInicio'],
          completada: data['completada'],
          racha: data['racha'],
        );
        t.setId(data['id']);
        return t;
      }).toList();
      return taskList;
    } catch (e) {
      return [];
    }
  }

  Future<void> deleteTask(String id) async {
    try {
      _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .collection('tasks')
          .doc(id)
          .delete();
    } catch (e) {
      throw Exception('Error during delete task: $e');
    }
  }
}
