// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/foundation.dart';

import '../../ui/providers/modify_player_state_provider.dart';

class LocalPlayer {
  final String id;
  String _name;

  String _localDbImageUrl;
  final List<String> _teamIdList;

  LocalPlayer({
    required this.id,
    required String name,
    required String localDbImageUrl,
    required List<String> teamIdList
  }) : _teamIdList = teamIdList, _localDbImageUrl = localDbImageUrl, _name = name;


  ///getters
  String get name => _name;
  String get localDbImageUrl => _localDbImageUrl;
  List<String> get teamIdList => _teamIdList;

  void changeName({required String name, required ModifyPlayerStateProvider modifyPlayerStateProvider}) {
    _name = name;
  }

  void changeLocalImageUrl({required String imageUrl, required ModifyPlayerStateProvider modifyPlayerStateProvider}) {
    _localDbImageUrl = imageUrl;
  }
  


  LocalPlayer copyWith({
    String? id,
    String? name,
    String? localDbImageUrl,
    List<String>? teamIdList
  }) {
    return LocalPlayer(
      id: id ?? this.id,
      name: name ?? this.name,
      localDbImageUrl: localDbImageUrl ?? this.localDbImageUrl,
      teamIdList: teamIdList ?? this.teamIdList,
    );
  }
  

  @override
  bool operator ==(covariant LocalPlayer other) {
    if (identical(this, other)) return true;
  
    return 
      other.runtimeType == runtimeType &&
      other.id == id &&
      other._name == _name &&
      other._localDbImageUrl == _localDbImageUrl &&
      listEquals(other._teamIdList, _teamIdList);
  }

  @override
  int get hashCode {
    return id.hashCode ^
      _name.hashCode ^
      _localDbImageUrl.hashCode ^
      _teamIdList.hashCode;
  }
}
