import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/common/widgets/ui_button.dart';
import '../../../../core/utils/constants/app_colors.dart';
import '../../../../core/utils/constants/app_sizes.dart';
import '../../../../core/utils/enums/common_enums.dart';
import '../../../../core/utils/enums/team_types.dart';

import '../../../../core/utils/func/dekhao.dart';
import '../../../image/ui/widgets/upload_image_widget_2.dart';
import '../../domain/entities/team.dart';
import '../providers/edit_team_provider.dart';
import '../widgets/edit_team_name_textfield.dart';
import '../widgets/edit_team_player_list.dart';

part '../widgets/edit_team_button.dart';

class EditTeamScreen extends StatefulWidget {
  final Team? team;
  final TeamType teamType;
  final bool showDeleteButton;
  // final Future<bool> Function(EditTeamProvider editTeamProvider, BuildContext pageContext) onDeletePress; 
  // /// #### Callback function that provides enough data to save the modified team data with the [`EditTeamProvider`] provider.
  // ///
  // /// Use the [`afterEdit`] team object that is provided by this [`afterEditDone`] function to save new or modified team data, not the team provided in the constructor.
  // final Future<bool> Function(Team afterEdit, Uint8List? newTeamImageToSave, EditTeamProvider editTeamProvider, BuildContext pageContext) afterEditDone; 
  const EditTeamScreen({
    super.key, 
    required this.team, 
    required this.teamType, 
    this.showDeleteButton = true,
    // required this.afterEditDone, 
    // required this.onDeletePress,
  });

  @override
  State<EditTeamScreen> createState() => _EditTeamScreenState();
}

class _EditTeamScreenState extends State<EditTeamScreen> {
  final ScrollController _scrollController = ScrollController();

  Timer? _scrollTimer;

  void _startAutoScroll(double dy) {
    const scrollStep = 10.0;
    const scrollThreshold = 100.0;
    const scrollDuration = Duration(milliseconds: 20);

    final screenHeight = MediaQuery.of(context).size.height;

    if (dy < scrollThreshold) {
      _startScrolling(-scrollStep, scrollDuration);
    } else if (dy > screenHeight - scrollThreshold) {
      _startScrolling(scrollStep, scrollDuration);
    } else {
      _stopScrolling();
    }
  }

  void _startScrolling(double step, Duration duration) {
    _stopScrolling(); // Stop any existing timer

    _scrollTimer = Timer.periodic(duration, (timer) {
      final newOffset = (_scrollController.offset + step).clamp(
        0.0,
        _scrollController.position.maxScrollExtent,
      );
      _scrollController.jumpTo(newOffset);
    });
  }

  void _stopScrolling() {
    _scrollTimer?.cancel();
    _scrollTimer = null;
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<EditTeamProvider>(
      create: (context) => EditTeamProvider(team: widget.team, teamType: widget.teamType),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: AppColors.context(context).contentBoxColor,
            appBar: AppBar(
              leading: CloseButton(
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              actions: [
                
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.only(left: 18.0, right: 8),
              child: SingleChildScrollView(
                controller: _scrollController,
                child: Column(
                  // mainAxisSize: MainAxisSize.min,
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 1.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(widget.team == null ? "Create team" : "Edit team", style: Theme.of(context).textTheme.titleLarge?.copyWith(fontStyle: FontStyle.italic),),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text("* Indicates required", style: Theme.of(context).textTheme.labelMedium?.copyWith(fontStyle: FontStyle.italic),),
                                  const SizedBox(
                                    height: 40,
                                  ),
                                ],
                              ),
                              
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: _TeamModifyButtons(
                                  
                                  onDeletePress:() async{
                                    final provider = Provider.of<EditTeamProvider>(context, listen: false);
                                    return await provider.deleteTeam(widget.team!, provider);
                                  },
                                  
                                  onSavePress: () async{
                                    final provider = Provider.of<EditTeamProvider>(context, listen: false);
                                    return await provider.saveTeam(newteamImage: provider.newTeamImage, editTeamProvider: provider, team: provider.modifiedTeam,).then((res) {
                                      if(res != null) {
                                        return true;
                                      }
                                      return false;
                                    });
                                  },
                                  
                                  showDeleteButton: widget.showDeleteButton,
                                  
                                ),
                              )
                            ],
                          ),
                        ),
                                  
                        /// team picture
                        SizedBox(
                          height: 140,
                          width: 140,
                          child: UploadImage(
                            onPick: (pickedImage) {
                              context.read<EditTeamProvider>().updateTeamImage(pickedImage);
                            },
                            radius: 140,
                            imageUrl: widget.team?.localDbImageUrl,
                            fromLocalDb: true,
                          ),
                        ),
                                  
                                  
                        /// Gap of 20
                        SizedBox(height: 35),
                                  
                                  
                        /// team name input
                        SizedBox(
                          height: 100,
                          width: double.infinity,
                          child: TeamNameTextfield(),
                        )
                      ],
                    ),
                
                    EditTeamPlayerListWidget(
                      onPointerMove: (details) {
                        _startAutoScroll(details.position.dy);
                      },
                      onPointerUp: () {
                        _stopScrolling();
                      },
                      onPointerCancel: () {
                        _stopScrolling();
                      },
                    )
                  ],
                ),
              ),
            ),
          );
        }
      ),
    );
  }
}




