import 'package:hive/hive.dart';

part 'NotesModel.g.dart';

@HiveType(typeId: 0)
class NotesModel extends HiveObject {
  @HiveField(0)
  String imgUrl;

  @HiveField(1)
  String title;

  @HiveField(2)
  String note;

  NotesModel({
    required this.imgUrl,
    required this.title,
    required this.note,
  });
}
