import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:untitled/shared/components/components.dart';
import 'package:untitled/shared/cubit/cubit.dart';
import 'package:untitled/shared/cubit/state.dart';

class HomeLayout extends StatelessWidget {
  const HomeLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit()..createDatabase(),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (BuildContext context, Object? state) {
          if (state is AppInsertDatabaseState) {
            Navigator.pop(context);
          }
        },
        builder: (BuildContext context, state) {
          AppCubit cubit = AppCubit.get(context);
          return Scaffold(
            key: cubit.scaffoldKey,
            appBar: AppBar(
              title: Text(cubit.titles[cubit.currentIndex]),
            ),
            body: ConditionalBuilder(
              condition: state is! AppGetDatabaseLoadingState,
              builder: (context) => cubit.screens[cubit.currentIndex],
              fallback: (context) => const Center(
                child: CircularProgressIndicator(),
              ),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                {
                  if (cubit.isBottomSheetShown) {
                    if (cubit.formKey.currentState!.validate()) {
                      cubit.insertToDatabase(
                        date: cubit.dateController.text,
                        time: cubit.timerController.text,
                        title: cubit.titleController.text,
                      );
                    }
                  } else {
                    cubit.scaffoldKey.currentState
                        ?.showBottomSheet(elevation: 20, (context) {
                          return Form(
                            key: cubit.formKey,
                            child: Container(
                              color: Colors.white,
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  myTextFormField(
                                    border: const OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(25)),
                                      borderSide:
                                          BorderSide(color: Colors.grey),
                                    ),
                                    controller: cubit.titleController,
                                    type: TextInputType.text,
                                    validate: (String? value) {
                                      if (value!.isEmpty) {
                                        return 'title must be not empty';
                                      }
                                      return null;
                                    },
                                    labelText: 'Task Title',
                                    prefixIcon: const Icon(Icons.title),
                                  ),
                                  const SizedBox(
                                    height: 15.0,
                                  ),
                                  myTextFormField(
                                    border: const OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(25)),
                                      borderSide:
                                          BorderSide(color: Colors.grey),
                                    ),
                                    controller: cubit.timerController,
                                    type: TextInputType.datetime,
                                    validate: (String? value) {
                                      if (value!.isEmpty) {
                                        return 'time must be not empty';
                                      }
                                      return null;
                                    },
                                    labelText: 'Task Time',
                                    prefixIcon:
                                        const Icon(Icons.watch_later_outlined),
                                    onTap: () {
                                      debugPrint('Timing Tapped');
                                      showTimePicker(
                                        context: context,
                                        initialTime: TimeOfDay.now(),
                                      ).then((value) {
                                        debugPrint(value?.format(context));
                                        cubit.timerController.text =
                                            value!.format(context);
                                      });
                                    },
                                  ),
                                  const SizedBox(
                                    height: 15.0,
                                  ),
                                  myTextFormField(
                                    border: const OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(25)),
                                      borderSide:
                                          BorderSide(color: Colors.grey),
                                    ),
                                    controller: cubit.dateController,
                                    type: TextInputType.datetime,
                                    validate: (String? value) {
                                      if (value!.isEmpty) {
                                        return 'date must be not empty';
                                      }
                                      return null;
                                    },
                                    labelText: 'Task Date',
                                    prefixIcon:
                                        const Icon(Icons.calendar_today),
                                    onTap: () {
                                      debugPrint('Date Tapped');
                                      showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime.now(),
                                        lastDate: DateTime.now().add(
                                          const Duration(days: 60),
                                        ),
                                      ).then((value) {
                                        debugPrint(
                                            DateFormat.yMMMd().format(value!));
                                        cubit.dateController.text =
                                            DateFormat.yMMMd().format(value);
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                          );
                        })
                        .closed
                        .then((value) {
                          cubit.changeBottomSheetShown(isShow: false);
                        });
                    cubit.changeBottomSheetShown(isShow: true);
                  }
                }
              },
              child: Icon(cubit.isBottomSheetShown ? Icons.add : Icons.edit),
            ),
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: AppCubit.get(context).currentIndex,
              onTap: (index) {
                cubit.changeIndex(index);
              },
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.menu),
                  label: 'new Task',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.check_circle_outline),
                  label: 'Done',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.archive_outlined),
                  label: 'Archived',
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
