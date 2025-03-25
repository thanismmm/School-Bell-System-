import 'package:flutter/material.dart';
import 'package:school_bell_system/page/sheduleupdate.dart';


class Updateoption extends StatelessWidget {
  const Updateoption({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              margin:  EdgeInsets.all(16),
              child:  Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Schedule Update',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text('Update the Belling Schedue '),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => ScheduleUpdate()));
                      } , // Add functionality
                      child: Text('Update'),
                    ),
                  ],
                ),
              ),
            ),

            Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              margin: const EdgeInsets.all(16),
              child: const Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Other Settings',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text('Update the Other Settings '),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: null, // Add functionality
                      child: Text('Update'),
                    ),
                  ],
                ),
              ),
            ),
      ],
    );
  }
}
