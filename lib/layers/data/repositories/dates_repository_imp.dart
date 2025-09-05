import 'package:quantday/core/extensions/datetime_extension.dart';
import 'package:quantday/layers/data/datasources/dates_datasource.dart';
import 'package:quantday/layers/domain/repositories/dates_repository.dart';

class DatesRepositoryImp implements DatesRepository {
  final DatesDataSource _datesDataSource;

  DatesRepositoryImp(this._datesDataSource);

  @override
  Future<DateTime?> getLastLoadDateOfTasks() async {
    final lastLoadedDate = await _datesDataSource.getLastLoadedDate();
    return DateTime.tryParse(lastLoadedDate ?? '');
  }

  @override
  Future<bool> updateLastLoadDateOfTasks(DateTime date) async {
    return await _datesDataSource.updateLastLoadedDate(date.quantDayFormat);
  }
}
