import 'dart:async';
import 'dart:collection';
import 'dart:io';

import 'package:disk_util/disk_util.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:macos_ntfs_rw/contants/logger.dart';
import 'package:macos_ntfs_rw/providers/driver_provider.dart';

final volumeProvider = ChangeNotifierProvider.autoDispose<DisksObserver>((ref) {
  ref.maintainState = true;
  var ntfsDriverPath = ref.watch(ntfsDriverProvider).value;
  return DisksObserver(ntfsDriverPath);
});

class DisksObserver with ChangeNotifier {
  List<Disk> _disks = [];
  final DiskUtil _diskUtil = DiskUtil();
  late Timer _timer;
  late Directory? _driverPath;

  DisksObserver(Directory? driverPath) {
    _driverPath = driverPath;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) => refresh());
  }

  void refresh() => _diskUtil.get_disks().then(
        (disks) {
          if (listEquals(_disks, disks)) {
            return;
          } else {
            _disks = disks;
            notifyListeners();
          }
        },
      );
  UnmodifiableListView<Volume> getAllVolumes() {
    List<Volume> volumes = [];
    for (var disk in _disks) {
      volumes.addAll(disk.volumes);
    }
    return UnmodifiableListView(volumes);
  }
  UnmodifiableListView<Volume> ntfsVolumes() {
    List<Volume> ntfsVolumes = [];

    for (var disk in _disks) {
      for (var volume in disk.volumes) {
        if (volume.fsType == FSType.NTFS) {
          ntfsVolumes.add(volume);
        }
      }
    }

    return UnmodifiableListView(ntfsVolumes);
  }

  void mountVolRW(Volume vol) async {
    compute<Volume, dynamic>((volume) async {
      var mountPoint =
          "/Volumes/${volume.label.isNotEmpty ? volume.label : volume.fsHandler.path.split("/").last}";

      var process = await Process.run("mkdir", ["-p", mountPoint]);
      process = await Process.run("diskutil", ["unmount", vol.fsHandler.path]);
      process = await Process.run(
          _driverPath!.path, [volume.fsHandler.path, mountPoint]);
      if (process.exitCode == 0) {
        logger.i(
            "Mounted ${volume.label.isNotEmpty ? volume.label : volume.fsHandler.path} at $mountPoint with Read/Write Permissions");
      } else {
        logger.e(
            "Failed to mount ${volume.label.isNotEmpty ? volume.label : volume.fsHandler.path} at $mountPoint, diskutil exit code: ${process.exitCode}");
      }
    }, vol)
        .then((_) => refresh());
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}
