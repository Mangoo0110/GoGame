
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gogame/features/image/ui/widgets/show_round_image.dart';
import 'package:provider/provider.dart';

import '../../../../core/common/widgets/ui_button.dart';
import '../../../../core/utils/constants/app_colors.dart';
import '../../../../core/utils/constants/app_sizes.dart';
import '../../../../core/utils/func/dekhao.dart';
import '../../../../core/utils/routing/smooth_page_transition.dart';
import '../../../players/ui/pages/add_team_players.dart';
import '../../../players/ui/widgets/team_player_edit_tile.dart';
import '../../domain/entities/team.dart';
import '../pages/available_teams_to_select.dart';
import '../providers/teams_selection_provider.dart';

class SelectedTeamBeforeGame extends StatefulWidget {
  final SelectingTeam selectingTeam;
  // final bool Function(Team selectedTeam) onSelectTeam; 
  // final bool Function() onRemoveTeam;
  const SelectedTeamBeforeGame({required super.key, required this.selectingTeam});

  @override
  State<SelectedTeamBeforeGame> createState() => _SelectedTeamBeforeGameViewState();
}

class _SelectedTeamBeforeGameViewState extends State<SelectedTeamBeforeGame> {

  //Team? team;
  int cnt = 0;

  late BuildContext initialContext;

  final ScrollController _scrollController = ScrollController();
  final ScrollController _sliverScrollController = ScrollController();

  @override
  void initState() {
    initialContext = context;
    // TODO: implement initState
    //team = widget.selectingTeam;
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _scrollController.dispose();
    _sliverScrollController.dispose();
    super.dispose();
  }


  void updatePlayersOrder(int playerAtBefore, int playerAtNow) {
    widget.selectingTeam.reorderPlayer(playerAtBefore: playerAtBefore, playerAtNow: playerAtNow);
  }


  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.selectingTeam,

      builder: (selectingTeamContext, child) {

        Team? team = widget.selectingTeam.team;
        dekhao("SelectedTeamBeforeGame (SelectingTeam ${widget.selectingTeam.serial}) load $cnt");
        cnt++;

        return LayoutBuilder(
          builder: (context, constraints) {
            
            return AnimatedContainer(
              duration: Duration(milliseconds: 120),
              height: constraints.maxHeight,
              width:  constraints.maxWidth,
              decoration: BoxDecoration(
                color: AppColors.context(context).contentBoxColor,
                //border: Border.all(color: AppColors.context(context).textColor),
                borderRadius: AppSizes.mediumBorderRadius
              ),
              child: team == null ?
                UiButton(
                  onTap: () {
                    Navigator.push(context, SmoothPageTransition().bottomToUp(
                      secondScreen: AvailableTeamsToSelect(
                        availableTeamsToChooseFrom: context.read<TeamSelectionProvider>().availableTeamsToChooseFrom,

                        onSelect:(selectedTeam) {
                          Navigator.pop(context);
                          bool result = context.read<TeamSelectionProvider>().changeTeamOfSelectingTeam(widget.selectingTeam, selectedTeam);
                          
                          // if(result) {
                          //   team = selectedTeam;
                          //   setState(() {
                              
                          //   });
                          // }
                        },)
                    ));
                  },
                  borderRadius: AppSizes.mediumBorderRadius,
                  child: FittedBox(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.touch_app),
                        Text("Press to select a team", maxLines: 8, style: Theme.of(context).textTheme.labelLarge,),
                      ],
                    ),
                  )
                )
        
                :
                _teamView(team)
            );
            
          },
        );
      }
    );
  }

  Widget _teamView(Team team) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return CustomScrollView(
          // crossAxisAlignment: CrossAxisAlignment.start,
          // mainAxisSize: MainAxisSize.min,
          slivers: [
            SliverToBoxAdapter(child: _teamHeader(team)),

            SliverToBoxAdapter(
              child: SizedBox(
                height: 35,
              ),
            ),

            SliverToBoxAdapter(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Players[${team.teamPlayerIds.length}]", style: Theme.of(context).textTheme.titleMedium,),
                  UiButton(
                    onTap: () {
                      Navigator.push(context, SmoothPageTransition().bottomToUp(
                        secondScreen: AddTeamPlayers(
                          addedPlayerIds: context.read<TeamSelectionProvider>().alreadyAddedPlayerIds(),
                          onDone: (selectedPlayerIds) {
              
                            Navigator.pop(context);
                            //dekhao("len of selectedPlayerIds ${selectedPlayerIds.length}");
                            context.read<TeamSelectionProvider>().addPlayersToSelectingTeam(widget.selectingTeam, selectedPlayerIds);
                            setState(() {
                              
                            });
                          },
                        ))
                      );
                    },
                    borderRadius: AppSizes.smallBorderRadius,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Icon(Icons.add),
                          Text("Add")
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),

            SliverToBoxAdapter(
              child: ReorderableListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                scrollController: _scrollController,
                itemCount: team.teamPlayerIds.length,
                onReorder: (oldIndex, newIndex) {
                  updatePlayersOrder(oldIndex, newIndex);
                },
                onReorderStart: (index) {
                  HapticFeedback.mediumImpact();
                },
                onReorderEnd: (index) {
                  HapticFeedback.lightImpact();
                },
                itemBuilder: (context, index) {
                  final selectedPlayer = context.read<TeamSelectionProvider>().getSelectedPlayerState(team.teamPlayerIds[index]);
              
                  if(selectedPlayer == null) {
                    return Container();
                  }
              
                  return _TeamPlayerTile(
                    widgetKey: Key(team.teamPlayerIds[index]), 
                    onRemove: () {
                      context.read<TeamSelectionProvider>().removePlayerFromTeam(widget.selectingTeam, team.teamPlayerIds[index]);
                      // setState(() {
                        
                      // });
                    }, 
                    selectedPlayer: selectedPlayer,
                  );
                },
              ),
            ),
            SliverToBoxAdapter(child: SizedBox(height: 50,),)
          ],
        );
      },
    );
  }

  Widget _teamHeader(Team selectedTeam) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ShowRoundImage(imageUrl: selectedTeam.localDbImageUrl, radius: 50, fromLocalDb: true,),

                // Remove team button.
                UiButton(
                  borderRadius: AppSizes.smallBorderRadius,
                  onTap: () {
                    context.read<TeamSelectionProvider>().removeTeam(widget.selectingTeam);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(Icons.close, color: Colors.red, size: ((Theme.of(context).textTheme.labelLarge?.fontSize) ?? 30) * 1.5,),

                        Text("Remove", style: Theme.of(context).textTheme.labelLarge?.copyWith(color: Colors.red),),
                      ],
                    ),
                  ),
                )
              ],
            ),

            SizedBox(height: 8,),

            Text(selectedTeam.name, style: Theme.of(context).textTheme.labelLarge,),
          ],
        );
      },
    );
  }
}



