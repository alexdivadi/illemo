import 'package:illemo/src/features/emotions/domain/models/emotion.dart';
import 'package:sqflite/sqflite.dart';

const emotionTaxonomyVersion = 2;
const _versionKey = 'emotion_taxonomy_version';

const _v1Labels = {
  'sadness.hurt.let_down': 'Let down',
  'sadness.exhausted': 'Exhausted',
  'sadness.exhausted.drained': 'Drained',
  'sadness.exhausted.depleted': 'Depleted',
  'sadness.exhausted.spent': 'Spent',
  'sadness.hopeless': 'Hopeless',
  'sadness.hopeless.powerless': 'Powerless',
  'sadness.hopeless.despairing': 'Despairing',
  'sadness.hopeless.empty': 'Empty',
  'anger.resentful.indignant': 'Indignant',
  'anger.critical.sceptical': 'Sceptical',
  'anger.critical.exasperated': 'Exasperated',
  'anger.overwhelmed': 'Overwhelmed',
  'anger.overwhelmed.stressed': 'Stressed',
  'anger.overwhelmed.frantic': 'Frantic',
  'anger.overwhelmed.out_of_control': 'Out of control',
};

Future<int> migrateEmotionTaxonomy(DatabaseExecutor db) async {
  final metadata = await db.query(
    'metadata',
    columns: ['value'],
    where: 'key = ?',
    whereArgs: [_versionKey],
    limit: 1,
  );
  final version = metadata.isEmpty ? 1 : int.tryParse(metadata.single['value']! as String) ?? 1;
  if (version >= emotionTaxonomyVersion) return 0;

  final emotionsById = {for (final emotion in Emotion.values) emotion.id: emotion};
  final rows = await db.query('emotion_entries');
  var migrated = 0;
  for (final row in rows) {
    final oldId = (row['deep_id'] ?? row['specific_id'])! as String;
    final emotion = _resolveV1Emotion(oldId, emotionsById);
    if (emotion.id == oldId) continue;

    final parent = emotion.parentId == null ? null : emotionsById[emotion.parentId];
    final specific = parent == null || parent.isCategory ? emotion : parent;
    await db.update(
      'emotion_entries',
      {
        'core_id': emotion.id.split('.').first,
        'specific_id': specific.id,
        'deep_id': specific == emotion ? null : emotion.id,
      },
      where: 'id = ?',
      whereArgs: [row['id']],
    );
    migrated++;
  }
  await db.insert(
    'metadata',
    {'key': _versionKey, 'value': '$emotionTaxonomyVersion'},
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
  return migrated;
}

Emotion _resolveV1Emotion(String oldId, Map<String, Emotion> emotionsById) {
  var candidate = oldId;
  while (true) {
    final existing = emotionsById[candidate];
    if (existing != null) return existing;

    final label = _v1Labels[candidate];
    if (label != null) {
      final root = oldId.split('.').first;
      for (final emotion in Emotion.values) {
        if (emotion.id.startsWith('$root.') && emotion.label == label) return emotion;
      }
    }

    final separator = candidate.lastIndexOf('.');
    if (separator < 0) return emotionsById[oldId.split('.').first]!;
    candidate = candidate.substring(0, separator);
  }
}
