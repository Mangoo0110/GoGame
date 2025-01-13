import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/common/widgets/text_widgets.dart';
import '../../../../core/utils/constants/app_colors.dart';

import '../providers/register_provider.dart';

class RegisterButtonWidget extends StatefulWidget {
  const RegisterButtonWidget({super.key});

  @override
  State<RegisterButtonWidget> createState() => _RegisterButtonWidgetState();
}

class _RegisterButtonWidgetState extends State<RegisterButtonWidget> {
  bool canRegister = false;

  @override
  Widget build(BuildContext context) {
    canRegister =  context.watch<RegisterProvider>().canRegister;
    return LayoutBuilder(
      builder: (context, constraints) {
        return InkWell(
          onTap: () async{

            if(canRegister) {
              await context.read<RegisterProvider>()
              .registerBang(
                onDone: () {
                  // if(context.read<A>().currentStore == null) return;
                  // Navigator.of(context)
                  //   .pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>const Dashboard()), (route) => false);
                },
              );
            }
            
          },
          child: Container(
            height: 60,
            width: min(550, constraints.maxWidth),
            decoration: BoxDecoration(
              color: (canRegister) ? AppColors.context(context).accentColor : AppColors.context(context).accentColor.withOpacity(.2),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Center(
              child: TextWidgets(context).buttonTextHigh(
                buttonText: "Register", 
                textColor: (canRegister) ? AppColors.context(context).textColor: AppColors.context(context).textColor.withOpacity(.3)
              )
            ),
          )
        
        );
      },
    );
  }


}