import 'dart:async';
import 'dart:convert';

import 'package:gogame/features/team/data/models/team_model.dart';
import 'package:hive/hive.dart';

import '../../../../../core/utils/func/dekhao.dart';

abstract interface class TeamLocalDatasource {

  Future<bool> openDb();

  Future<void> saveLocalTeam(TeamModel team);

  Future<List<TeamModel>> fetchAllLocalTeam();

  /// Returns stream of local teams.
  Stream<List<TeamModel>> localTeamStream();

  Future<TeamModel> fetchOneLocalTeam(String teamId);

  Future<void> deleteLocalTeam(String teamId);

}


class TeamHiveImpl implements TeamLocalDatasource{

  static TeamHiveImpl? _instance;
  Box<dynamic>? _box;
  int _boxModifiedCnt = 0;


  TeamHiveImpl._(){
    if(_box == null){
      openDb();
    }
  }


  static TeamHiveImpl get instance {
    _instance ??= TeamHiveImpl._();
    return _instance!;
  }

  static final _boxName = 'TeamBox';

  @override
  Future<bool> openDb() async{
    dekhao("opening player box");
    try {
      _box ??= await Hive.openBox(_boxName);
      if(_box == null) {
        dekhao("_box is still null");
        return false;
      } else {
        dekhao("_box is not null and functionable ${_box?.name}");
        return true;
      }
    } catch (e) {
      dekhao("Failed to open box.. $e");
      rethrow;
    }
  }

  /// Returns a stream of list of players.
  /// If the hive box is not opened, it will throw an exception.
  
  Stream<BoxEvent> _watchBoxChanges() {
    return _box!.watch();
  }

  @override
  Stream<List<TeamModel>> localTeamStream() async*{

    if(_box == null) {
      dekhao("'localPlayersStream' >> Fatal!! PlayerHiveDatasourceImpl Hive box is not opened! ${'\n\n'} First call init function to make sure object's hive box is opened and not null.");
      throw Exception('Fatal!! Local db is not opened!');
    }  

    yield await fetchAllLocalTeam(); // Emit initial state
    await for (final _ in _watchBoxChanges()) {
      yield await fetchAllLocalTeam(); // Emit updated list on each change
    }   
  }

  
  @override
  Future<void> deleteLocalTeam(String teamId) async{
    return await openDb().then((_) async{
      return await _box!.delete(teamId);
    });
  }

  @override
  Future<List<TeamModel>> fetchAllLocalTeam() async{
    return await openDb().then((_) async{
      List<TeamModel> teams = [];
      for(final data in _box!.values) {
        try {
          teams.add(TeamModel.fromMap(_convertToJsonMap(data)));
        } catch (e) {
          dekhao(e);
        }
      }
      return teams;
    });
  }

  @override
  Future<TeamModel> fetchOneLocalTeam(String teamId) async{
    return await openDb().then((_) async{
      return TeamModel.fromMap(_convertToJsonMap(_box!.get(teamId)));
    });
  }


  @override
  Future<void> saveLocalTeam(TeamModel team) async{
    return await openDb().then((_) async{
      return await _box!.put(team.id, team.toMap());
    });
  }
  
  // @override
  // Future<void> openDb() async{
  //   await openBox();
  // }

  _convertToJsonMap(dynamic data) {
    return jsonDecode(jsonEncode(data));
  }
}