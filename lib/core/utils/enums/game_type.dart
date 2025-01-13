enum GameType {
  none,
  cricket,
  badminton;

  factory GameType.fromMap(String type) {
    GameType gameType = GameType.cricket;

    for (var val in GameType.values) {
      if (val.name == type) {
        gameType = val;
        break;
      }
    }
    return gameType;
  }
}

enum TossDecision {
  _none,
  battingFirst,
  bowlingFirst;

  factory TossDecision.fromMap(String type){
    TossDecision tossDecision = TossDecision.battingFirst;

    for (var val in TossDecision.values) {
      if(val.name == type) {
        tossDecision = val; break;
      }
    }
    return tossDecision;
  }
}

enum TossWonBy {
  _none,
  firstTeam,
  secondTeam;

  factory TossWonBy.fromMap(String type){
    TossWonBy tossWonBy = TossWonBy._none;

    for (var val in TossWonBy.values) {
      if(val.name == type) {
        tossWonBy = val; break;
      }
    }
    return tossWonBy;
  }
}

enum GameWonBy {
  _empty,
  /// Means the game was a draw.
  none,
  firstTeam,
  secondTeam;

  factory GameWonBy.fromMap(String type){
    GameWonBy gameWonBy = GameWonBy._empty;

    for (var val in GameWonBy.values) {
      if(val.name == type) {
        gameWonBy = val; break;
      }
    }
    return gameWonBy;
  }
}

enum CricketType {
  _none,
  shortPitch,
  longPitch;

  factory CricketType.fromMap(String type){
    CricketType cricketType = CricketType._none;

    for (var val in CricketType.values) {
      if(val.name == type) {
        cricketType = val; break;
      }
    }
    return cricketType;
  }
}
