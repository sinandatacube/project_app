// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:projects/cubit/authentication/authenication_cubit.dart';
// import 'package:projects/cubit/media/media_cubit.dart';
// import 'package:projects/cubit/project/project_cubit.dart';
// import 'package:projects/screens/splash/splash_screen.dart';

// GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MultiBlocProvider(
//       providers: [
//         BlocProvider(create: (context) => AuthenicationCubit()),
//         BlocProvider(create: (context) => ProjectCubit()),
//         BlocProvider(create: (context) => MediaCubit()),
//       ],
//       child: MaterialApp(
//         navigatorKey: navigatorKey,
//         showSemanticsDebugger: false,
//         title: 'Flutter Demo',
//         theme: ThemeData(
//           appBarTheme: AppBarTheme(
//             backgroundColor: Colors.black,
//             foregroundColor: Colors.white,
//           ),
//           scaffoldBackgroundColor: Colors.white,
//           dialogBackgroundColor: Colors.white,
//           elevatedButtonTheme: ElevatedButtonThemeData(
//             style: ButtonStyle(
//               backgroundColor: WidgetStateProperty.all(Colors.black),
//               foregroundColor: WidgetStateProperty.all(Colors.white),
//             ),
//           ),

//           colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
//         ),
//         home: SplashScreen(),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projects/core/theme/app_theme.dart';
import 'package:projects/cubit/authentication/authenication_cubit.dart';
import 'package:projects/cubit/media/media_cubit.dart';
import 'package:projects/cubit/project/project_cubit.dart';
import 'package:projects/screens/splash/splash_screen.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AuthenicationCubit()),
        BlocProvider(create: (_) => ProjectCubit()),
        BlocProvider(create: (_) => MediaCubit()),
      ],
      child: MaterialApp(
        navigatorKey: navigatorKey,
        title: 'ProjectX',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const SplashScreen(),
      ),
    );
  }
}
