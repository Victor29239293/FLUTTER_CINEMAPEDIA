import 'package:flutter_cinemapedia/infrastructure/datasource/drift_datasource.dart';
import 'package:flutter_cinemapedia/infrastructure/repository/loca_storage_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ignore: non_constant_identifier_names
final LocalStorageProvider = Provider((ref) {
  return LocalStorageRepositoryImpl(DriftDatasource());
});
