// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'team.dart';

class LocalTeam extends Team{
  LocalTeam({required super.id, required super.name, required super.localDbImageUrl, required super.playerIds, required super.teamType});
  

  @override
  String toString() {
    return 'Local team(_id: $id, _name: $name, _imageUrl: $localDbImageUrl, playerIds: $playerIds, teamType: ${teamType.name})';
  }
}
