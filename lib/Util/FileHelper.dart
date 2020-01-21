import 'dart:async';
import 'dart:core';
import 'dart:io'; // as io;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../Models/App_Models.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import '../Models/Session.dart';
import '../Models/EventAttendie.dart';
import 'package:sprintf/sprintf.dart';
import 'package:synchronized/synchronized.dart';
import '../Models/AppData.dart';
import '../Models/WaverObj.dart';

class FileHelper {
  CurrentSession sessionData;
  FileHelper([CurrentSession sess]) {
    sessionData = sess;
  }
  static FileHelper _FileHelper;

  //base location of the attendence file location
  Future<String> get BASEPATH async {
    final directory = await getApplicationDocumentsDirectory();
    String path = directory.path + "/Tracker";
    return path;
  }

  //check to see if directory exist if not create it
  Future<void> checkIfDirectoryExist() async {
    if (!await Directory(await BASEPATH).exists()) {
      final directory = await getApplicationDocumentsDirectory();
      String path = directory.path + "/Tracker";
      new Directory(path).create();
    }
  }

  Future<String> getWaiverDirectory() async {
    final bpath = await BASEPATH;
    String fPath = bpath + "/Waivers";
    return fPath;
  }

  Future<String> getSessionsFilePath() async {
    final bpath = await BASEPATH;
    String month = DateFormat.MMMM("en_US").format(new DateTime.now());
    String year = DateFormat.y("en_US").format(new DateTime.now());
    String path = bpath + "/AllSessions_" + month + year + ".csv";
    return path;
  }

  Future<String> getRolesFilePath() async {
    final bpath = await BASEPATH;
    String month = DateFormat.MMMM("en_US").format(new DateTime.now());
    String year = DateFormat.y("en_US").format(new DateTime.now());
    final path = bpath + "/Roles_" + month + year + ".csv";
    return path;
  }

  Future<String> getValidUsersFilePath() async {
    final bpath = await BASEPATH;
    String month = DateFormat.MMMM("en_US").format(new DateTime.now());
    String year = DateFormat.y("en_US").format(new DateTime.now());
    final path = await bpath + "/Users" + "_" + month + year + ".csv";
    return path;
  }

  Future<String> getAttendenceFilePath() async {
    final bpath = await BASEPATH;
    String dept = sessionData.department;
    String month = DateFormat.MMMM("en_US").format(new DateTime.now());
    String year = DateFormat.y("en_US").format(new DateTime.now());
    final path =
        await bpath + "/Atendance/" + dept + "_" + month + "_" + year + ".csv";
    return path;
  }

  Future<String> get getAttendenceFileName async {
    String dept = sessionData.department;
    String month = DateFormat.MMMM("en_US").format(new DateTime.now());
    String year = DateFormat.y("en_US").format(new DateTime.now());
    String path = dept + "_Attendence_" + month + "_" + year + ".csv";
    return path;
  }

//get all the files in a direcotry and filter for current department
  Future<List<String>> GetAllFilesinGroup() async {
    List<String> newList = new List<String>();
    List filList = new List();
    final bpath = await BASEPATH + "/Attendence/";
    String lookingName = sessionData.department + "_Attendence";
    filList = Directory(bpath).listSync();
    filList.forEach((item) {
      if (item.Contains(lookingName)) {
        newList.add(item);
      }
    });
    return newList;
  }

  //get waver files
  Future<String> GetWaiverFile(String fName) async {
    String fPath = await BASEPATH + "/Waivers";
    String newFilePath = fPath + "/" + fName;
    return newFilePath;
  }

