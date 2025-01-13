
import 'dart:typed_data';

import 'package:fluttertoast/fluttertoast.dart';

import '../../../../core/utils/func/dekhao.dart';
import '../../../../core/utils/uuid_service/firebase_uid.dart';
import '../../../../init_dependency.dart';
import '../../../image/domain/usecases/delete_image_from_local_db.dart';
import '../../../image/domain/usecases/save_image_locally.dart';
import '../../domain/entities/team.dart';
import '../../domain/usecases/delete_local_team.dart';
import '../../domain/usecases/save_local_team.dart';
import 'edit_team_provider.dart';

mixin TeamDbCalls {

  String _generateteamLocalImageUrl(){
    return "teams/${uuidByFirebaseSdk()}";
  }
  
  Future<Team?> saveTeam({required Uint8List? newteamImage, required EditTeamProvider editTeamProvider, required Team team}) async {

    //save team

    if(newteamImage != null) {
      dekhao("Need to save image.");
      if(team.localDbImageUrl.isEmpty) {
        team.changeImageUrl(imageUrl: _generateteamLocalImageUrl(), editTeamProvider: editTeamProvider);
      }
      return await _saveteamImage(newteamImage: newteamImage, team: team).then((isSaved1) async 
          => !isSaved1 ? null 
            : await _saveteamInfo(team)).then((isSaved2){
              return team;
            });
    } else {
      dekhao("No need to save image.");
      return await _saveteamInfo(team).then((isSaved) => team);
    }

  }

  Future<bool>_saveteamInfo(Team team) async{
    return await serviceLocator<SaveLocalTeam>().call(team).then((value) {
        return value.fold(
          (l) {
            Fluttertoast.showToast(msg: "Error saving team info.");
            return false;
          }, (r) {
            return true;
          });
      });
  }

  Future<bool> _saveteamImage({required Uint8List newteamImage, required Team team}) async{
    
    if(team.localDbImageUrl.isEmpty) {
      throw Exception("Team object's team.localDbImageUrl is empty!");
    }
    
    dekhao("Saving team's image.");
    return await serviceLocator<SaveImageLocally>().call(SaveImageLocallyParams(url: team.localDbImageUrl, imageData: newteamImage)).then((value) {
        return value.fold(
          (l) {
            Fluttertoast.showToast(msg: "Error saving image.");
            return false;
          }, (r) {
            dekhao("Image saved successfully.");
            return true;
          });
      });
  }

  Future<bool> deleteTeam(Team team, EditTeamProvider editTeamProvider) async{
    dekhao("Deleting team.");
    return await _deleteTeamImage(team).then((_){
      team.changeImageUrl(imageUrl: '', editTeamProvider: editTeamProvider); 
      return _deleteTeamInfo(team);
    });
  }

  Future<bool> _deleteTeamImage(Team team) async{
    if(team.localDbImageUrl.isEmpty) return true;
    return await serviceLocator<DeleteImageFromLocalDb>().call(team.localDbImageUrl).then((value) {
      return value.fold(
        (l) {
          Fluttertoast.showToast(msg: "Error deleting image.");
          return false;
        }, (r) {
          dekhao("Deleted image successfully.");
          return true;
        });
    });
  }

  Future<bool> _deleteTeamInfo(Team team) async{

    return await serviceLocator<DeleteLocalTeam>().call(team.id).then((value) {
        return value.fold(
          (l) {
            Fluttertoast.showToast(msg: "Error deleting team.");
            return false;
          }, (r) {
            dekhao("Deleted team successfully.");
            Fluttertoast.showToast(msg: "Team is deleted successfully.");
            return true;
          });
      });
  }
}