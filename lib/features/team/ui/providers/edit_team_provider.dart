import 'package:flutter/foundation.dart';


import '../../../../core/utils/enums/team_types.dart';
import '../../../../core/utils/func/dekhao.dart';
import '../../../../core/utils/uuid_service/firebase_uid.dart';

import '../../../../core/utils/enums/common_enums.dart';
import '../../domain/entities/team.dart';
import 'team_db_calls.dart';

class EditTeamProvider extends ChangeNotifier with TeamDbCalls{

  Team? _teamBefore;
  late Team _teamNow;

  SaveStatus _saveStatus = SaveStatus.canNotSave;
  DeleteStatus _deleteStatus = DeleteStatus.canNotDelete;

  Uint8List? _newteamImage;


  EditTeamProvider({
    required Team? team,
    required TeamType teamType
  }) {
    if(team != null) {
      _teamBefore = team;
      _teamNow = team.copyWith(teamType: team.teamType);
      _deleteStatus = DeleteStatus.canDelete; notifyListeners();
    } else {
      _deleteStatus = DeleteStatus.canNotDelete; notifyListeners();
      _teamNow = Team(id: uuidByFirebaseSdk(), name: "", teamType: teamType, localDbImageUrl: _generateteamLocalImageUrl(), playerIds: []);
    }
  }

  //getters
  SaveStatus get saveStatus => _saveStatus;
  DeleteStatus get deleteStatus => _teamBefore == null ? DeleteStatus.canNotDelete : _deleteStatus;
  Team get modifiedTeam => _teamNow;
  String get teamName => _teamNow.name;
  String get teamDocId => _teamNow.id;
  Uint8List? get teamImage => _newteamImage;
  Uint8List? get newTeamImage => _newteamImage;
  List<String> get playerIds => List.unmodifiable(_teamNow.playerIds);


  void _checkIfCanSave(){
    if(_teamNow.name.isNotEmpty && _teamBefore != _teamNow){
      if(_saveStatus != SaveStatus.canSave){
        _saveStatus = SaveStatus.canSave; notifyListeners();
      }
    } else {
      if(_saveStatus != SaveStatus.canNotSave){
        _saveStatus = SaveStatus.canNotSave; notifyListeners();
      }
    }
    dekhao(_saveStatus.name);
  }


  String _generateteamLocalImageUrl(){
    return "teams/${uuidByFirebaseSdk()}";
  }

  void updateTeamName(String name){
    dekhao("updating name is $name");
    _teamNow.changeName(name: name, editTeamProvider: this);
    dekhao("after updating name is ${_teamNow.name}");
    
    _checkIfCanSave();
  }

  /// newteamImage: Image size should be less than the set limit (e.g 1MB).
  void updateTeamImage(Uint8List image){
    _newteamImage = image;
    if(_teamNow.localDbImageUrl.isEmpty) _teamNow.changeImageUrl(imageUrl: _generateteamLocalImageUrl(), editTeamProvider: this);
    _checkIfCanSave();
  }

  void addPlayerId(String playerId) {
    _teamNow.addPlayerId(playerId); _checkIfCanSave();
    notifyListeners();
  }

  void addPlayerIdList(List<String> playerIds) {
    for(final id in playerIds) {
      _teamNow.addPlayerId(id);
    }
    dekhao("after adding ids ${_teamNow != _teamBefore}");
    notifyListeners();
    _checkIfCanSave();
  }

  void removePlayerId(String playerId) {
    _teamNow.removePlayerId(playerId); _checkIfCanSave();
    notifyListeners();
  }

  void updatePlayersOrder(int playerAtBefore, int playerAtNow) {
    // Call object's player order update method.
    _teamNow.updatePlayersOrder(playerAtBefore: playerAtBefore, playerAtNow: playerAtNow);
    _saveStatus = SaveStatus.canSave;
    notifyListeners();
  }

  @override
  Future<Team?> saveTeam({required Uint8List? newteamImage, required EditTeamProvider editTeamProvider, required Team team}) async{
    _saveStatus = SaveStatus.saving; notifyListeners();

    return await super.saveTeam(newteamImage: newteamImage, editTeamProvider: editTeamProvider, team: team).then((res) {
      if(res != null) {
        _saveStatus = SaveStatus.saved; notifyListeners();
      } else {
        _saveStatus = SaveStatus.failed; notifyListeners();
      }
      return res;
    });
  }

  @override
  Future<bool> deleteTeam(Team team, EditTeamProvider editTeamProvider) {
    _deleteStatus = DeleteStatus.deleting;

    return super.deleteTeam(team, editTeamProvider).then((res) {
      if(res) {
        _deleteStatus = DeleteStatus.deleted; notifyListeners();
      } else {
        _deleteStatus = DeleteStatus.failed; notifyListeners();
      }
      return res;
    });
  }

}