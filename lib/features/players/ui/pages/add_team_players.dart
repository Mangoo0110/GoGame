import 'package:flutter/material.dart';
import 'package:gogame/core/common/widgets/ui_button.dart';
import 'package:gogame/core/utils/constants/app_sizes.dart';
import 'package:gogame/features/players/ui/providers/player_data_provider.dart';
import 'package:provider/provider.dart';
import '../../../../core/utils/constants/app_colors.dart';
import '../../../image/ui/widgets/show_round_image.dart';
import '../../domain/entities/local_player.dart';

class AddTeamPlayers extends StatelessWidget {
  final List<String> addedPlayerIds;
  final Function(List<String> selectedPlayerIds) onDone;
  AddTeamPlayers({super.key, required this.onDone, required this.addedPlayerIds});
  
  List<String> _selectedPlayerIds = [];
  List<LocalPlayer> _yetToAddPlayerIds = [];

  getYetToAddPlayers(BuildContext context) {
    _yetToAddPlayerIds.clear();
    for(final player in context.read<PlayerDataProvider>().players) {
      if( !addedPlayerIds.contains(player.id)) {
        _yetToAddPlayerIds.add(player);
      }
    }
  }

  void _addPlayer(String playerId) {
    if(_selectedPlayerIds.contains(playerId) || playerId.isEmpty) return;
    _selectedPlayerIds.add(playerId);
  }

  void _removePlayer(String playerId) {
    _selectedPlayerIds.removeWhere((element) => element == playerId);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        getYetToAddPlayers(context);
        return Scaffold(
          appBar: AppBar(
            title: Text("Select players"),
            actions: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.greenAccent,
                  borderRadius: AppSizes.smallBorderRadius,
                ),
                child: UiButton(
                  borderRadius: AppSizes.smallBorderRadius,
                  onTap: () {
                    onDone(_selectedPlayerIds);
                  },

                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Icon(Icons.done,),
                        SizedBox(width: AppSizes.smallPadding,),
                        Text("Done")
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 6),
            child: GridView.builder(
              shrinkWrap: true,
              itemCount: _yetToAddPlayerIds.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Adjust the number of columns as needed
                crossAxisSpacing: 5.0,
                mainAxisSpacing: 5.0,
                childAspectRatio: 2
              ),
              itemBuilder: (context, index) {
                return AddTeamPlayerTile(
                  key: Key(_yetToAddPlayerIds[index].id), 
                  player: _yetToAddPlayerIds[index],
                  onSelect: () {
                    _addPlayer(_yetToAddPlayerIds[index].id);
                  },
                  onDeSelect: () {
                    _removePlayer(_yetToAddPlayerIds[index].id);
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }
}


class AddTeamPlayerTile extends StatefulWidget {
  final LocalPlayer player;
  /// Calls when tile is selected.
  final VoidCallback onSelect;
  /// Calls when tile is deselected.
  final VoidCallback onDeSelect;
  const AddTeamPlayerTile({required super.key, required this.player, required this.onSelect, required this.onDeSelect});

  @override
  State<AddTeamPlayerTile> createState() => _AddTeamPlayerTileState();
}

class _AddTeamPlayerTileState extends State<AddTeamPlayerTile> {

  bool selected = false;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {

        return AnimatedContainer(
          duration: Duration(milliseconds: 100),
          curve: Curves.easeIn,
          decoration: BoxDecoration(
            color: AppColors.context(context).contentBoxColor,
            borderRadius: AppSizes.smallBorderRadius,
            border: Border.all(width: 2, color:  selected ? Colors.green.shade200 : AppColors.context(context).contentBoxColor,)
          ),
          child: UiButton(
            onTap: (){
              selected = !selected;
              
              if(selected) {
                widget.onSelect();
              } else {
                widget.onDeSelect();
              }

              setState(() {
                
              });
            },
            borderRadius: AppSizes.smallBorderRadius,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ShowRoundImage(
                    imageUrl: widget.player.localDbImageUrl,
                    radius: 45,
                    fromLocalDb: true,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(widget.player.name, style: Theme.of(context).textTheme.labelLarge, maxLines: 2,),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}



