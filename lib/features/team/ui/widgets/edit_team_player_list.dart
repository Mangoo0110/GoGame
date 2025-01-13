import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../../core/common/widgets/ui_button.dart';
import '../../../../core/utils/constants/app_sizes.dart';
import '../../../../core/utils/func/dekhao.dart';
import '../../../../core/utils/routing/smooth_page_transition.dart';
import '../../../players/ui/pages/add_team_players.dart';
import '../../../players/ui/widgets/team_player_edit_tile.dart';
import '../providers/edit_team_provider.dart';

class EditTeamPlayerListWidget extends StatefulWidget {
  final Function(PointerMoveEvent pointerDetails) onPointerMove;
  final VoidCallback onPointerUp;
  final VoidCallback onPointerCancel;
  const EditTeamPlayerListWidget({super.key, required this.onPointerMove, required this.onPointerUp, required this.onPointerCancel});

  @override
  State<EditTeamPlayerListWidget> createState() => _EditTeamPlayerListWidgetState();
}

class _EditTeamPlayerListWidgetState extends State<EditTeamPlayerListWidget> {

  ScrollController _controller = ScrollController();

  @override
  void dispose() {
    // TODO: implement dispose
    _controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final teamPlayerIds = context.watch<EditTeamProvider>().playerIds;
    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Players [${teamPlayerIds.length}]", style: Theme.of(context).textTheme.titleMedium,),
                UiButton(
                  onTap: () {
                    Navigator.push(context, SmoothPageTransition().bottomToUp(
                      secondScreen: AddTeamPlayers(
                        addedPlayerIds: context.read<EditTeamProvider>().playerIds,
                        onDone: (selectedPlayerIds) {
                          dekhao("len of selectedPlayerIds ${selectedPlayerIds.length}");
                          context.read<EditTeamProvider>().addPlayerIdList(selectedPlayerIds);
                          Navigator.pop(context);
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
            Listener(
              onPointerCancel: (event) {
                widget.onPointerCancel();
              },
              onPointerUp: (event) {
                widget.onPointerUp();
              },
              onPointerMove: (event) {
                widget.onPointerMove(event);
              },
              child: ReorderableListView.builder(
                //scrollController: _controller,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: teamPlayerIds.length,
                onReorder: (oldIndex, newIndex) {
                  dekhao("reorder call");
                  context.read<EditTeamProvider>().updatePlayersOrder(oldIndex, newIndex);
                },
                onReorderStart: (index) {
                  HapticFeedback.mediumImpact();
                },
                onReorderEnd: (index) {
                  HapticFeedback.lightImpact();
                },
                itemBuilder: (context, index) {
                  return TeamPlayerEditTile(
                    key: Key(teamPlayerIds[index]),
                    onRemove: () {
                      context.read<EditTeamProvider>().removePlayerId(teamPlayerIds[index]);
                    }, 
                    playerId: teamPlayerIds[index],);
                },
              ),
            ),
          
          ],
        );
      },
    );
  }
}