import 'package:flutter/material.dart';

class GestureRecording extends StatelessWidget {
  Future<void> _recordGesture(String type, BuildContext context) async {
    print("Recording $type");
    await showDialog(
      context: context,
      builder: (BuildContext context) => SimpleDialog(
        title: const Text("Recording..."),
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 16),
            child: ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text("Done")),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Record Gestures"),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Accept Gesture",
                style: Theme.of(context).textTheme.headline5,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Currently not set"),
                TextButton(
                  onPressed: () => _recordGesture("accept", context),
                  child: Text("Record"),
                ),
              ],
            ),
          ),
          SizedBox(height: 16.0),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Decline Gesture",
                style: Theme.of(context).textTheme.headline5,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Currently not set"),
                TextButton(
                  onPressed: () => _recordGesture("decline", context),
                  child: Text("Record"),
                ),
              ],
            ),
          ),
          SizedBox(height: 16.0),
          TextButton(
            onPressed: () =>
                Navigator.of(context).pushReplacementNamed('/join'),
            child: Text("Done"),
          ),
        ],
      ),
    );
  }
}