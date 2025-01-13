import 'package:dartz/dartz.dart';
import 'package:gogame/features/team/domain/entities/team.dart';
import '../../../../core/api_handler/failure.dart';
import '../../../../core/api_handler/success.dart';
import '../../../../core/usecases/usecases.dart';
import '../repositories/team_repo.dart';

class SaveLocalTeam implements AsyncEitherUsecase<Success, Team>{

  final LocalTeamRepo _teamRepo;

  SaveLocalTeam(this._teamRepo);

  /// Saves the player info only locally.
  @override
  Future<Either<DataCRUDFailure, Success>> call(Team params) async{
    return await _teamRepo.saveLocalTeam(params);
  }

}