import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/app.dart';

void main() {
  runApp(const ProviderScope(child: SyncRunApp()));
}
