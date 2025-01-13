import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:gogame/core/utils/func/dekhao.dart';

import '../../domain/entities/team.dart';
import 'team_db_calls.dart';

class SelectingTeam extends ChangeNotifier{
  final String serial;
  Team? _team;

  SelectingTeam._({required Team? team, required this.serial}): _team = team;

  // Getters
  /// Returns a copy of the [`Team`] object. So that changes of the view object doesn't affect on the real object.
  /// 
  /// To access [`Team`] methods and change its data use helper methods declared in this class object.
  Team? get team => _team?.copyWith(teamType: _team!.teamType);


  void _removeTeam() {
    _team = null; notifyListeners();
  }


  /// Creates a new object of `Team` from the provided `Team` object data.
  /// Rewrites the team data object with new `Team` object. This restricts the changes in the current object to reflect on the provided object.
  void _addTeam(Team team) {
    _removeTeam();
    _team = team.copyWith(teamType: team.teamType); notifyListeners();
  }


  /// Private method: can not be directly accessed from Ui side.
  void _removePlayer(String playerId) {
    _team?.removePlayerId(playerId); notifyListeners();
  }


  /// Private method: can not be directly accessed from Ui side.
  void _addPlayer(String playerId) {
    _team?.addPlayerId(playerId); notifyListeners();
  }


  void reorderPlayer({required int playerAtBefore, required int playerAtNow}) {
    _team?.updatePlayersOrder(playerAtBefore: playerAtBefore, playerAtNow: playerAtNow); notifyListeners();
  }
}



class SelectedPlayer extends ChangeNotifier {
  final String playerId;
  final List<String> _teamIdList = [];

  SelectedPlayer._({required this.playerId});

  List<String> get teamIdList => List<String>.from(_teamIdList);

  /// Triggers update.
  void _addTeamReference(Team team) {
    if(_teamIdList.contains(team.id)) return;
    _teamIdList.add(team.id); notifyListeners();
  }

  void _removeTeamReference(String teamId) {
    _teamIdList.removeWhere((e) => e == teamId); notifyListeners();
    if(_teamIdList.contains(teamId)) {
      dekhao("Failed to remove team reference.");
    } else {
      dekhao("Removed team reference.");
    }
  }

  @override
  String toString() {
    return 'SelectedPlayer(playerId: $playerId, teamIdList: ${_teamIdList.toString()})';
  }

}



class TeamSelectionProvider extends ChangeNotifier with TeamDbCalls{
  final List<SelectingTeam> _selectedTeams = List<SelectingTeam>.generate(2, growable: false, (index) => SelectingTeam._(team: null, serial: 'serial$index'));
  
  final SplayTreeMap<String, Team> _availableTeamsMap = SplayTreeMap<String, Team>();

  final SplayTreeMap<String, Team> _allTeamMap = SplayTreeMap<String, Team>();

  final int _howMany = 2;

  final SplayTreeMap<String, SelectedPlayer> _selectedPlayers = SplayTreeMap<String, SelectedPlayer>();

  TeamSelectionProvider({
    required List<Team> selectedTeams,
    required List<Team> allTeams,
  }) {

    for(final team in allTeams) {
      _allTeamMap[team.id] = team;
      if(_selectedTeams.where((e) => e.team != null && e.team?.id != team.id).isEmpty) {
        _availableTeamsMap[team.id] = (team.copyWith(teamType: team.teamType));
      }
    }

    for(int cnt = 0; cnt < _howMany; cnt++) {
      _selectedTeams[cnt] = SelectingTeam._(team: null, serial: 'serial$cnt');
    }
    
    if(selectedTeams.isNotEmpty) {
      int cnt=0;
      for(final team in selectedTeams) {
        _selectedTeams[cnt] = SelectingTeam._(team: team.copyWith(teamType: team.teamType), serial: 'serial$cnt'); cnt++;
        if(cnt > _howMany) break;
      }
    }
  }

  
  // Getters
  List<Team> get availableTeamsToChooseFrom => _availableTeamsMap.entries.map((e) => e.value).toList();
  SelectingTeam get firstSelectedTeam => _selectedTeams[0];
  SelectingTeam get secondSelectedTeam => _selectedTeams[1];
  UnmodifiableListView<SelectedPlayer> get selectedPlayers=> UnmodifiableListView<SelectedPlayer>(_selectedPlayers.entries.map((e) => e.value).toList()) ;
  

