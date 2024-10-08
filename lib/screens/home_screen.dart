import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:async';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isTimerRunning = false;
  Stopwatch _stopwatch = Stopwatch();
  Timer? _timer;
  List<CallLog> callLogs = [];

  void startTimer() {
    setState(() {
      isTimerRunning = true;
      _stopwatch.start();
    });
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {});
    });
  }

  void stopTimer() {
    setState(() {
      isTimerRunning = false;
      _stopwatch.stop();
      callLogs.add(CallLog(
        duration: _stopwatch.elapsed,
        timestamp: DateTime.now(),
      ));
      _stopwatch.reset();
    });
    _timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lawyer Call Timer'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Text(
                _formatDuration(_stopwatch.elapsed),
                style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          ElevatedButton(
            child: Text(isTimerRunning ? 'Stop Call' : 'Start Call'),
            onPressed: isTimerRunning ? stopTimer : startTimer,
          ),
          Expanded(
            flex: 2,
            child: ListView.builder(
              itemCount: callLogs.length,
              itemBuilder: (context, index) {
                final log = callLogs[index];
                return ListTile(
                  title: Text('Call ${callLogs.length - index}'),
                  subtitle: Text(DateFormat('yyyy-MM-dd HH:mm').format(log.timestamp)),
                  trailing: Text(_formatDuration(log.duration)),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }
}

class CallLog {
  final Duration duration;
  final DateTime timestamp;

  CallLog({required this.duration, required this.timestamp});
}