
import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


import '../../../../core/common/textfields/email_textfield.dart';
import '../../../../core/common/textfields/password_textfield.dart';
import '../../../../core/utils/constants/app_colors.dart';
import '../widgets/app_title_widget.dart';
import 'signin.dart';
import '../providers/register_provider.dart';
import '../widgets/register_button.dart';



class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {

  bool canOnboard = false;
  final GlobalKey<FormState>  _signUpFormKey = GlobalKey<FormState>();

  final TextEditingController _userEmailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  final TextEditingController _confirmPasswordController = TextEditingController();

    Uint8List? _pickedImage;

  final TextEditingController _nameController = TextEditingController();
  
  final FocusNode _nameFocus = FocusNode();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => RegisterProvider(),
      child: LayoutBuilder(
        builder:(context, constraints) => SafeArea(
          child: Scaffold(
            backgroundColor: AppColors.context(context).backgroundColor,
            body: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  //crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const GradientTextAnimation(),
                    const SizedBox(height: 60),
                    
                    // image section
                
                    // Container(
                    //   height: 160,
                    //   width: double.infinity,
                    //   decoration: BoxDecoration(
                    //     color: AppColors.context(context).backgroundColor,
                    //     border: Border.all(color: AppColors.context(context).backgroundColor, width: .8),
                    //     borderRadius: BorderRadius.circular(8),
                    //     boxShadow: const [
                    //       BoxShadow(color: Color(0x1F000000), blurRadius: 5)
                    //     ]
                    //   ),
                    //   child: const Padding(
                    //     padding: EdgeInsets.all(8.0),
                    //     child: InputImageWidget(),
                    //   ),
                    // ),

                    const SizedBox(height: 10,),
                                
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
                          context.read<RegisterProvider>().setEmail(value);
                        },
                        validationCheck: (text) {
                          return RegExp(
                            r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
                          ).hasMatch(text) ? null : 'Not a valid email';
                          
                        },
                    )),
                    
                    const SizedBox(height: 0),

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
                          context.read<RegisterProvider>().setPassword(value);
                        },
                        validationCheck: (text) {
                          return RegExp(
                            r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*#?&])[A-Za-z\d@$!%*#?&]{8,}$',
                          ).hasMatch(text) ? null : 'At least 8 characters and one special character.';
                        },
                      ),
                    ),
                    
                    const SizedBox(height: 0),

                    Container(
                      height: 75,
                      width: min(550, constraints.maxWidth),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10)
                      ),
                      child: PasswordTextfield(
                        maxLines: 1,
                        controller: _confirmPasswordController,
                        hintText: "453dftaker44@",
                        labelText: "Confirm password",
                        onChanged: (value) {
                          context.read<RegisterProvider>().setConfirmPassword(value);
                        },
                        validationCheck: (text) {
                          return RegExp(
                            r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*#?&])[A-Za-z\d@$!%*#?&]{8,}$',
                          ).hasMatch(text) ? null : 'At least 8 characters and one special character.';
                        },
                      ),
                    ),

                    const SizedBox(height: 0),
                    
                    const RegisterButtonWidget(),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const SignInView()));
                        // Perform signup or password recovery here
                      },
                      child: Text('Already have an account! Login here', style: Theme.of(context).textTheme.bodyMedium,),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
  

}