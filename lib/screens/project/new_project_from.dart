// import 'dart:developer';

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:loading_animation_widget/loading_animation_widget.dart';
// import 'package:projects/cubit/project/project_cubit.dart';
// import 'package:projects/model/project_model.dart';
// import 'package:projects/my_app.dart';
// import 'package:projects/screens/home/home_screen.dart';
// import 'package:projects/screens/maps/choose_location.dart';
// import 'package:projects/utils/snackBar.dart';
// import 'package:projects/utils/text_field.dart';
// import 'package:projects/utils/text_styles.dart';
// import 'package:projects/utils/toast.dart';

// class NewProjectFrom extends StatelessWidget {
//   NewProjectFrom({super.key});
//   final TextEditingController _projectNameCtrl = TextEditingController();
//   final TextEditingController _projectLocationCtrl = TextEditingController();
//   double _projectLat = 0;
//   double _projectLong = 0;
//   GlobalKey<FormState> formkey = GlobalKey<FormState>();
//   ProjectCubit _projectCubit = ProjectCubit();
//   @override
//   Widget build(BuildContext context) {
//     final Size size = MediaQuery.sizeOf(context);
//     return Scaffold(
//       appBar: AppBar(title: Text("New Project")),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: EdgeInsets.symmetric(
//             horizontal: size.width * 0.03,
//             vertical: size.height * 0.02,
//           ),
//           child: Form(
//             key: formkey,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,

//               children: [
//                 Text("Project Name", style: bodyTextStyle),
//                 const SizedBox(height: 5),
//                 CustomTextField(controller: _projectNameCtrl, isNumber: false),

//                 const SizedBox(height: 12),
//                 Text("Project Location", style: bodyTextStyle),
//                 const SizedBox(height: 5),
//                 CustomTextField(
//                   controller: _projectLocationCtrl,
//                   isNumber: false,
//                   isReadOnly: true,
//                   onTap:
//                       () => navigatorKey.currentState?.push(
//                         MaterialPageRoute(
//                           builder:
//                               (_) => Chooselocation(
//                                 onSelected: (locationName, lat, long) {
//                                   _projectLocationCtrl.text = locationName;
//                                   _projectLat = lat;
//                                   _projectLong = long;
//                                 },
//                               ),
//                         ),
//                       ),
//                 ),
//                 SizedBox(height: 20),
//                 Center(
//                   child: BlocConsumer<ProjectCubit, ProjectState>(
//                     bloc: _projectCubit,
//                     listener: (context, state) {
//                       if (state is ProjectSaved) {
//                         showToast(state.note, true);
//                         navigatorKey.currentState?.pushAndRemoveUntil(
//                           MaterialPageRoute(builder: (_) => HomeScreen()),
//                           (route) => false,
//                         );
//                       }
//                       if (state is ProjectFailed) {
//                         showSnackBar(context, state.error);
//                       }
//                     },
//                     builder: (context, state) {
//                       return ElevatedButton(
//                         onPressed: () {
//                           if (formkey.currentState!.validate()) {
//                             ProjectModel _project = ProjectModel(
//                               projectId: "",
//                               projectName: _projectNameCtrl.text.trim(),
//                               lat: _projectLat,
//                               long: _projectLong,
//                             );
//                             _projectCubit.saveProject(_project);
//                           }
//                         },
//                         child:
//                             state is ProjectLoading
//                                 ? LoadingAnimationWidget.progressiveDots(
//                                   size: 30,
//                                   color: Colors.white,
//                                 )
//                                 : Text('Add Project'),
//                       );
//                     },
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import 'package:projects/cubit/project/project_cubit.dart';
import 'package:projects/model/project_model.dart';
import 'package:projects/my_app.dart';
import 'package:projects/screens/home/home_screen.dart';
import 'package:projects/screens/maps/choose_location.dart';
import 'package:projects/utils/snackBar.dart';
import 'package:projects/utils/text_field.dart';
import 'package:projects/utils/text_styles.dart';
import 'package:projects/utils/toast.dart';

class NewProjectFrom extends StatefulWidget {
  const NewProjectFrom({super.key});

  @override
  State<NewProjectFrom> createState() => _NewProjectFromState();
}

class _NewProjectFromState extends State<NewProjectFrom> {
  final TextEditingController _projectNameCtrl = TextEditingController();
  final TextEditingController _projectLocationCtrl = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late final ProjectCubit _projectCubit;

  double _projectLat = 0.0;
  double _projectLong = 0.0;

  static const double _horizontalPadding = 16;
  static const double _borderRadius = 14;

  @override
  void initState() {
    super.initState();
    _projectCubit = ProjectCubit();
  }

  @override
  void dispose() {
    _projectCubit.close();
    _projectNameCtrl.dispose();
    _projectLocationCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.sizeOf(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(
        title: const Text('New Project'),
        backgroundColor: theme.colorScheme.primary,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: _horizontalPadding,
            vertical: size.height * 0.02,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Project Name', style: bodyTextStyle),
                const SizedBox(height: 6),
                CustomTextField(
                  controller: _projectNameCtrl,
                  isNumber: false,
                  hintText: 'Enter project name',
                ),
                const SizedBox(height: 20),

                Text('Project Location', style: bodyTextStyle),
                const SizedBox(height: 6),
                CustomTextField(
                  controller: _projectLocationCtrl,
                  isNumber: false,
                  isReadOnly: true,
                  hintText: 'Select location',
                  onTap: () async {
                    final result = await navigatorKey.currentState?.push(
                      MaterialPageRoute(
                        builder:
                            (_) => Chooselocation(
                              onSelected: (locationName, lat, long) {
                                _projectLocationCtrl.text = locationName;
                                _projectLat = lat;
                                _projectLong = long;
                              },
                            ),
                      ),
                    );

                    if (result != null) {
                      setState(() {
                        _projectLocationCtrl.text = result.locationName;
                        _projectLat = result.lat;
                        _projectLong = result.long;
                      });
                    }
                  },
                ),

                const SizedBox(height: 30),

                BlocConsumer<ProjectCubit, ProjectState>(
                  bloc: _projectCubit,
                  listener: (context, state) {
                    if (state is ProjectSaved) {
                      showToast(state.note, true);
                      navigatorKey.currentState?.pushAndRemoveUntil(
                        MaterialPageRoute(builder: (_) => const HomeScreen()),
                        (route) => false,
                      );
                    }
                    if (state is ProjectFailed) {
                      showSnackBar(context, state.error);
                    }
                  },
                  builder: (context, state) {
                    final bool isLoading = state is ProjectLoading;
                    return Center(
                      child: ElevatedButton(
                        onPressed:
                            isLoading
                                ? () {}
                                : () {
                                  if (_formKey.currentState!.validate()) {
                                    final project = ProjectModel(
                                      projectId: '',
                                      projectName: _projectNameCtrl.text.trim(),
                                      lat: _projectLat,
                                      long: _projectLong,
                                    );
                                    _projectCubit.saveProject(project);
                                  }
                                },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.colorScheme.primary,
                        ),
                        child:
                            isLoading
                                ? LoadingAnimationWidget.progressiveDots(
                                  size: 30,
                                  color: Colors.white,
                                )
                                : const Text('Add Project'),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
