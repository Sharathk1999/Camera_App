import 'package:hive_flutter/hive_flutter.dart';
part 'image_model.g.dart';


@HiveType(typeId: 1)
class ImageModel extends HiveObject {
  @HiveField(0)
  late String imagePath;
}
