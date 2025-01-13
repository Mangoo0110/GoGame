import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../image/ui/widgets/show_round_image.dart';
import '../providers/player_data_provider.dart';

class TeamPlayerEditTile extends StatelessWidget {
  final Color? tileColor;
  final String playerId;
  final VoidCallback onRemove;
  const TeamPlayerEditTile({super.key, required this.onRemove, required this.playerId, this.tileColor});

  @override
  Widget build(BuildContext context) {
    final player = context.read<PlayerDataProvider>().getLocalPlayerById(playerId);
    return LayoutBuilder(
      builder: (context, constraints) {
        if(player == null) return Container();

        return Container(
          decoration: BoxDecoration(
            color: tileColor,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 2),
            child: Table(
              columnWidths: {0: FlexColumnWidth(.85), 1: FlexColumnWidth(.15)},
              children: [
                TableRow(
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Icon(Icons.drag_handle),
                        ),
                        Flexible(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              ShowRoundImage(
                                imageUrl: player.localDbImageUrl,
                                radius: 45,
                                fromLocalDb: true,
                              ),
                              Flexible(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Text(player.name, style: Theme.of(context).textTheme.labelLarge,),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    CloseButton(
                      onPressed: () {
                        onRemove();
                      },
                    )
                  ],
                ),
              ],
            )
          ),
        );
      },
    );
  }
}