import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_tracker/componets/exercise_tile.dart';
import 'package:workout_tracker/data/workout_data.dart';

class WorkoutPage extends StatefulWidget {
  final String workoutName;
  const WorkoutPage({super.key, required this.workoutName});

  @override
  State<WorkoutPage> createState() => _WorkoutPageState();
}

class _WorkoutPageState extends State<WorkoutPage> {
  //checkbox was tapped

  void onCheckBoxChanged(String workoutName, String exerciseName) {
    Provider.of<WorkoutData>(context, listen: false)
        .checkOffExcercise(workoutName, exerciseName);
  }

// text controller
  final exerciseNameController = TextEditingController();
  final weightController = TextEditingController();
  final repsController = TextEditingController();
  final setsController = TextEditingController();

//create a new exercise

// save workout
  void save() {
    // get exercise name from text controller
    String newExerciseName = exerciseNameController.text;
    String weight = weightController.text;
    String reps = repsController.text;
    String sets = setsController.text;

    // add exercise to workoutdata list
    Provider.of<WorkoutData>(context, listen: false)
        .addExercise(widget.workoutName, newExerciseName, weight, reps, sets);
    // pop dialog box
    Navigator.pop(context);
    clear();
  }

  // cancel workout
  void cancel() {
    // pop dialog box
    Navigator.pop(context);
  }

  void clear() {
    exerciseNameController.clear();
    weightController.clear();
    repsController.clear();
    setsController.clear();
  }

  void createNewExercise() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("Add a new exercise"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  //exercise name
                  TextField(
                    controller: exerciseNameController,
                    decoration: InputDecoration(
                      hintText: "exercise name",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  //weight
                  TextField(
                    controller: weightController,
                    decoration: InputDecoration(
                      hintText: "weigth",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  //reps
                  TextField(
                    controller: repsController,
                    decoration: InputDecoration(
                      hintText: "reps",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  //sets
                  TextField(
                    controller: setsController,
                    decoration: InputDecoration(
                      hintText: "sets",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
              actions: [
                //save button
                MaterialButton(
                  color: Colors.green,
                  onPressed: save,
                  child: Text("save"),
                ),

                //cancel button
                MaterialButton(
                  color: Colors.red,
                  onPressed: cancel,
                  child: Text("cancel"),
                ),
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WorkoutData>(
        builder: (context, value, child) => Scaffold(
              appBar: AppBar(
                title: Text(widget.workoutName),
                centerTitle: true,
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: createNewExercise,
                child: Icon(Icons.add),
              ),
              body: ListView.builder(
                  itemCount:
                      value.numberOfExerciseInWorkout(widget.workoutName),
                  itemBuilder: (context, index) => ExerciseTile(
                      onCheckBoxChanged: (val) => onCheckBoxChanged(
                          widget.workoutName,
                          value
                              .getrelevantWorkout(widget.workoutName)
                              .exercises[index]
                              .name),
                      exerciseName: value
                          .getrelevantWorkout(widget.workoutName)
                          .exercises[index]
                          .name,
                      weight: value
                          .getrelevantWorkout(widget.workoutName)
                          .exercises[index]
                          .weight,
                      reps: value
                          .getrelevantWorkout(widget.workoutName)
                          .exercises[index]
                          .reps,
                      sets: value
                          .getrelevantWorkout(widget.workoutName)
                          .exercises[index]
                          .sets,
                      isCompleted: value
                          .getrelevantWorkout(widget.workoutName)
                          .exercises[index]
                          .isComplete)),
            ));
  }
}
