import 'package:gogame/core/utils/enums/team_types.dart';
import 'package:gogame/features/team/domain/entities/team.dart';

class CricketTeam extends Team {
  CricketTeam({
    required super.id,
    required super.name,
    required super.localDbImageUrl,
    required super.playerIds,
  }) : super(teamType: TeamType.cricket);

}
