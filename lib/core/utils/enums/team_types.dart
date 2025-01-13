enum TeamType {
  none,
  cricket,
  badminton;

  factory TeamType.fromMap(String type){
    TeamType teamType = TeamType.cricket;

    for (var val in TeamType.values) {
      if(val.name == type) {
        teamType = val; break;
      }
    }
    return teamType;
  }
}