

// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// import '../../../../core/common/widgets/ui_button.dart';
// import '../../../../core/utils/constants/app_colors.dart';
// import '../../../../core/utils/constants/app_sizes.dart';
// import '../../../../core/utils/enums/common_enums.dart';
// import '../../../../core/utils/func/dekhao.dart';
// import '../providers/edit_team_provider.dart';

part of '../pages/edit_team_screen.dart';

class _TeamModifyButtons extends StatefulWidget {
  final bool showDeleteButton;
  final Future<bool> Function() onDeletePress; 
  final Future<bool> Function() onSavePress; 
  const _TeamModifyButtons({super.key, required this.onDeletePress, required this.onSavePress, required this.showDeleteButton});

  @override
  State<_TeamModifyButtons> createState() => _TeamModifyButtonsState();
}

class _TeamModifyButtonsState extends State<_TeamModifyButtons> {

  void _watchModifyStatus(){
    saveStatus = context.watch<EditTeamProvider>().saveStatus;
    deleteStatus = context.watch<EditTeamProvider>().deleteStatus;
    if(saveStatus == SaveStatus.saved || deleteStatus == DeleteStatus.deleted){
      Future.delayed(Duration(seconds: 1), (){
        if(mounted) Navigator.pop(context);
      });
    }
  }

  void _deleteWork(BuildContext context) async{
    final provider = Provider.of<EditTeamProvider>(context);
      await widget.onDeletePress().then((res) {
        if(res) {

        }
      });
  }

  void _saveWork(BuildContext context) async{
    await widget.onSavePress().then((res) {
      if(res) {
        
      }
    });
  }


  SaveStatus saveStatus = SaveStatus.canNotSave;
  DeleteStatus deleteStatus = DeleteStatus.canNotDelete;

  Color _buttonContainerColor() {
    return saveStatus == SaveStatus.saving ?
      Colors.green
      :
      
      deleteStatus == DeleteStatus.deleting ?
      Colors.red
      :

      Colors.transparent;
  }

  Color _buttonBorderColor() {
    return Colors.transparent;
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    _watchModifyStatus();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    saveStatus = context.watch<EditTeamProvider>().saveStatus;
    dekhao("state is ${saveStatus.name.toString()}");
    return LayoutBuilder(
      builder: (context, constraints) {
        return Center(
          child: 
          saveStatus == SaveStatus.saved || deleteStatus == DeleteStatus.deleted ?
          _processed()
          :
        
          saveStatus == SaveStatus.saving || deleteStatus == DeleteStatus.deleting?
          _processing()
          : 
        
          saveStatus == SaveStatus.failed || deleteStatus == DeleteStatus.failed?
          Row(
            children: [
              if(saveStatus == SaveStatus.failed) 
                _saveError(),
              
              SizedBox(width: 10,),
              
              if(deleteStatus == DeleteStatus.failed && widget.showDeleteButton == true) 
                _deleteError(),
            ],
          )
          :
          
          Row(
            children: [
              saveStatus == SaveStatus.canNotSave ? 
              _saveIdle() 
              
              :
              UiButton(
                borderRadius: AppSizes.smallBorderRadius,
                onTap: () async{
                  widget.onSavePress();
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child:  _canSave(),
                )
              ),
              
              SizedBox(width: 10,),

              if(deleteStatus == DeleteStatus.canDelete && widget.showDeleteButton == true) 
                UiButton(
                  borderRadius: AppSizes.smallBorderRadius,
                  onTap: () async{
                    widget.onDeletePress();
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: _canDelete(),
                  )
                ),
            ],
          )
        );
      },
    );
  }

  Widget _processing() {
    return LayoutBuilder(
      builder: (context, constraints) {
        if(deleteStatus == DeleteStatus.deleting) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox( height: 25, width: 25, child: CircularProgressIndicator(strokeWidth: 3,)),
              SizedBox(width: 5,),
              Text("Saving", style: Theme.of(context).textTheme.titleSmall)
            ],
          );
        } else {
          if(widget.showDeleteButton == false) return Container();
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox( height: 25, width: 25, child: CircularProgressIndicator(strokeWidth: 3,)),
              SizedBox(width: 5,),
              Text("Deleting", style: Theme.of(context).textTheme.titleSmall)
            ],
          );
        }
        
      },
    );
  }

  Widget _canSave() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Icon(Icons.done, color: Colors.greenAccent, size: AppSizes.largeIconSize, weight: 4);
      },
    );
  }

  Widget _canDelete() {
    return LayoutBuilder(
      builder: (context, constraints) {
        if(widget.showDeleteButton == false) return Container();
        return Icon(Icons.delete_rounded, color: Colors.red, size: AppSizes.largeIconSize, weight: 4,);
      },
    );
  }

  Widget _saveIdle() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Row(
          children: [
            Icon(Icons.done, color: AppColors.context(context).textGreyColor, size: AppSizes.largeIconSize, weight: 4),
          ],
        );
      },
    );
  }

  Widget _deleteIdle() {
    return LayoutBuilder(
      builder: (context, constraints) {
        if(widget.showDeleteButton == false) return Container();
        return Row(
          children: [
            Icon(Icons.delete_rounded, color: AppColors.context(context).textGreyColor, size: AppSizes.largeIconSize, weight: 4),
          ],
        );
      },
    );
  }

  Widget _processed() {
    return LayoutBuilder(
      builder: (context, constraints) {
        if(saveStatus == SaveStatus.saved) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.done),
              SizedBox(width: 5,),
              Text("Saved", style: Theme.of(context).textTheme.titleMedium)
            ],
          ); 
        } else{
          if(widget.showDeleteButton == false) return Container();
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.done),
              SizedBox(width: 5,),
              Text("Deleted", style: Theme.of(context).textTheme.titleMedium)
            ],
          ); 
        }
      },
    );
  }

  Widget _saveError() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error, color: Colors.yellow,),
            SizedBox(width: 5,),
            Text("Save failed", style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.yellow), )
          ],
        );
      },
    );
  }

  Widget _deleteError() {
    return LayoutBuilder(
      builder: (context, constraints) {
        if(widget.showDeleteButton == false) return Container();
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error, color: Colors.yellow,),
            SizedBox(width: 5,),
            Text("Delete failed", style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.yellow), )
          ],
        );
      },
    );
  }

}