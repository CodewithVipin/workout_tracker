class Exercise {
  final String name;
  final String weight;
  final String reps;
  final String sets;
  bool isComplete;
  Exercise(
      {required this.name,
      required this.weight,
      required this.reps,
      this.isComplete = false,
      required this.sets});
}
