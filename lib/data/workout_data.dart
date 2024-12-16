import 'package:flutter/material.dart';
import 'package:workout_tracker/data/hive_database.dart';
import 'package:workout_tracker/datetime/date_time.dart';
import 'package:workout_tracker/models/exercise.dart';
import 'package:workout_tracker/models/workout.dart';

class WorkoutData extends ChangeNotifier {
  final db = HiveDatabase();

/*

WORKOUT DATA STRUCTURE

- This overall list contains the different workouts
- Each workout has name, and list of exercises

*/

  List<Workout> workoutList = [
//default workout

    Workout(
      name: "Upper Body",
      exercises: [
        Exercise(name: "Bicep Curls", weight: "10", reps: "10", sets: "3"),
      ],
    ),
    Workout(
      name: "Lower Body",
      exercises: [
        Exercise(name: "Bicep Curls", weight: "10", reps: "10", sets: "3"),
      ],
    ),
  ];

  // if there are workouts already in database, then get that workout list, other the
  // default values
  void initilizeWorkoutList() {
    if (db.previousDataExists()) {
      workoutList = db.readFromDatabase();
    }
    // otherwise use the default workouts
    else {
      db.saveTODatabase(workoutList);
    }

    // load the heat map

    loadHeatMap();
  }

// get the list of workouts

  List<Workout> getworkoutList() {
    return workoutList;
  }

// get the length of workouts

  int numberOfExerciseInWorkout(String workoutName) {
    Workout releventWorkout = getrelevantWorkout(workoutName);

    return releventWorkout.exercises.length;
  }

// add a workout

  void addWorkout(String name) {
// add a new workout with a blank list of exercises

    workoutList.add(Workout(
      name: name,
      exercises: [],
    ));
    notifyListeners();

    //save to database
    db.saveTODatabase(workoutList);
  }

// add an exercise to a workout

  void addExercise(String workoutName, String exerciseName, String weight,
      String reps, String sets) {
// find the relevent workout
    Workout releventWorkout = getrelevantWorkout(workoutName);
    releventWorkout.exercises.add(Exercise(
      name: exerciseName,
      weight: weight,
      reps: reps,
      sets: sets,
    ));
    notifyListeners();
    //save to database
    db.saveTODatabase(workoutList);
  }

// check off the exercise

  void checkOffExcercise(String workoutName, String exerciseName) {
// find the relevant workout and relevant exercise in the workout

    Exercise relevantExercise = getRelevantExercise(workoutName, exerciseName);

    // checkoff the boolean to show user completed the exercise

    relevantExercise.isComplete = !relevantExercise.isComplete;
    notifyListeners();
    //save to database
    db.saveTODatabase(workoutList);
    // load the heat map

    loadHeatMap();
  }

// get the length of given workout

// return relevant workout object, given a workout name
  Workout getrelevantWorkout(String workoutName) {
    Workout releventWorkout =
        workoutList.firstWhere((workout) => workout.name == workoutName);

    return releventWorkout;
  }

// return relevant workout object,given a workout name + exercise name

  Exercise getRelevantExercise(String workoutName, String exerciseName) {
    // find the relevant workout first

    Workout releventWorkout = getrelevantWorkout(workoutName);

    // then find the relevant exersise in that workout

    Exercise relevantExercise = releventWorkout.exercises
        .firstWhere((exercise) => exercise.name == exerciseName);

    return relevantExercise;
  }

  // get the start date

  String getStartDate() {
    return db.getStartDate();
  }

  /*

HEAT MAP


  */

  Map<DateTime, int> heatMapDataSet = {};

  void loadHeatMap() {
    DateTime startDate = createDateTimeObject(getStartDate());

    // count the number of days to load

    int daysInBetween = DateTime.now().difference(startDate).inDays;

    // go from start date to today, and add each completion status to  the dataset

    //"COMPLETE_STATUS_YYYYMMDD" will be the key in the database

    for (int i = 0; i < daysInBetween + 1; i++) {
      String yyyymmdd =
          convertDateTimeToYYYYMMDD(startDate.add(Duration(days: i)));
      // completion status = 0 or 1
      int completionStatus = db.getCompletionStatus(yyyymmdd);

      //year
      int year = startDate.add(Duration(days: i)).year;

      // month

      int month = startDate.add(Duration(days: i)).month;

      //day

      int day = startDate.add(Duration(days: i)).day;

      final percetforEachDay = <DateTime, int>{
        DateTime(year, month, day): completionStatus
      };
      // add to the heatmap dataset

      heatMapDataSet.addEntries(percetforEachDay.entries);
    }
  }
}
