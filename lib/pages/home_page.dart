import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_tracker/componets/heat_map.dart';
import 'package:workout_tracker/data/workout_data.dart';
import 'package:workout_tracker/pages/workout_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    Provider.of<WorkoutData>(context, listen: false).initilizeWorkoutList();
  }

//textcontroller

  final newWorkoutNameController = TextEditingController();

// create a new workout

  void createNewWorkout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Create a new workout"),
        content: TextField(
          controller: newWorkoutNameController,
        ),
        actions: [
          //save button
          MaterialButton(
            onPressed: save,
            child: Text("save"),
          ),

          //cancel button
          MaterialButton(
            onPressed: cancel,
            child: Text("cancel"),
          )
        ],
      ),
    );
  }

  // go to workout page
  void goToWorkoutPage(String workoutName) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => WorkoutPage(
            workoutName: workoutName,
          ),
        ));
  }

  // save workout
  void save() {
    // get workout name from text controller
    String newWorkoutName = newWorkoutNameController.text;

    // add workout to workoutdata list
    Provider.of<WorkoutData>(context, listen: false).addWorkout(newWorkoutName);
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
    newWorkoutNameController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WorkoutData>(
        builder: (context, value, child) => Scaffold(
            backgroundColor: Colors.grey[300],
            appBar: AppBar(
              centerTitle: true,
              title: Text("Workout Tracker"),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: createNewWorkout,
              child: Icon(Icons.add),
            ),
            body: ListView(
              children: [
                // heat map
                MyHeatMap(
                    datasets: value.heatMapDataSet,
                    startDateYYYYMMDD: value.getStartDate()),

                //workout list
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: value.getworkoutList().length,
                  itemBuilder: (context, index) => ListTile(
                    tileColor: Colors.grey,
                    title: Text(value.getworkoutList()[index].name),
                    trailing: IconButton(
                      onPressed: () =>
                          goToWorkoutPage(value.getworkoutList()[index].name),
                      icon: Icon(Icons.arrow_forward_ios),
                    ),
                  ),
                ),
              ],
            )));
  }
}
