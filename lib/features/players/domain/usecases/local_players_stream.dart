import 'package:dartz/dartz.dart';
import '../entities/local_player.dart';

import '../../../../core/api_handler/failure.dart';
import '../../../../core/usecases/usecases.dart';
import '../repositories/player_repo.dart';

class LocalPlayersStream implements EitherUsecase<Stream<List<LocalPlayer>>, NoParams>{

  final PlayerRepo _playerRepo;

  LocalPlayersStream(this._playerRepo);

  /// Fetches all the players from the local database as a stream.
  ///#### ***Make sure local db is opened before calling this method***.
  @override
  Either<DataCRUDFailure, Stream<List<LocalPlayer>>> call(NoParams params) {
    return _playerRepo.localPlayersStream();
  }

}