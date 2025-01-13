import '../../../../team/domain/entities/team.dart';

import '../../../../../core/utils/enums/game_type.dart';

class CricketShortPiece {
  final String id;
  final String? _tournamentId;
  final GameType gameType = GameType.cricket;
  final CricketType cricketType = CricketType.shortPitch;
  final Team _firstTeam;
  final Team _secondTeam;

  /// If true, it should be saved in localDb only.
  final bool _localGame;

  /// 1 if first team won the Toss.
  /// 2 if second team won the Toss.
  TossWonBy? _tossWonBy;
  TossDecision? _tossDecision;
  final int overs;
  final int maxPlayers;
  int? _firstInningsRun;
  int? _secondInningsRun;
  DateTime? _gameStartedAt;
  // Edit this field at data layer model before passing the model to be saved in database.
  DateTime? _lastEditAt;
  final DateTime _createdAt;

  CricketShortPiece._({
    required this.id,
    required String? tournamentId,
    required Team firstTeam,
    required Team secondTeam,
    required bool localGame,
    required this.overs,
    required this.maxPlayers,
    required DateTime? lastEditAt,
    required DateTime createdAt,
  })  : _tournamentId = tournamentId,
        _firstTeam = firstTeam,
        _secondTeam = secondTeam,
        _localGame = localGame,
        _lastEditAt = lastEditAt,
        _createdAt = createdAt;

  

  /// Getters
  //String? get tournamentId => _tournamentId;
  Team get firstTeam => _firstTeam;
  Team get secondTeam => _secondTeam;
  bool get localGame => _localGame;
  int? get firstInningsRun => _firstInningsRun;
  int? get secondInningsRun => _secondInningsRun;
  DateTime get createdAt => _createdAt;
  DateTime? get lastEditAt => _lastEditAt;


  factory CricketShortPiece.localGame({
    required String id,
    required Team firstTeam,
    required Team secondTeam,
    required int overs,
    required int maxPlayers,
  })  {
    {
    if (id.isEmpty) {
      throw Exception("Error! Should provide an unique game id.");
    }

    if (firstTeam == secondTeam) {
      throw Exception("Error! Teams can not be same.");
    }

    if (overs <= 0) {
      throw Exception("Error! Overs can not be less or equal to zero(0).");
    }

    if (maxPlayers <= 0 || maxPlayers > 15) {
      throw Exception("Error! MaxPlayers range is 1 to 15.");
    }

    return CricketShortPiece._(
      id: id,
      tournamentId: null,
      firstTeam: firstTeam,
      secondTeam: secondTeam,
      localGame: true,
      overs: overs,
      maxPlayers: maxPlayers,
      lastEditAt: null,
      createdAt: DateTime.now(),
    );
  }
  }

  factory CricketShortPiece.tournamentGame({
    required String id,
    required String tournamentId,
    required Team firstTeam,
    required Team secondTeam,
    required int overs,
    required int maxPlayers,
  }) {
    if (tournamentId.isEmpty) {
      throw Exception("Error! Should provide an unique game id.");
    }

    if (id.isEmpty) {
      throw Exception("Error! Tournament id can not be empty.");
    }

    if (firstTeam == secondTeam) {
      throw Exception("Error! Teams can not be same.");
    }

    if (overs <= 0) {
      throw Exception("Error! Overs can not be less or equal to zero(0).");
    }

    if (maxPlayers <= 0 || maxPlayers > 11) {
      throw Exception("Error! MaxPlayers range is 1 to 11.");
    }

    return CricketShortPiece._(
      id: id,
      tournamentId: tournamentId,
      firstTeam: firstTeam,
      secondTeam: secondTeam,
      localGame: false,
      overs: overs,
      maxPlayers: maxPlayers,
      lastEditAt: null,
      createdAt: DateTime.now(),
    );
  }

  /// ### Once set can't be changed.
  void updateFirstInningsRun(int run) {
    _firstInningsRun ??= run;
    _lastEditAt = DateTime.now();
  }

  /// ### Once set can't be changed.
  void updateSecondInningsRun(int run) {
    _secondInningsRun ??= run;
  }

  /// ### Once set can't be changed.
  void startGameSignal() {
    _gameStartedAt ??= DateTime.now();
  }

  /// ### Once set can't be changed.
  void updateTossWonBy(TossWonBy tossWonBy, TossDecision tossDecision) {
    _tossWonBy ??= tossWonBy;
    _tossDecision ??= tossDecision;
  }
}