  // onTeamStreamUpdate({required List<Team> allTeams,}) {
  //   int cnt = 0;
  //   for(final selected in _selectedTeams) {
  //     //_selectedTeams[cnt] = allTeams.where((e) => selected.team != null && e.id == selected.team!.id).first;
  //     cnt++;
  //   }
  //   notifyListeners();
  // }
  


  void updatePlayersOrder(SelectingTeam selectingTeam, int playerAtBefore, int playerAtNow) {
    // Call object's player order update method.
    selectingTeam.reorderPlayer(playerAtBefore: playerAtBefore, playerAtNow: playerAtNow);
    notifyListeners();
  }



  SelectedPlayer? getSelectedPlayerState(String playerId) {
    return _selectedPlayers[playerId];
  }



  bool changeTeamOfSelectingTeam(SelectingTeam selectingTeam, Team team) {
    removeTeam(selectingTeam);
    try {
      selectingTeam._addTeam(team);
      _availableTeamsMap.remove(team.id);

      addPlayersToSelectingTeam(selectingTeam, team.teamPlayerIds);
      return true;
    } catch (e) {

      dekhao("Error changing first team $e");
      return false;
    }    
  }



  void removePlayerFromTeam(SelectingTeam selectingTeam, String playerId) {
    if(selectingTeam.team == null) {
      dekhao("SelectingTeam's team is null!");
      return;
    }
    //First, remove teamReference from removing player's SelectedPlayer object.
    // If _selectedPlayers map contains removing [playerId], then remove selectingTeam's team reference from its team selected references [_teamIdList].
    if( _selectedPlayers.containsKey(playerId)) {
      _selectedPlayers[playerId]?._removeTeamReference(selectingTeam.team!.id);
    }
    // Remove player from the team.
    selectingTeam._removePlayer(playerId);
    

  }



  void addPlayersToSelectingTeam(SelectingTeam selectingTeam, List<String> playerIds) {
    for(final playerId in playerIds) {

      // Add playerId to the team.
      selectingTeam._addPlayer(playerId);

      // Create and add [`SelectedPlayer`] to _selectedPlayers map if doesn't exist
      if( !_selectedPlayers.containsKey(playerId)) {
        _selectedPlayers[playerId] = SelectedPlayer._(playerId: playerId);
      }
      // Add team reference to [SelectedPlayer] object. That triggers listening ui widgets to update their state.
      _selectedPlayers[playerId]?._addTeamReference(selectingTeam.team!);
    }
  }



  bool removeTeam(SelectingTeam selectingTeam) {
    try {
      if(selectingTeam.team != null) {

        // First, one by one, get the team playerIds and remove the deleting teamId from their SelectedPlayer instance's _teamIdList.
        for(final playerId in selectingTeam.team!.teamPlayerIds) {
          
          final SelectedPlayer? selectedPlayer = _selectedPlayers[playerId];
          if(selectedPlayer != null) {
            // Remove team reference.
            selectedPlayer._removeTeamReference(selectingTeam.team!.id);
          }
          
        }
        // Save the teamId for later to calling team restoring function.
        final teamId = selectingTeam.team!.id;
        // Remove the team from SelectingTeam object.
        selectingTeam._removeTeam();
        // Call _restoreInAvailableTeams to restore original team data.
        // Add the removed team's original db object to  _availableTeamsMap.
        _restoreInAvailableTeams(teamId);
        
        //_selectedTeams.removeAt(1); notifyListeners();
      }

      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }



  List<String> alreadyAddedPlayerIds() {
    final List<String> firstTeamPlayerIds = firstSelectedTeam.team?.teamPlayerIds ?? [];
    final List<String> secondTeamPlayerIds = secondSelectedTeam.team?.teamPlayerIds ?? [];
    return (firstTeamPlayerIds + secondTeamPlayerIds).toSet().toList();
  }

  bool doesThisPlayerExistInMoreThanOneTeam(String playerId) {
    return (firstSelectedTeam.team?.teamPlayerIds.contains(playerId) ?? false) && (secondSelectedTeam.team?.teamPlayerIds.contains(playerId) ?? false);
  }


  _restoreInAvailableTeams(String teamId) {
    if(_selectedTeams.where((e) => e.team?.id == teamId).isNotEmpty) {
      dekhao("Failed restoring team($teamId) into _availableTeamsMap! Team is still selected.");
      return;
    } else {
      if(_allTeamMap.containsKey(teamId)) {
        _availableTeamsMap[teamId] = _allTeamMap[teamId]!;
        dekhao("Restored team($teamId) into _availableTeamsMap");
      } else {
        dekhao("Failed restoring team($teamId) into _availableTeamsMap! Team not found!");
      }
    }
  }



}

