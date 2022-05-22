
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:macos_ntfs_rw/contants/logger.dart';

final ntfsDriverProvider = FutureProvider.autoDispose<Directory>((ref) async {
  ref.maintainState = true;
  var process = await Process.run("which", ["ntfs-3g"]);
  if(process.exitCode != 0) {
    logger.e("NTFS Driver was not found, Make Sure that MacFUSE and ntfs-3g is installed!");
    throw "Driver not Installed";
  } else {
    return Directory(process.stdout);
  }
});