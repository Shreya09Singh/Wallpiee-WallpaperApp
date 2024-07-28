import 'package:hive/hive.dart';

import 'package:wallpiie/Model/NotesModel.dart';

class Boxes {
  static Box<NotesModel> getData() => Hive.box<NotesModel>('notes');
}
