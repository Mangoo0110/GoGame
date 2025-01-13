import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gogame/app.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import 'core/utils/constants/app_names.dart';
import 'core/utils/themes/theme.dart';
import 'features/image/ui/providers/image_read_provider.dart';
import 'features/image/ui/providers/image_write_provider.dart';
import 'features/players/ui/providers/player_data_provider.dart';
import 'features/team/ui/providers/team_data_provider.dart';
import 'init_dependency.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  List<ChangeNotifierProvider> providers = [
    ChangeNotifierProvider<ImageReadProvider>(create: (context)=> ImageReadProvider()),
    ChangeNotifierProvider<ImageWriteProvider>(create: (context)=> ImageWriteProvider()),
    ChangeNotifierProvider<PlayerDataProvider>(create: (context)=> PlayerDataProvider()),
  ];
  
  await getApplicationDocumentsDirectory().then((docDir)  async{
    Hive.init(docDir.path);

    await initDependencies().then((value) async{
      Animate.restartOnHotReload = true;
      runApp(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<ImageReadProvider>(create: (context)=> ImageReadProvider()),
            ChangeNotifierProvider<ImageWriteProvider>(create: (context)=> ImageWriteProvider()),
            ChangeNotifierProvider<PlayerDataProvider>(create: (context)=> PlayerDataProvider(),),
            ChangeNotifierProvider<TeamDataProvider>(create: (context)=> TeamDataProvider(),),
          ],
          child: (const MyApp()),
        ));
    });
    
  });
  
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppNames.nameOfTheApp,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: const AppInitialScreen()
    );
  }
}

 