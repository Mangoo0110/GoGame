import 'package:flutter/foundation.dart';
import '../../domain/usecases/fetch_all_local_teams.dart';
import '../../../../core/usecases/usecases.dart';
import '../../../../core/utils/func/dekhao.dart';
import '../../../../init_dependency.dart';
import '../../../players/domain/usecases/open_local_player_db.dart';
import '../../domain/entities/team.dart';
import '../../domain/usecases/local_team_stream.dart';

class TeamDataProvider extends ChangeNotifier{
  Map<String, Team> _teamMap = {};

  List<Team> _teamList = [];
  
  TeamDataProvider(){
    dekhao("init TeamDataProvider");
    init();
  }

  void init(){
    getAllLocalTeams().then((value) async{
      await _localTeamStream();
    });
  }

  /// getters
  List<Team> get localTeams => _teamList;

  Future<void> _localTeamStream() async{
    await serviceLocator<OpenLocalPlayerDb>().call(NoParams()).then((value) async{
      value.fold(
        (l) {
          dekhao("Error: $l");
        }, (r) async{
          serviceLocator<LocalTeamStream>().call(NoParams()).fold(
            (l) {
              dekhao("Error: $l");
            }, (r) {
              r.listen((event) {
                for (var element in event) {
                  _teamMap[element.id] = element;
                }
                dekhao("Teams len: ${_teamMap.length}");
                _teamList.clear();
                _teamList = event; notifyListeners();
              });
            }
          );
        });
    });
  }

  Future<void> getAllLocalTeams() async{
    return serviceLocator<FetchAllLocalTeams>().call(NoParams()).then((value) {
        return value.fold(
          (l) {
            return null;
          }, (r) {
            for (var element in r) {
              _teamMap[element.id] = element;
            }
            _teamList = r;
            notifyListeners();
          });
    });
  }

  Team? getTeamById(String playerId) {
    return _teamMap[playerId];
  }
}