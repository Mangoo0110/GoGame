import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gogame/core/common/widgets/ui_button.dart';
import 'package:gogame/core/utils/constants/app_colors.dart';
import 'package:gogame/core/utils/constants/app_sizes.dart';
import 'package:gogame/core/utils/routing/smooth_page_transition.dart';
import 'package:gogame/features/team/domain/entities/team.dart';
import 'package:gogame/features/team/ui/pages/side_by_side_team_selection.dart';
import 'package:provider/provider.dart';

import '../../../../image/ui/widgets/show_rect_image.dart';
import '../providers/quick_game_init_provider.dart';

class QuickGameInit extends StatelessWidget {
  const QuickGameInit({super.key,});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return ChangeNotifierProvider<QuickGameInitProvider>(
          create: (context) => QuickGameInitProvider(),
          child: BottomSheet(
            backgroundColor: AppColors.context(context).contentBoxColor,
            onClosing: () {
              
            },
            // elevation: 4,
            // shape: RoundedRectangleBorder(borderRadius: AppSizes.smallBorderRadius),
            builder: (context) => Padding(
              padding: const EdgeInsets.all(6.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("New game", style: Theme.of(context).textTheme.labelLarge,),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          StartButton(),
                          SizedBox(width: 5,),
                          SaveAndPlayLaterButton()
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 35,
                  ),

                  SizedBox(
                    height: 150,
                    child: GameTeams()
                  ),

                  SizedBox(
                    height: 15,
                  ),
                  
                  PrimarySettings(),
                  SizedBox(
                    height: 35,
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

class StartButton extends StatefulWidget {
  const StartButton({super.key});

  @override
  State<StartButton> createState() => _StartButtonState();
}

class _StartButtonState extends State<StartButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.greenAccent.shade700,
        borderRadius: AppSizes.smallBorderRadius,
      ),
      child: UiButton(
        onTap: () {
          
        },
        borderRadius: AppSizes.smallBorderRadius,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text("Start now", style: Theme.of(context).textTheme.bodyMedium,),
        ),
      ),
    );
  }
}

class SaveAndPlayLaterButton extends StatefulWidget {
  const SaveAndPlayLaterButton({super.key});

  @override
  State<SaveAndPlayLaterButton> createState() => _SaveAndPlayLaterButtonState();
}

class _SaveAndPlayLaterButtonState extends State<SaveAndPlayLaterButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.context(context).contentBoxColor.withAlpha(120),
        borderRadius: AppSizes.smallBorderRadius,
      ),
      child: UiButton(
        onTap: () {
          
        },
        borderRadius: AppSizes.smallBorderRadius,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text("Play later", style: Theme.of(context).textTheme.bodyMedium,),
        ),
      ),
    );
  }
}


class GameTeams extends StatefulWidget {
  const GameTeams({super.key});

  @override
  State<GameTeams> createState() => _GameTeamsState();
}

class _GameTeamsState extends State<GameTeams> {
  Team? _firstTeam, _secondTeam;
  @override
  Widget build(BuildContext context) {
    double containerHeight = 130;
    return LayoutBuilder(
      builder: (context, constraints) {
        return SizedBox(height: 130, child: _teamTile(null));
        // return Table(
        //   columnWidths: {0: FlexColumnWidth(.45), 1: FlexColumnWidth(.1), 2: FlexColumnWidth(.45),},
        //   children: [
        //     TableRow(
        //       children: [
        //         SizedBox(height: containerHeight, child: _teamTile(_firstTeam)),
        //         SizedBox(height: containerHeight, child: Center(child: Text("VS", style: Theme.of(context).textTheme.titleMedium,))),
        //         SizedBox(height: containerHeight, child: _teamTile(_secondTeam))
        //       ]
        //     )
        //   ],
        // );
      },
    );
  }

  Widget _teamTile(Team? team) {
    
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          height: constraints.maxHeight,
          width: constraints.maxWidth,
          decoration: BoxDecoration(
            color: AppColors.context(context).contentBoxColor,
            border: team == null ? Border.all(color: Colors.greenAccent, width: 2) : null,
            borderRadius: AppSizes.mediumBorderRadius
          ),
          child: team == null ? 
            UiButton(
              borderRadius: AppSizes.mediumBorderRadius, 
              onTap: (){
                Navigator.push(
                  context, 
                  SmoothPageTransition().rightToLeft(
                    secondScreen: SideBySideTeamSelection.call(
                       teams: [], 
                       onDone:(selectedTeams) {
                         _firstTeam = selectedTeams.first;
                         _secondTeam = selectedTeams.last;
                       },
                    )
                  )
                );
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.touch_app),
                  Padding(
                    padding: const EdgeInsets.only(left: 6.0),
                    child: Text('Tap to select a teams'),
                  ),
                ],
              )
            )
            :
            UiButton(
              borderRadius: AppSizes.mediumBorderRadius, 
              onTap: (){
          
              },
              child: ShowRectImage(
                fromLocalDb: true,
                height: constraints.maxHeight,
                width: constraints.maxWidth,
                imageUrl: team.localDbImageUrl, 
                borderRadiusVal: AppSizes.mediumBorderRadius.bottomLeft.x
              )
            )
        );
      },
    );
  }
}


class PrimarySettings extends StatefulWidget {
  const PrimarySettings({super.key});

  @override
  State<PrimarySettings> createState() => _PrimarySettingsState();
}

class _PrimarySettingsState extends State<PrimarySettings> {

  List<DropdownMenuItem<int>> _maxPlayersOptions = [];
  List<DropdownMenuItem<int>> _overOptions = [];

  int _selectedMaxPlayer = 9, _selectedOver = 8;

  _populateOptions() {

    // maxPlayersOptions 1 to 15
    for(int i=1; i<=15; i++) {
      _maxPlayersOptions.add(DropdownMenuItem(value: i, child: Text(i.toString())));
    }

    // overOptions 1 to 15
    for(int i=1; i<=15; i++) {
      _overOptions.add(DropdownMenuItem(value: i, child: Text(i.toString())));
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    _populateOptions();
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          children: [
            _maxPlayer(),
            _overs()
          ],
        );
      },
    );
  }

  Widget _maxPlayer(){
    return LayoutBuilder(
      builder: (context, constraints) {
        return Row(
          children: [
            Text("Max players:"),
            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: DropdownButton(
                items: _maxPlayersOptions, 
                onChanged:(value) {
                  if(value != null) {
                    _selectedMaxPlayer = value;
                    setState(() {
                      
                    });
                  }
                },
                hint: Center(child: Text(_selectedMaxPlayer.toString(), style: Theme.of(context).textTheme.labelMedium,))
                
              ),
            )
          ],
        );
      },
    );
  }

  Widget _overs(){
    return LayoutBuilder(
      builder: (context, constraints) {
        return Row(
          children: [
            Text("Over per innings:"),
            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: DropdownButton(
                items: _overOptions, 
                // selectedItemBuilder: (context) {
                //   return 
                // },
                hint: Center(child: Text(_selectedOver.toString(), style: Theme.of(context).textTheme.labelMedium)),
                onChanged:(value) {
                  if(value != null) {
                    _selectedOver = value;
                    setState(() {
                      
                    });
                  }
                },
              ),
            )
          ],
        );
      },
    );
  }
}