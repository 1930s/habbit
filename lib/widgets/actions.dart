import 'package:flutter/material.dart';
import 'dart:math';
import '../models/dailytask.dart';
import '../blocs/bloc_provider.dart';
import '../blocs/tasks_bloc.dart';
import '../blocs/habits_bloc.dart';

class Actions extends StatelessWidget {
  final double height;
  Actions(this.height);

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<HabitsBloc>(context).tasksBloc;
    return StreamBuilder<DailyTask>(
      initialData: bloc.selectedTask.value,
      stream: bloc.selectedTask.stream,
      builder: (context, snapshot) {
        final task = snapshot.data;
        if (task == null) {
          return Container();
        }

        final mainButtonWidth = min(height - 40, 100).toDouble();
        final buttonWidth = mainButtonWidth * 2 / 3;
        return Container(
          height: height,
          padding: EdgeInsets.only(
              bottom: max(0, (height - mainButtonWidth - 30)) / 2),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                  width: buttonWidth,
                  // decoration: BoxDecoration(color: Colors.yellow),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          final _task = task.rebuild(
                              (b) => b.status = DailyTaskStatus.failed);
                          bloc.updataTask(_task);
                        },
                        child: Container(
                          width: buttonWidth,
                          height: buttonWidth,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: task.status == DailyTaskStatus.failed
                                  ? Colors.red
                                  : Colors.transparent,
                              border: Border.all(width: 2, color: Colors.red)),
                          child: Icon(
                            Icons.close,
                            size: buttonWidth * 0.5,
                            color: task.status == DailyTaskStatus.failed
                                ? Colors.white
                                : Colors.red,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10),
                      ),
                      Text(
                        'failed',
                        style: TextStyle(color: Colors.black54),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: mainButtonWidth,
                  // decoration: BoxDecoration(color: Colors.red),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            final _task = task.rebuild(
                                (b) => b.status = DailyTaskStatus.completed);
                            bloc.updataTask(_task);
                          },
                          child: Container(
                            width: mainButtonWidth,
                            height: mainButtonWidth,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: task.status == DailyTaskStatus.completed
                                    ? Colors.green
                                    : Colors.transparent,
                                border:
                                    Border.all(width: 2, color: Colors.green)),
                            child: Icon(
                              Icons.done,
                              size: mainButtonWidth * 0.5,
                              color: task.status == DailyTaskStatus.completed
                                  ? Colors.white
                                  : Colors.green,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 10),
                        ),
                        Text(
                          'completed',
                          style: TextStyle(color: Colors.black54),
                        ),
                      ]),
                ),
                Container(
                  width: buttonWidth,
                  // decoration: BoxDecoration(color: Colors.blue),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            final _task = task.rebuild(
                                (b) => b.status = DailyTaskStatus.skipped);
                            bloc.updataTask(_task);
                          },
                          child: Container(
                            width: buttonWidth,
                            height: buttonWidth,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: task.status == DailyTaskStatus.skipped
                                    ? Colors.black54
                                    : Colors.transparent,
                                border: Border.all(
                                    width: 2,
                                    color:
                                        task.status != DailyTaskStatus.skipped
                                            ? Colors.black54
                                            : Colors.transparent)),
                            child: Icon(
                              Icons.skip_next,
                              size: buttonWidth * 0.5,
                              color: task.status == DailyTaskStatus.skipped
                                  ? Colors.white
                                  : Colors.black54,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 10),
                        ),
                        Text(
                          'skip',
                          style: TextStyle(color: Colors.black54),
                        ),
                      ]),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
