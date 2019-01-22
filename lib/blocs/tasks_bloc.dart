import 'package:rxdart/rxdart.dart';
import 'package:built_collection/built_collection.dart';

import '../models/dailytask.dart';
import '../models/habit.dart';
import '../blocs/bloc_base.dart';
import '../env.dart';

final _monthDays = 25;
final _quaterDays = 81;

class TasksBloc extends BlocBase {
  final selectedTask = BehaviorSubject<DailyTask>();
  final tasks = BehaviorSubject<BuiltList<DailyTask>>();

  Habit _selectedHabit;

  BuiltList<DailyTask> _formatTasks(Habit habit, BuiltList<DailyTask> tasks) {
    final now = DateTime.now().toLocal();
    final currentDate = DateTime(now.year, now.month, now.day, 23, 59, 59);
    final passedDays = currentDate
        .difference(DateTime.fromMicrosecondsSinceEpoch(habit.created))
        .inDays;
    final seq = passedDays + 1;

    var presentedDays = _monthDays;
    if (passedDays >= _monthDays) {
      presentedDays = _quaterDays;
    }

    var _tasks = <DailyTask>[];
    for (int i = 0; i < presentedDays; i++) {
      var task = tasks[i];
      if (task.seq > seq) {
        task = task.rebuild((b) => b
          ..isFuture = true
          ..isToday = false
          ..isYesterday = false
          ..isSelected = false);
      } else if (task.seq == seq) {
        task = task.rebuild((b) => b
          ..isSelected = true
          ..isFuture = false
          ..isYesterday = false
          ..isToday = true);
      } else if (task.seq == seq - 1) {
        task = task.rebuild((b) => b
          ..isYesterday = true
          ..isToday = false
          ..isFuture = false
          ..isSelected = false);
      } else {
        task = task.rebuild((b) => b
          ..isFuture = false
          ..isYesterday = false
          ..isSelected = false
          ..isToday = false);
      }
      _tasks.add(task);
    }

    return BuiltList(_tasks);
  }

  selectHabit(Habit habit) {
    _selectedHabit = habit;
    final _tasks = Env.repository.getTasks(habit.habitID);
    final formatedTasks = _formatTasks(habit, _tasks);
    tasks.add(formatedTasks);
    selectedTask
        .add(formatedTasks.where((task) => task.isSelected == true).first);
  }

  selectTask(DailyTask task) {
    if (task.isSelected != true) {
      selectedTask.add(task);
      task = task.rebuild((b) => b..isSelected = true);
    } else {
      var status = DailyTaskStatus.completed;
      if (task.status == DailyTaskStatus.completed) {
        status = DailyTaskStatus.failed;
      } else if (task.status == DailyTaskStatus.failed) {
        status = DailyTaskStatus.skipped;
      }
      task = task.rebuild((b) => b..status = status);
      Env.repository.updateTask(task, _selectedHabit.habitID);
    }
    tasks.add(tasks.value.rebuild((b) => b.map((_task) {
          if (_task.isSelected == true && _task.seq != task.seq) {
            return _task.rebuild((__task) => __task..isSelected = false);
          }
          if (_task.seq == task.seq) {
            return task;
          }
          return _task;
        })));
  }

  updataTask(DailyTask task) {
    Env.repository.updateTask(task, _selectedHabit.habitID);
    task = task.rebuild((b) => b.isSelected = true);
    selectedTask.add(task);
    tasks.add(tasks.value.rebuild((b) => b.map((_task) {
          return _task.seq == task.seq ? task : _task;
        })));
  }

  dispose() {
    selectedTask.close();
    tasks.close();
  }
}
