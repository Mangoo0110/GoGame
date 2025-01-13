import 'package:flutter/material.dart';
import 'package:gogame/core/utils/constants/app_colors.dart';
import 'package:gogame/features/team/ui/providers/team_data_provider.dart';
import 'package:gogame/features/team/ui/providers/teams_selection_provider.dart';
import 'package:provider/provider.dart';

import '../../domain/entities/team.dart';
import '../widgets/selected_team_before_game.dart';


class SideBySideTeamSelection extends StatefulWidget {
  /// How many teams need to be selcted by the user.
  final int _howMany;
  /// If provided should be less than or equal to [_howMany] or exception will be thrown.
  final List<Team> _teams;
  /// Return the teams selected by the user after done selecting.
  final Function(List<Team> selectedTeams) _onDone;

  const SideBySideTeamSelection._({super.key, required int howMany, required List<Team> teams, required dynamic Function(List<Team>) onDone}) : _onDone = onDone, _teams = teams, _howMany = howMany;


  /// howmany: How many teams need to be selcted by the user.
  /// 
  /// teams: If provided should be less than or equal to [howMany] or exception will be thrown.
  /// 
  /// onDone: Return the teams selected by the user after done selecting.
  factory SideBySideTeamSelection.call({
    Key? key, 
    
    required List<Team> teams, 
    
    required Function(List<Team> selectedTeams) onDone,
  }){
    // if(howMany < 2) Exception("At least 2 teams need to be checked and select side by side.");
    // if(howMany > 2) Exception("Sorry, but currently only two teams can be select and compared side by side.");
    if(teams.length > 2) throw Exception("Given team length is greater than 2.");

    return SideBySideTeamSelection._(key: key, howMany: 2, teams: teams, onDone: onDone);
  }




  @override
  State<SideBySideTeamSelection> createState() => _SideBySideTeamSelectionState();
}

class _SideBySideTeamSelectionState extends State<SideBySideTeamSelection> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<TeamSelectionProvider>(
      create: (context) => TeamSelectionProvider(
        selectedTeams: widget._teams, 
        allTeams: context.read<TeamDataProvider>().localTeams),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Scaffold(
            backgroundColor: AppColors.context(context).contentBoxColor,
            appBar: AppBar(
              elevation: 1,
              shadowColor: AppColors.context(context).textColor,
              title: Text("Select teams"),
              actions: [
                //SelectionDoneButton(),
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.only(left: 6.0, right: 4, top: 20),
              child: Table(
                columnWidths: {0: FlexColumnWidth(.48), 1: FlexColumnWidth(.005), 2: FlexColumnWidth(.48), },
                children: [
                  TableRow(
                    children: [
                      // First team
                      SizedBox(
                        height: constraints.maxHeight ,
                        child: SelectedTeamBeforeGame(
                          key: Key("First team"), 

                          selectingTeam: context.read<TeamSelectionProvider>().firstSelectedTeam,

                        ),
                      ),
              
                      /// Gap
                      Container(
                        height: constraints.maxHeight,
                        width: .01,
                        color: AppColors.context(context).textColor,
                      ),
              
                      // Second team
                      SizedBox(
                        height: constraints.maxHeight ,
                        child: SelectedTeamBeforeGame(
                          key: Key("Second team"), 

                          selectingTeam: context.read<TeamSelectionProvider>().secondSelectedTeam, 
                          
                        ),
                      ),
                    ]
                  )
                ],
              ),
            )
          );
        },
      ),
    );
  }
}




