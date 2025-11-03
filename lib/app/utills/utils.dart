import 'dart:io';
import 'dart:js_interop';

import 'package:fan_poll/app/utills/custom_snackbar.dart';
import 'package:flutter/foundation.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:screenshot/screenshot.dart';
import 'package:web/web.dart' as web;

class Utils {
  static String calculateDaysLeft(String expiresAt) {
    try {
      final expiryDate = DateTime.parse(expiresAt);
      final now = DateTime.now();

      if (expiryDate.isBefore(now)) return "Ended";
      final difference = expiryDate.difference(now).inDays;
      return "$difference Days Left";
    } catch (e) {
      return "Unknown";
    }
  }

  static formatDate(String dateString) {
    try {
      final dateTime = DateTime.parse(dateString);
      return DateFormat("d MMM, yyyy").format(dateTime);
    } catch (e) {
      return "Invalid date";
    }
  }

  static formatNotificationTime(String rawDateTime) {
    final dateTime = DateTime.parse(rawDateTime);
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes <= 3) {
      return 'Few minutes ago';
    }

    final today = DateTime(now.year, now.month, now.day);
    final notificationDate = DateTime(dateTime.year, dateTime.month, dateTime.day);

    if (notificationDate == today) {
      return 'Today at ${DateFormat.jm().format(dateTime)}';
    }

    if (notificationDate == today.subtract(const Duration(days: 1))) {
      return 'Yesterday at ${DateFormat.jm().format(dateTime)}';
    }

    return DateFormat('dd/MM/yy hh:mma').format(dateTime);
    // return '${DateFormat('dd MMM yyyy').format(dateTime)} ${DateFormat.jm().format(dateTime)}';
  }

  // Future<void> captureAndGeneratePDF(
  //     ScreenshotController controller, String pollId) async {
  //   final imageBytes = await controller.capture();

  //   if (imageBytes != null) {
  //     final pdf = pw.Document();
  //     final image = pw.MemoryImage(imageBytes);

  //     pdf.addPage(
  //       pw.Page(
  //         build: (pw.Context context) {
  //           return pw.Center(
  //             child: pw.Image(image),
  //           );
  //         },
  //       ),
  //     );

  //     final directory = Directory('/storage/emulated/0/Download');
  //     final file = File("${directory.path}/$pollId.pdf");
  //     await file.writeAsBytes(await pdf.save());

  //     CustomSnackbar.success("Download completed", "PDF download successfully");
  //   }
  // }
  Future<void> captureAndGeneratePDF(ScreenshotController controller, String pollId) async {
    final imageBytes = await controller.capture();

    if (imageBytes != null) {
      if (kIsWeb) {
        // ✅ Provide download on web
        downloadImageWeb(imageBytes, 'poll_$pollId.png');
        CustomSnackbar.success("Downloaded", "Image downloaded");
        return;
      }

      // ✅ Mobile permission and gallery save
      PermissionStatus status;
      if (Platform.isAndroid) {
        status = await Permission.storage.request();
        if (!status.isGranted) {
          status = await Permission.photos.request();
        }
      } else {
        status = await Permission.photos.request();
      }

      if (!status.isGranted) {
        CustomSnackbar.error("Permission denied", "Cannot save image to gallery");
        return;
      }

      final result = await ImageGallerySaverPlus.saveImage(
        Uint8List.fromList(imageBytes),
        quality: 100,
        name: "poll_$pollId",
      );

      if (result['isSuccess'] == true) {
        CustomSnackbar.success("Saved", "Image saved to gallery");
      } else {
        CustomSnackbar.error("Error", "Failed to save image to gallery");
      }
    } else {
      CustomSnackbar.error("Error", "Failed to capture image");
    }
  }

  void downloadImageWeb(Uint8List imageBytes, String fileName) {
    // Convert Dart Uint8List to JavaScript Uint8Array
    final jsBytes = imageBytes.toJS;

    // Create a JSArray<JSAny> containing the jsBytes
    final blobParts = [jsBytes].toJS;

    // Create the Blob using JS-compatible parts
    final blob = web.Blob(blobParts);

    // Create object URL and anchor
    final url = web.URL.createObjectURL(blob);
    final anchor = web.document.createElement('a') as web.HTMLAnchorElement;
    anchor.href = url;
    anchor.download = fileName;
    anchor.style.display = 'none';

    web.document.body!.appendChild(anchor);
    anchor.click();

    Future.delayed(const Duration(seconds: 1), () {
      web.URL.revokeObjectURL(url);
      anchor.remove();
    });
  }
}
