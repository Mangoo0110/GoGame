import 'package:dartz/dartz.dart';
import '../../../../core/api_handler/failure.dart';
import '../../../../core/api_handler/success.dart';
import '../entities/team.dart';

abstract interface class LocalTeamRepo {

  Future<Either<DataCRUDFailure, bool>>openLocalDb();

  Future<Either<DataCRUDFailure, Success>> saveLocalTeam(Team team);

  Future<Either<DataCRUDFailure, List<Team>>> fetchAllLocalTeam();

  /// Returns stream of local teams.
  Either<DataCRUDFailure, Stream<List<Team>>> localTeamStream();

  Future<Either<DataCRUDFailure, Team>> fetchOneLocalTeam(String teamId);

  Future<Either<DataCRUDFailure, Success>> deleteLocalTeam(String teamId);
}