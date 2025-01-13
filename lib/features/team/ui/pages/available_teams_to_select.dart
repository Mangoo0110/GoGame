import 'package:flutter/material.dart';

import '../../../../core/utils/constants/app_colors.dart';
import '../../../image/ui/widgets/show_round_image.dart';
import '../../domain/entities/team.dart';

class AvailableTeamsToSelect extends StatefulWidget {
  final List<Team> availableTeamsToChooseFrom;
  final Function(Team selectedTeam) onSelect;
  const AvailableTeamsToSelect({super.key, required this.onSelect, required this.availableTeamsToChooseFrom});

  @override
  State<AvailableTeamsToSelect> createState() => _AvailableTeamsToSelectState();
}

class _AvailableTeamsToSelectState extends State<AvailableTeamsToSelect> {
  

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final teams =  widget.availableTeamsToChooseFrom;
        return Scaffold(
          appBar: AppBar(
            title: Text("Available teams to select from", maxLines: 2,),
            
          ),
          body: ListView.builder(
            itemCount: teams.length,
            itemBuilder: (context, index) {
              final team = teams[index];
              return Padding(
                padding: const EdgeInsets.all(2.0),
                child: ListTile(
                  tileColor: AppColors.context(context).contentBoxColor,
                  onTap: () {
                    widget.onSelect(team);
                  },
                  leading: ShowRoundImage(
                    key: Key(team.id),
                    imageUrl: team.localDbImageUrl,
                    radius: 45,
                    fromLocalDb: true,
                  ),
                  title: Text(team.name),
                ),
              ); 
            },
          ),
        );
      },
    );
  }
}