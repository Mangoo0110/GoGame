import 'package:dartz/dartz.dart';

import 'package:gogame/core/api_handler/failure.dart';

import 'package:gogame/core/api_handler/success.dart';
import 'package:gogame/features/players/data/datasources/local/player_local_datasource.dart';
import 'package:gogame/features/players/data/models/local_player_model.dart';

import 'package:gogame/features/players/domain/entities/local_player.dart';

import '../../../../core/api_handler/trycatch.dart';
import '../../domain/repositories/player_repo.dart';

class PlayerRepoImpl implements PlayerRepo{

  final PlayerLocalDatasource _playerLocalDatasource;

  PlayerRepoImpl(this._playerLocalDatasource);

  @override
  Future<Either<DataCRUDFailure, List<LocalPlayer>>> fetchAllLocalPlayers() async{
    return await asyncTryCatch<List<LocalPlayer>>(tryFunc: ()async{
      return await _playerLocalDatasource.fetchAllLocalPlayers();
    });
  }

  @override
  Future<Either<DataCRUDFailure, LocalPlayer>> fetchLocalPlayerInfo({required String playerId}) async{
    return await asyncTryCatch<LocalPlayer>(tryFunc: ()async{
      return await _playerLocalDatasource.fetchLocalPlayerInfo(playerId: playerId);
    });
  }

  @override
  Future<Either<DataCRUDFailure, Success>> saveLocalPlayerInfo({required LocalPlayer player}) async{
    return await asyncTryCatch<Success>(tryFunc: ()async{
      return await _playerLocalDatasource.saveLocalPlayerInfo(player: LocalPlayerModel.fromEntity(player)).then((_) => Success());
    });
  }
  
  @override
  Either<DataCRUDFailure, Stream<List<LocalPlayer>>> localPlayersStream() {
    return tryCatch<Stream<List<LocalPlayer>>>(tryFunc: (){
      return  _playerLocalDatasource.localPlayersStream();
    });
  }
  
  @override
  Future<Either<DataCRUDFailure, bool>> openLocalDb() async{
    return await asyncTryCatch<bool>(tryFunc: ()async{
      return await _playerLocalDatasource.openBox();
    });
  }
  
  @override
  Future<Either<DataCRUDFailure, Success>> deleteLocalPlayer({required LocalPlayer player}) async{
    return await asyncTryCatch<Success>(tryFunc: ()async{
      return await _playerLocalDatasource.deleteLocalPlayerInfo(playerId: player.id).then((_) => Success());
    });
  }

}