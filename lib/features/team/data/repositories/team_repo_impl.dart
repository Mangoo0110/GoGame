import 'package:dartz/dartz.dart';

import 'package:gogame/core/api_handler/failure.dart';

import 'package:gogame/core/api_handler/success.dart';
import 'package:gogame/features/team/data/datasources/local/team_local_datasource.dart';
import 'package:gogame/features/team/data/models/team_model.dart';

import 'package:gogame/features/team/domain/entities/team.dart';

import '../../../../core/api_handler/trycatch.dart';
import '../../domain/repositories/team_repo.dart';

class TeamRepoImpl implements LocalTeamRepo{

  final TeamLocalDatasource _teamLocalDatasource;

  TeamRepoImpl(this._teamLocalDatasource);

  @override
  Future<Either<DataCRUDFailure, Success>> deleteLocalTeam(String teamId) async{
    return await asyncTryCatch<Success>(tryFunc: ()async{
      return await _teamLocalDatasource.deleteLocalTeam(teamId).then((_) => Success());
    });
  }

  @override
  Future<Either<DataCRUDFailure, List<Team>>> fetchAllLocalTeam() async{
    return await asyncTryCatch<List<Team>>(tryFunc: ()async{
      return await _teamLocalDatasource.fetchAllLocalTeam();
    });
  }

  @override
  Future<Either<DataCRUDFailure, Team>> fetchOneLocalTeam(String teamId) async{
    return await asyncTryCatch<Team>(tryFunc: ()async{
      return await _teamLocalDatasource.fetchOneLocalTeam(teamId);
    });
  }

  @override
  Either<DataCRUDFailure, Stream<List<Team>>> localTeamStream() {
    return tryCatch<Stream<List<Team>>>(tryFunc: () {
      return _teamLocalDatasource.localTeamStream();
    });
  }

  @override
  Future<Either<DataCRUDFailure, bool>> openLocalDb() async{
    return await asyncTryCatch<bool>(tryFunc: ()async{
      return await _teamLocalDatasource.openDb();
    });
  }

  @override
  Future<Either<DataCRUDFailure, Success>> saveLocalTeam(Team team) async{
    return await asyncTryCatch<Success>(tryFunc: ()async{
      return await _teamLocalDatasource.saveLocalTeam(TeamModel.fromEntity(team)).then((_) => Success());
    });
  }
}