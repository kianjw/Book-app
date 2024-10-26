import 'package:flutter/material.dart';
import 'dart:async';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';

class ProductivityPage extends StatefulWidget {
  final int booksPerYear;

  ProductivityPage({required this.booksPerYear});

  @override
  _ProductivityPageState createState() => _ProductivityPageState();
}

class _ProductivityPageState extends State<ProductivityPage> {
  int dailyReadingGoal = 15; // Updated daily reading goal to 15 minutes
  late int totalSecondsRemaining;
  late bool isTimerRunning;
  late Duration countdownDuration;
  late DateTime? lastTimerStartTime;
  late Timer? _timer;
  int weeklyReadingSeconds = 0; // Updated to store weekly reading seconds

  @override
  void initState() {
    super.initState();
    // Calculate total seconds for 15 minutes
    totalSecondsRemaining = dailyReadingGoal * 60; // Convert minutes to seconds
    isTimerRunning = false;
    countdownDuration = Duration(seconds: totalSecondsRemaining);
    lastTimerStartTime = null;
  }

  void _toggleTimer() {
    setState(() {
      if (isTimerRunning) {
        // Stop the timer
        _timer?.cancel();
        isTimerRunning = false;
      } else {
        // Start the timer
        isTimerRunning = true;
        lastTimerStartTime = DateTime.now();
        _startTimer();
      }
    });
  }

  void _startTimer() {
    const oneSecond = Duration(seconds: 1);
    _timer = Timer.periodic(oneSecond, (timer) {
      setState(() {
        if (totalSecondsRemaining > 0) {
          totalSecondsRemaining--;
          countdownDuration = Duration(seconds: totalSecondsRemaining);
          weeklyReadingSeconds++; // Increment weekly reading seconds every second
        } else {
          timer.cancel(); // Stop the timer when countdown reaches 0
          isTimerRunning = false;
        }
      });
    });
  }

  String _formatDuration(Duration duration) {
    return '${duration.inHours}:${(duration.inMinutes % 60).toString().padLeft(2, '0')}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
  }

  String _formatWeeklyReadingTime(int seconds) {
    Duration duration = Duration(seconds: seconds);
    return '${duration.inHours}:${(duration.inMinutes % 60).toString().padLeft(2, '0')}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text('Productivity Page'),
    ),
    body: Container(
      color: Colors.white, // Set the background color to white
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              'Daily Reading Goal: $dailyReadingGoal minutes',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            SizedBox(height: 5),
            // Custom CircularCountDownTimer for 15 minutes
            Stack(
              alignment: Alignment.center,
              children: [
                // Gray background circle
                Container(
                  width: MediaQuery.of(context).size.width / 5,
                  height: MediaQuery.of(context).size.width / 5,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey, // Gray background color
                  ),
                ),
                // Blue countdown timer circle
                CircularCountDownTimer(
                  duration: totalSecondsRemaining,
                  initialDuration: totalSecondsRemaining,
                  controller: CountDownController(),
                  width: MediaQuery.of(context).size.width / 5,
                  height: MediaQuery.of(context).size.width / 5,
                  ringColor: Colors.blueAccent,
                  ringGradient: null,
                  fillColor: Colors.transparent, // Transparent fill color
                  backgroundGradient: null,
                  strokeWidth: 7.0,
                  strokeCap: StrokeCap.round,
                  textStyle: TextStyle(
                    fontSize: 30.0,
                    color: Colors.black, // Change countdown text color to black
                    fontWeight: FontWeight.bold,
                  ),
                  textFormat: CountdownTextFormat.HH_MM_SS,
                  isReverse: true,
                  isReverseAnimation: false,
                  isTimerTextShown: true, // Show the built-in timer text
                  autoStart: false,
                  onComplete: () {
                    setState(() {
                      isTimerRunning = false;
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 10),
            // Days of the week below weekly reading time with dates
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildDayOfWeek(DateTime.now().subtract(Duration(days: 1)), 'Mon'),
                  _buildDayOfWeek(DateTime.now(), 'Tue'),
                  _buildDayOfWeek(DateTime.now().add(Duration(days: 1)), 'Wed'),
                  _buildDayOfWeek(DateTime.now().add(Duration(days: 2)), 'Thu'),
                  _buildDayOfWeek(DateTime.now().add(Duration(days: 3)), 'Fri'),
                  _buildDayOfWeek(DateTime.now().add(Duration(days: 4)), 'Sat'),
                  _buildDayOfWeek(DateTime.now().add(Duration(days: 5)), 'Sun'),
                ],
              ),
            ),
            SizedBox(height: 10),
            LinearProgressIndicator(
              value: 1 - (totalSecondsRemaining / (dailyReadingGoal * 60)),
              backgroundColor: Colors.white,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
            ),
            SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: _toggleTimer,
              icon: Icon(isTimerRunning ? Icons.stop : Icons.play_arrow),
              label: Text(isTimerRunning ? 'Stop Timer' : 'Start Timer'),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
                  if (states.contains(MaterialState.pressed)) {
                    return isTimerRunning ? Colors.red.withOpacity(0.8) : Colors.green.withOpacity(0.8);
                  }
                  return isTimerRunning ? Colors.red : Colors.green;
                }),
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Your longest reading streak 2 days',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
          ],
        ),
      ),
    ),
  );
}

  Widget _buildDayOfWeek(DateTime date, String dayName) {
  bool isMonday = dayName == 'Mon';
  bool isTuesday = dayName == 'Tue';

  return Column(
    children: [
      Text(
        dayName,
        style: TextStyle(
          fontSize: 12,
          color: isMonday || isTuesday ? Colors.green : Colors.black87, // Conditionally set color to green for 'Mon' and 'Tue', otherwise black87
          fontWeight: isMonday || isTuesday ? FontWeight.bold : FontWeight.normal, // Bold font weight for 'Mon' and 'Tue', otherwise normal
        ),
      ),
      SizedBox(height: 5),
      Text(
        '${date.day}',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: isMonday || isTuesday ? Colors.green : Colors.black87, // Conditionally set color to green for 'Mon' and 'Tue', otherwise black87
        ),
      ),
    ],
  );
}


  @override
  void dispose() {
    _timer?.cancel(); // Cancel the timer when the widget is disposed
    super.dispose();
  }
}
