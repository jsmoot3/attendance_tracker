import 'dart:async';
import 'dart:core';
import 'dart:io'; // as io;
import 'dart:convert';
import '../Models/App_Models.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import '../Models/Session.dart';
import '../Models/EventAttendie.dart';
import 'package:sprintf/sprintf.dart';
import 'package:synchronized/synchronized.dart';

class FileHelper {
  CurrentSession sessionData;
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

  Future<String> getSessionsFilePath() async {
    final bpath = await BASEPATH;
    String month = DateFormat.MMMM("en_US").format(new DateTime.now());
    String year = DateFormat.y("en_US").format(new DateTime.now());
    String path = bpath + "/AllSessions_" + month + year + ".csv";
    return path;
  }

  Future<String> getRolesFilePath() async {
    final bpath = await BASEPATH;
    String dept = sessionData.department;
    String month = DateFormat.MMMM("en_US").format(new DateTime.now());
    String year = DateFormat.y("en_US").format(new DateTime.now());
    final path = bpath + "/Roles_" + month + "_" + year + ".csv";
    return path;
  }

  Future<File> getValidUsersFile() async {
    final bpath = await BASEPATH;
    String dept = sessionData.department;
    String month = DateFormat.MMMM("en_US").format(new DateTime.now());
    String year = DateFormat.y("en_US").format(new DateTime.now());
    final path =
        await bpath + "/Tracker/users" + "_" + month + "_" + year + ".csv";
    return File(path);
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
        /*
        for (int row = 0; row < glines.length; row++) {
          CurrentSession csess = new CurrentSession();
          List<String> lineItem = glines[row].split(',');
          csess.flEventSessionId = lineItem[0].trim();
          csess.fLeventIDfk = lineItem[1].trim();
          csess.campusLocation = lineItem[2].trim();
          csess.trainer = lineItem[5].trim();
          csess.timeOfDay = lineItem[3].trim();
          csess.day = lineItem[4].trim();
          csess.department = lineItem[5].trim();
          csess.trainingGroup = lineItem[6].trim();
          csess.weekofClass = lineItem[2].trim();
          csess.divison = lineItem[8].trim() + "-" + lineItem[6].trim();
          csess.requireWaiver.trim();
          csess.waiverName = lineItem[10] ?? "";
          csess.startDate = DateTime.parse(lineItem[9]);
          allSession.add(csess);
        }
*/
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
    List<String> allRoles = new List();
    try {
      final filepath = await getRolesFilePath();
      String head = 'rName,user,empLid';
/*
      String rName;
      String user;
      String empLid;
 */
      for (int row = 0; row < roles.length; row++) {
        String line = sprintf(
            '%s,%s,%s', [roles[row].rName, roles[row].user, roles[row].empLid]);
        allRoles.add(line);
      }
      /*
      //check to see if directory exist if not create it
      if (!await Directory(await BASEPATH).exists()) {
        final directory = await getApplicationDocumentsDirectory();
        String path = directory.path + "/Tracker";
        new Directory(path).create();
      }
      */

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

  Future<bool> WriteAttendieToFile(EventAttendie eventAttendie) async {
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
} //end of class
