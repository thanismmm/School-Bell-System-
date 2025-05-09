import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class ScheduleProvider with ChangeNotifier {
  // Time lists
  final List<TimeOfDay> _regularTimes = List.generate(15, (_) => TimeOfDay.now());
  final List<TimeOfDay> _fridayTimes = List.generate(11, (_) => TimeOfDay.now());
  final List<TimeOfDay> _examTimes = List.generate(8, (_) => TimeOfDay.now());

  // Bell settings
  String _bellType = '10';
  int _shortBellDuration = 5;
  int _longBellDuration = 15;
  bool _emergencyRing = true;
  List<int> _morningBellMode = [0, 6, 4];
  List<int> _intervalBellMode = [0, 4, 3];
  List<int> _closingBellMode = [0, 5, 2];
  bool _isUpdating = false;

  // Audio files
  String _audioList = 'Mor_Str.mp3,Mor_End.mp3,Sub_1.mp3,Sub_2.mp3,Interval.mp3';
  String _audioListF = 'aa.mp3';

  // Getters
  List<TimeOfDay> get regularTimes => _regularTimes;
  List<TimeOfDay> get fridayTimes => _fridayTimes;
  List<TimeOfDay> get examTimes => _examTimes;
  String get bellType => _bellType;
  int get shortBellDuration => _shortBellDuration;
  int get longBellDuration => _longBellDuration;
  bool get emergencyRing => _emergencyRing;
  List<int> get morningBellMode => _morningBellMode;
  List<int> get intervalBellMode => _intervalBellMode;
  List<int> get closingBellMode => _closingBellMode;
  String get audioList => _audioList;
  String get audioListF => _audioListF;
  bool get isUpdating => _isUpdating;

  TimeOfDay getCurrentTime(String scheduleType, int index) {
    switch (scheduleType) {
      case 'Regular':
        return _regularTimes[index];
      case 'Friday':
        return _fridayTimes[index];
      case 'Exam':
        return _examTimes[index];
      default:
        return TimeOfDay.now();
    }
  }

  int getTimeCount(String scheduleType) {
    switch (scheduleType) {
      case 'Regular':
        return _regularTimes.length;
      case 'Friday':
        return _fridayTimes.length;
      case 'Exam':
        return _examTimes.length;
      default:
        return 0;
    }
  }

  Future<void> fetchScheduleFromFirebase() async {
    try {
      final snapshot = await FirebaseDatabase.instance.ref().get();
      if (snapshot.exists) {
        final data = snapshot.value as Map<dynamic, dynamic>;
        
        _updateTimes(data);
        _updateBellSettings(data);
        _updateAudioFiles(data);
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading schedule: $e');
    }
  }

  void updateTime(String scheduleType, int index, TimeOfDay time) {
    switch (scheduleType) {
      case 'Regular':
        _regularTimes[index] = time;
        break;
      case 'Friday':
        _fridayTimes[index] = time;
        break;
      case 'Exam':
        _examTimes[index] = time;
        break;
    }
    notifyListeners();
  }

  void updateBellType(String value) {
    _bellType = value;
    notifyListeners();
  }

  void updateShortBellDuration(String value) {
    _shortBellDuration = int.tryParse(value) ?? 5;
    notifyListeners();
  }

  void updateLongBellDuration(String value) {
    _longBellDuration = int.tryParse(value) ?? 15;
    notifyListeners();
  }

  void toggleEmergencyRing(bool value) {
    _emergencyRing = value;
    notifyListeners();
  }

  void updateMorningBellMode(int index, int value) {
    _morningBellMode[index] = value;
    notifyListeners();
  }

  void updateIntervalBellMode(int index, int value) {
    _intervalBellMode[index] = value;
    notifyListeners();
  }

  void updateClosingBellMode(int index, int value) {
    _closingBellMode[index] = value;
    notifyListeners();
  }

  void updateAudioList(String value) {
    _audioList = value;
    notifyListeners();
  }

  void updateAudioListF(String value) {
    _audioListF = value;
    notifyListeners();
  }

  Future<void> saveScheduleToFirebase() async {
    _isUpdating = true;
    notifyListeners();
     try {
      final updates = {
        'R_Time': _regularTimes.map(_formatDatabaseTime).join(','),
        'F_Time': _fridayTimes.map(_formatDatabaseTime).join(','),
        'E_Time': _examTimes.map(_formatDatabaseTime).join(','),
        'Bell_Type': _bellType,
        'S_Bell_Dur': _shortBellDuration.toString(),
        'L_Bell_Dur': _longBellDuration,
        'Emergency_Ring': _emergencyRing ? 1 : 0,
        'Mor_Bell_Mode': _morningBellMode.join(','),
        'Int_Bell_Mode': _intervalBellMode.join(','),
        'Clo_Bell_Mode': _closingBellMode.join(','),
        'Audio_List': _audioList,
        'Audio_List_F': _audioListF,
        'Updated_Time': DateTime.now().millisecondsSinceEpoch ~/ 1000,
        'Update': "20",
        'Status': {'value': 1},
        'count': 5,
      };

      await FirebaseDatabase.instance.ref().update(updates);
    } catch (e) {
      debugPrint('Error saving schedule: $e');
      rethrow;
    } finally {
      _isUpdating = false;
      notifyListeners();
    }
  }

  void _updateTimes(Map<dynamic, dynamic> data) {
    _updateTimeList(data['R_Time'], _regularTimes);
    _updateTimeList(data['F_Time'], _fridayTimes);
    _updateTimeList(data['E_Time'], _examTimes);
  }

  void _updateTimeList(String? timeString, List<TimeOfDay> timeList) {
    if (timeString != null) {
      final times = timeString.split(',');
      for (int i = 0; i < times.length && i < timeList.length; i++) {
        timeList[i] = _parseDatabaseTime(times[i]);
      }
    }
  }

  void _updateBellSettings(Map<dynamic, dynamic> data) {
    _bellType = data['Bell_Type']?.toString() ?? '10';
    _shortBellDuration = int.tryParse(data['S_Bell_Dur']?.toString() ?? '5') ?? 5;
    _longBellDuration = data['L_Bell_Dur'] ?? 15;
    _emergencyRing = data['Emergency_Ring'] == 1;
    
    _updateBellMode(data['Mor_Bell_Mode'], _morningBellMode);
    _updateBellMode(data['Int_Bell_Mode'], _intervalBellMode);
    _updateBellMode(data['Clo_Bell_Mode'], _closingBellMode);
  }

  void _updateBellMode(String? modeString, List<int> modeList) {
    if (modeString != null) {
      final modes = modeString.split(',').map((e) => int.tryParse(e) ?? 0).toList();
      for (int i = 0; i < modes.length && i < modeList.length; i++) {
        modeList[i] = modes[i];
      }
    }
  }

  void _updateAudioFiles(Map<dynamic, dynamic> data) {
    _audioList = data['Audio_List'] ?? 'Mor_Str.mp3,Mor_End.mp3,Sub_1.mp3,Sub_2.mp3,Interval.mp3';
    _audioListF = data['Audio_List_F'] ?? 'aa.mp3';
  }

  TimeOfDay _parseDatabaseTime(String timeStr) {
    try {
      final padded = timeStr.padLeft(6, '0');
      final hour = int.parse(padded.substring(0, 2));
      final minute = int.parse(padded.substring(2, 4));
      return TimeOfDay(hour: hour, minute: minute);
    } catch (e) {
      return TimeOfDay.now();
    }
  }

  String _formatDatabaseTime(TimeOfDay time) {
    return '${time.hour.toString().padLeft(2, '0')}${time.minute.toString().padLeft(2, '0')}00';
  }
}