import 'dart:async';
import 'dart:core';
import 'dart:io'; // as io;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import '../Models/Session.dart';
import '../Models/EventAttendie.dart';
import 'package:sprintf/sprintf.dart';

class FileHelper {
  CurrentSession sessionData;
  static FileHelper _FileHelper;

  //base location of the attendence file location
  Future<String> get BASEPATH async {
    final directory = await getApplicationDocumentsDirectory();
    String path = directory.path + "/Tracker";
    return path;
  }

  Future<String> getSessionsFilePath() async {
    final bpath = await BASEPATH;
    String month = DateFormat.MMMM("en_US").format(new DateTime.now());
    String year = DateFormat.y("en_US").format(new DateTime.now());
    String path = bpath + "/AllSessions_" + month + year + ".csv";
    return path;
  }

  Future<File> getRolesFile() async {
    final bpath = await BASEPATH;
    String dept = sessionData.department;
    String month = DateFormat.MMMM("en_US").format(new DateTime.now());
    String year = DateFormat.y("en_US").format(new DateTime.now());
    final path =
        await bpath + "/Tracker/Roles" + "_" + month + "_" + year + ".csv";
    return File(path);
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
    List<String> allSessions = new List<String>();
    try {
      String filepath = await getSessionsFilePath();
      String head =
          "'flEventSessionId','fLeventIDfk','campusLocation','trainer','timeOfDay','day','department','trainingGroup','weekofClass','divison','requireWaiver','waiverName','startDate'";

      for (int row = 0; row < acsess.length; row++) {
        // CurrentSession r = acsess[s];
        String line = sprintf('%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,', [
          // grop.FLEventSessionID, grop.FLeventIDfk, grop.CampusLocation, grop.TimeOfDay, grop.Day, grop.Department, grop.TrainingGroup, grop.WeekofClass, grop.Divison, grop.StartDate, grop.WaiverName ?? "NONE",grop.RequireWaiver);
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
        //var documents = Environment.GetFolderPath(Environment.SpecialFolder.MyDocuments);
        // var directoryname = Path.Combine(documents, "FitLife");
        new Directory(path).create();
      }
      if (await File(filepath).exists()) {
        File(filepath).delete();
        // File.AppendText()
      }
      // File newfile = new File(file);
      new File(filepath).writeAsString("$head");
      for (int i = 0; i < allSessions.length; i++) {
        //if (i > 0) {
          File(filepath).writeAsString(allSessions[i]);
        //}
      }
      return true;
      //await return true;
    } catch (ex) {
      print("file writeEventSessions 139: " + ex.toString());
      return false;
    }
  }

  Future<List<CurrentSession>> readSessionsFile() async {
    String file = await getSessionsFilePath();
    List<CurrentSession> allSession = new List<CurrentSession>();
    try {
      if (await File(file).exists()) {
        File newFile = new File(file);
        String line;
        List<String> glines = await newFile.readAsLines();

        //newFile..readAsLines().then()
        glines.forEach((line) {
          CurrentSession csess = new CurrentSession();
          List<String> lineItem = line.split(',');
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
        });

        /*
    String flEventSessionId;
  String fLeventIDfk;
  String campusLocation;
  String trainer;
  String timeOfDay;
  String day;
  String department;
  String trainingGroup;
  String weekofClass;
  String divison;
  String requireWaiver;
  String waiverName;
  DateTime startDate;

    */
      }
      return await allSession;
    } catch (ex) {
      print("file readSessionsFile 227 :" + ex.Message);
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
