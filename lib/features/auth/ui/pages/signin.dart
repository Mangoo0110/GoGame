import 'dart:math';


import 'package:gogame/app.dart';

import 'signup.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/common/textfields/email_textfield.dart';
import '../../../../core/common/textfields/password_textfield.dart';
import '../../../../core/utils/constants/app_colors.dart';
import '../providers/auth_provider.dart';
import '../providers/login_provider.dart';
import '../widgets/app_title_widget.dart';
import '../widgets/login_button.dart';


class SignInView extends StatefulWidget {
   const SignInView({super.key});

  @override
  State<SignInView> createState() => _SignInViewState();
}

class _SignInViewState extends State<SignInView> {
  final _signInFormKey = GlobalKey<FormState>();

  final TextEditingController _userEmailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  //final TextEditingController _confirmPasswordController = TextEditingController();

  // focusnodes
  // late FocusNode _emailFocusNode, _passwordFocusNode, _confirmPasswordFocusNode;

  @override
  void initState() {
    // TODO: implement initState
    // _emailFocusNode = FocusNode();
    // _passwordFocusNode = FocusNode();
    // _confirmPasswordFocusNode = FocusNode();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create:(context) => LoginProvider(),
      child: LayoutBuilder(
        builder:(context,constraints) => GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Scaffold(
            backgroundColor: AppColors.context(context).backgroundColor,
            body: Center(
              child: SingleChildScrollView(
                keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _signInFormKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    //crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const GradientTextAnimation(),
                      // ShaderMask(
                      //   shaderCallback: (Rect bounds) {
                      //     return LinearGradient(
                      //       colors: [AppColors.context(context).accentColor , Colors.white],
                      //     ).createShader(bounds);
                      //   },
                      //   blendMode: BlendMode.srcATop,
                      //   child: Text(AppNames.nameOfTheApp, style: Theme.of(context).textTheme.headlineMedium,)
                      // ),
                      const SizedBox(height: 60),
                      Container(
                      height: 75,
                      width: min(550, constraints.maxWidth),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10)
                      ),
                      child: EmailTextfield(
                        maxLines: 1,
                        controller: _userEmailController,
                        hintText: "your@example.com",
                        labelText: "Email",
                        onChanged: (value) {
                          context.read<LoginProvider>().setEmail(value);
                        },
                        validationCheck: (text) {
                          return RegExp(
                            r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
                          ).hasMatch(text) ? null : 'Not a valid email';
                          
                        },
                    )),
                    
                    const SizedBox(height: 12),

                    Container(
                      height: 75,
                      width: min(550, constraints.maxWidth),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10)
                      ),
                      child: PasswordTextfield(
                        maxLines: 1,
                        controller: _passwordController,
                        hintText: "453dftaker44@",
                        labelText: "Password",
                        onChanged: (value) {
                          context.read<LoginProvider>().setPassword(value);
                        },
                        validationCheck: (text) {
                          return null;
                        },
                    ),
                    ),
                    
                      const SizedBox(height: 0),
                      const LoginButtonWidget(),
                      
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const SignUpView()));
                        },
                        child: Text('Dont have an account? SignUp here.', style: Theme.of(context).textTheme.bodyMedium,),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> signIn() async{
    await context.read<UserAuthProvider>()
      .signIn(email: _userEmailController.text.trim(), password: _passwordController.text.trim())
      .then((value) {
        if(mounted && context.read<UserAuthProvider>().isUserSignedIn()){
          Navigator.of(context)
          .pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>const AppInitialScreen()), (route) => false);
        }
      }
    );
  }
}