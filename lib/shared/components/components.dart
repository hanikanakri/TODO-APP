import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:untitled/shared/cubit/cubit.dart';

Widget myTextFormField({
  required TextEditingController controller,
  required TextInputType type,
  required String labelText,
  required String? Function(String?) validate,
  String Function(String)? onChanged,
  String Function(String)? onFieldSubmitted,
  void Function()? onTap,
  Widget? widget,
  IconData? suffixIcon,
  Widget? prefixIcon,
  Color? focusColor,
  Color? cursorColor,
  Color? iconColor,
  Color? writingColor,
  Color enabledBorderUnderlineColor = Colors.grey,
  Color? hintColor,
  Color? labelColor,
  Color? suffixColor,
  Color? hoverColor,
  Color? fillColor,
  Color? errorColor,
  Color? suffixColorGesture,
  bool obscureText = false,
  double? fontSize,
  InputBorder? border,
  EdgeInsets? contentPadding,
}) =>
    TextFormField(
      onChanged: onChanged,
      onTap: onTap,
      onFieldSubmitted: onFieldSubmitted,
      controller: controller,
      keyboardType: type,
      cursorColor: cursorColor,
      obscureText: obscureText,
      decoration: InputDecoration(
        errorStyle: TextStyle(color: errorColor),
        hoverColor: hoverColor,
        fillColor: fillColor,
        prefixIcon: prefixIcon,
        focusColor: focusColor,
        labelText: labelText,
        iconColor: iconColor,
        suffixIcon: widget,
        contentPadding: contentPadding,
        labelStyle: TextStyle(color: labelColor),
        hintStyle: TextStyle(
          color: hintColor,
          fontSize: fontSize,
        ),
        filled: true,
        //fillColor: Colors.grey[200],
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade300, width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(0),
        ),
        border: border,
        helperMaxLines: 2,
      ),
      validator: validate,
    );

Widget buildTaskItem(Map model, context) => Dismissible(
      key: Key(model['id'].toString()),
      onDismissed: (direction) {
        AppCubit.get(context).deleteDatabase(id: model['id']);
      },
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            CircleAvatar(
              radius: 40.0,
              child: Text('${model['time']}'),
            ),
            const SizedBox(
              width: 20.0,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${model['title']}',
                    style: const TextStyle(
                        fontSize: 16.0, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '${model['date']}',
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
            const SizedBox(
              width: 20.0,
            ),
            IconButton(
              onPressed: () {
                AppCubit.get(context)
                    .updateDatabase(status: 'done', id: model['id']);
              },
              icon: const Icon(
                Icons.check_box,
                color: Colors.green,
              ),
            ),
            IconButton(
              onPressed: () {
                AppCubit.get(context)
                    .updateDatabase(status: 'archive', id: model['id']);
              },
              icon: const Icon(
                Icons.archive,
                color: Colors.black45,
              ),
            ),
          ],
        ),
      ),
    );

Widget tasksBuilder({
  required List<Map> cubit,
}) =>
    ConditionalBuilder(
      condition: cubit.isNotEmpty,
      builder: (context) => ListView.separated(
        itemBuilder: (context, index) {
          return buildTaskItem(cubit[index], context);
        },
        separatorBuilder: (context, index) {
          return Container(
            width: double.infinity,
            height: 1,
            color: Colors.grey[300],
          );
        },
        itemCount: cubit.length,
      ),
      fallback: (context) => const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.menu,
              size: 100.0,
              color: Colors.grey,
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              'There is no tasks yet, Please Add some tasks',
              style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey),
            ),
          ],
        ),
      ),
    );
