import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:macos_ntfs_rw/providers/theme_provider.dart';

class ThemeControls extends ConsumerWidget {
  const ThemeControls({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(themeProvider);
    return Card(
      elevation: 10,
        margin: const EdgeInsets.all(8),
        color: Theme.of(context).canvasColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Flexible(
                flex: 1,
                child: IconButton(
                  icon: const Icon(Icons.dark_mode),
                  onPressed: theme.toggleBrightness,
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              Flexible(
                flex: 10,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: Colors.primaries
                      .map((color) =>
                          Stack(alignment: Alignment.center, children: [
                            IconButton(
                              icon: Icon(Icons.circle, color: color),
                              onPressed: () => theme.theme = color,
                            ),
                            theme.theme == color
                                ? const Icon(Icons.check)
                                : Container(),
                          ]))
                      .toList(),
                ),
              ),
            ],
          ),
        ));
  }
}
