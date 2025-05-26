// import 'dart:developer';

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:loading_animation_widget/loading_animation_widget.dart';
// import 'package:projects/cubit/authentication/authenication_cubit.dart';
// import 'package:projects/cubit/project/project_cubit.dart';
// import 'package:projects/model/project_model.dart';
// import 'package:projects/my_app.dart';
// import 'package:projects/screens/authentication/login_screen.dart';
// import 'package:projects/screens/maps/project_locations_view.dart';
// import 'package:projects/screens/project/new_project_from.dart';
// import 'package:projects/screens/project/project_details.dart';
// import 'package:projects/utils/snackBar.dart';
// import 'package:projects/utils/text_field.dart';
// import 'package:projects/utils/toast.dart';

// class HomeScreen extends StatefulWidget {
//   HomeScreen({super.key});

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   AuthenicationCubit authCubit = AuthenicationCubit();

//   ProjectCubit projectCubit = ProjectCubit();

//   final TextEditingController _searchCtrl = TextEditingController();
//   @override
//   void initState() {
//     projectCubit.fetchAllProjects();
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final Size size = MediaQuery.sizeOf(context);
//     return Scaffold(
//       floatingActionButton: FloatingActionButton(
//         backgroundColor: Colors.black,
//         foregroundColor: Colors.white,
//         onPressed:
//             () => navigatorKey.currentState?.push(
//               MaterialPageRoute(builder: (_) => NewProjectFrom()),
//             ),
//         child: Icon(Icons.add),
//       ),
//       appBar: AppBar(
//         elevation: 0,
//         backgroundColor: Colors.black,
//         centerTitle: false,
//         title: const Text(
//           'Projects',
//           style: TextStyle(
//             fontSize: 24,
//             fontWeight: FontWeight.bold,
//             color: Colors.white,
//           ),
//         ),
//         actions: [
//           Container(
//             margin: const EdgeInsets.only(right: 16),
//             decoration: BoxDecoration(
//               color: Colors.grey[900],
//               borderRadius: BorderRadius.circular(12),
//             ),
//             child: IconButton(
//               onPressed: () => showLogoutDialog(context),
//               icon: const Icon(
//                 Icons.logout_rounded,
//                 color: Colors.white,
//                 size: 22,
//               ),
//               tooltip: 'Logout',
//             ),
//           ),
//         ],
//       ),

//       body: Padding(
//         padding: EdgeInsets.symmetric(
//           horizontal: size.width * 0.03,
//           vertical: size.height * 0.02,
//         ),
//         child: Column(
//           children: [
//             CustomTextField(
//               controller: _searchCtrl,
//               isNumber: false,
//               prefixIcon: Icons.search,
//               hintText: "Search here...",

//               onChanged: (val) {
//                 projectCubit.searchProjects(val);
//               },
//             ),

//             // SizedBox(height: 8),
//             BlocBuilder(
//               bloc: projectCubit,
//               builder: (context, state) {
//                 if (state is ProjectsLoaded) {
//                   return Column(
//                     children: [
//                       Row(
//                         children: [
//                           Container(
//                             margin: const EdgeInsets.only(right: 16),
//                             decoration: BoxDecoration(
//                               color: Colors.grey[900],
//                               borderRadius: BorderRadius.circular(12),
//                             ),
//                             child: IconButton(
//                               onPressed:
//                                   () => navigatorKey.currentState?.push(
//                                     MaterialPageRoute(
//                                       builder:
//                                           (_) => ProjectLocationsView(
//                                             projects: state.projects,
//                                           ),
//                                     ),
//                                   ),
//                               icon: const Icon(
//                                 Icons.map_outlined,
//                                 color: Colors.white,
//                                 size: 22,
//                               ),
//                               tooltip: 'Map view',
//                             ),
//                           ),
//                           Container(
//                             margin: const EdgeInsets.only(right: 16),
//                             decoration: BoxDecoration(
//                               color: Colors.grey[900],
//                               borderRadius: BorderRadius.circular(12),
//                             ),
//                             child: IconButton(
//                               onPressed: () {},
//                               icon: const Icon(
//                                 Icons.bar_chart_rounded,
//                                 color: Colors.white,
//                                 size: 22,
//                               ),
//                               tooltip: 'Charts',
//                             ),
//                           ),
//                         ],
//                       ),
//                       SizedBox(height: 12),

