import 'package:flutter/material.dart';
import 'package:gogame/core/common/widgets/ui_button.dart';
import 'package:gogame/core/utils/constants/app_colors.dart';
import 'package:gogame/core/utils/constants/app_sizes.dart';
import 'package:gogame/features/image/ui/widgets/show_round_image.dart';
import 'package:provider/provider.dart';

import '../../../../core/utils/routing/smooth_page_transition.dart';
import '../../domain/entities/local_player.dart';
import '../providers/player_data_provider.dart';
import 'modify_player_info_screen.dart';

class PlayerFriends extends StatefulWidget {
  const PlayerFriends({super.key});

  @override
  State<PlayerFriends> createState() => _PlayerFriendsState();
}

class _PlayerFriendsState extends State<PlayerFriends> {
  List<LocalPlayer> players = [];

  @override
  Widget build(BuildContext context) {
    players = context.watch<PlayerDataProvider>().players;
    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          appBar: AppBar(
            title: Text("Your player friends"),
            actions: [
              addPlayerButton(),
            ],
          ),
          body: ListView.builder(
            shrinkWrap: true,
            itemCount: players.length,
            itemBuilder: (context, index) {
              final player = players[index];
              return Padding(
                padding: const EdgeInsets.all(2.0),
                child: ListTile(
                  tileColor: AppColors.context(context).contentBoxColor,
                  onTap: () {
                    Navigator.of(context).push(
                      SmoothPageTransition().rightToLeft(secondScreen: ModifyPlayerInfoScreen(player: player))
                    );
                  },
                  leading: ShowRoundImage(
                    key: Key(player.id),
                    imageUrl: player.localDbImageUrl,
                    radius: 45,
                    fromLocalDb: true,
                  ),
                  title: Text(player.name),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget addPlayerButton() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return UiButton(
          borderRadius: AppSizes.smallBorderRadius,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Icon(Icons.add),
                Text("Create", style: Theme.of(context).textTheme.titleMedium,)
              ],
            ),
          ),
          onTap: () {
            Navigator.of(context).push(
              SmoothPageTransition().rightToLeft(secondScreen: ModifyPlayerInfoScreen(player: null))
            );
          },
        );
      },
    );
  }
}