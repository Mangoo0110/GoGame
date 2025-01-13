import 'package:dartz/dartz.dart';
import '../../../../core/api_handler/failure.dart';
import '../../../../core/api_handler/success.dart';
import '../../../../core/usecases/usecases.dart';
import '../repositories/team_repo.dart';

class DeleteLocalTeam implements AsyncEitherUsecase<Success, String>{

  final LocalTeamRepo _teamRepo;

  DeleteLocalTeam(this._teamRepo);

  /// Saves the team info only locally.
  @override
  Future<Either<DataCRUDFailure, Success>> call(String teamId) async{
    return await _teamRepo.deleteLocalTeam(teamId);
  }

}