//                       ListView.separated(
//                         separatorBuilder:
//                             (context, index) => SizedBox(height: 12),
//                         shrinkWrap: true,
//                         // padding: EdgeInsets.symmetric(
//                         //   vertical: size.height * 0.01,
//                         // ),
//                         itemCount: state.projects.length,
//                         itemBuilder: (context, index) {
//                           ProjectModel current = state.projects[index];
//                           return Container(
//                             decoration: BoxDecoration(
//                               border: Border.all(color: Colors.grey.shade400),
//                               borderRadius: BorderRadius.circular(12),
//                             ),
//                             child: ListTile(
//                               onTap:
//                                   () => navigatorKey.currentState?.push(
//                                     MaterialPageRoute(
//                                       builder:
//                                           (_) => ProjectDetails(
//                                             projectId: current.projectId,
//                                             projectName: current.projectName,
//                                           ),
//                                     ),
//                                   ),
//                               title: Text(current.projectName),
//                               trailing: Icon(Icons.arrow_forward_ios),
//                             ),
//                           );
//                         },
//                       ),
//                     ],
//                   );
//                 }
//                 if (state is ProjectFailed) {
//                   return Center(child: Text(state.error));
//                 }
//                 return Center(
//                   child: CircularProgressIndicator(color: Colors.black),
//                 );
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   //*************************************************** */
//   Future<void> showLogoutDialog(BuildContext context) async {
//     return showDialog<void>(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text('Confirm Logout'),
//           content: const Text('Are you sure you want to log out?'),
//           actions: <Widget>[
//             TextButton(
//               child: const Text('No'),
//               onPressed: () {
//                 navigatorKey.currentState?.pop();
//               },
//             ),
//             BlocConsumer(
//               bloc: authCubit,
//               listener: (context, state) {
//                 if (state is AuthSuccess) {
//                   showToast(state.note, true);
//                   navigatorKey.currentState?.pop();
//                   navigatorKey.currentState?.pushAndRemoveUntil(
//                     MaterialPageRoute(builder: (_) => LoginScreen()),
//                     (route) => false,
//                   );
//                 }
//                 if (state is AuthFailed) {
//                   showToast(state.error, false);
//                 }
//               },
//               builder: (context, state) {
//                 return ElevatedButton(
//                   child:
//                       state is AuthLoading
//                           ? LoadingAnimationWidget.progressiveDots(
//                             size: 30,
//                             color: Colors.white,
//                           )
//                           : const Text('Yes'),
//                   onPressed: () async {
//                     authCubit.logout();
//                   },
//                 );
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import 'package:projects/cubit/authentication/authenication_cubit.dart';
import 'package:projects/cubit/project/project_cubit.dart';
import 'package:projects/model/project_model.dart';
import 'package:projects/my_app.dart';
import 'package:projects/screens/authentication/login_screen.dart';
import 'package:projects/screens/maps/project_locations_view.dart';
import 'package:projects/screens/project/new_project_from.dart';
import 'package:projects/screens/project/project_details.dart';
import 'package:projects/utils/snackBar.dart';
import 'package:projects/utils/text_field.dart';
import 'package:projects/utils/toast.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final AuthenicationCubit _authCubit = AuthenicationCubit();
  late final ProjectCubit _projectCubit = ProjectCubit();
  final TextEditingController _searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();

    _projectCubit.fetchAllProjects();
  }

  @override
  void dispose() {
    _authCubit.close();
    _projectCubit.close();
    _searchCtrl.dispose();
    super.dispose();
  }

  static const double _horizontalPadding = 16;
  static const double _borderRadius = 14;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.sizeOf(context);

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: theme.colorScheme.primary,
        onPressed:
            () => navigatorKey.currentState?.push(
              MaterialPageRoute(builder: (_) => NewProjectFrom()),
            ),
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: theme.colorScheme.primary,
        centerTitle: false,
        title: Text(
          'Projects',
          style: theme.textTheme.headlineSmall?.copyWith(
            color: theme.colorScheme.onPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: _horizontalPadding),
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(_borderRadius),
            ),
            child: IconButton(
              onPressed: () => _showLogoutDialog(context),
              icon: Icon(
                Icons.logout_rounded,
                color: theme.colorScheme.onPrimaryContainer,
                size: 22,
              ),
              tooltip: 'Logout',
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: _horizontalPadding,
            vertical: 12,
          ),
          child: Column(
            children: [
              BlocBuilder<ProjectCubit, ProjectState>(
                bloc: _projectCubit,
                builder: (context, state) {
                  if (state is ProjectsLoaded) {
                    return Expanded(
                      child: Column(
                        children: [
                          CustomTextField(
                            controller: _searchCtrl,
                            isNumber: false,
                            prefixIcon: Icons.search,
                            hintText: "Search projects...",
                            onChanged:
                                (val) => _projectCubit.searchProjects(val),
                          ),
                          const SizedBox(height: 16),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              _buildIconButton(
                                icon: Icons.map_outlined,
                                tooltip: "Map view",
                                onPressed:
                                    () => navigatorKey.currentState?.push(
                                      MaterialPageRoute(
                                        builder:
                                            (_) => ProjectLocationsView(
                                              projects: state.projects,
                                            ),
                                      ),
                                    ),
                              ),
                              const SizedBox(width: 12),
                              _buildIconButton(
                                icon: Icons.bar_chart_rounded,
                                tooltip: "Charts",
                                onPressed: () {
                                  // TODO: Implement charts screen
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),

                          Expanded(
                            child: ListView.separated(
                              itemCount: state.projects.length,
                              separatorBuilder:
                                  (_, __) => const SizedBox(height: 12),
                              itemBuilder: (context, index) {
                                final project = state.projects[index];
                                return Card(
                                  elevation: 4,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                      _borderRadius,
                                    ),
                                  ),
                                  child: ListTile(
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 8,
                                    ),
                                    onTap:
                                        () => navigatorKey.currentState?.push(
                                          MaterialPageRoute(
                                            builder:
                                                (_) => ProjectDetails(
                                                  projectId: project.projectId,
                                                  projectName:
                                                      project.projectName,
                                                ),
                                          ),
                                        ),
                                    title: Text(
                                      project.projectName,
                                      style: theme.textTheme.titleMedium
                                          ?.copyWith(
                                            fontWeight: FontWeight.w600,
                                          ),
                                    ),
                                    trailing: Icon(
                                      Icons.arrow_forward_ios,
                                      color: theme.colorScheme.primary,
                                      size: 20,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  } else if (state is ProjectFailed) {
                    return Expanded(
                      child: Center(
                        child: Text(
                          state.error,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: theme.colorScheme.error,
                          ),
                        ),
                      ),
                    );
                  }
                  return Expanded(
                    child: Center(
                      child: CircularProgressIndicator(
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIconButton({
    required IconData icon,
    required String tooltip,
    required VoidCallback onPressed,
  }) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(_borderRadius),
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon),
        color: theme.colorScheme.onPrimaryContainer,
        tooltip: tooltip,
        splashRadius: 24,
      ),
    );
  }

  Future<void> _showLogoutDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Confirm Logout'),
          content: const Text('Are you sure you want to log out?'),
          actions: [
            TextButton(
              onPressed: () => navigatorKey.currentState?.pop(),
              child: const Text('No'),
            ),
            BlocConsumer<AuthenicationCubit, AuthenicationState>(
              bloc: _authCubit,
              listener: (context, state) {
                if (state is AuthSuccess) {
                  showToast(state.note, true);
                  navigatorKey.currentState?.pop();
                  navigatorKey.currentState?.pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                    (route) => false,
                  );
                } else if (state is AuthFailed) {
                  showToast(state.error, false);
                }
              },
              builder: (context, state) {
                return ElevatedButton(
                  onPressed:
                      state is AuthLoading ? null : () => _authCubit.logout(),
                  child:
                      state is AuthLoading
                          ? LoadingAnimationWidget.progressiveDots(
                            size: 24,
                            color: Colors.white,
                          )
                          : const Text('Yes'),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(_borderRadius),
                    ),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
