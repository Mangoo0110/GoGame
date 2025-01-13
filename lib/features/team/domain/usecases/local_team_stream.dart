import 'package:dartz/dartz.dart';
import 'package:gogame/features/team/domain/entities/team.dart';
import '../../../../core/api_handler/failure.dart';
import '../../../../core/usecases/usecases.dart';
import '../repositories/team_repo.dart';

class LocalTeamStream implements EitherUsecase<Stream<List<Team>>, NoParams>{

  final LocalTeamRepo _teamRepo;

  LocalTeamStream(this._teamRepo);

  /// Saves the team info only locally.
  @override
  Either<DataCRUDFailure, Stream<List<Team>>> call(NoParams params) {
    return  _teamRepo.localTeamStream();
  }

}