import 'package:illemo/src/features/emotions/data/repositories/emotion_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'export_service.g.dart';

class ExportService {
  ExportService(this.repository);

  final EmotionRepository repository;

  /// Returns JSON for all history, or the inclusive calendar-day range.
  /// Either bound may be omitted. Times of day are ignored.
  Future<String> exportHistory({DateTime? startDate, DateTime? endDate}) =>
      repository.exportHistory(startDate: startDate, endDate: endDate);

  /// Imports JSON from [exportHistory] and returns the number of entries written.
  /// Existing days are skipped unless [override] replaces their entire log.
  /// Invalid backups or ID conflicts roll back the entire import.
  Future<int> importHistory(String json, {bool override = false}) =>
      repository.importHistory(json, override: override);
}

@riverpod
ExportService exportService(Ref ref) => ExportService(ref.watch(emotionRepositoryProvider));