  Future<bool> writeEventSessions(List<CurrentSession> acsess) async {
    final lock = new Lock();
    List<String> allSessions = new List();
    try {
      String filepath = await getSessionsFilePath();
      String head =
          'flEventSessionId,fLeventIDfk,campusLocation,trainer,timeOfDay,day,department,trainingGroup,weekofClass,divison,requireWaiver,waiverName,startDate';

      for (int row = 0; row < acsess.length; row++) {
        String line = sprintf('%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s', [
          acsess[row].flEventSessionId.toString(),
          acsess[row].fLeventIDfk.toString(),
          acsess[row].campusLocation,
          acsess[row].trainer,
          acsess[row].timeOfDay,
          acsess[row].day,
          acsess[row].department,
          acsess[row].trainingGroup,
          acsess[row].weekofClass,
          acsess[row].divison,
          acsess[row].requireWaiver,
          acsess[row].waiverName == "" ? "NONE" : acsess[row].waiverName,
          acsess[row].startDate
        ]);
        allSessions.add(line);
      }
      //check to see if directory exist if not create it
      if (!await Directory(await BASEPATH).exists()) {
        final directory = await getApplicationDocumentsDirectory();
        String path = directory.path + "/Tracker";
        new Directory(path).create();
      }

      //delete file if exist
      if (await File(filepath).exists()) {
        File(filepath).delete();
      }
      File newfile = new File(filepath);
      // var logFile = File('log.txt');
      // var sink = newfile.openWrite();
      var sink2 = newfile.openWrite(mode: FileMode.append);
      sink2.write(head + '\n');
      for (int i = 0; i < allSessions.length; i++) {
        sink2.write(
          allSessions[i] + '\n',
        );
      }
      // await sink.flush();
      await sink2.flush();
      // await sink.close();
      await sink2.close();

      return true;
      //await return true;
    } catch (ex) {
      print("file writeEventSessions 139: " + ex.toString());
      return false;
    }
  }

  Future send(File file, String message) async {
    try {
      await file.writeAsString(message + '\n',
          mode: FileMode.append, flush: false);
    } catch (e) {
      print("Error: $e");
    }
    return await file.length();
  }

  Future<List<CurrentSession>> readSessionsFile() async {
    String file = await getSessionsFilePath();
    List<CurrentSession> allSession = new List<CurrentSession>();
    try {
      if (await File(file).exists()) {
        File newFile = new File(file);
        //String line;
        List<String> glines = await newFile.readAsLines();
        print('The file is ${glines.length} lines long.');

        await Future.forEach(glines, (str) async {
          List<String> lineItem = str.split(',');
          if (lineItem[0] != "flEventSessionId") {
            CurrentSession csess = new CurrentSession();
            // List<String> lineItem = glines[row].split(',');
            csess.flEventSessionId = lineItem[0];
            csess.fLeventIDfk = lineItem[1];
            csess.campusLocation = lineItem[2];
            csess.trainer = lineItem[3];
            csess.timeOfDay = lineItem[4];
            csess.day = lineItem[5];
            csess.department = lineItem[6];
            csess.trainingGroup = lineItem[7];
            csess.weekofClass = lineItem[8];
            csess.divison = lineItem[9] + "-" + lineItem[6];
            csess.requireWaiver = lineItem[10] == null ? "NO" : "Yes";
            csess.waiverName = lineItem[11] == null ? "" : lineItem[11];
            csess.startDate = DateTime.parse(lineItem[12]);
            allSession.add(csess);
          }
          //  'flEventSessionId,fLeventIDfk,campusLocation,trainer,timeOfDay,day,department 6,trainingGroup,weekofClass,divison,requireWaiver,waiverName,startDate';
        });
      }
    } catch (ex) {
      print("file readSessionsFile 227 :" + ex.toString());
    }
    return allSession;
  }

  Future<bool> writeRoles(List<Role> roles) async {
    final lock = new Lock();
    bool status = false;
    List<String> allRoles = new List();
    try {
      final filepath = await getRolesFilePath();
      String head = 'rName,user,empLid';

      for (int row = 0; row < roles.length; row++) {
        String line = sprintf(
            '%s,%s,%s', [roles[row].rName, roles[row].user, roles[row].empLid]);
        allRoles.add(line);
      }

      //check to see if directory exist if not create it
      await checkIfDirectoryExist();

      //delete file if exist
      if (await File(filepath).exists()) {
        File(filepath).delete();
      }
      File newfile = new File(filepath);
      // var logFile = File('log.txt');
      // var sink = newfile.openWrite();
      var sink2 = newfile.openWrite(mode: FileMode.append);
      sink2.write(head + '\n');
      for (int i = 0; i < allRoles.length; i++) {
        sink2.write(allRoles[i] + '\n');
      }
      // await sink.flush();
      await sink2.flush();
      // await sink.close();
      await sink2.close();

      return true;
      //await return true;
    } catch (ex) {
      print("file writeRoles 276: " + ex.toString());
      return false;
    }
  }

