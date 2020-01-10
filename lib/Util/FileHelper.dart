import 'dart:async';
import 'dart:core';
import 'dart:io';// as io;
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import '../Models/Session.dart';
import '../Models/EventAttendie.dart';


class FileHelper {
  CurrentSession sessionData;

  //base location of the attendence file location
  Future<String> get BASEPATH async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }


  Future<File> getSessionsFile() async {
    final bpath = await BASEPATH;
    String dept = sessionData.department;
    String month = DateFormat.MMMM("en_US").format(new DateTime.now());
    String year = DateFormat.y("en_US").format(new DateTime.now());
    final path = await bpath +
        "/Tracker/Sessions" +
        "_" +
        month +
        "_" +
        year +
        ".csv";
    return File(path);
  }

  Future<File> getRolesFile() async {
    final bpath = await BASEPATH;
    String dept = sessionData.department;
    String month = DateFormat.MMMM("en_US").format(new DateTime.now());
    String year = DateFormat.y("en_US").format(new DateTime.now());
    final path = await bpath +
        "/Tracker/Roles" +
        "_" +
        month +
        "_" +
        year +
        ".csv";
    return File(path);
  }

  Future<File> getValidUsersFile() async {
    final bpath = await BASEPATH;
    String dept = sessionData.department;
    String month = DateFormat.MMMM("en_US").format(new DateTime.now());
    String year = DateFormat.y("en_US").format(new DateTime.now());
    final path = await bpath +
        "/Tracker/users" +
        "_" +
        month +
        "_" +
        year +
        ".csv";
    return File(path);
  }


  Future<File> getAttendenceFile() async {
    final bpath = await BASEPATH;
    String dept = sessionData.department;
    String month = DateFormat.MMMM("en_US").format(new DateTime.now());
    String year = DateFormat.y("en_US").format(new DateTime.now());
    final path = await bpath +
        "/Tracker/Atendance/" +
        dept +
        "_" +
        month +
        "_" +
        year +
        ".csv";
    return File(path);
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


  Future<bool> WriteSessionToFile(List<CurrentSession> csess) async {
    File file = await getSessionsFile();
    String head = "'flEventSessionId','fLeventIDfk','campusLocation','trainer','timeOfDay','day','department','trainingGroup','weekofClass','divison','requireWaiver','waiverName','startDate'";
    csess.forEach((r) {
      var line = r.flEventSessionId,r.fLeventIDfk','$r.campusLocation','$r.trainer','$r.timeOfDay','$r.day','$r.department','$r.trainingGroup','$r.weekofClass','$r.divison','$r.requireWaiver','$r.waiverName','$r.startDate'";
    })

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

/*
 Future<void> WriteFile(string file, string header, List<string> data) async
        {
            try
            {
                //string FilePath = GetFilePath(file);
                if (!Directory.Exists(BASEPATH))
                {
                    var documents = Environment.GetFolderPath(Environment.SpecialFolder.MyDocuments);
                    var directoryname = Path.Combine(documents, "FitLife");
                    Directory.CreateDirectory(directoryname);
                }
                var newAtten = FILEBASEPATH + "/Attendence";
                if (!Directory.Exists(newAtten))
                {
                    var directoryname = Path.Combine(FILEBASEPATH, "Attendence");
                    Directory.CreateDirectory(directoryname);
                }

                if (!File.Exists(file))
                {
                    File.Create(file).Dispose();
                    // File.AppendText()
                    using (var w = File.AppendText(file))
                    {
                        w.WriteLine(header);
                        foreach (var line in data)
                        {
                            w.WriteLine(line);
                        }
                        w.Flush();
                        w.Close();
                    }

                }
                else if (File.Exists(file))
                {
                    //File.Delete(file);
                    //File.Create(file).Dispose();
                    using (var w = File.AppendText(file))
                    {
                        // w.WriteLine(header);
                        foreach (var line in data)
                        {
                            w.WriteLine(line);
                        }
                        w.Flush();
                        w.Close();
                        //}
                    }
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine("ERROR Writing:" + ex.Message);
            }
        }

*/
} //end of class
