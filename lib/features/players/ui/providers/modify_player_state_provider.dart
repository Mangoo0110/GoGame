import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gogame/core/utils/func/dekhao.dart';
import 'package:gogame/core/utils/uuid_service/firebase_uid.dart';
import 'package:gogame/features/image/domain/usecases/delete_image.dart';
import 'package:gogame/features/image/domain/usecases/save_image_locally.dart';
import 'package:gogame/features/players/domain/entities/local_player.dart';
import 'package:gogame/features/players/domain/usecases/delete_player.dart';

import '../../../../core/utils/enums/common_enums.dart';
import '../../../../init_dependency.dart';
import '../../../image/domain/usecases/delete_image_from_local_db.dart';
import '../../domain/usecases/save_local_player.dart';

class ModifyPlayerStateProvider extends ChangeNotifier{

  LocalPlayer? _playerBefore;
  late LocalPlayer _modifyingPlayer;

  SaveStatus _saveStatus = SaveStatus.canNotSave;
  DeleteStatus _deleteStatus = DeleteStatus.canNotDelete;

  Uint8List? _newPlayerImage;


  ModifyPlayerStateProvider({
    required LocalPlayer? player
  }) {
    if(player != null) {
      _playerBefore = player;
      _modifyingPlayer = player.copyWith();
      _deleteStatus = DeleteStatus.canDelete; notifyListeners();
    } else {
      _modifyingPlayer = LocalPlayer(id: uuidByFirebaseSdk(), name: "", localDbImageUrl: _generatePlayerLocalImageUrl(), teamIdList: []);
    }
  }

  //getters
  SaveStatus get saveStatus => _saveStatus;
  DeleteStatus get deleteStatus => _deleteStatus;
  String get playerName => _modifyingPlayer.name;
  String get playerDocId => _modifyingPlayer.id;
  Uint8List? get playerImage => _newPlayerImage;

  String _generatePlayerLocalImageUrl(){
    return "players/${uuidByFirebaseSdk()}";
  }

  void updatePlayerName(String name){
    _modifyingPlayer.changeName(name: name, modifyPlayerStateProvider: this);
    _checkIfCanSave();
  }

  /// newPlayerImage: Image size should be less than the set limit (e.g 1MB).
  void updatePlayerImage(Uint8List image){
    _newPlayerImage = image;
    if(_modifyingPlayer.localDbImageUrl.isEmpty) _modifyingPlayer.changeLocalImageUrl(imageUrl: _generatePlayerLocalImageUrl(), modifyPlayerStateProvider: this);
    _checkIfCanSave();
  }


  void _checkIfCanSave(){
    if(_modifyingPlayer.name.isNotEmpty){
      if(_saveStatus != SaveStatus.canSave){
        _saveStatus = SaveStatus.canSave; notifyListeners();
      }
    } else {
      if(_saveStatus != SaveStatus.canNotSave){
        _saveStatus = SaveStatus.canNotSave; notifyListeners();
      }
    }
  }



  Future<LocalPlayer?> savePlayer() async {

    if(_saveStatus == SaveStatus.canNotSave) return null;
    //save player
    _saveStatus = SaveStatus.saving; notifyListeners();

    if(_newPlayerImage != null) {
      dekhao("Need to save image.");
      return await _savePlayerImage(newPlayerImage: _newPlayerImage!).then((isSaved1) async 
          => !isSaved1 ? null 
            : await _savePlayerInfo()).then((isSaved2){
              return _modifyingPlayer;
            });
    } else {
      dekhao("No need to save image.");
      return await _savePlayerInfo().then((isSaved) => _modifyingPlayer);
    }

  }

  Future<bool>_savePlayerInfo() async{
    return await serviceLocator<SavePlayerLocally>().call(_modifyingPlayer).then((value) {
        return value.fold(
          (l) {
            Fluttertoast.showToast(msg: "Error saving player info.");
            _saveStatus = SaveStatus.failed; notifyListeners();
            return false;
          }, (r) {
            _saveStatus = SaveStatus.saved; notifyListeners();
            return true;
          });
      });
  }

  Future<bool> _savePlayerImage({required Uint8List newPlayerImage}) async{
    dekhao("Saving player's image.");
    return await serviceLocator<SaveImageLocally>().call(SaveImageLocallyParams(url: _modifyingPlayer.localDbImageUrl, imageData: newPlayerImage)).then((value) {
        return value.fold(
          (l) {
            Fluttertoast.showToast(msg: "Error saving image.");
            _saveStatus = SaveStatus.failed; notifyListeners();
            return false;
          }, (r) {
            dekhao("Image saved successfully.");
            return true;
          });
      });
  }

  Future<bool> deletePlayer() async{
    _deleteStatus = DeleteStatus.deleting; notifyListeners();
    dekhao("Deleting player.");
    return await _deletePlayerImage().then((_){
      return _deletePlayerInfo();
    });
  }

  Future<bool> _deletePlayerImage() async{
    return await serviceLocator<DeleteImageFromLocalDb>().call(_modifyingPlayer.localDbImageUrl).then((value) {
      return value.fold(
        (l) {
          Fluttertoast.showToast(msg: "Error deleting image.");
          _deleteStatus = DeleteStatus.failed; notifyListeners();
          return false;
        }, (r) {
          dekhao("Deleted image successfully.");
          return true;
        });
    });
  }

  Future<bool> _deletePlayerInfo() async{

    return await serviceLocator<DeleteLocalPlayer>().call(_modifyingPlayer).then((value) {
        return value.fold(
          (l) {
            Fluttertoast.showToast(msg: "Error deleting player.");
            _deleteStatus = DeleteStatus.failed; notifyListeners();
            return false;
          }, (r) {
            dekhao("Deleted player successfully.");
            _deleteStatus = DeleteStatus.deleted; notifyListeners();
            Fluttertoast.showToast(msg: "Player is deleted successfully.");
            return true;
          });
      });
  }

  
}