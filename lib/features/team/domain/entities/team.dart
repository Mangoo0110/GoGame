// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/foundation.dart';

import '../../../../core/utils/enums/team_types.dart';
import '../../ui/providers/edit_team_provider.dart';

class Team {
  final String _id;
  String _name;
  String _localDbImageUrl;
  final TeamType teamType;
  @protected
  List<String> playerIds;
  Team({
    required String id,
    required String name,
    required String localDbImageUrl,
    required this.playerIds,
    required this.teamType,
  })  : _id = id,
        _name = name,
        _localDbImageUrl = localDbImageUrl;


  String get id => _id;
  String get name => _name;
  String get localDbImageUrl => _localDbImageUrl;
  List<String> get teamPlayerIds => List<String>.from(playerIds);

  Team copyWith({String? id, String? name, String? imageUrl, required TeamType teamType, List<String>? playerIds}) {
    return Team(
      id: id ?? _id,
      name: name ?? _name,
      teamType: teamType,
      localDbImageUrl: imageUrl ?? _localDbImageUrl,
      playerIds: List<String>.of(playerIds ?? this.playerIds), // Creates a list with new reference.
    );
  }

  void addPlayerId(String playerId) {

    if(playerId.isEmpty || playerIds.contains(playerId)) return;
    playerIds.add(playerId);
  }

  void addPlayerIdList(List<String> playerIdList) {

    for(final playerId in playerIdList) {
      if(playerId.isNotEmpty && !playerIds.contains(playerId)) {
        playerIds.add(playerId);
      }
    }
    
  }

  void removePlayerId(String playerId) {
    
    if(playerId.isEmpty || !playerIds.contains(playerId)) return;
    playerIds.removeWhere((element) => element == playerId);
  }

  void removeAllPlayerIds() {
    playerIds.clear();
  }

  void updatePlayersOrder({required int playerAtBefore, required int playerAtNow}) {
    // This code of line written to avoid the out of range issue in dart from the reorderable list.
    if(playerAtNow > playerAtBefore) playerAtNow--;
    
    if((playerAtBefore < 0 || playerAtBefore > playerIds.length) || (playerAtNow < 0 || playerAtNow > playerIds.length)) return;

    final movingPlayerId = playerIds[playerAtBefore];
    playerIds.removeAt(playerAtBefore);
    playerIds.insert(playerAtNow, movingPlayerId);
  }

  void changeName({required String name, required EditTeamProvider editTeamProvider}) {
    _name = name;
  }

  void changeImageUrl({required String imageUrl, required EditTeamProvider editTeamProvider}) {
    _localDbImageUrl = imageUrl;
  }

  

  

  @override
  bool operator ==(covariant Team other) {
    if (identical(this, other)) return true;
  
    return 
      other.runtimeType == runtimeType &&
      other._id == _id &&
      other._name == _name &&
      other._localDbImageUrl == _localDbImageUrl &&
      other.teamType == teamType &&
      listEquals(other.playerIds, playerIds);
  }

  @override
  int get hashCode {
    return _id.hashCode ^
      _name.hashCode ^
      _localDbImageUrl.hashCode ^
      teamType.hashCode ^
      playerIds.hashCode;
  }

  @override
  String toString() {
    return 'Team(_id: $_id, _name: $_name, _imageUrl: $_localDbImageUrl, playerIds: $playerIds, teamType: ${teamType.name})';
  }
}
