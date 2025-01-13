
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:gogame/app.dart';
import 'package:provider/provider.dart';
import '../../../../core/common/widgets/text_widgets.dart';
import '../../../../core/utils/constants/app_colors.dart';

import '../providers/login_provider.dart';

class LoginButtonWidget extends StatefulWidget {
  const LoginButtonWidget({super.key});

  @override
  State<LoginButtonWidget> createState() => _LoginButtonWidgetState();
}

class _LoginButtonWidgetState extends State<LoginButtonWidget> {
  bool canLogin = false;

  @override
  Widget build(BuildContext context) {
    canLogin =  context.watch<LoginProvider>().canRegister;
    return LayoutBuilder(
      builder: (context, constraints) {
        return InkWell(
          onTap: () async{
            if(canLogin) {
              await context.read<LoginProvider>()
              .loginBang(
                onDone: () {
                  Navigator.of(context)
                    .pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>const AppInitialScreen()), (route) => false);
                },
              );
            }
            
          },
          child: Container(
            height: 60,
            width: min(550, constraints.maxWidth),
            decoration: BoxDecoration(
              color: (canLogin) ? AppColors.context(context).accentColor : AppColors.context(context).accentColor.withOpacity(.2),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Center(
              child: TextWidgets(context).buttonTextHigh(
                buttonText: "Login", 
                textColor: (canLogin) ? AppColors.context(context).textColor: AppColors.context(context).textColor.withOpacity(.3)
              )
            ),
          )
        
        );
      },
    );
  }


}