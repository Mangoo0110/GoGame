enum BallState{
  run1,
  run2,
  run3,
  boundary,
  six,
  noBall,
  wide,
  legbye1,
  legbye2,
  legbye3,
  legbye4,
  bye1,
  bye2,
  bye4,
  dot,
  lbwOut,
  runOut,
  stumping,
  catchOut,
  boldOut

}


class CricketPrimarySetting {
  
}


class RunSetting {

}


class CricketGameSettings {
  final CricketPrimarySetting cricketPrimarySetting;
  final RunSetting runSetting;

  CricketGameSettings({required this.cricketPrimarySetting, required this.runSetting});
  
}

