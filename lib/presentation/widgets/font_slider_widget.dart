import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kjv_strong/logics/providers.dart';

class FontSliderWidget extends ConsumerWidget {
  const FontSliderWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      title: const Text("Font Size"),
      trailing: Text(ref.watch(fontSizeProvider).toStringAsFixed(1)),
      subtitle: SliderTheme(
        data: const SliderThemeData(
          trackHeight: 1.5,
          thumbShape: RoundSliderThumbShape(enabledThumbRadius: 7.0),),
        child: Slider(
          min: 12.0,
          max: 30.0,
          value: ref.watch(fontSizeProvider),
          inactiveColor: Colors.grey[500],
          onChanged: (value) {
            ref.watch(fontSizeProvider.notifier).state = value;
          },
          onChangeEnd: (value) {
            ref.watch(boxStorageProvider).saveFontSize(value);
          },
        ),
      ),
    );
  }
}