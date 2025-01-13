import 'package:dartz/dartz.dart';
import 'package:gogame/core/api_handler/success.dart';
import '../entities/local_player.dart';

import '../../../../core/api_handler/failure.dart';

abstract interface class PlayerRepo {

  ///### Saves the player info to the local database.
  Future<Either<DataCRUDFailure, Success>> saveLocalPlayerInfo({required LocalPlayer player});

  ///### Deletes the player info from the local database.
  Future<Either<DataCRUDFailure, Success>> deleteLocalPlayer({required LocalPlayer player});

  ///### Opens the local database.
  Future<Either<DataCRUDFailure, bool>> openLocalDb();

  ///### Fetches the player info from the local database.
  ///
  /// playerId: The id of the player whose info is to be fetched.
  Future<Either<DataCRUDFailure, LocalPlayer>> fetchLocalPlayerInfo({required String playerId});

  /// Fetches all the players from the local database.
  Future<Either<DataCRUDFailure, List<LocalPlayer>>> fetchAllLocalPlayers();

  ///### Fetches all the players from the local database as a stream.
  Either<DataCRUDFailure, Stream<List<LocalPlayer>>> localPlayersStream();

}