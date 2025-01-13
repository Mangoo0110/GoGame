import 'package:dartz/dartz.dart';
import 'package:gogame/features/players/domain/entities/local_player.dart';

import '../../../../core/api_handler/failure.dart';
import '../../../../core/api_handler/success.dart';
import '../../../../core/usecases/usecases.dart';
import '../repositories/player_repo.dart';

class SavePlayerLocally implements AsyncEitherUsecase<Success, LocalPlayer>{

  final PlayerRepo _playerRepo;

  SavePlayerLocally(this._playerRepo);

  /// Saves the player info only locally.
  @override
  Future<Either<DataCRUDFailure, Success>> call(LocalPlayer params) async{
    return await _playerRepo.saveLocalPlayerInfo(player: params);
  }

}