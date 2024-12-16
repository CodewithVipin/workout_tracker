// ignore_for_file: avoid_print

import 'package:hive/hive.dart';
import 'package:workout_tracker/datetime/date_time.dart';
import 'package:workout_tracker/models/exercise.dart';
import 'package:workout_tracker/models/workout.dart';

class HiveDatabase {
  // reference our hive box

  final _myBox = Hive.box('workout_database1');

  // check if already data stored, if not, record the start date
  bool previousDataExists() {
    if (_myBox.isEmpty) {
      print("previous data does NOT exist");
      _myBox.put("START_DATE", todayDateYYYYMMDD());
      return false;
    } else {
      print("previous data does exists");
      return true;
    }
  }

  // return our start date as yyyymmdd

  String getStartDate() {
    return _myBox.get("START_DATE");
  }

  // write data

  void saveTODatabase(List<Workout> workouts) {
// convert workout obejcts into list of strings so that we can save in hive

    final workoutList = convertObjectToWorkoutList(workouts);
    final exerciseList = convertObjectToExerciseList(workouts);

/*

check if any exercises have been done
we will put a 0 or 1 for each yyyymmdd date 

*/
    if (exerciseCompleted(workouts)) {
      _myBox.put("COMPLETION_STATUS_${todayDateYYYYMMDD()}", 1);
    } else {
      _myBox.put("COMPLETION_STATUS_${todayDateYYYYMMDD()}", 0);
    }
    // save into Hive
    _myBox.put("WORKOUTS", workoutList);
    _myBox.put("EXERCISES", exerciseList);
  }

  //read data, and return list of workouts

  List<Workout> readFromDatabase() {
    List<Workout> mySavedWorkouts = [];

    List<String> workoutNames = _myBox.get("WORKOUTS");
    final exerciseDetails = _myBox.get("EXERCISES");

    //create the workout objects
    for (int i = 0; i < workoutNames.length; i++) {
      //each workout has multiple exercises

      List<Exercise> exercisesInEachWorkout = [];

      for (int j = 0; j < exerciseDetails[i].length; j++) {
        // so add each exercise into a list
        exercisesInEachWorkout.add(
          Exercise(
            name: exerciseDetails[i][j][0],
            weight: exerciseDetails[i][j][1],
            reps: exerciseDetails[i][j][2],
            sets: exerciseDetails[i][j][3],
            isComplete: exerciseDetails[i][j][4] == "true" ? true : false,
          ),
        );
      }
      // create individual workout

      Workout workout =
          Workout(name: workoutNames[i], exercises: exercisesInEachWorkout);
      // add individual workout to overall list

      mySavedWorkouts.add(workout);
    }
    return mySavedWorkouts;
  }

  //check if any exercise have been done

  bool exerciseCompleted(List<Workout> workouts) {
    // go thru each workout
    for (var workout in workouts) {
      // go thru eache exercise in workout

      for (var exercise in workout.exercises) {
        if (exercise.isComplete) {
          return true;
        }
      }
    }
    return false;
  }

// return completion status of a given date yyyymmdd
  int getCompletionStatus(String yyyymmdd) {
    // return 0 or 1,  if null then return 0

    int completionStatus = _myBox.get("COMPLETION_STATUS_$yyyymmdd") ?? 0;
    return completionStatus;
  }
}

// converts workout objects into a list--> e.g. [upper body, lowerbody]

List<String> convertObjectToWorkoutList(List<Workout> workouts) {
  List<String> workoutList = [
    //e.g. [upper body, lowerbody]
  ];
  for (int i = 0; i < workouts.length; i++) {
    // in each workout, add the name, followed by lists of exercises
    workoutList.add(
      workouts[i].name,
    );
  }
  return workoutList;
}

// converts the exercise in a workout object into a list of strings

List<List<List<String>>> convertObjectToExerciseList(List<Workout> workouts) {
  /*
  [
    Upper Body
    [ [ biceps, 10 kg, 10 reps, 3 sets], [trceps, 20 kg, 10 reps, 3 sets]],

    Lower Body

    [[ squats, 25 kg, 10 reps, 3 sets], [legraise, 20 kg, 10 reps, 3 sets]],

    ] 
  
  ]

*/

  List<List<List<String>>> exerciseList = [];
  //go through each workout

  for (int i = 0; i < workouts.length; i++) {
    List<Exercise> exerciseInWorkout = workouts[i].exercises;

    List<List<String>> individualWorkout = [
      //Upper body
      //[biceps, 10 kg, 10 reps, 10 sets], [triceps, 10 kg, 10 reps, 10 sets] ],
    ];

    // go through each exercise in exerciseList

    for (int j = 0; j < exerciseInWorkout.length; j++) {
      List<String> individualExercise = [
        // [biceps, 10 kg, 10 reps, 3 sets]
      ];
      individualExercise.addAll(
        [
          exerciseInWorkout[j].name,
          exerciseInWorkout[j].weight,
          exerciseInWorkout[j].reps,
          exerciseInWorkout[j].sets,
          exerciseInWorkout[j].isComplete.toString(),
        ],
      );
      individualWorkout.add(individualExercise);
    }
    exerciseList.add(individualWorkout);
  }
  return exerciseList;
}
