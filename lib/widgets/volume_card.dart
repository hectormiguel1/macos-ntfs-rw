import 'package:disk_util/disk_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:macos_ntfs_rw/providers/disk_provider.dart';
import 'package:percent_indicator/percent_indicator.dart';

class VolumeCard extends ConsumerWidget {
  final Volume vol;

  const VolumeCard({required this.vol, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final diskObserver = ref.watch(volumeProvider);
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Card(
          elevation: 10,
          margin: const EdgeInsets.all(5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                const FaIcon(FontAwesomeIcons.hardDrive, size: 36),
                const SizedBox(width: 20),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      vol.label.isNotEmpty ? vol.label : vol.fsHandler.path,
                      style: const TextStyle(
                          fontWeight: FontWeight.w500, fontSize: 16),
                    ),
                    const SizedBox(height: 5),
                    Text("Filesystem Type: ${vol.fsType.type.toUpperCase()}"),
                    const SizedBox(height: 5),
                    Text("Is Mounted: ${vol.isMounted ? "Yes" : "No"}"),
                    const SizedBox(height: 5),
                    Text(vol.isMounted
                        ? "Mounted At: ${vol.mountPoint!.path}"
                        : "Not Mounted"),
                    const SizedBox(height: 5),
                    LinearPercentIndicator(
                      padding: const EdgeInsets.all(0),
                      barRadius: const Radius.circular(20),
                      width: 270,
                      lineHeight: 30,
                      animation: true,
                      animationDuration: 600,
                      center: Text(
                        "${DiskUtil.formatSize(vol.sizeUsed)} Out of ${DiskUtil.formatSize(vol.size)} Used",
                        style: const TextStyle(
                            color: Colors.black, fontWeight: FontWeight.w400),
                      ),
                      percent: vol.sizeUsed / vol.size,
                      progressColor: Theme.of(context).colorScheme.primary,
                    ),
                  ],
                ),
                const SizedBox(width: 20),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    OutlinedButton(
                        onPressed: () => diskObserver.mountVolRW(vol),
                        child: const Text("Mount R/W")),
                    const SizedBox(height: 20),
                    OutlinedButton(
                        onPressed: () {}, child: const Text(" Unmount "))
                  ],
                )
              ],
            ),
          )),
    );
  }
}
