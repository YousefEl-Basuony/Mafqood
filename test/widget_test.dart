import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mafqood/core/theme/app_theme.dart';

void main() {
  test('Mafqood light and dark themes build cleanly', () {
    final light = AppTheme.lightTheme();
    final dark = AppTheme.darkTheme();
    expect(light.brightness, Brightness.light);
    expect(dark.brightness, Brightness.dark);
  });
}
