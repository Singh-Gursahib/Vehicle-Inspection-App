import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

Future<void> saveAndLaunchFile(List<int> bytes, String fileName) async {
  try {
    // Get the external storage directory
    Directory? externalDirectory = await getExternalStorageDirectory();
    if (externalDirectory == null) {
      print('Error: External storage directory is not available.');
      return;
    }

    // Construct the file path
    String filePath = '${externalDirectory.path}/$fileName';

    // Write PDF bytes to the file
    File file = File(filePath);
    await file.writeAsBytes(bytes, flush: true);
    print('PDF saved successfully: $filePath');

    // Launch the file using platform-specific API
    await OpenFile.open(filePath);
  } catch (e) {
    print('Error saving or launching file: $e');
  }
}
