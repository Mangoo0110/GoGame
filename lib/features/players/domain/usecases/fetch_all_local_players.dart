import 'package:dartz/dartz.dart';
import 'package:gogame/features/players/domain/entities/local_player.dart';

import '../../../../core/api_handler/failure.dart';
import '../../../../core/usecases/usecases.dart';
import '../repositories/player_repo.dart';

class FetchAllLocalPlayers implements AsyncEitherUsecase<List<LocalPlayer>, NoParams>{

  final PlayerRepo _playerRepo;

  FetchAllLocalPlayers(this._playerRepo);

  @override
  Future<Either<DataCRUDFailure, List<LocalPlayer>>> call(NoParams params) async{
    return await _playerRepo.fetchAllLocalPlayers();
  }

}