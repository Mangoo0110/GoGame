import 'package:flutter/material.dart';
import 'package:gogame/features/cricket/game/ui/pages/quick_game_init.dart';
import '../core/common/widgets/ui_button.dart';
import '../core/utils/constants/app_colors.dart';
import '../core/utils/constants/app_sizes.dart';
import '../core/utils/routing/smooth_page_transition.dart';
import '../features/players/ui/pages/modify_player_info_screen.dart';
import '../features/players/ui/pages/player_friends.dart';
import 'features/team/ui/pages/local_team_list.dart';

class AppInitialScreen extends StatelessWidget {
  const AppInitialScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          appBar: AppBar(
            title: Text("GoGame", style: Theme.of(context).textTheme.titleMedium,),
            actions: [
              showLocalTeamButton(),
              showLocalPlayersButton(),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: Stack(
              children: [
                body(),
                Positioned(
                  left: constraints.maxWidth / 2 - 150/2,
                  bottom: 12,
                  child: AnimatedContainer(
                    width: 150,
                    decoration: BoxDecoration(
                      color: AppColors.context(context).accentColor,
                      borderRadius: AppSizes.smallBorderRadius,
                      
                    ),
                    duration:  Duration(milliseconds: 300),
                    child: FittedBox(child: bottomButton())
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Widget body() {
    int playedGameCnt = 0;
    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Recent games", style: Theme.of(context).textTheme.headlineMedium,),
            SizedBox(
              height: 20,
            ),
            Text("No games played recently... ${'\n'}Add players and press on 'New game' to start a game.", style: Theme.of(context).textTheme.labelLarge?.copyWith(color: AppColors.context(context).textGreyColor), maxLines: 12,),

          ],
        );
      },
    );
  }

  Widget showLocalPlayersButton() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return UiButton(
          borderRadius: AppSizes.largeBorderRadius,
          onTap: () {
            Navigator.of(context).push(
              SmoothPageTransition().rightToLeft(secondScreen: PlayerFriends())
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(Icons.groups_2_outlined),
          ),
        );
      },
    );
  }


  Widget showLocalTeamButton() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return UiButton(
          borderRadius: AppSizes.largeBorderRadius,
          onTap: () {
            Navigator.of(context).push(
              SmoothPageTransition().rightToLeft(secondScreen: LocalTeamList())
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(Icons.featured_play_list),
          ),
        );
      },
    );
  }

  Widget bottomButton() {
    return newGameButton();
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
                Text("Add player")
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

  Widget newGameButton() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return UiButton(
          onTap: () async{
             showBottomSheet(
              context: context,
              showDragHandle: true,
              enableDrag: true,
                // barrierColor: Colors.black.withOpacity(0.5),
                // barrierDismissible: false,
                // //useSafeArea: true,
                // useRootNavigator: true,
                sheetAnimationStyle: AnimationStyle(curve: Curves.fastOutSlowIn),
                builder: (context) {
                return QuickGameInit();
                },
            );
          },
          borderRadius: AppSizes.smallBorderRadius,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Icon(Icons.add),
                Text("New game")
              ],
            ),
          ),
        );
      },
    );
  }
}