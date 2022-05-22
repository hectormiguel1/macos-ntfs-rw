import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:macos_ntfs_rw/providers/disk_provider.dart';
import 'package:macos_ntfs_rw/providers/theme_provider.dart';
import 'package:macos_ntfs_rw/widgets/theme_controls.dart';
import 'package:macos_ntfs_rw/widgets/volume_card.dart';

class MainPage extends ConsumerWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final volProvider = ref.watch(volumeProvider);
    final volumes = volProvider.ntfsVolumes().length > 1
        ? volProvider.ntfsVolumes()
        : volProvider.getAllVolumes();
    final theme = ref.watch(themeProvider);
    return Scaffold(
        body: Column(children: [
      const Flexible(flex: 1, child: ThemeControls()),
      const SizedBox(
        height: 2,
      ),
      Expanded(
        flex: 9,
        child: ListView.builder(
            itemCount: volumes.length,
            itemBuilder: (context, idx) => VolumeCard(vol: volumes[idx])),
      ),
    ]));
  }
}
