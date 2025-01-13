import 'package:dartz/dartz.dart';
import 'package:gogame/features/players/domain/entities/local_player.dart';

import '../../../../core/api_handler/failure.dart';
import '../../../../core/usecases/usecases.dart';
import '../repositories/player_repo.dart';

class FetchLocalPlayerInfo implements AsyncEitherUsecase<LocalPlayer, String>{

  final PlayerRepo _playerRepo;

  FetchLocalPlayerInfo(this._playerRepo);

  /// params: playerId
  @override
  Future<Either<DataCRUDFailure, LocalPlayer>> call(String params) async{
    return await _playerRepo.fetchLocalPlayerInfo(playerId: params);
  }

}