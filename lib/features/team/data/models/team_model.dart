
import '../../../../core/utils/enums/team_types.dart';
import '../../domain/entities/team.dart';

class TeamModel extends Team {
  TeamModel({
    required super.id,
    required super.name,
    required super.localDbImageUrl,
    required super.playerIds,
    required super.teamType,
  });

  factory TeamModel.fromEntity(Team entity) {
    return TeamModel(
      id: entity.id,
      name: entity.name,
      localDbImageUrl: entity.localDbImageUrl,
      playerIds: entity.playerIds,
      teamType: entity.teamType
    );
  }

  factory TeamModel.fromMap(Map<String, dynamic> map) {

    return TeamModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      localDbImageUrl: map['localDbImageUrl'] ?? '',
      playerIds: map['playerIds'] == null ? [] : List<String>.from(map['playerIds']),
      teamType: TeamType.fromMap(map['teamType'] ?? '')
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'localDbImageUrl': localDbImageUrl,
      'playerIds': playerIds,
      'teamType': TeamType.cricket.name,
    };
  }
}
