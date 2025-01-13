import 'package:dartz/dartz.dart';

import '../../../../core/api_handler/failure.dart';
import '../../../../core/usecases/usecases.dart';
import '../repositories/player_repo.dart';

class OpenLocalPlayerDb implements AsyncEitherUsecase<bool, NoParams>{

  final PlayerRepo _playerRepo;

  OpenLocalPlayerDb(this._playerRepo);

  /// Saves the player info only locally.
  @override
  Future<Either<DataCRUDFailure, bool>> call(NoParams params) async{
    return await _playerRepo.openLocalDb();
  }

}