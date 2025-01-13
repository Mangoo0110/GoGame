

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/utils/constants/app_colors.dart';
import '../providers/edit_team_provider.dart';

class TeamNameTextfield extends StatelessWidget {

  TeamNameTextfield({
    super.key, 
    });


  final FocusNode _focusNode = FocusNode(); 
  final TextEditingController _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _nameController.text = context.read<EditTeamProvider>().teamName;
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
              context.read<EditTeamProvider>().updateTeamName('');
            },
          ),
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          alignLabelWithHint: false,
          constraints: BoxConstraints(minHeight: constraints.maxHeight),
          hintText: 'Enter team name...',
          labelText: 'Team name',
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
          context.read<EditTeamProvider>().updateTeamName(value);
        },
      ),
    );
  }
}