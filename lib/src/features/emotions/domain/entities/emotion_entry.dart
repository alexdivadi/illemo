import 'package:equatable/equatable.dart';
import 'package:illemo/src/features/emotions/domain/models/emotion_definition.dart';

class EmotionEntry extends Equatable {
  const EmotionEntry({
    required this.id,
    required this.coreId,
    required this.specificId,
    required this.loggedAt,
    this.deepId,
  });

  final String id;
  final String coreId;
  final String specificId;
  final String? deepId;
  final DateTime loggedAt;

  EmotionDefinition get core => EmotionDefinition.get(coreId);
  EmotionDefinition get specific => EmotionDefinition.get(specificId);
  EmotionDefinition? get deep => deepId == null ? null : EmotionDefinition.get(deepId!);
  String get label => deep?.label ?? specific.label;

  @override
  List<Object?> get props => [id, coreId, specificId, deepId, loggedAt];
}