  Future<List<Role>> readRolesFile() async {
    String file = await getSessionsFilePath();
    List<Role> allRoles = new List<Role>();
    final filepath = await getRolesFilePath();
    try {
      if (await File(filepath).exists()) {
        File newFile = new File(filepath);
        //String line;
        List<String> glines = await newFile.readAsLines();
        print('The Roles file is ${glines.length} lines long.');
        await Future.forEach(glines, (str) async {
          List<String> lineItem = str.split(',');
          if (lineItem[0] != "rName") {
            Role csess = new Role();
            // List<String> lineItem = glines[row].split(',');
            csess.rName = lineItem[0];
            csess.user = lineItem[1];
            csess.empLid = lineItem[2];
            allRoles.add(csess);
          }
        });
      }
    } catch (ex) {
      print("file readRolesFile 292 :" + ex.toString());
    }
    return allRoles;
  }

  Future<bool> writeValidUsers(List<ValidUser> validUser) async {
    WidgetsFlutterBinding.ensureInitialized();
    bool status = false;
    List<String> allValidUser = new List();
    String line = "";
    try {
      final filepath = await getValidUsersFilePath();
      if (await File(filepath).exists()) {
        List<String> glines = await File(filepath).readAsLines();
        if (validUser.length == glines.length) {
          return true;
        }
        File(filepath).delete();
      }
      String head = 'cardId,barcode,empLid';
      for (int row = 0; row < validUser.length; row++) {
        String line = sprintf('%s,%s,%s', [
          validUser[row].cardId.toString(),
          validUser[row].barcode.toString(),
          validUser[row].empLid
        ]);
        allValidUser.add(line);
      }

      //check to see if directory exist if not create it
      await checkIfDirectoryExist();

      //delete file if exist
      /*
      if (await File(filepath).exists()) {
        List<String> glines = await File(filepath).readAsLines();
        if (validUser.length == glines.length) {
          return true;
        }
        File(filepath).delete();
      }

       */
      File newfile = new File(filepath);
      var sink2 = newfile.openWrite(mode: FileMode.append);
      sink2.write(head + '\n');
      for (int i = 0; i < allValidUser.length; i++) {
        sink2.write(allValidUser[i] + '\n');
      }

      // await sink.flush();
      await sink2.flush();
      // await sink.close();
      await sink2.close();

      return true;
      //await return true;
    } catch (ex) {
      print("file writeRoles 276: " + ex.toString());
      return false;
    }
  }

  Future<List<ValidUser>> readValidUsers() async {
    List<ValidUser> allValidUser = new List<ValidUser>();
    final filepath = await getValidUsersFilePath();
    try {
      if (await File(filepath).exists()) {
        File newFile = new File(filepath);
        //String line;
        List<String> glines = await newFile.readAsLines();
        print('The ValidUsers file is ${glines.length} lines long.');
        await Future.forEach(glines, (str) async {
          List<String> lineItem = str.split(',');
          if (lineItem[0] != "cardId") {
            ValidUser csess = new ValidUser();
            // List<String> lineItem = glines[row].split(',');
            csess.cardId = lineItem[0];
            csess.barcode = lineItem[1];
            csess.empLid = lineItem[2];
            allValidUser.add(csess);
          }
        });
      } else {
        return null;
      }
    } catch (ex) {
      print("file readallValidUserFile 358 :" + ex.toString());
    }
    return allValidUser;
  }

  Future<bool> writeDepartments(List<String> input) async {
    bool status = false;
    List<String> allDepartments = new List();
    final bpath = await BASEPATH;
    String filepath = bpath + "/Departments.csv";
    try {
      // final filepath = await getValidUsersFilePath();
      String head = 'Departments';
      String items = "";
      for (int row = 0; row < input.length; row++) {
        String line = input[row];
        allDepartments.add(line);
      }
      //check to see if directory exist if not create it
      await checkIfDirectoryExist();
      //delete file if exist
      if (await File(filepath).exists()) {
        File(filepath).delete();
      }
      File newfile = new File(filepath);
      var sink2 = newfile.openWrite(mode: FileMode.append);
      sink2.write(head + '\n');
      for (int i = 0; i < allDepartments.length; i++) {
        sink2.write(allDepartments[i] + '\n');
      }
      // await sink.flush();
      await sink2.flush();
      // await sink.close();
      await sink2.close();

      return true;
      //await return true;
    } catch (ex) {
      print("file writeRoles 276: " + ex.toString());
      return false;
    }
  }