class _TeamPlayerTile extends StatefulWidget {
  final SelectedPlayer selectedPlayer;
  final VoidCallback onRemove;
  final Key widgetKey;
  const _TeamPlayerTile({required this.widgetKey, required this.selectedPlayer, required this.onRemove}):super(key: widgetKey);

  @override
  State<_TeamPlayerTile> createState() => __TeamPlayerTileState();
}

class __TeamPlayerTileState extends State<_TeamPlayerTile> {

  bool markTileRed = false; int cnt = 0;

  late BuildContext _context;

  // _watchPlayer() {
  //   markTileRed = (context.watch<TeamSelectionProvider>()
  //       .getSelectedPlayerState(widget.playerId)?.teamIdList.length ?? 0) > 1;
    
  //   dekhao("markTile red($markTileRed) cnt = $cnt");
  //   cnt++;
  // }

  // @override
  // void didChangeDependencies() {
  //   // TODO: implement didChangeDependencies
  //   _watchPlayer();
  //   super.didChangeDependencies();
  // }

  @override
  void initState() {
    // TODO: implement initState
    _context = context;
    markTileRed = (widget.selectedPlayer.teamIdList.length) > 1;

    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    final selectedPlayerState = widget.selectedPlayer;

    return ListenableBuilder(
      listenable: selectedPlayerState,
      builder: (selectedPlayerContext, child) {
        dekhao(selectedPlayerState.toString());
        markTileRed = (widget.selectedPlayer.teamIdList.length) > 1;
        dekhao("markTileRed is $markTileRed, player: ${selectedPlayerState.toString()}");
        return _tile();
      }
    );
  }

  Widget _tile() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return AnimatedContainer(
          duration: Duration(milliseconds: 120),
          decoration: BoxDecoration(
            color: markTileRed ? Colors.redAccent.shade100 : AppColors.context(context).contentBoxColor,
            border: markTileRed ? Border.all(color: AppColors.context(_context).contentBoxColor) : null
          ),
          child: TeamPlayerEditTile(
            key: widget.widgetKey,
            tileColor: null,
            onRemove: () {
              widget.onRemove();
            }, 
            playerId: widget.selectedPlayer.playerId,),
        );
      },
    );
  }
}