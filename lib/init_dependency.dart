import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gogame/firebase_options.dart';
import '../features/image/data/datasources/firebase/image_firebase_datasource.dart';
import '../features/image/data/repositories/image_repo_impl.dart';
import '../features/image/domain/usecases/delete_image.dart';
import '../features/image/domain/usecases/fetch_image.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get_it/get_it.dart';

import 'features/image/data/datasources/hive/image_local_datasource.dart';
import 'features/image/domain/usecases/delete_image_from_local_db.dart';
import 'features/image/domain/usecases/fetch_image_from_local_db.dart';
import 'features/image/domain/usecases/save_image_locally.dart';
import 'features/image/domain/usecases/save_image_with_reference_path.dart';
import 'features/image/domain/usecases/save_image_with_url.dart';
import 'features/players/data/datasources/local/player_local_datasource.dart';
import 'features/players/data/repositories/player_repo_impl.dart';
import 'features/players/domain/usecases/delete_player.dart';
import 'features/players/domain/usecases/fetch_all_local_players.dart';
import 'features/players/domain/usecases/fetch_local_player_info.dart';
import 'features/players/domain/usecases/local_players_stream.dart';
import 'features/players/domain/usecases/open_local_player_db.dart';
import 'features/players/domain/usecases/save_local_player.dart';
import 'features/team/data/datasources/local/team_local_datasource.dart';
import 'features/team/data/repositories/team_repo_impl.dart';
import 'features/team/domain/usecases/delete_local_team.dart';
import 'features/team/domain/usecases/fetch_all_local_teams.dart';
import 'features/team/domain/usecases/local_team_stream.dart';
import 'features/team/domain/usecases/open_local_team_db.dart';
import 'features/team/domain/usecases/save_local_team.dart';

final serviceLocator = GetIt.instance;

  //::: Datasources [register singletone]

  //::: Repo [register factory]

  //::: Usecases

Future<void> initDependencies()async{
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  ).then((value) async{
    // await FirebaseAppCheck.instance.activate(
    
    //   webProvider: ReCaptchaV3Provider("DormsityAppAnik"),
    //   androidProvider: AndroidProvider.debug,
    //   appleProvider: AppleProvider.appAttest
    // );
  });
  
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  serviceLocator.registerSingleton(()=> firebaseFirestore);
  serviceLocator.registerSingleton(()=> FirebaseAuth.instance);
  //_authService();
  _imageService();
  _playerInfoService();
  _teamService();

  //_userInfoService();
}


void _imageService() {
  //::: Remote Datasource [register singletone]
  serviceLocator.registerLazySingleton(() => ImageFirebaseStorageImpl.instance);

  //::: Local Datasource [register singletone]
  serviceLocator.registerLazySingleton(() => ImageHiveDatasouceImpl.instance);

  //::: Repo [register factory]
  serviceLocator.registerFactory(() => ImageRepoImpl(serviceLocator<ImageFirebaseStorageImpl>(), serviceLocator<ImageHiveDatasouceImpl>()));

  //::: Usecases
  serviceLocator.registerLazySingleton(() => DeleteImage(serviceLocator<ImageRepoImpl>()));
  serviceLocator.registerLazySingleton(() => DeleteImageFromLocalDb(serviceLocator<ImageRepoImpl>()));
  serviceLocator.registerLazySingleton(() => FetchImage(serviceLocator<ImageRepoImpl>()));
  serviceLocator.registerLazySingleton(() => FetchImageFromLocalDb(serviceLocator<ImageRepoImpl>()));
  serviceLocator.registerLazySingleton(() => SaveImageWithUrl(serviceLocator<ImageRepoImpl>()));
  serviceLocator.registerLazySingleton(() => SaveImageWithReferencePath(serviceLocator<ImageRepoImpl>()));
  serviceLocator.registerLazySingleton(() => SaveImageLocally(serviceLocator<ImageRepoImpl>()));
  
}

