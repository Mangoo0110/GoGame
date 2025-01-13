import '../../../../core/utils/enums/team_types.dart';
import '../../domain/entities/cricket_team.dart';

class CricketTeamModel extends CricketTeam {
  CricketTeamModel({
    required super.id,
    required super.name,
    required super.localDbImageUrl,
    required super.playerIds,
  });

  factory CricketTeamModel.fromEntity(CricketTeam entity) {
    return CricketTeamModel(
      id: entity.id,
      name: entity.name,
      localDbImageUrl: entity.localDbImageUrl,
      playerIds: entity.playerIds,
    );
  }

  factory CricketTeamModel.fromMap(Map<String, dynamic> map) {

    if(map['teamType'] != TeamType.cricket.name) {
      throw FormatException("Can not convert map data to CricketTeamModel. TeamType was not regestered as cricket team(TeamType.cricket).");
    }

    return CricketTeamModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      localDbImageUrl: map['localDbImageUrl'] ?? '',
      playerIds: map['playerIds'] == null ? [] : List<String>.from(map['playerIds']),
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