  Future<List<String>> readDepartments() async {
    List<String> allDepartments = new List<String>();
    final bpath = await BASEPATH;
    final filepath = bpath + "/Departments.csv";
    try {
      if (await File(filepath).exists()) {
        File newFile = File(filepath);
        List<String> glines = await newFile.readAsLines();
        print('The ValidUsers file is ${glines.length} lines long.');
        await Future.forEach(glines, (str) async {
          if (str != "Departments") {
            allDepartments.add(str);
          }
        });
      } else {
        return null;
      }
    } catch (ex) {
      print("file readallValidUserFile 358 :" + ex.toString());
    }
    return allDepartments;
  }

  Future<bool> writeAttendieToFile(EventAttendie eventAttendie) async {
    String month = DateFormat.MMMM("en_US").format(new DateTime.now());
    String year = DateFormat.y("en_US").format(new DateTime.now());
    String path = await getAttendenceFilePath();
    List<String> data = new List<String>();
    var BarcodeId = eventAttendie.StudentBarCode.toString();
    var StudentId = eventAttendie.StudentId.toString();
    var EventSessionId_fk = eventAttendie.EventSessionId_fk;
    var FLEventId_FK = eventAttendie.FLEventId_FK;
    var Date = eventAttendie.Date;
    var WeekOfClass = eventAttendie.WeekOfClass;
    var HasCheckWaiver = eventAttendie.HasCheckWaiver;
    var OtherAttLocation = eventAttendie.OtherAttLocation;
    var SignedInBy = eventAttendie.SignedInBy;

    var line =
        '$StudentId, $BarcodeId, $EventSessionId_fk, $FLEventId_FK, $Date, $WeekOfClass, $HasCheckWaiver, $eventAttendie, $SignedInBy, $OtherAttLocation';
    var head =
        '"StudentId", "BarcodeId", "EventSessionId_fk", "FLEventId_FK", "Date", "WeekOfClass", "HasCheckWaiver", "SignedInBy","OtherAttLocation"';
    data.add(line);
    //  WriteFile(path, head, data);

    return true;
  }

  Future<bool> writeDataInfoToFile(CurrentDataInfo cDataInfo) async {
    final bpath = await BASEPATH;
    String filepath = bpath + "/CurrentDataInfo.csv";
    try {
      //check to see if directory exist if not create it
      await checkIfDirectoryExist();

      //delete file if exist
      if (await File(filepath).exists()) {
        File(filepath).delete();
      }
      File newfile = new File(filepath);
      var sink2 = newfile.openWrite(mode: FileMode.append);

      String mon = cDataInfo.month;
      String from = cDataInfo.from;
      String to = cDataInfo.to;
      String count = cDataInfo.rcount;

      sink2.write("Month: $mon \n");
      sink2.write("From: $from - To: $to \n");
      sink2.write("From: $from \n");
      sink2.write("To: $to \n");
      sink2.write("$count");
      // await sink.flush();
      await sink2.flush();
      // await sink.close();
      await sink2.close();
      return true;
      //await return true;
    } catch (ex) {
      print("file writeRoles 276: " + ex.toString());
      return false;
    }
  }

  Future<CurrentDataInfo> readDataInfoFromFile() async {
    final bpath = await BASEPATH;
    CurrentDataInfo _currentDataInfo = new CurrentDataInfo();
    String filepath = bpath + "/CurrentDataInfo.csv";
    try {
      if (await File(filepath).exists()) {
        File newFile = new File(filepath);
        //String line;
        List<String> glines = await newFile.readAsLines();
        _currentDataInfo.month = glines[0];
        _currentDataInfo.dateSpan = glines[1];
        _currentDataInfo.from = await new Future.value(glines[2]);
        _currentDataInfo.to = await new Future.value(glines[3]);
        _currentDataInfo.rcount = await new Future.value(glines[4]);
      }
    } catch (ex) {
      print("file readallValidUserFile 358 :" + ex.toString());
      return null;
    }
    return _currentDataInfo;
  }

  Future<void> writewaverObjs(List<WaverObj> waverObj) async {
    //final bpath = await BASEPATH + ;
    final bpath = getWaiverDirectory().toString();
    try {
      for (int i = 0; i < waverObj.length; i++) {
        String path = bpath + "/" + waverObj[i].name;
        ByteData bData = waverObj[i].doc;
        final buffer = bData.buffer;
        new File(path).writeAsBytes(
            buffer.asUint8List(bData.offsetInBytes, bData.lengthInBytes));
      }
    } catch (ex) {
      print("file writewaverObjs 531 :" + ex.toString());
      return null;
    }
  }
} //end of class
