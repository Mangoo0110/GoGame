import 'package:dartz/dartz.dart';
import 'package:gogame/features/team/domain/entities/team.dart';
import '../../../../core/api_handler/failure.dart';
import '../../../../core/usecases/usecases.dart';
import '../repositories/team_repo.dart';

class FetchAllLocalTeams implements AsyncEitherUsecase<List<Team>, NoParams>{

  final LocalTeamRepo _teamRepo;

  FetchAllLocalTeams(this._teamRepo);

  /// Saves the team info only locally.
  @override
  Future<Either<DataCRUDFailure, List<Team>>> call(NoParams params) async{
    return await _teamRepo.fetchAllLocalTeam();
  }

}