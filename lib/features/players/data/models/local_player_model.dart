
import '../../domain/entities/local_player.dart';

class LocalPlayerModel extends LocalPlayer {
  LocalPlayerModel({
    required super.id,
    required super.name,
    required super.localDbImageUrl,
    required super.teamIdList,
  });

  factory LocalPlayerModel.fromMap(Map<String, dynamic> map) {
    //dekhao(map.keys);
    return LocalPlayerModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      localDbImageUrl: map['localDbImageUrl'] ?? '',
      teamIdList: map['teamIdList'] == null ? [] : (map['teamIdList'] as List<dynamic>).map((e) => e.toString()).toList(),
    );
  }

  factory LocalPlayerModel.fromEntity(LocalPlayer entity) {
    return LocalPlayerModel(
      id: entity.id,
      name: entity.name,
      localDbImageUrl: entity.localDbImageUrl,
      teamIdList: entity.teamIdList,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'localDbImageUrl': localDbImageUrl,
      'teamIdList': teamIdList,
    };
  }
}
