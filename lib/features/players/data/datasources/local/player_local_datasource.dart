import 'dart:convert';

import '../../../../../core/utils/func/dekhao.dart';
import '../../../../auth/data/datasources/remote/auth_remote_datasource.dart';
import '../../models/local_player_model.dart';

import 'package:hive/hive.dart';


abstract interface class PlayerLocalDatasource {

  Future<bool> openBox();

  Future<void> saveLocalPlayerInfo({required LocalPlayerModel player});

  Future<void> deleteLocalPlayerInfo({required String playerId});

  Future<LocalPlayerModel> fetchLocalPlayerInfo({required String playerId});

  Future<List<LocalPlayerModel>>fetchAllLocalPlayers();

  Stream<List<LocalPlayerModel>> localPlayersStream();

}




class  PlayerHiveDatasourceImpl implements PlayerLocalDatasource{

  static PlayerHiveDatasourceImpl? _instance;
  Box<dynamic>? _box;
  int _boxModifiedCnt = 0;


  PlayerHiveDatasourceImpl._(){
    if(_box == null){
      openBox();
    }
  }


  static PlayerHiveDatasourceImpl get instance {
    _instance ??= PlayerHiveDatasourceImpl._();
    return _instance!;
  }

  static final _boxName = 'PlayerBox';

  @override
  Future<bool> openBox() async{
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
  Stream<List<LocalPlayerModel>> localPlayersStream() async*{

    if(_box == null) {
      dekhao("'localPlayersStream' >> Fatal!! PlayerHiveDatasourceImpl Hive box is not opened! ${'\n\n'} First call init function to make sure object's hive box is opened and not null.");
      throw Exception('Fatal!! Local db is not opened!');
    }  

    yield await fetchAllLocalPlayers(); // Emit initial state
    await for (final _ in _watchBoxChanges()) {
      yield await fetchAllLocalPlayers(); // Emit updated list on each change
    }   
  }

  @override
  Future<List<LocalPlayerModel>> fetchAllLocalPlayers() async{
    return await openBox()
    .then((value) {
      final dataList = _box!.values;
      List<LocalPlayerModel> players = [];
      for(final data in dataList){
        try {
        
          if(dataList.isEmpty){
            throw Exception('Fatal!! Player data is empty!');
          }

          players.add(LocalPlayerModel.fromMap(jsonDecode(jsonEncode(data))));
        } catch (e) {
          dekhao("Hive data formatting failed! ");
          throw FormatException("Hive data formatting failed!", _box!.get(AuthFirebaseImpl.instance.currentUserAuth!.id).toString());
        }
      }

      return players;
      
    });
  }

  @override
  Future<LocalPlayerModel> fetchLocalPlayerInfo({required String playerId}) async{
    return await openBox()
    .then((value) {
      
      try {
        final data = _box!.get(playerId);
        if(data == null){
          throw Exception('Fatal!! Data not found!');
        }
        return LocalPlayerModel.fromMap(jsonDecode(jsonEncode(data)));
      } catch (e) {
        dekhao("Hive data formatting failed! ");
        throw FormatException("Hive data formatting failed!", _box!.get(AuthFirebaseImpl.instance.currentUserAuth!.id).toString());
      }
    });
  }

  @override
  Future<void> saveLocalPlayerInfo({required LocalPlayerModel player}) async{
    //if(AuthFirebaseImpl.instance.currentUserAuth == null) return;
    return await openBox().then((value) async{
      
      return await _box!.put(player.id, player.toMap());
    });
  }
  
  @override
  Future<void> deleteLocalPlayerInfo({required String playerId}) async{
    return await openBox().then((value) async{
      return await _box!.delete(playerId);
    });
  }

  
}