void _playerInfoService() {
  //::: Remote Datasource(implementation) [register singletone]

  //::: Local Datasource(implementation)  [register singletone]
  serviceLocator.registerLazySingleton(() => PlayerHiveDatasourceImpl.instance);

  //::: Repo(implementation) [register factory]
  serviceLocator.registerFactory(() => PlayerRepoImpl(serviceLocator<PlayerHiveDatasourceImpl>()));

  //::: Usecases
  serviceLocator.registerLazySingleton(() => SavePlayerLocally(serviceLocator<PlayerRepoImpl>()));
  serviceLocator.registerLazySingleton(() => DeleteLocalPlayer(serviceLocator<PlayerRepoImpl>()));
  serviceLocator.registerLazySingleton(() => FetchLocalPlayerInfo(serviceLocator<PlayerRepoImpl>()));
  serviceLocator.registerLazySingleton(() => FetchAllLocalPlayers(serviceLocator<PlayerRepoImpl>()));
  serviceLocator.registerLazySingleton(() => LocalPlayersStream(serviceLocator<PlayerRepoImpl>()));
  serviceLocator.registerLazySingleton(() => OpenLocalPlayerDb(serviceLocator<PlayerRepoImpl>()));
  
}

void _teamService() {
  //::: Remote Datasource(implementation) [register singletone]

  //::: Local Datasource(implementation)  [register singletone]
  serviceLocator.registerLazySingleton(() => TeamHiveImpl.instance);

  //::: Repo(implementation) [register factory]
  serviceLocator.registerFactory(() => TeamRepoImpl(serviceLocator<TeamHiveImpl>()));

  //::: Usecases
  serviceLocator.registerLazySingleton(() => SaveLocalTeam(serviceLocator<TeamRepoImpl>()));
  serviceLocator.registerLazySingleton(() => DeleteLocalTeam(serviceLocator<TeamRepoImpl>()));
  serviceLocator.registerLazySingleton(() => FetchAllLocalTeams(serviceLocator<TeamRepoImpl>()));
  serviceLocator.registerLazySingleton(() => LocalTeamStream(serviceLocator<TeamRepoImpl>()));
  serviceLocator.registerLazySingleton(() => OpenLocalTeamDb(serviceLocator<TeamRepoImpl>()));
  
}


// void _authService(){  
  
//   serviceLocator.registerLazySingleton(() => AuthFirebaseImpl.instance);

//   serviceLocator.registerFactory(() => AuthRepoImpl(serviceLocator<AuthFirebaseImpl>()));

//   // usecases

//   serviceLocator.registerLazySingleton(() => UserSignIn(serviceLocator<AuthRepoImpl>()));

//   serviceLocator.registerLazySingleton(() => UserSignUp(serviceLocator<AuthRepoImpl>()));

//   serviceLocator.registerLazySingleton(() => GetCurrentUserAuth(serviceLocator<AuthRepoImpl>()));

//   serviceLocator.registerLazySingleton(() => IsUserSignedIn(serviceLocator<AuthRepoImpl>()));

// }

// void _userInfoService(){

//   //::: Datasources [register singletone]  
//   serviceLocator.registerLazySingleton(() => UserFirestoreImpl.instance);
//   serviceLocator.registerLazySingleton(() => UserHiveImpl.instance);

//   //::: Repo [register factory]
//   serviceLocator.registerFactory(() => UserRepoImpl(serviceLocator<UserFirestoreImpl>(), serviceLocator<UserHiveImpl>()));

//   //::: Usecases
//   serviceLocator.registerLazySingleton(() => SaveUserInfo(serviceLocator<UserRepoImpl>()));
//   serviceLocator.registerLazySingleton(() => FetchCurrentUserInfo(serviceLocator<UserRepoImpl>()));
//   serviceLocator.registerLazySingleton(() => FetchUserInfo(serviceLocator<UserRepoImpl>()));
// }



