import 'package:project_1/entities/tarea.dart';

class User {
  int _uid;
  String _email;
  String _name;
  String _photoUrl;
  List<Tarea> _tasks;

  User(this._email, this._name, this._photoUrl)
      : _uid = 0,
        _tasks = [];

  int get uid => _uid;
  String get email => _email;
  String get name => _name;
  String get photoUrl => _photoUrl;
  List<Tarea> get tasks => _tasks;

  void setUid(int uid) {
    _uid = uid;
  }

  void setEmail(String email) {
    _email = email;
  }

  void setName(String name) {
    _name = name;
  }

  void setPhotoUrl(String photoUrl) {
    _photoUrl = photoUrl;
  }

  void setTasks(List<Tarea> tasks) {
    _tasks = tasks;
  }
}
