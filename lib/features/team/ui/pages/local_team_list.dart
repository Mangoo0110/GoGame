import 'package:flutter/material.dart';
import '../../../../../core/utils/enums/team_types.dart';
import '../pages/edit_team_screen.dart';
import '../providers/team_data_provider.dart';
import 'package:provider/provider.dart';

import '../../../../core/common/widgets/ui_button.dart';
import '../../../../core/utils/constants/app_colors.dart';
import '../../../../core/utils/constants/app_sizes.dart';
import '../../../../core/utils/routing/smooth_page_transition.dart';
import '../../../image/ui/widgets/show_round_image.dart';
import '../../domain/entities/team.dart';

class LocalTeamList extends StatelessWidget {
  const LocalTeamList({super.key});

  List<Team> getTeams(BuildContext context) {
    return context.watch<TeamDataProvider>().localTeams;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final teams = getTeams(context);
        return Scaffold(
          appBar: AppBar(
            title: Text("Local teams"),
            actions: [
              createButton()
            ],
          ),
          body: ListView.builder(
            itemCount: teams.length,
            itemBuilder: (context, index) {
              final team = teams[index];
              return Padding(
                padding: const EdgeInsets.all(2.0),
                child: ListTile(
                  tileColor: AppColors.context(context).contentBoxColor,
                  onTap: () {
                    Navigator.of(context).push(
                      SmoothPageTransition().rightToLeft(
                        secondScreen: EditTeamScreen(
                          // afterEditDone: (afterEdit, newTeamImageToSave, editTeamProvider) async{
                          //   await editTeamProvider.saveTeam(newteamImage: newTeamImageToSave, editTeamProvider: editTeamProvider, team: afterEdit);
                          // },
                          // onDeletePress:(editTeamProvider) async{
                          //   await editTeamProvider.deleteTeam(team, editTeamProvider);
                          // },
                          showDeleteButton: true,
                          team: team, 
                          teamType: team.teamType,
                        ))
                    );
                  },
                  leading: ShowRoundImage(
                    key: Key(team.id),
                    imageUrl: team.localDbImageUrl,
                    radius: 45,
                    fromLocalDb: true,
                  ),
                  title: Text(team.name),
                ),
              ); 
            },
          ),
        );
      },
    );
  }

  Widget createButton() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return UiButton(
          borderRadius: AppSizes.smallBorderRadius,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Icon(Icons.add),
                Text("Create", style: Theme.of(context).textTheme.titleMedium)
              ],
            ),
          ),
          onTap: () {
            Navigator.of(context).push(
              SmoothPageTransition().rightToLeft(secondScreen: EditTeamScreen(
                // afterEditDone: (afterEdit, newTeamImageToSave, editTeamProvider) async{
                //   await editTeamProvider.saveTeam(newteamImage: newTeamImageToSave, editTeamProvider: editTeamProvider, team: afterEdit);
                // },
                // onDeletePress: (editTeamProvider) async{
                // },
                showDeleteButton: true,
                team: null, 
                teamType: TeamType.cricket,
              ))
            );
          },
        );
      },
    );
  }
}