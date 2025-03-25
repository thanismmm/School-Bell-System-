import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:school_bell_system/page/loginpage.dart';

class ScheduleUpdate extends StatefulWidget {
  const ScheduleUpdate({super.key});

  @override
  _ScheduleUpdateState createState() => _ScheduleUpdateState();
}

class _ScheduleUpdateState extends State<ScheduleUpdate> {
  String? selectedType;
  TimeOfDay startTime = TimeOfDay.now();
  TimeOfDay intervalTime = TimeOfDay.now();
  TimeOfDay overTime = TimeOfDay.now();
  final List<String> types = ['Regular', 'Friday', 'Exam', 'Emergency'];
  List<TimeOfDay> subjectTimes = List.generate(9, (index) => TimeOfDay.now());

  @override
  void initState() {
    super.initState();
    _fetchScheduleFromFirebase();
  }

  Future<void> _fetchScheduleFromFirebase() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    DocumentSnapshot snapshot =
        await firestore.collection('scheduleUpdate').doc('scheduleUpdate').get();

    if (snapshot.exists) {
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;

      setState(() {
        selectedType = data['type'];
        startTime = _parseTime(data['startTime']);
        intervalTime = _parseTime(data['intervalTime']);
        overTime = _parseTime(data['overTime']);

        for (int i = 0; i < subjectTimes.length; i++) {
          subjectTimes[i] = _parseTime(data['subject${i + 1}']);
        }
      });
    }
  }

  TimeOfDay _parseTime(String time) {
    List<String> parts = time.split(':');
    int hour = int.parse(parts[0]);
    int minute = int.parse(parts[1]);
    return TimeOfDay(hour: hour, minute: minute);
  }

  Future<void> _selectTime(
      BuildContext context, Function(TimeOfDay) updateTime) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      updateTime(picked);
    }
  }

  Future<void> _saveScheduleToFirebase() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    Map<String, dynamic> scheduleData = {
      'type': selectedType,
      'startTime': '${startTime.hour}:${startTime.minute}',
      'intervalTime': '${intervalTime.hour}:${intervalTime.minute}',
      'overTime': '${overTime.hour}:${overTime.minute}',
    };

    for (int i = 0; i < subjectTimes.length; i++) {
      scheduleData['subject${i + 1}'] =
          '${subjectTimes[i].hour}:${subjectTimes[i].minute}';
    }

    await firestore
        .collection('scheduleUpdate')
        .doc('scheduleUpdate')
        .set(scheduleData);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Schedule Updated!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    String currentDateTime = DateFormat('yyyy-MM-dd').format(DateTime.now());

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.blue,
        toolbarHeight: 80,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                ClipOval(
                  child: Image.asset(
                    'lib/images/logo.jpg',
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "School Bell System",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      currentDateTime,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            IconButton(
              icon: const Icon(Icons.logout, color: Colors.white),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              ListTile(
                title: Text('Type', style: TextStyle(fontSize: 18)),
                trailing: DropdownButton<String>(
                  value: selectedType,
                  hint: Text('Select Type'),
                  items: types.map((String type) {
                    return DropdownMenuItem<String>(
                      value: type,
                      child: Text(type),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedType = newValue;
                    });
                  },
                ),
              ),
              Divider(),
              ListTile(
                title: Text('Start Time', style: TextStyle(fontSize: 18)),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(startTime.format(context)),
                    IconButton(
                      icon: Icon(Icons.access_time),
                      onPressed: () => _selectTime(
                          context, (time) => setState(() => startTime = time)),
                    ),
                  ],
                ),
              ),
              Divider(),
              for (int i = 0; i < subjectTimes.length; i++) ...[
                ListTile(
                  title: Text('Subject ${i + 1} Time',
                      style: TextStyle(fontSize: 18)),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(subjectTimes[i].format(context)),
                      IconButton(
                        icon: Icon(Icons.access_time),
                        onPressed: () => _selectTime(context,
                            (time) => setState(() => subjectTimes[i] = time)),
                      ),
                    ],
                  ),
                ),
                Divider(),
              ],
              ListTile(
                title: Text('Interval Time', style: TextStyle(fontSize: 18)),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(intervalTime.format(context)),
                    IconButton(
                      icon: Icon(Icons.access_time),
                      onPressed: () => _selectTime(
                          context,
                          (time) => setState(() => intervalTime = time)),
                    ),
                  ],
                ),
              ),
              Divider(),
              ListTile(
                title: Text('Over Time', style: TextStyle(fontSize: 18)),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(overTime.format(context)),
                    IconButton(
                      icon: Icon(Icons.access_time),
                      onPressed: () => _selectTime(
                          context, (time) => setState(() => overTime = time)),
                    ),
                  ],
                ),
              ),
              Center(
                child: ElevatedButton(
                  onPressed: _saveScheduleToFirebase,
                  child: Text('Update Schedule'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
