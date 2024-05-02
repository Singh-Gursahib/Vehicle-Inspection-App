import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:my_mechanic_qld/mobile.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'mobile.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Vehicle Inspection App',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: HomeScreen(), // Set HomeScreen as the home widget
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF21ce88),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 300,
              child: Text(
                'Welcome to \nMy Mechanic QLD Inspection Application',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 40),
            Image.asset('lib/assets/logo.png', width: 200, height: 200),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => InspectionStepper()),
                );
              },
              child: Text('Start Inspection'),
            ),
          ],
        ),
      ),
    );
  }
}

class VehicleInspectionForm {
  String customerName = '';
  DateTime dateInspected = DateTime.now();
  String makeModel = '';
  String registrationNumber = '';
  String yearOfVehicle = '';
  String vin = '';
  double odometerReading = 0.0;
  List<String> imagePaths = []; // List of image file paths

  // Interior Inspection Fields
  String seats = 'N/A';
  String seatBelts = 'N/A';
  String otherTrims = 'N/A';
  String radio = 'N/A';
  String rearWindowDemister = 'N/A';
  String airConditioning = 'N/A';
  String heaterDemister = 'N/A';
  String washersWipers = 'N/A';
  String horn = 'N/A';
  String doorsLocksHinges = 'N/A';
  String windowOperation = 'N/A';
  String warningLightsGaugesDash = 'N/A';
  String allLights = 'N/A';
  String interiorComments = '';
  List<String> interiorImages = [];
  // Add more fields for Interior Inspection

  // Exterior Inspection Fields
  String rust = 'N/A';
  String bodyRepairs = 'N/A';
  String glassMirrors = 'N/A';
  String sunroofAerialConvertible = 'N/A';
  String framesMembers = 'N/A';
  String underBodyParts = 'N/A';
  String frontSuspension = 'N/A';
  String rearSuspension = 'N/A';
  String steeringComponents = 'N/A';
  String autoManualTransmission = 'N/A';
  String exhaust = 'N/A';
  String differential = 'N/A';
  String driveShafts = 'N/A';
  String exteriorComments = '';
  List<String> exteriorImages = [];

  // Engine Bay Inspection Fields
  String noise = 'N/A';
  String fluidLevel = 'N/A';
  String fluidLeaks = 'N/A';
  String mountings = 'N/A';
  String hosesPipes = 'N/A';
  String waterPumpFan = 'N/A';
  String ignitionSystem = 'N/A';
  String fuelSystem = 'N/A';
  String battery = 'N/A';
  String radiatorCap = 'N/A';
  String driveBeltPulleys = 'N/A';
  String brakeBooster = 'N/A';
  String masterCylinderABS = 'N/A';
  String engineComments = '';
  List<String> engineImages = [];

  // Tyres, Wheels & Brakes Inspection Fields
  String tyres = 'N/A';
  String wheelRims = 'N/A';
  String spareTyreRim = 'N/A';
  String brakeHoseCallipersPipes = 'N/A';
  String brakePads = 'N/A';
  String brakeDiscs = 'N/A';
  String brakeLinings = 'N/A';
  String wheelCylinders = 'N/A';
  String brakesAndDrums = 'N/A';
  String parkBrake = 'N/A';
  String wheelBearings = 'N/A';
  String tyreComments = '';
  List<String> tyreImages = [];
  // Add more fields for Tyres, Wheels & Brakes Inspection

  // Road Test Inspection Fields
  String easeOfStartingIdle = 'N/A';
  String engineNoise = 'N/A';
  String enginePerformance = 'N/A';
  String exhaustSmokeEmissions = 'N/A';
  String gearboxAutoManual = 'N/A';
  String differentialRoadTest = 'N/A';
  String steeringSuspension = 'N/A';
  String brakeOperation = 'N/A';
  String speedo = 'N/A';
  String cruiseControl = 'N/A';
  String _4wd = 'N/A';
  String camshaftDriveBelt = 'N/A';
  String roadTestComments = '';
  List<String> roadTestImages = [];
  // Add more fields for Road Test Inspection

  // Overall Rating & General Comments Fields
  String overallRating = 'N/A';
  String generalComments = '';
}

class InspectionStepper extends StatefulWidget {
  @override
  _InspectionStepperState createState() => _InspectionStepperState();
}

class _InspectionStepperState extends State<InspectionStepper> {
  late final VehicleInspectionForm _form;
  late int _currentStep;

  @override
  void initState() {
    super.initState();
    _form = VehicleInspectionForm();
    _currentStep = 0;
  }

  void _next() {
    if (_currentStep < _inspectionSteps.length - 1) {
      setState(() {
        _currentStep++;
      });
    }
  }

  void _previous() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
    }
  }

  Future<void> _saveForm() async {
    await generatePDF(_form);
  }

  // Method to handle image picking
  Future<void> pickImages(BuildContext context, List<String> path) async {
    // Request permissions if not already granted
    bool permissionsGranted = await requestPermissions(context);

    if (!permissionsGranted) {
      return; // Exit if permissions are not granted
    }

    final ImagePicker picker = ImagePicker();
    final List<XFile>? images = await picker.pickMultiImage();

    if (images != null) {
      setState(() {
        path.clear();
        path.addAll(images.map((file) => file.path));
      });
    }
  }

  Future<bool> requestPermissions(BuildContext context) async {
    // Check current permission status
    // var cameraStatus = await Permission.camera.status;
    // var photosStatus = await Permission.photos.status;
    var storageStatus = await Permission.storage.status;

    // Collect all permissions that are not granted
    List<Permission> neededPermissions = [];
    // if (!cameraStatus.isGranted) {
    //   neededPermissions.add(Permission.camera);
    // }
    // if (!photosStatus.isGranted) {
    //   neededPermissions.add(Permission.photos);
    // }
    // if (!storageStatus.isGranted) {
    //   neededPermissions.add(Permission.storage);
    // }

    // If all permissions are already granted
    if (neededPermissions.isEmpty) {
      return true;
    }

    print('Requesting permissions: $neededPermissions');

    // Request all not granted permissions
    Map<Permission, PermissionStatus> statuses =
        await neededPermissions.request();

    print(statuses);

    // Check if all requested permissions are granted after requesting
    bool allGranted = statuses.values.every((status) => status.isGranted);

    // If not all permissions are granted, handle them accordingly
    if (!allGranted) {
      if (statuses.values.any((status) => status.isPermanentlyDenied)) {
        // Handle permanently denied permissions
        showCustomDialog(
            context,
            "You have permanently denied some permissions which are essential for this feature. Please open app settings to grant these permissions.",
            openAppSettings // This function is provided by 'permission_handler'
            );
      } else if (statuses.values.any((status) => status.isDenied)) {
        // Handle temporarily denied permissions
        showCustomDialog(
            context,
            "Some permissions were denied temporarily. These are required for the feature to work properly. Please grant these permissions.",
            () => requestPermissions(context) // Request permissions again
            );
      }
    }

    return allGranted;
  }

  void showCustomDialog(
      BuildContext context, String content, VoidCallback onPressed) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Permissions Needed"),
          content: Text(content),
          actions: <Widget>[
            GestureDetector(
              onTap: () {
                Navigator.of(context).pop(); // Dismiss the dialog
                onPressed(); // Execute the provided function
              },
              child: Container(
                  color: Colors.green[300],
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Open Settings'),
                  )),
            ),
          ],
        );
      },
    );
  }

  Future<void> addImagesToPdf(PdfPage page, List<String> imagePaths) async {
    if (imagePaths.isEmpty) {
      return;
    }
    drawHeading(page, "IMAGES", 30, 5, 440);

    double startX = 5;
    double startY = 470;
    double padding = 10;
    double imageWidth = 160;
    double imageHeight = 50;

    for (var imagePath in imagePaths) {
      Uint8List imageData = await _readImageDataFromDevice(imagePath);
      // Create a PDF bitmap image
      PdfBitmap image = PdfBitmap(imageData);
      // Draw the image on the page
      page.graphics.drawImage(
        image,
        Rect.fromLTWH(startX, startY, imageWidth, imageHeight),
      );

      // Update startX for the next image, or wrap to the next line
      startX += imageWidth + padding;
      if (startX + imageWidth > page.getClientSize().width) {
        startX = 5; // Reset to left margin
        startY += imageHeight + padding; // Move down to the next line
      }
    }
  }

  Future<void> addImageFirstPage(PdfPage page, List<String> imagePaths) async {
    if (imagePaths.isEmpty) {
      return;
    }
    drawHeading(page, "VEHICLE IMAGE", 30, 5, 400);
    double startX = 5;
    double startY = 440;
    double padding = 10;
    double imageWidth = 200;
    double imageHeight = 200;

    for (var imagePath in imagePaths) {
      Uint8List imageData = await _readImageDataFromDevice(imagePath);
      // Create a PDF bitmap image
      PdfBitmap image = PdfBitmap(imageData);
      // Draw the image on the page
      page.graphics.drawImage(
        image,
        Rect.fromLTWH(startX, startY, imageWidth, imageHeight),
      );

      // Update startX for the next image, or wrap to the next line
      startX += imageWidth + padding;
      if (startX + imageWidth > page.getClientSize().width) {
        startX = 5; // Reset to left margin
        startY += imageHeight + padding; // Move down to the next line
      }
    }
  }

