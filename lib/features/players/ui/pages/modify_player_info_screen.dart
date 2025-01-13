import 'package:flutter/material.dart';
import 'package:gogame/features/players/ui/providers/modify_player_state_provider.dart';
import 'package:provider/provider.dart';
import '../../../../core/utils/constants/app_colors.dart';
import '../../../../core/utils/enums/common_enums.dart';
import '../../../../core/utils/func/dekhao.dart';
import '../../../../core/utils/uuid_service/firebase_uid.dart';

import '../../../../core/common/widgets/ui_button.dart';
import '../../../../core/utils/constants/app_sizes.dart';
import '../../../image/ui/widgets/upload_image_widget_2.dart';
import '../../domain/entities/local_player.dart';

class ModifyPlayerInfoScreen extends StatelessWidget {
  final LocalPlayer? player;
  const ModifyPlayerInfoScreen({super.key, required this.player});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ModifyPlayerStateProvider>(
      create: (context) => ModifyPlayerStateProvider(player: player),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Scaffold(
            backgroundColor: AppColors.context(context).contentBoxColor,
            appBar: AppBar(
              leading: CloseButton(
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.only(left: 18.0, right: 8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 1.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                Text(player == null ? "Create player" : "Edit player", style: Theme.of(context).textTheme.titleLarge?.copyWith(fontStyle: FontStyle.italic),),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text("* Indicates required", style: Theme.of(context).textTheme.labelMedium?.copyWith(fontStyle: FontStyle.italic),),
                                const SizedBox(
                                  height: 40,
                                ),
                              ],
                            ),
                            if(player != null) Container(
                              decoration: BoxDecoration(
                                color: AppColors.context(context).backgroundColor,
                                borderRadius: AppSizes.smallBorderRadius,
                              ),
                              child: UiButton(
                                borderRadius: AppSizes.smallBorderRadius,
                                onTap: () async{
                                  await context.read<ModifyPlayerStateProvider>().deletePlayer();
                                },

                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      Icon(Icons.delete, color: Colors.red.shade200,),
                                      SizedBox(width: AppSizes.smallPadding,),
                                      Text("Delete")
                                    ],
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),

                      /// Player picture
                      SizedBox(
                        height: 140,
                        width: 140,
                        child: UploadImage(
                          onPick: (pickedImage) {
                            context.read<ModifyPlayerStateProvider>().updatePlayerImage(pickedImage);
                          },
                          radius: 140,
                          imageUrl: player?.localDbImageUrl,
                          fromLocalDb: true,
                        ),
                      ),
              
              
                      /// Gap of 20
                      SizedBox(height: 35),
              
              
                      /// Player name input
                      SizedBox(
                        height: 100,
                        width: double.infinity,
                        child: PlayerNameTextfield(),
                      )
                    ],
                  ),
                  
                  /// 
                  /// Done button at bottom
                  /// 
                  ModifyPlayerDoneButton()
                ],
              ),
            ),
          );
        }
      ),
    );
  }

}


class ModifyPlayerDoneButton extends StatefulWidget {
  const ModifyPlayerDoneButton({super.key});

  @override
  State<ModifyPlayerDoneButton> createState() => _ModifyPlayerDoneButtonState();
}

class _ModifyPlayerDoneButtonState extends State<ModifyPlayerDoneButton> {

  void _watchModifyStatus(){
    saveStatus = context.watch<ModifyPlayerStateProvider>().saveStatus;
    deleteStatus = context.watch<ModifyPlayerStateProvider>().deleteStatus;
    if(saveStatus == SaveStatus.saved || deleteStatus == DeleteStatus.deleted){
      Future.delayed(Duration(seconds: 1), (){
        if(mounted) Navigator.pop(context);
      });
    }
  }


  SaveStatus saveStatus = SaveStatus.canNotSave;
  DeleteStatus deleteStatus = DeleteStatus.canNotDelete;

  Color _buttonContainerColor() {
    return Colors.transparent;
  }

  Color _buttonBorderColor() {
    return saveStatus == SaveStatus.canNotSave ?
      AppColors.context(context).contentBoxGreyColor
      :
      saveStatus == SaveStatus.failed ?
      AppColors.context(context).errorColor
      :
      AppColors.context(context).accentColor;
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    _watchModifyStatus();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    saveStatus = context.watch<ModifyPlayerStateProvider>().saveStatus;
    dekhao(saveStatus.name.toString());
    return LayoutBuilder(
      builder: (context, constraints) {
        return AnimatedContainer(
          duration: Duration(milliseconds: 300),
          height: 55,
          width: constraints.maxWidth,
          decoration: BoxDecoration(
            color: _buttonContainerColor(),
            borderRadius: AppSizes.largeBorderRadius,
            border: Border.all(color: _buttonBorderColor(), width: 2)
          ),
          child: UiButton(
            borderRadius: AppSizes.largeBorderRadius,
            tappable: saveStatus == SaveStatus.canSave,
            onTap: () {
              context.read<ModifyPlayerStateProvider>().savePlayer();
            },
            child: 
              Center(
                child: saveStatus == SaveStatus.canNotSave ?
                _idle()
                :
                saveStatus == SaveStatus.canSave ?
                _saveStatus()
                :
                saveStatus == SaveStatus.saving ?
                _saving()
                : 
                saveStatus == SaveStatus.failed?
                _error()
                :
                _saved()
              ),
          ),
        );
      },
    );
  }

  Widget _saving() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox( height: 25, width: 25, child: CircularProgressIndicator(strokeWidth: 3,)),
            SizedBox(width: 5,),
            Text("Processing", style: Theme.of(context).textTheme.titleSmall)
          ],
        );
      },
    );
  }

  Widget _saveStatus() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Text(
          "Save", 
          style: Theme.of(context).textTheme.titleMedium);
      },
    );
  }

  Widget _idle() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Text(
          "Save", 
          style: Theme.of(context).textTheme.titleMedium
            ?.copyWith(color: AppColors.context(context).textGreyColor));
      },
    );
  }

  Widget _saved() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.done),
            SizedBox(width: 5,),
            Text("Saved", style: Theme.of(context).textTheme.titleMedium)
          ],
        );
      },
    );
  }

  Widget _error() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error, color: Colors.yellow,),
            SizedBox(width: 5,),
            Text("Error", style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.yellow), )
          ],
        );
      },
    );
  }

}


class PlayerNameTextfield extends StatelessWidget {

  PlayerNameTextfield({
    super.key, 
    });


  final FocusNode _focusNode = FocusNode(); 
  final TextEditingController _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _nameController.text = context.read<ModifyPlayerStateProvider>().playerName;
    return LayoutBuilder(
      builder: (context, constraints) => TextFormField(
        onTapOutside: (event){
          _focusNode.unfocus();
        },
        focusNode: _focusNode,
        maxLines: 1,
        controller: _nameController,
        style: Theme.of(context).textTheme.bodyMedium,
        decoration: InputDecoration(
          suffixIcon: IconButton(
            icon: Icon(Icons.clear),
            onPressed: () {
              _nameController.clear();
              context.read<ModifyPlayerStateProvider>().updatePlayerName('');
            },
          ),
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          alignLabelWithHint: false,
          constraints: BoxConstraints(minHeight: constraints.maxHeight),
          hintText: 'Enter player name...',
          labelText: 'Player name',
          hintStyle: const TextStyle(color: Colors.grey),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.context(context).contentBoxGreyColor),
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.context(context).contentBoxGreyColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.context(context).accentColor),
          ),
        ),
        onChanged: (value) {
          context.read<ModifyPlayerStateProvider>().updatePlayerName(value);
        },
      ),
    );
  }
}
