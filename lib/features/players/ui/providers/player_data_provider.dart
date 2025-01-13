import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gogame/features/players/domain/usecases/open_local_player_db.dart';
import '../../../../core/utils/func/dekhao.dart';
import '../../domain/entities/local_player.dart';
import '../../../../init_dependency.dart';

import '../../../../core/usecases/usecases.dart';
import '../../domain/usecases/fetch_all_local_players.dart';
import '../../domain/usecases/local_players_stream.dart';

class PlayerDataProvider extends ChangeNotifier{

  Map<String, LocalPlayer> _playersMap = {};

  List<LocalPlayer> _playerList = [];
  
  PlayerDataProvider(){
    dekhao("init PlayerDataProvider");
    init();
  }

  void init(){
    getAllPlayersFromLocal().then((value) async{
      await _localPlayersStream();
    });
  }

  /// getters
  List<LocalPlayer> get players => _playerList;

  Future<void> _localPlayersStream() async{
    await serviceLocator<OpenLocalPlayerDb>().call(NoParams()).then((value) async{
      value.fold(
        (l) {
          dekhao("Error: $l");
        }, (r) async{
          serviceLocator<LocalPlayersStream>().call(NoParams()).fold(
            (l) {
              dekhao("Error: $l");
            }, (r) {
              r.listen((event) {
                for (var element in event) {
                  _playersMap[element.id] = element;
                }
                dekhao("Players len: ${_playersMap.length}");
                _playerList = event; notifyListeners();
              });
            }
          );
        });
    });
    
  }

  Future<void> getAllPlayersFromLocal() async{
    return serviceLocator<FetchAllLocalPlayers>().call(NoParams()).then((value) {
        return value.fold(
          (l) {
            return null;
          }, (r) {
            for (var element in r) {
              _playersMap[element.id] = element;
            }
            _playerList = r;
            notifyListeners();
          });
    });
  }

  LocalPlayer? getLocalPlayerById(String playerId) {
    return _playersMap[playerId];
  }

}