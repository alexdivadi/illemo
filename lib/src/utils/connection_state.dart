import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'connection_state.g.dart';

@riverpod
Stream<List<ConnectivityResult>> connectionState(Ref ref) {
  final connectivity = Connectivity();
  return connectivity.onConnectivityChanged;
}
