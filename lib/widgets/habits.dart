import 'package:flutter/material.dart';
import '../models/habit.dart';
import '../utils/icons.dart';

class _Habit extends StatelessWidget {
  final Habit habit;
  final double itemWidth;

  _Habit(this.itemWidth, this.habit);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 15),
      width: itemWidth,
      height: itemWidth,
      decoration: BoxDecoration(
          border: Border.all(
        color: Colors.black87,
        width: 2,
      )),
      padding: EdgeInsets.only(left: 4, bottom: 4),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            height: 32,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Icon(
                  getIconDataByName(habit.iconName),
                  size: 32,
                ),
                Icon(
                  Icons.more_vert,
                  size: 26,
                )
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(right: 4),
            child: Text(
              habit.title,
              overflow: TextOverflow.ellipsis,
              maxLines: 3,
              style: TextStyle(fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}

class _AddHabit extends StatelessWidget {
  final double itemWidth;

  _AddHabit(this.itemWidth);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 15),
      width: itemWidth,
      height: itemWidth,
      decoration: BoxDecoration(
          border: Border.all(
        color: Colors.black87,
        width: 2,
      )),
      padding: EdgeInsets.all(8),
      child: Center(
        child: Icon(Icons.add),
      ),
    );
  }
}

class Habits extends StatelessWidget {
  final List<Habit> habits;

  Habits(this.habits);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        padding: EdgeInsets.all(15.0),
        decoration: BoxDecoration(
            border: Border(top: BorderSide(color: Colors.black45, width: 0.5))),
        height: 156,
        child: Column(
          children: <Widget>[
            Container(
              height: 30,
              width: double.infinity,
              child: Text(
                'My Habits',
                style: TextStyle(color: Colors.black54, fontSize: 16),
              ),
            ),
            Container(
              height: 95,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemExtent: 110,
                itemCount: habits != null ? habits.length + 1 : 1,
                itemBuilder: (context, index) {
                  if (index < habits.length) {
                    return _Habit(95, habits[index]);
                  } else {
                    return _AddHabit(95);
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
