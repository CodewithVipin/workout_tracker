// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class ExerciseTile extends StatelessWidget {
  final String exerciseName;
  final String weight;
  final String reps;
  final String sets;
  bool isCompleted;
  void Function(bool?)? onCheckBoxChanged;
  ExerciseTile(
      {super.key,
      required this.exerciseName,
      required this.weight,
      required this.reps,
      required this.sets,
      required this.onCheckBoxChanged,
      required this.isCompleted});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[200],
      child: ListTile(
        title: Text(exerciseName),
        subtitle: Row(
          spacing: 10,
          children: [
            //weight
            Flexible(child: Chip(label: Text("$weight weight"))),
            //reps
            Flexible(child: Chip(label: Text("$reps reps"))),
            // sets
            Flexible(child: Chip(label: Text("$sets sets")))
          ],
        ),
        trailing: Checkbox(
            value: isCompleted,
            onChanged: (value) => onCheckBoxChanged!(value)),
      ),
    );
  }
}
