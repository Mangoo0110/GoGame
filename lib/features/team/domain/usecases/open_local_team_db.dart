import 'package:dartz/dartz.dart';

import '../../../../core/api_handler/failure.dart';
import '../../../../core/usecases/usecases.dart';
import '../repositories/team_repo.dart';

class OpenLocalTeamDb implements AsyncEitherUsecase<bool, NoParams>{

  final LocalTeamRepo _teamRepo;

  OpenLocalTeamDb(this._teamRepo);

  /// Saves the player info only locally.
  @override
  Future<Either<DataCRUDFailure, bool>> call(NoParams params) async{
    return await _teamRepo.openLocalDb();
  }

}