// Widget to display images in a grid
  Widget buildImageGrid(List<String> imagePaths) {
    return GridView.builder(
      gridDelegate:
          SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
      itemCount: imagePaths.length,
      itemBuilder: (context, index) {
        return Image.file(File(imagePaths[index]), fit: BoxFit.cover);
      },
    );
  }

  Future<void> generatePDF(VehicleInspectionForm form) async {
    try {
      // Create a new PDF document
      PdfDocument document = PdfDocument();

      // Common font setup
      PdfFont font = PdfStandardFont(PdfFontFamily.helvetica, 12);

      // Add the first page
      PdfPage firstPage = document.pages.add();

      // Add header on the first page
      await addHeader(firstPage, font);

      // Draw general vehicle information
      generalVehicleInfo(firstPage, font, form);

      // Add images to the first page
      await addImageFirstPage(firstPage, form.imagePaths);

      // Add footer on the first page
      await addFooter(firstPage, font);

      // Add a second page for the interior information
      PdfPage secondPage = document.pages.add();

      drawHeading(secondPage, "CONDITION OF THE INTERIOR", 70, 0, 0);
      await addInteriorInfo(secondPage, font, form);
      await addComments(secondPage, form.interiorComments);
      await addImagesToPdf(secondPage, form.interiorImages);
      await addFooter(secondPage, font);

      // Add a third page for the exterior information
      PdfPage thirdPage = document.pages.add();
      drawHeading(thirdPage, "CONDITION OF THE EXTERIOR", 70, 0, 0);
      await addExteriorInfo(thirdPage, font, form);
      await addComments(thirdPage, form.exteriorComments);
      await addImagesToPdf(thirdPage, form.exteriorImages);
      await addFooter(thirdPage, font);

      // Add a fourth page for engine bay information
      PdfPage fourthPage = document.pages.add();
      drawHeading(fourthPage, "ENGINE BAY INSPECTION", 70, 0, 0);
      await addEngineBayInfo(fourthPage, font, form);
      await addComments(fourthPage, form.engineComments);
      await addImagesToPdf(fourthPage, form.engineImages);
      await addFooter(fourthPage, font);

      // Add a fifth page for tyres, wheels, and brakes information
      PdfPage fifthPage = document.pages.add();
      drawHeading(fifthPage, "TYRES, WHEELS & BRAKES INSPECTION", 70, 0, 0);
      await addTyresWheelsBrakesInfo(fifthPage, font, form);
      await addComments(fifthPage, form.tyreComments);
      await addImagesToPdf(fifthPage, form.tyreImages);
      await addFooter(fifthPage, font);

      // Add a sixth page for road test information
      PdfPage sixthPage = document.pages.add();
      drawHeading(sixthPage, "ROAD TEST INSPECTION", 70, 0, 0);
      await addRoadTestInfo(sixthPage, font, form);
      await addComments(sixthPage, form.roadTestComments);
      await addImagesToPdf(sixthPage, form.roadTestImages);
      await addFooter(sixthPage, font);

      // Add a seventh page for overall rating and general comments
      PdfPage seventhPage = document.pages.add();
      drawHeading(seventhPage, "OVERALL RATING & GENERAL COMMENTS", 70, 0, 0);
      await addOverallRatingInfo(seventhPage, font, form);
      await addFinalCommentsAndSignature(seventhPage, form.generalComments);
      await addFooter(seventhPage, font);

      // Save the PDF document
      List<int> bytes = await document.save();

      // Dispose the PDF document
      document.dispose();

      // Save and launch the PDF
      await saveAndLaunchFile(
          bytes,
          'Report_' +
              DateFormat('yyyy-MM-dd').format(DateTime.now()) +
              '_' +
              _form.customerName +
              '.pdf');
    } catch (e) {
      print('Error generating PDF: $e');
    }
  }

  void drawHeading(
      PdfPage page, String text, double height, double startX, double startY) {
    // Create font settings
    PdfFont font =
        PdfStandardFont(PdfFontFamily.helvetica, 16, style: PdfFontStyle.bold);

    // Calculate the width based on page size and margins
    double width = page.getClientSize().width - startX * 2;

    // Draw the text on the page
    page.graphics.drawString(text, font,
        bounds: Rect.fromLTWH(startX, startY, width, height),
        format: PdfStringFormat(
            alignment: PdfTextAlignment.left,
            lineAlignment: PdfVerticalAlignment.middle));
  }

  Future<void> addComments(PdfPage page, String comments) async {
    if (comments.isEmpty) {
      return;
    }

    drawHeading(page, "COMMENTS", 30, 5, 390);
    // Create font settings
    const double startX = 5; // Start X position, can be adjusted as needed
    const double startY = 420; // Fixed Start Y position
    const double width = 500; // Maximum width of the text box
    const double height = 100; // Estimated height of the text box

    // Create font settings
    PdfFont font = PdfStandardFont(PdfFontFamily.helvetica, 12);

    // Draw the comments on the page
    page.graphics.drawString(comments, font,
        brush: PdfBrushes.black,
        bounds: Rect.fromLTWH(startX, startY, width, height),
        format: PdfStringFormat(
          alignment: PdfTextAlignment.left,
          lineAlignment: PdfVerticalAlignment.top,
        ));
  }

  Future<void> addFinalCommentsAndSignature(
      PdfPage page, String comments) async {
    // Comments section
    const double commentsStartX = 5; // Start X position for comments
    const double commentsStartY = 120; // Start Y position for comments
    const double commentsWidth = 500; // Maximum width of the comments box
    const double commentsHeight = 100; // Height of the comments box

    // Create font settings
    PdfFont font = PdfStandardFont(PdfFontFamily.helvetica, 10);
    PdfFont disclaimerFont = PdfStandardFont(PdfFontFamily.helvetica, 8);

    // Draw the comments on the page
    if (comments.isNotEmpty) {
      drawHeading(page, "COMMENTS", 30, 5, 130);

      page.graphics.drawString(comments, font,
          brush: PdfBrushes.black,
          bounds: Rect.fromLTWH(commentsStartX, commentsStartY + 40,
              commentsWidth, commentsHeight),
          format: PdfStringFormat(
            alignment: PdfTextAlignment.left,
            lineAlignment: PdfVerticalAlignment.top,
          ));
    }

    // Signature section
    const double signatureStartY = commentsStartY + commentsHeight + 10;
    String signatureText =
        "Signature\n\nI confirm I have inspected and road-tested the above vehicle as per the findings of this report.\n\nShanty Saluja\nDate: " +
            DateFormat('yyyy-MM-dd').format(DateTime.now());
    page.graphics.drawString(signatureText, font,
        brush: PdfBrushes.black,
        bounds:
            Rect.fromLTWH(commentsStartX, signatureStartY, commentsWidth, 80),
        format: PdfStringFormat(
          alignment: PdfTextAlignment.left,
          lineAlignment: PdfVerticalAlignment.top,
        ));

    // Disclaimer section with unordered list
    const double disclaimerStartY = signatureStartY + 80 + 10;

    // Draw the text on the page
    page.graphics.drawString(
        "Disclaimer",
        PdfStandardFont(
          PdfFontFamily.helvetica,
          16,
          style: PdfFontStyle.bold,
        ),
        brush: PdfBrushes.gray,
        bounds: Rect.fromLTWH(11, 170, 0, disclaimerStartY),
        format: PdfStringFormat(
            alignment: PdfTextAlignment.left,
            lineAlignment: PdfVerticalAlignment.middle));

    String disclaimerItems =
        "Timing belts\nFuel & Oil consumption\nTrip meters/computers\nAlarm/Security System\nNavigation equipment/GPS\nOperation of TV, cassette, CD or IPOD connection\nAutomatic switching of wipers and lights\nCompression of engine\nAnti-locking tracking system (ABS).";
    PdfUnorderedList(
            text:
                "It is the responsibility of the buyer to check for any financial interest owing on the vehicle and for any write off or stolen vehicle before purchasing the vehicle.\nThe My Mechanic Qld inspection is not a guarantee or warranty and is valid only at the time of inspection.\nIt is the responsibility of the buyer to conduct a visual inspection of the vehicle at the final point of sale as My Mechanic Qld can only advise on the condition of the vehicle at the time of inspection.\nAdvice on the vehicle inspected is provided in context of the age and condition of the vehicle at the time inspected.\nThe purchaser must take responsibility for the authenticity of the vehicle.\nVIN & Engine numbers are recorded by our inspectors however authenticity cannot be guaranteed.\nThe My Mechanic Qld inspection is VISUAL only. No removal of parts or components is undertaken during the inspection process.\nIf there is a dispute about the content of this report, the purchaser must refer the vehicle back to My Mechanic Qld prior to proceeding with any repairs.\nThis report serves to identify any visually detected problems however dismantling components may be subsequently required so as to provide a more accurate diagnosis.\nThe inspection report is prepared for the person named on the report and not for use by any third party.",
            style: PdfUnorderedMarkerStyle.circle,
            font: disclaimerFont,
            indent: 10,
            textIndent: 10,
            format: PdfStringFormat(lineSpacing: 1))
        .draw(
            page: page,
            bounds: Rect.fromLTWH(commentsStartX, disclaimerStartY + 30,
                commentsWidth - 50, 300));
    page.graphics.drawString(
        "My Mechanic Qld does not check the following items",
        PdfStandardFont(
          PdfFontFamily.helvetica,
          8,
          style: PdfFontStyle.bold,
        ),
        brush: PdfBrushes.gray,
        bounds: Rect.fromLTWH(18, 235, 0, disclaimerStartY + 240),
        format: PdfStringFormat(
            alignment: PdfTextAlignment.left,
            lineAlignment: PdfVerticalAlignment.middle));

    PdfUnorderedList(
            text: disclaimerItems,
            style: PdfUnorderedMarkerStyle.circle,
            font: disclaimerFont,
            indent: 10,
            textIndent: 10,
            format: PdfStringFormat(lineSpacing: 1))
        .draw(
            page: page,
            bounds: Rect.fromLTWH(commentsStartX + 15, disclaimerStartY + 205,
                commentsWidth, 300));
  }

  // Make sure this function is async
  Future<void> addHeader(PdfPage page, PdfFont font) async {
    PdfColor headerColor = PdfColor(33, 206, 136); // Green
    String companyName = 'My Mechanic QLD';
    String title = 'Vehicle Inspection Report';
    String email = 'contact@mymechanicqld.com';

    double startX = 0;
    double startY = 0;
    double padding = 20;
    double headerHeight = 2 * padding + 100;
    double availableTextWidth = page.getClientSize().width - 3 * padding - 100;

    // Draw header background
    page.graphics.drawRectangle(
      pen: PdfPen(headerColor, width: 0),
      brush: PdfSolidBrush(headerColor),
      bounds: Rect.fromLTWH(
          startX, startY, page.getClientSize().width, headerHeight),
    );

    // Draw header text
    PdfStringFormat leftAlignFormat = PdfStringFormat(
      alignment: PdfTextAlignment.left,
      lineAlignment: PdfVerticalAlignment.middle,
    );

    // Draw company name (bigger and bold)
    page.graphics.drawString(companyName,
        PdfStandardFont(PdfFontFamily.helvetica, 20, style: PdfFontStyle.bold),
        bounds: Rect.fromLTWH(startX + 2 * padding + 100, startY + padding,
            availableTextWidth, 30),
        format: leftAlignFormat);

    // Draw title and email
    page.graphics.drawString(title,
        PdfStandardFont(PdfFontFamily.helvetica, 15, style: PdfFontStyle.bold),
        bounds: Rect.fromLTWH(startX + 2 * padding + 100, startY + padding + 30,
            availableTextWidth, 25),
        format: leftAlignFormat);
    page.graphics.drawString(email, font,
        bounds: Rect.fromLTWH(startX + 2 * padding + 100, startY + padding + 55,
            availableTextWidth, 15),
        format: leftAlignFormat);
    page.graphics.drawString('+61451159954', font,
        bounds: Rect.fromLTWH(startX + 2 * padding + 100, startY + padding + 70,
            availableTextWidth, 15),
        format: leftAlignFormat);

    // Draw company logo
    page.graphics.drawImage(
      PdfBitmap(await _readImageData('logo.png')),
      Rect.fromLTWH(startX + padding, startY + padding, 100, 100),
    );
  }

  Future<Uint8List> _readImageData(String name) async {
    final data = await rootBundle.load('lib/assets/$name');

    // Print out some information for debugging
    print('Image data length: ${data.lengthInBytes}');
    print('Image data offset: ${data.offsetInBytes}');

    return data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
  }

  Future<Uint8List> _readImageDataFromDevice(String filePath) async {
    final File file = File(filePath);
    Uint8List bytes = await file.readAsBytes();

    // Print out some information for debugging
    print('Image file length: ${bytes.lengthInBytes}');

    return bytes;
  }

  Future<void> addFooter(PdfPage page, PdfFont font) async {
    // Footer content
    String companyName = 'My Mechanic QLD';
    String email = 'contact@mymechanicqld.com';
    String currentDate =
        "Date: " + DateFormat('yyyy-MM-dd').format(DateTime.now());

    // Footer height and position
    double footerHeight = 60;
    double footerWidth = page.getClientSize().width;
    double startX = 0;
    double startY = page.getClientSize().height - footerHeight;

    // Padding
    double padding = 20;

    //draw footer background
    PdfColor footerColor = PdfColor(240, 240, 240);

    page.graphics.drawRectangle(
      bounds: Rect.fromLTWH(startX, startY, footerWidth, footerHeight),
      brush: PdfSolidBrush(footerColor),
    );

    // Draw footer text
    PdfStringFormat leftFormat = PdfStringFormat(
      alignment: PdfTextAlignment.left,
      lineAlignment: PdfVerticalAlignment.middle,
    );

    PdfStringFormat rightFormat = PdfStringFormat(
      alignment: PdfTextAlignment.right,
      lineAlignment: PdfVerticalAlignment.middle,
    );

    page.graphics.drawString(
      companyName,
      PdfStandardFont(PdfFontFamily.helvetica, 13, style: PdfFontStyle.bold),
      bounds: Rect.fromLTWH(
          startX + padding, startY + 2, footerWidth - 2 * padding, 20),
      brush: PdfBrushes.black,
      format: leftFormat,
    );

    page.graphics.drawString(
      "Mail: " + email,
      font,
      bounds: Rect.fromLTWH(
          startX + padding, startY + 20, footerWidth - 2 * padding, 20),
      brush: PdfBrushes.black,
      format: leftFormat,
    );
    page.graphics.drawString(
      "Contact: +61451159954",
      font,
      bounds: Rect.fromLTWH(
          startX + padding, startY + 35, footerWidth - 2 * padding, 20),
      brush: PdfBrushes.black,
      format: leftFormat,
    );

    page.graphics.drawString(
      currentDate,
      font,
      bounds: Rect.fromLTWH(
          startX + padding, startY + 35, footerWidth - 2 * padding, 20),
      brush: PdfBrushes.black,
      format: rightFormat,
    );
  }

  Future<void> addInteriorInfo(
      PdfPage page, PdfFont font, VehicleInspectionForm form) async {
    final PdfGrid grid = PdfGrid();
    // Specify the columns count to the grid
    grid.columns.add(count: 5);

    // Create the header row of the grid
    final PdfGridRow headerRow = grid.headers.add(1)[0];
    headerRow.style.backgroundBrush =
        PdfSolidBrush(PdfColor(33, 206, 136)); // Green
    headerRow.style.textBrush = PdfBrushes.white;
    headerRow.cells[0].value = 'Category';
    headerRow.cells[1].value = 'Good';
    headerRow.cells[2].value = 'Fair';
    headerRow.cells[3].value = 'Bad';
    headerRow.cells[4].value = 'N/A';

    // Set header cells alignment
    for (int i = 0; i < headerRow.cells.count; i++) {
      PdfGridCell cell = headerRow.cells[i];
      cell.stringFormat = PdfStringFormat(alignment: PdfTextAlignment.center);
      cell.style.cellPadding =
          PdfPaddings(bottom: 5, left: 5, right: 5, top: 5);
    }

    // Add rows based on interior inspection data
    List<Map<String, String>> categories = [
      {'category': 'Seats', 'value': form.seats},
      {'category': 'Seat Belts', 'value': form.seatBelts},
      {'category': 'Other Trims', 'value': form.otherTrims},
      {'category': 'Radio', 'value': form.radio},
      {'category': 'Rear Window Demister', 'value': form.rearWindowDemister},
      {'category': 'Air Conditioning', 'value': form.airConditioning},
      {'category': 'Heater Demister', 'value': form.heaterDemister},
      {'category': 'Washers/Wipers', 'value': form.washersWipers},
      {'category': 'Horn', 'value': form.horn},
      {'category': 'Doors, Locks & Hinges', 'value': form.doorsLocksHinges},
      {'category': 'Window Operation', 'value': form.windowOperation},
      {
        'category': 'Warning Lights & Gauges/Dash',
        'value': form.warningLightsGaugesDash
      },
      {'category': 'All Lights', 'value': form.allLights},
    ];

    // Iterate through categories and add rows
    categories.forEach((category) {
      final PdfGridRow row = grid.rows.add();
      row.cells[0].value = category['category'];
      row.cells[0].style.cellPadding =
          PdfPaddings(bottom: 5, left: 15, right: 5, top: 5);
      List<String> evaluations = ['Good', 'Fair', 'Bad', 'N/A'];
      for (int i = 1; i <= 4; i++) {
        row.cells[i].value =
            (evaluations[i - 1] == category['value']) ? 'O' : '';
        row.cells[i].stringFormat =
            PdfStringFormat(alignment: PdfTextAlignment.center);
        row.cells[i].style.cellPadding =
            PdfPaddings(bottom: 5, left: 5, right: 5, top: 5);
      }
    });

    // Set gird columns width
    grid.columns[0].width = 200;
    double remainingWidth =
        (page.getClientSize().width - grid.columns[0].width) / 4;
    for (int i = 1; i < 5; i++) {
      grid.columns[i].width = remainingWidth;
    }

    // Apply the table built-in style for better visuals
    grid.applyBuiltInStyle(PdfGridBuiltInStyle.plainTable1);

    // Draw grid to the PDF page
    grid.draw(
        page: page,
        bounds: Rect.fromLTWH(
            0, 70, page.getClientSize().width, 0)); // Adjust startY as needed
  }

  Future<void> addExteriorInfo(
      PdfPage page, PdfFont font, VehicleInspectionForm form) async {
    final PdfGrid grid = PdfGrid();
    grid.columns.add(count: 5);

    final PdfGridRow headerRow = grid.headers.add(1)[0];
    headerRow.style.backgroundBrush =
        PdfSolidBrush(PdfColor(33, 206, 136)); // Green
    headerRow.style.textBrush = PdfBrushes.white;
    headerRow.cells[0].value = 'Category';
    headerRow.cells[1].value = 'Good';
    headerRow.cells[2].value = 'Fair';
    headerRow.cells[3].value = 'Bad';
    headerRow.cells[4].value = 'N/A';

    for (int i = 0; i < headerRow.cells.count; i++) {
      PdfGridCell cell = headerRow.cells[i];
      cell.stringFormat = PdfStringFormat(alignment: PdfTextAlignment.center);
      cell.style.cellPadding =
          PdfPaddings(bottom: 5, left: 5, right: 5, top: 5);
    }

    List<Map<String, String>> categories = [
      {'category': 'Rust', 'value': form.rust},
      {'category': 'Body Repairs', 'value': form.bodyRepairs},
      {'category': 'Glass & Mirrors', 'value': form.glassMirrors},
      {
        'category': 'Sunroof/Aerial/Convertible',
        'value': form.sunroofAerialConvertible
      },
      {'category': 'Frames & Members', 'value': form.framesMembers},
      {'category': 'Under Body Parts', 'value': form.underBodyParts},
      {'category': 'Front Suspension', 'value': form.frontSuspension},
      {'category': 'Rear Suspension', 'value': form.rearSuspension},
      {'category': 'Steering Components', 'value': form.steeringComponents},
      {'category': 'Exhaust', 'value': form.exhaust},
      {'category': 'Differential', 'value': form.differential},
      {'category': 'Drive Shafts', 'value': form.driveShafts},
    ];

    for (var category in categories) {
      final PdfGridRow row = grid.rows.add();
      row.cells[0].value = category['category'];
      row.cells[0].style.cellPadding =
          PdfPaddings(bottom: 5, left: 15, right: 5, top: 5);
      List<String> evaluations = ['Good', 'Fair', 'Bad', 'N/A'];
      for (int i = 1; i <= 4; i++) {
        row.cells[i].value =
            (evaluations[i - 1] == category['value']) ? 'O' : '';
        row.cells[i].stringFormat =
            PdfStringFormat(alignment: PdfTextAlignment.center);
        row.cells[i].style.cellPadding =
            PdfPaddings(bottom: 5, left: 5, right: 5, top: 5);
      }
    }

    grid.columns[0].width = 200;
    double remainingWidth =
        (page.getClientSize().width - grid.columns[0].width) / 4;
    for (int i = 1; i < 5; i++) {
      grid.columns[i].width = remainingWidth;
    }

    grid.applyBuiltInStyle(PdfGridBuiltInStyle.plainTable1);
    grid.draw(
        page: page,
        bounds: Rect.fromLTWH(0, 70, page.getClientSize().width, 0));
  }

  Future<void> addEngineBayInfo(
      PdfPage page, PdfFont font, VehicleInspectionForm form) async {
    final PdfGrid grid = PdfGrid();
    grid.columns.add(count: 5);

    final PdfGridRow headerRow = grid.headers.add(1)[0];
    headerRow.style.backgroundBrush =
        PdfSolidBrush(PdfColor(33, 206, 136)); // Green
    headerRow.style.textBrush = PdfBrushes.white;
    headerRow.cells[0].value = 'Category';
    headerRow.cells[1].value = 'Good';
    headerRow.cells[2].value = 'Fair';
    headerRow.cells[3].value = 'Bad';
    headerRow.cells[4].value = 'N/A';

    for (int i = 0; i < headerRow.cells.count; i++) {
      PdfGridCell cell = headerRow.cells[i];
      cell.stringFormat = PdfStringFormat(alignment: PdfTextAlignment.center);
      cell.style.cellPadding =
          PdfPaddings(bottom: 5, left: 5, right: 5, top: 5);
    }

    List<Map<String, String>> categories = [
      {'category': 'Noise', 'value': form.noise},
      {'category': 'Fluid Level', 'value': form.fluidLevel},
      {'category': 'Fluid Leaks', 'value': form.fluidLeaks},
      {'category': 'Mountings', 'value': form.mountings},
      {'category': 'Hoses & Pipes', 'value': form.hosesPipes},
      {'category': 'Water Pump & Fan', 'value': form.waterPumpFan},
      {'category': 'Ignition System', 'value': form.ignitionSystem},
      {'category': 'Fuel System', 'value': form.fuelSystem},
      {'category': 'Battery', 'value': form.battery},
      {'category': 'Radiator & Cap', 'value': form.radiatorCap},
      {'category': 'Drive Belt & Pulleys', 'value': form.driveBeltPulleys},
      {'category': 'Brake Booster', 'value': form.brakeBooster},
      {'category': 'Master Cylinder & ABS', 'value': form.masterCylinderABS},
    ];

    for (var category in categories) {
      final PdfGridRow row = grid.rows.add();
      row.cells[0].value = category['category'];
      row.cells[0].style.cellPadding =
          PdfPaddings(bottom: 5, left: 15, right: 5, top: 5);
      List<String> evaluations = ['Good', 'Fair', 'Bad', 'N/A'];
      for (int i = 1; i <= 4; i++) {
        row.cells[i].value =
            (evaluations[i - 1] == category['value']) ? 'O' : '';
        row.cells[i].stringFormat =
            PdfStringFormat(alignment: PdfTextAlignment.center);
        row.cells[i].style.cellPadding =
            PdfPaddings(bottom: 5, left: 5, right: 5, top: 5);
      }
    }

    grid.columns[0].width = 200;
    double remainingWidth =
        (page.getClientSize().width - grid.columns[0].width) / 4;
    for (int i = 1; i < 5; i++) {
      grid.columns[i].width = remainingWidth;
    }

    grid.applyBuiltInStyle(PdfGridBuiltInStyle.plainTable1);
    grid.draw(
        page: page,
        bounds: Rect.fromLTWH(0, 70, page.getClientSize().width, 0));
  }

  Future<void> addOverallRatingInfo(
      PdfPage page, PdfFont font, VehicleInspectionForm form) async {
    final PdfGrid grid = PdfGrid();
    grid.columns.add(count: 5);

    final PdfGridRow headerRow = grid.headers.add(1)[0];
    headerRow.style.backgroundBrush =
        PdfSolidBrush(PdfColor(33, 206, 136)); // Green
    headerRow.style.textBrush = PdfBrushes.white;
    headerRow.cells[0].value = 'Category';
    headerRow.cells[1].value = 'Good';
    headerRow.cells[2].value = 'Fair';
    headerRow.cells[3].value = 'Bad';
    headerRow.cells[4].value = 'N/A';

    for (int i = 0; i < headerRow.cells.count; i++) {
      PdfGridCell cell = headerRow.cells[i];
      cell.stringFormat = PdfStringFormat(alignment: PdfTextAlignment.center);
      cell.style.cellPadding =
          PdfPaddings(bottom: 5, left: 5, right: 5, top: 5);
    }

    List<Map<String, String>> categories = [
      {'category': 'Overall Condition', 'value': form.overallRating}
    ];

    for (var category in categories) {
      final PdfGridRow row = grid.rows.add();
      row.cells[0].value = category['category'];
      row.cells[0].style.cellPadding =
          PdfPaddings(bottom: 5, left: 15, right: 5, top: 5);
      List<String> evaluations = ['Good', 'Fair', 'Bad', 'N/A'];
      for (int i = 1; i <= 4; i++) {
        row.cells[i].value =
            (evaluations[i - 1] == category['value']) ? 'O' : '';
        row.cells[i].stringFormat =
            PdfStringFormat(alignment: PdfTextAlignment.center);
        row.cells[i].style.cellPadding =
            PdfPaddings(bottom: 5, left: 5, right: 5, top: 5);
      }
    }

    grid.columns[0].width = 200;
    double remainingWidth =
        (page.getClientSize().width - grid.columns[0].width) / 4;
    for (int i = 1; i < 5; i++) {
      grid.columns[i].width = remainingWidth;
    }

    grid.applyBuiltInStyle(PdfGridBuiltInStyle.plainTable1);
    grid.draw(
        page: page,
        bounds: Rect.fromLTWH(0, 70, page.getClientSize().width, 0));
  }

  Future<void> addTyresWheelsBrakesInfo(
      PdfPage page, PdfFont font, VehicleInspectionForm form) async {
    final PdfGrid grid = PdfGrid();
    grid.columns.add(count: 5);

    final PdfGridRow headerRow = grid.headers.add(1)[0];
    headerRow.style.backgroundBrush =
        PdfSolidBrush(PdfColor(33, 206, 136)); // Green
    headerRow.style.textBrush = PdfBrushes.white;
    headerRow.cells[0].value = 'Category';
    headerRow.cells[1].value = 'Good';
    headerRow.cells[2].value = 'Fair';
    headerRow.cells[3].value = 'Bad';
    headerRow.cells[4].value = 'N/A';

    for (int i = 0; i < headerRow.cells.count; i++) {
      PdfGridCell cell = headerRow.cells[i];
      cell.stringFormat = PdfStringFormat(alignment: PdfTextAlignment.center);
      cell.style.cellPadding =
          PdfPaddings(bottom: 5, left: 5, right: 5, top: 5);
    }

    List<Map<String, String>> categories = [
      {'category': 'Tyres', 'value': form.tyres},
      {'category': 'Wheel Rims', 'value': form.wheelRims},
      {'category': 'Spare Tyre & Rim', 'value': form.spareTyreRim},
      {
        'category': 'Brake Hose, Callipers, Pipes',
        'value': form.brakeHoseCallipersPipes
      },
      {'category': 'Brake Pads', 'value': form.brakePads},
      {'category': 'Brake Discs', 'value': form.brakeDiscs},
      {'category': 'Brake Linings', 'value': form.brakeLinings},
      {'category': 'Wheel Cylinders', 'value': form.wheelCylinders},
      {'category': 'Brakes and Drums', 'value': form.brakesAndDrums},
      {'category': 'Park Brake', 'value': form.parkBrake},
      {'category': 'Wheel Bearings', 'value': form.wheelBearings}
    ];

    for (var category in categories) {
      final PdfGridRow row = grid.rows.add();
      row.cells[0].value = category['category'];
      row.cells[0].style.cellPadding =
          PdfPaddings(bottom: 5, left: 15, right: 5, top: 5);
      List<String> evaluations = ['Good', 'Fair', 'Bad', 'N/A'];
      for (int i = 1; i <= 4; i++) {
        row.cells[i].value =
            (evaluations[i - 1] == category['value']) ? 'O' : '';
        row.cells[i].stringFormat =
            PdfStringFormat(alignment: PdfTextAlignment.center);
        row.cells[i].style.cellPadding =
            PdfPaddings(bottom: 5, left: 5, right: 5, top: 5);
      }
    }

    grid.columns[0].width = 200;
    double remainingWidth =
        (page.getClientSize().width - grid.columns[0].width) / 4;
    for (int i = 1; i < 5; i++) {
      grid.columns[i].width = remainingWidth;
    }

    grid.applyBuiltInStyle(PdfGridBuiltInStyle.plainTable1);
    grid.draw(
        page: page,
        bounds: Rect.fromLTWH(0, 70, page.getClientSize().width, 0));
  }

  Future<void> addRoadTestInfo(
      PdfPage page, PdfFont font, VehicleInspectionForm form) async {
    final PdfGrid grid = PdfGrid();
    grid.columns.add(count: 5);

    final PdfGridRow headerRow = grid.headers.add(1)[0];
    headerRow.style.backgroundBrush =
        PdfSolidBrush(PdfColor(33, 206, 136)); // Green
    headerRow.style.textBrush = PdfBrushes.white;
    headerRow.cells[0].value = 'Category';
    headerRow.cells[1].value = 'Good';
    headerRow.cells[2].value = 'Fair';
    headerRow.cells[3].value = 'Bad';
    headerRow.cells[4].value = 'N/A';

    for (int i = 0; i < headerRow.cells.count; i++) {
      PdfGridCell cell = headerRow.cells[i];
      cell.stringFormat = PdfStringFormat(alignment: PdfTextAlignment.center);
      cell.style.cellPadding =
          PdfPaddings(bottom: 5, left: 5, right: 5, top: 5);
    }

    List<Map<String, String>> categories = [
      {'category': 'Ease of Starting & Idle', 'value': form.easeOfStartingIdle},
      {'category': 'Engine Noise', 'value': form.engineNoise},
      {'category': 'Engine Performance', 'value': form.enginePerformance},
      {
        'category': 'Exhaust Smoke & Emissions',
        'value': form.exhaustSmokeEmissions
      },
      {'category': 'Gearbox (Auto/Manual)', 'value': form.gearboxAutoManual},
      {
        'category': 'Differential (Road Test)',
        'value': form.differentialRoadTest
      },
      {'category': 'Steering & Suspension', 'value': form.steeringSuspension},
      {'category': 'Brake Operation', 'value': form.brakeOperation},
      {'category': 'Speedometer', 'value': form.speedo},
      {'category': 'Cruise Control', 'value': form.cruiseControl},
      {'category': '4WD Operation', 'value': form._4wd},
      {'category': 'Camshaft Drive Belt', 'value': form.camshaftDriveBelt}
    ];

    for (var category in categories) {
      final PdfGridRow row = grid.rows.add();
      row.cells[0].value = category['category'];
      row.cells[0].style.cellPadding =
          PdfPaddings(bottom: 5, left: 15, right: 5, top: 5);
      List<String> evaluations = ['Good', 'Fair', 'Bad', 'N/A'];
      for (int i = 1; i <= 4; i++) {
        row.cells[i].value =
            (evaluations[i - 1] == category['value']) ? 'O' : '';
        row.cells[i].stringFormat =
            PdfStringFormat(alignment: PdfTextAlignment.center);
        row.cells[i].style.cellPadding =
            PdfPaddings(bottom: 5, left: 5, right: 5, top: 5);
      }
    }

    grid.columns[0].width = 200;
    double remainingWidth =
        (page.getClientSize().width - grid.columns[0].width) / 4;
    for (int i = 1; i < 5; i++) {
      grid.columns[i].width = remainingWidth;
    }

    grid.applyBuiltInStyle(PdfGridBuiltInStyle.plainTable1);
    grid.draw(
        page: page,
        bounds: Rect.fromLTWH(0, 70, page.getClientSize().width, 0));
  }

  void generalVehicleInfo(
      PdfPage page, PdfFont font, VehicleInspectionForm form) {
    double startY = 175; // Start further below the header; adjust as necessary
    double lineHeight = 25; // Increase line height for better readability
    double startX = 10; // Padding from the left edge
    PdfFont boldFont = PdfStandardFont(PdfFontFamily.helvetica, 12,
        style: PdfFontStyle.bold); // Bold font for labels

    page.graphics.drawString("GENERAL INFORMATION ABOUT THE VEHICLE",
        PdfStandardFont(PdfFontFamily.helvetica, 14, style: PdfFontStyle.bold),
        bounds: Rect.fromLTWH(startX + 90, startY - 2,
            page.getClientSize().width - startX * 2, lineHeight));

    // Helper to draw label-value pairs
    void drawLabelValuePair(String label, String value, int lineOffset) {
      String formattedText = '$label';
      page.graphics.drawString(formattedText, font,
          bounds: Rect.fromLTWH(startX, startY + (lineOffset + 1) * lineHeight,
              page.getClientSize().width - startX * 2, lineHeight));
      page.graphics.drawString(value, font,
          bounds: Rect.fromLTWH(
              startX + 170,
              startY + (lineOffset + 1) * lineHeight,
              page.getClientSize().width - startX * 2,
              lineHeight));
    }

    // Format date
    String formattedDate = DateFormat('yyyy-MM-dd')
        .format(form.dateInspected); // Format date as "YYYY-MM-DD"

    // Draw data
    drawLabelValuePair('Customer Name:', form.customerName, 0);
    drawLabelValuePair('Date Inspected:', formattedDate, 1);
    drawLabelValuePair('Make/Model:', form.makeModel, 2);
    drawLabelValuePair('Registration Number:', form.registrationNumber, 3);
    drawLabelValuePair('Year of Vehicle:', form.yearOfVehicle, 4);
    drawLabelValuePair('VIN:', form.vin, 5);
    drawLabelValuePair(
        'Odometer Reading:', '${form.odometerReading.toString()} km', 6);
  }

  DropdownButtonFormField<String> buildDropdownFormField(
    String label,
    String? value,
    Function(String?) onChanged,
  ) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(labelText: label),
      value: value,
      onChanged: onChanged,
      items: ['Good', 'Fair', 'Bad', 'N/A'].map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  List<Step> get _inspectionSteps => [
        // Define steps for the inspection process
        Step(
          isActive: _currentStep >= 0,
          title: Text(''),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Vehicle Information',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Customer Name'),
                onChanged: (value) {
                  _form.customerName = value;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Date Inspected'),
                readOnly: true,
                onTap: () {
                  showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime.now(),
                  ).then((selectedDate) {
                    if (selectedDate != null) {
                      setState(() {
                        _form.dateInspected = selectedDate;
                      });
                    }
                  });
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Make/Model'),
                onChanged: (value) {
                  _form.makeModel = value;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Registration #'),
                onChanged: (value) {
                  _form.registrationNumber = value;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Year of Vehicle'),
                onChanged: (value) {
                  _form.yearOfVehicle = value;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'VIN'),
                onChanged: (value) {
                  _form.vin = value;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Odometer Reading'),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  _form.odometerReading = double.tryParse(value) ?? 0.0;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => pickImages(context, _form.imagePaths),
                child: Text('Add Images'),
              ),
              SizedBox(height: 20),
              // Displaying the image grid
              _form.imagePaths.isEmpty
                  ? Container()
                  : Container(
                      height: 200, // Set a fixed height for the grid
                      child: buildImageGrid(_form.imagePaths),
                    ),
              // Add form fields for Vehicle Information step
            ],
          ),
        ),
        Step(
          isActive: _currentStep >= 1,
          title: Text(''),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Interior Inspection',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              buildDropdownFormField(
                'Seats',
                _form.seats,
                (value) {
                  setState(() {
                    _form.seats = value!;
                  });
                },
              ),
              buildDropdownFormField(
                'Seat Belts',
                _form.seatBelts,
                (value) {
                  setState(() {
                    _form.seatBelts = value!;
                  });
                },
              ),
              buildDropdownFormField(
                'Other Trims',
                _form.otherTrims,
                (value) {
                  setState(() {
                    _form.otherTrims = value!;
                  });
                },
              ),
              buildDropdownFormField(
                'Radio',
                _form.radio,
                (value) {
                  setState(() {
                    _form.radio = value!;
                  });
                },
              ),
              buildDropdownFormField(
                'Rear Window Demister',
                _form.rearWindowDemister,
                (value) {
                  setState(() {
                    _form.rearWindowDemister = value!;
                  });
                },
              ),
              buildDropdownFormField(
                'Air Conditioning',
                _form.airConditioning,
                (value) {
                  setState(() {
                    _form.airConditioning = value!;
                  });
                },
              ),
              buildDropdownFormField(
                'Heater Demister',
                _form.heaterDemister,
                (value) {
                  setState(() {
                    _form.heaterDemister = value!;
                  });
                },
              ),
              buildDropdownFormField(
                'Washers/Wipers',
                _form.washersWipers,
                (value) {
                  setState(() {
                    _form.washersWipers = value!;
                  });
                },
              ),
              buildDropdownFormField(
                'Horn',
                _form.horn,
                (value) {
                  setState(() {
                    _form.horn = value!;
                  });
                },
              ),
              buildDropdownFormField(
                'Doors/Locks/Hinges',
                _form.doorsLocksHinges,
                (value) {
                  setState(() {
                    _form.doorsLocksHinges = value!;
                  });
                },
              ),
              buildDropdownFormField(
                'Window Operation',
                _form.windowOperation,
                (value) {
                  setState(() {
                    _form.windowOperation = value!;
                  });
                },
              ),
              buildDropdownFormField(
                'Warning Lights/Gauges/Dash',
                _form.warningLightsGaugesDash,
                (value) {
                  setState(() {
                    _form.warningLightsGaugesDash = value!;
                  });
                },
              ),
              buildDropdownFormField(
                'All Lights',
                _form.allLights,
                (value) {
                  setState(() {
                    _form.allLights = value!;
                  });
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Interior Comments'),
                onChanged: (value) {
                  setState(() {
                    _form.interiorComments = value;
                  });
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => pickImages(context, _form.interiorImages),
                child: Text('Add Images'),
              ),
              SizedBox(height: 20),
              // Displaying the image grid
              _form.interiorImages.isEmpty
                  ? Container()
                  : Container(
                      height: 200, // Set a fixed height for the grid
                      child: buildImageGrid(_form.interiorImages),
                    ),

              // Add more DropdownButtonFormField widgets for other interior inspection fields
            ],
          ),
        ),
        Step(
          isActive: _currentStep >= 2,
          title: Text(''),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Exterior Inspection',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              buildDropdownFormField(
                'Rust',
                _form.rust,
                (value) {
                  setState(() {
                    _form.rust = value!;
                  });
                },
              ),
              buildDropdownFormField(
                'Body Repairs',
                _form.bodyRepairs,
                (value) {
                  setState(() {
                    _form.bodyRepairs = value!;
                  });
                },
              ),
              buildDropdownFormField(
                'Glass / Mirrors',
                _form.glassMirrors,
                (value) {
                  setState(() {
                    _form.glassMirrors = value!;
                  });
                },
              ),
              buildDropdownFormField(
                'Sunroof / Aerial / Convertible',
                _form.sunroofAerialConvertible,
                (value) {
                  setState(() {
                    _form.sunroofAerialConvertible = value!;
                  });
                },
              ),
              buildDropdownFormField(
                'Frames & Members',
                _form.framesMembers,
                (value) {
                  setState(() {
                    _form.framesMembers = value!;
                  });
                },
              ),
              buildDropdownFormField(
                'Under Body Parts',
                _form.underBodyParts,
                (value) {
                  setState(() {
                    _form.underBodyParts = value!;
                  });
                },
              ),
              buildDropdownFormField(
                'Front Suspension',
                _form.frontSuspension,
                (value) {
                  setState(() {
                    _form.frontSuspension = value!;
                  });
                },
              ),
              buildDropdownFormField(
                'Rear Suspension',
                _form.rearSuspension,
                (value) {
                  setState(() {
                    _form.rearSuspension = value!;
                  });
                },
              ),
              buildDropdownFormField(
                'Steering Components',
                _form.steeringComponents,
                (value) {
                  setState(() {
                    _form.steeringComponents = value!;
                  });
                },
              ),
              buildDropdownFormField(
                'Auto / Manual Transmission',
                _form.autoManualTransmission,
                (value) {
                  setState(() {
                    _form.autoManualTransmission = value!;
                  });
                },
              ),
              buildDropdownFormField(
                'Exhaust',
                _form.exhaust,
                (value) {
                  setState(() {
                    _form.exhaust = value!;
                  });
                },
              ),
              buildDropdownFormField(
                'Differential',
                _form.differential,
                (value) {
                  setState(() {
                    _form.differential = value!;
                  });
                },
              ),
              buildDropdownFormField(
                'Drive Shafts',
                _form.driveShafts,
                (value) {
                  setState(() {
                    _form.driveShafts = value!;
                  });
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Exterior Comments'),
                onChanged: (value) {
                  setState(() {
                    _form.exteriorComments = value;
                  });
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => pickImages(context, _form.exteriorImages),
                child: Text('Add Images'),
              ),
              SizedBox(height: 20),
              // Displaying the image grid
              _form.exteriorImages.isEmpty
                  ? Container()
                  : Container(
                      height: 200, // Set a fixed height for the grid
                      child: buildImageGrid(_form.exteriorImages),
                    ),
            ],
          ),
        ),
        Step(
          isActive: _currentStep >= 3,
          title: Text(''),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Engine Bay Inspection',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              buildDropdownFormField(
                'Noise',
                _form.noise,
                (value) {
                  setState(() {
                    _form.noise = value!;
                  });
                },
              ),
              buildDropdownFormField(
                'Fluid Level',
                _form.fluidLevel,
                (value) {
                  setState(() {
                    _form.fluidLevel = value!;
                  });
                },
              ),
              buildDropdownFormField(
                'Fluid Leaks',
                _form.fluidLeaks,
                (value) {
                  setState(() {
                    _form.fluidLeaks = value!;
                  });
                },
              ),
              buildDropdownFormField(
                'Mountings',
                _form.mountings,
                (value) {
                  setState(() {
                    _form.mountings = value!;
                  });
                },
              ),
              buildDropdownFormField(
                'Hoses / Pipes',
                _form.hosesPipes,
                (value) {
                  setState(() {
                    _form.hosesPipes = value!;
                  });
                },
              ),
              buildDropdownFormField(
                'Water Pump / Fan',
                _form.waterPumpFan,
                (value) {
                  setState(() {
                    _form.waterPumpFan = value!;
                  });
                },
              ),
              buildDropdownFormField(
                'Ignition System',
                _form.ignitionSystem,
                (value) {
                  setState(() {
                    _form.ignitionSystem = value!;
                  });
                },
              ),
              buildDropdownFormField(
                'Fuel System',
                _form.fuelSystem,
                (value) {
                  setState(() {
                    _form.fuelSystem = value!;
                  });
                },
              ),
              buildDropdownFormField(
                'Battery',
                _form.battery,
                (value) {
                  setState(() {
                    _form.battery = value!;
                  });
                },
              ),
              buildDropdownFormField(
                'Radiator / Cap',
                _form.radiatorCap,
                (value) {
                  setState(() {
                    _form.radiatorCap = value!;
                  });
                },
              ),
              buildDropdownFormField(
                'Drive Belt / Pulleys',
                _form.driveBeltPulleys,
                (value) {
                  setState(() {
                    _form.driveBeltPulleys = value!;
                  });
                },
              ),
              buildDropdownFormField(
                'Brake Booster',
                _form.brakeBooster,
                (value) {
                  setState(() {
                    _form.brakeBooster = value!;
                  });
                },
              ),
              buildDropdownFormField(
                'Master Cylinder / ABS',
                _form.masterCylinderABS,
                (value) {
                  setState(() {
                    _form.masterCylinderABS = value!;
                  });
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Engine Comments'),
                onChanged: (value) {
                  setState(() {
                    _form.engineComments = value;
                  });
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => pickImages(context, _form.engineImages),
                child: Text('Add Images'),
              ),
              SizedBox(height: 20),
              // Displaying the image grid
              _form.engineImages.isEmpty
                  ? Container()
                  : Container(
                      height: 200, // Set a fixed height for the grid
                      child: buildImageGrid(_form.engineImages),
                    ),

              // Add more DropdownButtonFormField widgets for other engine bay inspection fields
            ],
          ),
        ),
        Step(
          isActive: _currentStep >= 4,
          title: Text(''),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Tyres, Wheels & Brakes Inspection',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              buildDropdownFormField(
                'Tyres',
                _form.tyres,
                (value) {
                  setState(() {
                    _form.tyres = value!;
                  });
                },
              ),
              buildDropdownFormField(
                'Wheel Rims',
                _form.wheelRims,
                (value) {
                  setState(() {
                    _form.wheelRims = value!;
                  });
                },
              ),
              buildDropdownFormField(
                'Spare Tyre / Rim',
                _form.spareTyreRim,
                (value) {
                  setState(() {
                    _form.spareTyreRim = value!;
                  });
                },
              ),
              buildDropdownFormField(
                'Brake Hose Callipers / Pipes',
                _form.brakeHoseCallipersPipes,
                (value) {
                  setState(() {
                    _form.brakeHoseCallipersPipes = value!;
                  });
                },
              ),
              buildDropdownFormField(
                'Brake Pads',
                _form.brakePads,
                (value) {
                  setState(() {
                    _form.brakePads = value!;
                  });
                },
              ),
              buildDropdownFormField(
                'Brake Discs',
                _form.brakeDiscs,
                (value) {
                  setState(() {
                    _form.brakeDiscs = value!;
                  });
                },
              ),
              buildDropdownFormField(
                'Brake Linings',
                _form.brakeLinings,
                (value) {
                  setState(() {
                    _form.brakeLinings = value!;
                  });
                },
              ),
              buildDropdownFormField(
                'Wheel Cylinders',
                _form.wheelCylinders,
                (value) {
                  setState(() {
                    _form.wheelCylinders = value!;
                  });
                },
              ),
              buildDropdownFormField(
                'Brakes and Drums',
                _form.brakesAndDrums,
                (value) {
                  setState(() {
                    _form.brakesAndDrums = value!;
                  });
                },
              ),
              buildDropdownFormField(
                'Park Brake',
                _form.parkBrake,
                (value) {
                  setState(() {
                    _form.parkBrake = value!;
                  });
                },
              ),
              buildDropdownFormField(
                'Wheel Bearings',
                _form.wheelBearings,
                (value) {
                  setState(() {
                    _form.wheelBearings = value!;
                  });
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Tyre Comments'),
                onChanged: (value) {
                  setState(() {
                    _form.tyreComments = value;
                  });
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => pickImages(context, _form.tyreImages),
                child: Text('Add Images'),
              ),
              SizedBox(height: 20),
              // Displaying the image grid
              _form.tyreImages.isEmpty
                  ? Container()
                  : Container(
                      height: 200, // Set a fixed height for the grid
                      child: buildImageGrid(_form.tyreImages),
                    ),

              // Add more DropdownButtonFormField widgets for other tyres, wheels & brakes inspection fields
            ],
          ),
        ),
        Step(
          isActive: _currentStep >= 5,
          title: Text(''),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Road Test Inspection',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              buildDropdownFormField(
                'Ease of Starting Idle',
                _form.easeOfStartingIdle,
                (value) {
                  setState(() {
                    _form.easeOfStartingIdle = value!;
                  });
                },
              ),
              buildDropdownFormField(
                'Engine Noise',
                _form.engineNoise,
                (value) {
                  setState(() {
                    _form.engineNoise = value!;
                  });
                },
              ),
              buildDropdownFormField(
                'Engine Performance',
                _form.enginePerformance,
                (value) {
                  setState(() {
                    _form.enginePerformance = value!;
                  });
                },
              ),
              buildDropdownFormField(
                'Exhaust Smoke / Emissions',
                _form.exhaustSmokeEmissions,
                (value) {
                  setState(() {
                    _form.exhaustSmokeEmissions = value!;
                  });
                },
              ),
              buildDropdownFormField(
                'Gearbox Auto / Manual',
                _form.gearboxAutoManual,
                (value) {
                  setState(() {
                    _form.gearboxAutoManual = value!;
                  });
                },
              ),
              buildDropdownFormField(
                'Differential',
                _form.differentialRoadTest,
                (value) {
                  setState(() {
                    _form.differentialRoadTest = value!;
                  });
                },
              ),
              buildDropdownFormField(
                'Steering / Suspension',
                _form.steeringSuspension,
                (value) {
                  setState(() {
                    _form.steeringSuspension = value!;
                  });
                },
              ),
              buildDropdownFormField(
                'Brake Operation',
                _form.brakeOperation,
                (value) {
                  setState(() {
                    _form.brakeOperation = value!;
                  });
                },
              ),
              buildDropdownFormField(
                'Speedo',
                _form.speedo,
                (value) {
                  setState(() {
                    _form.speedo = value!;
                  });
                },
              ),
              buildDropdownFormField(
                'Cruise Control',
                _form.cruiseControl,
                (value) {
                  setState(() {
                    _form.cruiseControl = value!;
                  });
                },
              ),
              buildDropdownFormField(
                '4WD',
                _form._4wd,
                (value) {
                  setState(() {
                    _form._4wd = value!;
                  });
                },
              ),
              buildDropdownFormField(
                'Camshaft / Drive Belt',
                _form.camshaftDriveBelt,
                (value) {
                  setState(() {
                    _form.camshaftDriveBelt = value!;
                  });
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Road Test Comments'),
                onChanged: (value) {
                  setState(() {
                    _form.roadTestComments = value;
                  });
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => pickImages(context, _form.roadTestImages),
                child: Text('Add Images'),
              ),
              SizedBox(height: 20),
              // Displaying the image grid
              _form.roadTestImages.isEmpty
                  ? Container()
                  : Container(
                      height: 200, // Set a fixed height for the grid
                      child: buildImageGrid(_form.roadTestImages),
                    ),

              // Add more DropdownButtonFormField widgets for other road test inspection fields
            ],
          ),
        ),
        Step(
          isActive: _currentStep >= 6,
          title: Text(''),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Overall Rating & General Comments',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              buildDropdownFormField(
                'Overall Rating',
                _form.overallRating,
                (value) {
                  setState(() {
                    _form.overallRating = value!;
                  });
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'General Comments'),
                onChanged: (value) {
                  setState(() {
                    _form.generalComments = value;
                  });
                },
              ),
            ],
          ),
        ),
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.green.shade400,
        centerTitle: true,
        title: Text(
          'My Mechanic QLD - Inspection App',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ColorScheme.light(primary: Colors.green.shade400),
        ),
        child: Stepper(
          type: StepperType.horizontal,
          steps: _inspectionSteps,
          currentStep: _currentStep,
          onStepContinue: _next,
          onStepCancel: _previous,
          onStepTapped: (step) {
            setState(() {
              _currentStep = step;
            });
          },
          controlsBuilder:
              (BuildContext context, ControlsDetails controlsDetails) {
            return Container(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (_currentStep != 0)
                    GestureDetector(
                      onTap: () {
                        controlsDetails.onStepCancel!();
                      },
                      child: Container(
                          decoration: BoxDecoration(
                            color: Colors.green.shade400,
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 8.0),
                            child: Text('Previous',
                                style: TextStyle(color: Colors.white)),
                          )),
                    ),
                  if (_currentStep != _inspectionSteps.length - 1)
                    GestureDetector(
                      onTap: () {
                        controlsDetails.onStepContinue!();
                      },
                      child: Container(
                          decoration: BoxDecoration(
                            color: Colors.green.shade400,
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 8.0),
                            child: Text('Next',
                                style: TextStyle(color: Colors.white)),
                          )),
                    ),
                  if (_currentStep == _inspectionSteps.length - 1)
                    GestureDetector(
                      onTap: () {
                        _saveForm();
                      },
                      child: Container(
                          decoration: BoxDecoration(
                            color: Colors.green.shade400,
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 8.0),
                            child: Text('Save Form',
                                style: TextStyle(color: Colors.white)),
                          )),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
