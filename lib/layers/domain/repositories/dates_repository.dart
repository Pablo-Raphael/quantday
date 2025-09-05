abstract class DatesRepository {
  Future<DateTime?> getLastLoadDateOfTasks();

  Future<bool> updateLastLoadDateOfTasks(DateTime date);
}
