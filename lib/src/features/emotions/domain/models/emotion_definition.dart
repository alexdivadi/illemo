import 'package:flutter/material.dart';

enum EmotionKey { joy, sadness, anger, fear, disgust, surprise }

@immutable
class EmotionDefinition {
  const EmotionDefinition({
    required this.id,
    required this.label,
    required this.core,
    this.parentId,
  });

  final String id;
  final String label;
  final EmotionKey core;
  final String? parentId;

  bool get isCore => parentId == null;

  static const values = <EmotionDefinition>[
    EmotionDefinition(id: 'joy', label: 'Joy', core: EmotionKey.joy),
    EmotionDefinition(id: 'joy.grateful', label: 'Grateful', core: EmotionKey.joy, parentId: 'joy'),
    EmotionDefinition(
        id: 'joy.grateful.appreciative',
        label: 'Appreciative',
        core: EmotionKey.joy,
        parentId: 'joy.grateful'),
    EmotionDefinition(
        id: 'joy.grateful.touched',
        label: 'Touched',
        core: EmotionKey.joy,
        parentId: 'joy.grateful'),
    EmotionDefinition(
        id: 'joy.grateful.blessed',
        label: 'Blessed',
        core: EmotionKey.joy,
        parentId: 'joy.grateful'),
    EmotionDefinition(id: 'joy.hopeful', label: 'Hopeful', core: EmotionKey.joy, parentId: 'joy'),
    EmotionDefinition(
        id: 'joy.hopeful.optimistic',
        label: 'Optimistic',
        core: EmotionKey.joy,
        parentId: 'joy.hopeful'),
    EmotionDefinition(
        id: 'joy.hopeful.encouraged',
        label: 'Encouraged',
        core: EmotionKey.joy,
        parentId: 'joy.hopeful'),
    EmotionDefinition(
        id: 'joy.hopeful.inspired',
        label: 'Inspired',
        core: EmotionKey.joy,
        parentId: 'joy.hopeful'),
    EmotionDefinition(id: 'joy.playful', label: 'Playful', core: EmotionKey.joy, parentId: 'joy'),
    EmotionDefinition(
        id: 'joy.playful.energetic',
        label: 'Energetic',
        core: EmotionKey.joy,
        parentId: 'joy.playful'),
    EmotionDefinition(
        id: 'joy.playful.silly', label: 'Silly', core: EmotionKey.joy, parentId: 'joy.playful'),
    EmotionDefinition(
        id: 'joy.playful.lighthearted',
        label: 'Lighthearted',
        core: EmotionKey.joy,
        parentId: 'joy.playful'),
    EmotionDefinition(id: 'joy.proud', label: 'Proud', core: EmotionKey.joy, parentId: 'joy'),
    EmotionDefinition(
        id: 'joy.proud.confident', label: 'Confident', core: EmotionKey.joy, parentId: 'joy.proud'),
    EmotionDefinition(
        id: 'joy.proud.accomplished',
        label: 'Accomplished',
        core: EmotionKey.joy,
        parentId: 'joy.proud'),
    EmotionDefinition(
        id: 'joy.proud.worthy', label: 'Worthy', core: EmotionKey.joy, parentId: 'joy.proud'),
    EmotionDefinition(id: 'joy.content', label: 'Content', core: EmotionKey.joy, parentId: 'joy'),
    EmotionDefinition(
        id: 'joy.content.peaceful',
        label: 'Peaceful',
        core: EmotionKey.joy,
        parentId: 'joy.content'),
    EmotionDefinition(
        id: 'joy.content.satisfied',
        label: 'Satisfied',
        core: EmotionKey.joy,
        parentId: 'joy.content'),
    EmotionDefinition(
        id: 'joy.content.fulfilled',
        label: 'Fulfilled',
        core: EmotionKey.joy,
        parentId: 'joy.content'),
    EmotionDefinition(id: 'joy.excited', label: 'Excited', core: EmotionKey.joy, parentId: 'joy'),
    EmotionDefinition(
        id: 'joy.excited.eager', label: 'Eager', core: EmotionKey.joy, parentId: 'joy.excited'),
    EmotionDefinition(
        id: 'joy.excited.enthusiastic',
        label: 'Enthusiastic',
        core: EmotionKey.joy,
        parentId: 'joy.excited'),
    EmotionDefinition(
        id: 'joy.excited.thrilled',
        label: 'Thrilled',
        core: EmotionKey.joy,
        parentId: 'joy.excited'),
    EmotionDefinition(id: 'sadness', label: 'Sadness', core: EmotionKey.sadness),
    EmotionDefinition(
        id: 'sadness.lonely', label: 'Lonely', core: EmotionKey.sadness, parentId: 'sadness'),
    EmotionDefinition(
        id: 'sadness.lonely.isolated',
        label: 'Isolated',
        core: EmotionKey.sadness,
        parentId: 'sadness.lonely'),
    EmotionDefinition(
        id: 'sadness.lonely.disconnected',
        label: 'Disconnected',
        core: EmotionKey.sadness,
        parentId: 'sadness.lonely'),
    EmotionDefinition(
        id: 'sadness.lonely.left_out',
        label: 'Left out',
        core: EmotionKey.sadness,
        parentId: 'sadness.lonely'),
    EmotionDefinition(
        id: 'sadness.hurt', label: 'Hurt', core: EmotionKey.sadness, parentId: 'sadness'),
    EmotionDefinition(
        id: 'sadness.hurt.wounded',
        label: 'Wounded',
        core: EmotionKey.sadness,
        parentId: 'sadness.hurt'),
    EmotionDefinition(
        id: 'sadness.hurt.let_down',
        label: 'Let down',
        core: EmotionKey.sadness,
        parentId: 'sadness.hurt'),
    EmotionDefinition(
        id: 'sadness.hurt.betrayed',
        label: 'Betrayed',
        core: EmotionKey.sadness,
        parentId: 'sadness.hurt'),
    EmotionDefinition(
        id: 'sadness.vulnerable',
        label: 'Vulnerable',
        core: EmotionKey.sadness,
        parentId: 'sadness'),
    EmotionDefinition(
        id: 'sadness.vulnerable.exposed',
        label: 'Exposed',
        core: EmotionKey.sadness,
        parentId: 'sadness.vulnerable'),
    EmotionDefinition(
        id: 'sadness.vulnerable.fragile',
        label: 'Fragile',
        core: EmotionKey.sadness,
        parentId: 'sadness.vulnerable'),
    EmotionDefinition(
        id: 'sadness.vulnerable.tender',
        label: 'Tender',
        core: EmotionKey.sadness,
        parentId: 'sadness.vulnerable'),
    EmotionDefinition(
        id: 'sadness.exhausted', label: 'Exhausted', core: EmotionKey.sadness, parentId: 'sadness'),
    EmotionDefinition(
        id: 'sadness.exhausted.drained',
        label: 'Drained',
        core: EmotionKey.sadness,
        parentId: 'sadness.exhausted'),
    EmotionDefinition(
        id: 'sadness.exhausted.depleted',
        label: 'Depleted',
        core: EmotionKey.sadness,
        parentId: 'sadness.exhausted'),
    EmotionDefinition(
        id: 'sadness.exhausted.spent',
        label: 'Spent',
        core: EmotionKey.sadness,
        parentId: 'sadness.exhausted'),
    EmotionDefinition(
        id: 'sadness.grief', label: 'Grief', core: EmotionKey.sadness, parentId: 'sadness'),
    EmotionDefinition(
        id: 'sadness.grief.loss',
        label: 'Loss',
        core: EmotionKey.sadness,
        parentId: 'sadness.grief'),
    EmotionDefinition(
        id: 'sadness.grief.mourning',
        label: 'Mourning',
        core: EmotionKey.sadness,
        parentId: 'sadness.grief'),
    EmotionDefinition(
        id: 'sadness.grief.heartbroken',
        label: 'Heartbroken',
        core: EmotionKey.sadness,
        parentId: 'sadness.grief'),
    EmotionDefinition(
        id: 'sadness.hopeless', label: 'Hopeless', core: EmotionKey.sadness, parentId: 'sadness'),
    EmotionDefinition(
        id: 'sadness.hopeless.powerless',
        label: 'Powerless',
        core: EmotionKey.sadness,
        parentId: 'sadness.hopeless'),
    EmotionDefinition(
        id: 'sadness.hopeless.despairing',
        label: 'Despairing',
        core: EmotionKey.sadness,
        parentId: 'sadness.hopeless'),
    EmotionDefinition(
        id: 'sadness.hopeless.empty',
        label: 'Empty',
        core: EmotionKey.sadness,
        parentId: 'sadness.hopeless'),
    EmotionDefinition(id: 'anger', label: 'Anger', core: EmotionKey.anger),
    EmotionDefinition(
        id: 'anger.frustrated', label: 'Frustrated', core: EmotionKey.anger, parentId: 'anger'),
    EmotionDefinition(
        id: 'anger.frustrated.annoyed',
        label: 'Annoyed',
        core: EmotionKey.anger,
        parentId: 'anger.frustrated'),
    EmotionDefinition(
        id: 'anger.frustrated.blocked',
        label: 'Blocked',
        core: EmotionKey.anger,
        parentId: 'anger.frustrated'),
    EmotionDefinition(
        id: 'anger.frustrated.impatient',
        label: 'Impatient',
        core: EmotionKey.anger,
        parentId: 'anger.frustrated'),
    EmotionDefinition(
        id: 'anger.resentful', label: 'Resentful', core: EmotionKey.anger, parentId: 'anger'),
    EmotionDefinition(
        id: 'anger.resentful.bitter',
        label: 'Bitter',
        core: EmotionKey.anger,
        parentId: 'anger.resentful'),
    EmotionDefinition(
        id: 'anger.resentful.indignant',
        label: 'Indignant',
        core: EmotionKey.anger,
        parentId: 'anger.resentful'),
    EmotionDefinition(
        id: 'anger.resentful.offended',
        label: 'Offended',
        core: EmotionKey.anger,
        parentId: 'anger.resentful'),
    EmotionDefinition(
        id: 'anger.jealous', label: 'Jealous', core: EmotionKey.anger, parentId: 'anger'),
    EmotionDefinition(
        id: 'anger.jealous.envious',
        label: 'Envious',
        core: EmotionKey.anger,
        parentId: 'anger.jealous'),
    EmotionDefinition(
        id: 'anger.jealous.suspicious',
        label: 'Suspicious',
        core: EmotionKey.anger,
        parentId: 'anger.jealous'),
    EmotionDefinition(
        id: 'anger.jealous.unsettled',
        label: 'Unsettled',
        core: EmotionKey.anger,
        parentId: 'anger.jealous'),
    EmotionDefinition(
        id: 'anger.critical', label: 'Critical', core: EmotionKey.anger, parentId: 'anger'),
    EmotionDefinition(
        id: 'anger.critical.sceptical',
        label: 'Sceptical',
        core: EmotionKey.anger,
        parentId: 'anger.critical'),
    EmotionDefinition(
        id: 'anger.critical.dismissive',
        label: 'Dismissive',
        core: EmotionKey.anger,
        parentId: 'anger.critical'),
    EmotionDefinition(
        id: 'anger.critical.exasperated',
        label: 'Exasperated',
        core: EmotionKey.anger,
        parentId: 'anger.critical'),
    EmotionDefinition(
        id: 'anger.overwhelmed', label: 'Overwhelmed', core: EmotionKey.anger, parentId: 'anger'),
    EmotionDefinition(
        id: 'anger.overwhelmed.stressed',
        label: 'Stressed',
        core: EmotionKey.anger,
        parentId: 'anger.overwhelmed'),
    EmotionDefinition(
        id: 'anger.overwhelmed.frantic',
        label: 'Frantic',
        core: EmotionKey.anger,
        parentId: 'anger.overwhelmed'),
    EmotionDefinition(
        id: 'anger.overwhelmed.out_of_control',
        label: 'Out of control',
        core: EmotionKey.anger,
        parentId: 'anger.overwhelmed'),
    EmotionDefinition(
        id: 'anger.withdrawn', label: 'Withdrawn', core: EmotionKey.anger, parentId: 'anger'),
    EmotionDefinition(
        id: 'anger.withdrawn.numb',
        label: 'Numb',
        core: EmotionKey.anger,
        parentId: 'anger.withdrawn'),
    EmotionDefinition(
        id: 'anger.withdrawn.detached',
        label: 'Detached',
        core: EmotionKey.anger,
        parentId: 'anger.withdrawn'),
    EmotionDefinition(
        id: 'anger.withdrawn.checked_out',
        label: 'Checked out',
        core: EmotionKey.anger,
        parentId: 'anger.withdrawn'),
    EmotionDefinition(id: 'fear', label: 'Fear', core: EmotionKey.fear),
    EmotionDefinition(
        id: 'fear.anxious', label: 'Anxious', core: EmotionKey.fear, parentId: 'fear'),
    EmotionDefinition(
        id: 'fear.anxious.worried',
        label: 'Worried',
        core: EmotionKey.fear,
        parentId: 'fear.anxious'),
    EmotionDefinition(
        id: 'fear.anxious.apprehensive',
        label: 'Apprehensive',
        core: EmotionKey.fear,
        parentId: 'fear.anxious'),
    EmotionDefinition(
        id: 'fear.anxious.uneasy',
        label: 'Uneasy',
        core: EmotionKey.fear,
        parentId: 'fear.anxious'),
    EmotionDefinition(
        id: 'fear.insecure', label: 'Insecure', core: EmotionKey.fear, parentId: 'fear'),
    EmotionDefinition(
        id: 'fear.insecure.inferior',
        label: 'Inferior',
        core: EmotionKey.fear,
        parentId: 'fear.insecure'),
    EmotionDefinition(
        id: 'fear.insecure.uncertain',
        label: 'Uncertain',
        core: EmotionKey.fear,
        parentId: 'fear.insecure'),
    EmotionDefinition(
        id: 'fear.insecure.unworthy',
        label: 'Unworthy',
        core: EmotionKey.fear,
        parentId: 'fear.insecure'),
    EmotionDefinition(id: 'fear.scared', label: 'Scared', core: EmotionKey.fear, parentId: 'fear'),
    EmotionDefinition(
        id: 'fear.scared.threatened',
        label: 'Threatened',
        core: EmotionKey.fear,
        parentId: 'fear.scared'),
    EmotionDefinition(
        id: 'fear.scared.panicked',
        label: 'Panicked',
        core: EmotionKey.fear,
        parentId: 'fear.scared'),
    EmotionDefinition(
        id: 'fear.scared.dreading',
        label: 'Dreading',
        core: EmotionKey.fear,
        parentId: 'fear.scared'),
    EmotionDefinition(
        id: 'fear.rejected', label: 'Rejected', core: EmotionKey.fear, parentId: 'fear'),
    EmotionDefinition(
        id: 'fear.rejected.excluded',
        label: 'Excluded',
        core: EmotionKey.fear,
        parentId: 'fear.rejected'),
    EmotionDefinition(
        id: 'fear.rejected.unwanted',
        label: 'Unwanted',
        core: EmotionKey.fear,
        parentId: 'fear.rejected'),
    EmotionDefinition(
        id: 'fear.rejected.abandoned',
        label: 'Abandoned',
        core: EmotionKey.fear,
        parentId: 'fear.rejected'),
    EmotionDefinition(
        id: 'fear.helpless', label: 'Helpless', core: EmotionKey.fear, parentId: 'fear'),
    EmotionDefinition(
        id: 'fear.helpless.trapped',
        label: 'Trapped',
        core: EmotionKey.fear,
        parentId: 'fear.helpless'),
    EmotionDefinition(
        id: 'fear.helpless.stuck',
        label: 'Stuck',
        core: EmotionKey.fear,
        parentId: 'fear.helpless'),
    EmotionDefinition(
        id: 'fear.helpless.powerless',
        label: 'Powerless',
        core: EmotionKey.fear,
        parentId: 'fear.helpless'),
    EmotionDefinition(
        id: 'fear.confused', label: 'Confused', core: EmotionKey.fear, parentId: 'fear'),
    EmotionDefinition(
        id: 'fear.confused.lost', label: 'Lost', core: EmotionKey.fear, parentId: 'fear.confused'),
    EmotionDefinition(
        id: 'fear.confused.torn', label: 'Torn', core: EmotionKey.fear, parentId: 'fear.confused'),
    EmotionDefinition(
        id: 'fear.confused.conflicted',
        label: 'Conflicted',
        core: EmotionKey.fear,
        parentId: 'fear.confused'),
    EmotionDefinition(id: 'disgust', label: 'Disgust', core: EmotionKey.disgust),
    EmotionDefinition(
        id: 'disgust.disapproving',
        label: 'Disapproving',
        core: EmotionKey.disgust,
        parentId: 'disgust'),
    EmotionDefinition(
        id: 'disgust.disapproving.judging',
        label: 'Judging',
        core: EmotionKey.disgust,
        parentId: 'disgust.disapproving'),
    EmotionDefinition(
        id: 'disgust.disapproving.appalled',
        label: 'Appalled',
        core: EmotionKey.disgust,
        parentId: 'disgust.disapproving'),
    EmotionDefinition(
        id: 'disgust.disapproving.shocked',
        label: 'Shocked',
        core: EmotionKey.disgust,
        parentId: 'disgust.disapproving'),
    EmotionDefinition(
        id: 'disgust.disappointed',
        label: 'Disappointed',
        core: EmotionKey.disgust,
        parentId: 'disgust'),
    EmotionDefinition(
        id: 'disgust.disappointed.let_down',
        label: 'Let down',
        core: EmotionKey.disgust,
        parentId: 'disgust.disappointed'),
    EmotionDefinition(
        id: 'disgust.disappointed.disillusioned',
        label: 'Disillusioned',
        core: EmotionKey.disgust,
        parentId: 'disgust.disappointed'),
    EmotionDefinition(
        id: 'disgust.disappointed.deflated',
        label: 'Deflated',
        core: EmotionKey.disgust,
        parentId: 'disgust.disappointed'),
    EmotionDefinition(
        id: 'disgust.avoidant', label: 'Avoidant', core: EmotionKey.disgust, parentId: 'disgust'),
    EmotionDefinition(
        id: 'disgust.avoidant.hesitant',
        label: 'Hesitant',
        core: EmotionKey.disgust,
        parentId: 'disgust.avoidant'),
    EmotionDefinition(
        id: 'disgust.avoidant.reluctant',
        label: 'Reluctant',
        core: EmotionKey.disgust,
        parentId: 'disgust.avoidant'),
    EmotionDefinition(
        id: 'disgust.avoidant.resistant',
        label: 'Resistant',
        core: EmotionKey.disgust,
        parentId: 'disgust.avoidant'),
    EmotionDefinition(
        id: 'disgust.repulsed', label: 'Repulsed', core: EmotionKey.disgust, parentId: 'disgust'),
    EmotionDefinition(
        id: 'disgust.repulsed.unsettled',
        label: 'Unsettled',
        core: EmotionKey.disgust,
        parentId: 'disgust.repulsed'),
    EmotionDefinition(
        id: 'disgust.repulsed.revolted',
        label: 'Revolted',
        core: EmotionKey.disgust,
        parentId: 'disgust.repulsed'),
    EmotionDefinition(
        id: 'disgust.repulsed.bothered',
        label: 'Bothered',
        core: EmotionKey.disgust,
        parentId: 'disgust.repulsed'),
    EmotionDefinition(
        id: 'disgust.awful', label: 'Awful', core: EmotionKey.disgust, parentId: 'disgust'),
    EmotionDefinition(
        id: 'disgust.awful.terrible',
        label: 'Terrible',
        core: EmotionKey.disgust,
        parentId: 'disgust.awful'),
    EmotionDefinition(
        id: 'disgust.awful.dreadful',
        label: 'Dreadful',
        core: EmotionKey.disgust,
        parentId: 'disgust.awful'),
    EmotionDefinition(
        id: 'disgust.awful.horrible',
        label: 'Horrible',
        core: EmotionKey.disgust,
        parentId: 'disgust.awful'),
    EmotionDefinition(id: 'surprise', label: 'Surprise', core: EmotionKey.surprise),
    EmotionDefinition(
        id: 'surprise.startled',
        label: 'Startled',
        core: EmotionKey.surprise,
        parentId: 'surprise'),
    EmotionDefinition(
        id: 'surprise.startled.shocked',
        label: 'Shocked',
        core: EmotionKey.surprise,
        parentId: 'surprise.startled'),
    EmotionDefinition(
        id: 'surprise.startled.shaken',
        label: 'Shaken',
        core: EmotionKey.surprise,
        parentId: 'surprise.startled'),
    EmotionDefinition(
        id: 'surprise.startled.off_guard',
        label: 'Off guard',
        core: EmotionKey.surprise,
        parentId: 'surprise.startled'),
    EmotionDefinition(
        id: 'surprise.amazed', label: 'Amazed', core: EmotionKey.surprise, parentId: 'surprise'),
    EmotionDefinition(
        id: 'surprise.amazed.astonished',
        label: 'Astonished',
        core: EmotionKey.surprise,
        parentId: 'surprise.amazed'),
    EmotionDefinition(
        id: 'surprise.amazed.awestruck',
        label: 'Awestruck',
        core: EmotionKey.surprise,
        parentId: 'surprise.amazed'),
    EmotionDefinition(
        id: 'surprise.amazed.stunned',
        label: 'Stunned',
        core: EmotionKey.surprise,
        parentId: 'surprise.amazed'),
    EmotionDefinition(
        id: 'surprise.confused',
        label: 'Confused',
        core: EmotionKey.surprise,
        parentId: 'surprise'),
    EmotionDefinition(
        id: 'surprise.confused.puzzled',
        label: 'Puzzled',
        core: EmotionKey.surprise,
        parentId: 'surprise.confused'),
    EmotionDefinition(
        id: 'surprise.confused.perplexed',
        label: 'Perplexed',
        core: EmotionKey.surprise,
        parentId: 'surprise.confused'),
    EmotionDefinition(
        id: 'surprise.confused.disoriented',
        label: 'Disoriented',
        core: EmotionKey.surprise,
        parentId: 'surprise.confused'),
    EmotionDefinition(
        id: 'surprise.curious', label: 'Curious', core: EmotionKey.surprise, parentId: 'surprise'),
    EmotionDefinition(
        id: 'surprise.curious.interested',
        label: 'Interested',
        core: EmotionKey.surprise,
        parentId: 'surprise.curious'),
    EmotionDefinition(
        id: 'surprise.curious.intrigued',
        label: 'Intrigued',
        core: EmotionKey.surprise,
        parentId: 'surprise.curious'),
    EmotionDefinition(
        id: 'surprise.curious.fascinated',
        label: 'Fascinated',
        core: EmotionKey.surprise,
        parentId: 'surprise.curious'),
    EmotionDefinition(
        id: 'surprise.moved', label: 'Moved', core: EmotionKey.surprise, parentId: 'surprise'),
    EmotionDefinition(
        id: 'surprise.moved.touched',
        label: 'Touched',
        core: EmotionKey.surprise,
        parentId: 'surprise.moved'),
    EmotionDefinition(
        id: 'surprise.moved.speechless',
        label: 'Speechless',
        core: EmotionKey.surprise,
        parentId: 'surprise.moved'),
    EmotionDefinition(
        id: 'surprise.moved.overwhelmed',
        label: 'Overwhelmed',
        core: EmotionKey.surprise,
        parentId: 'surprise.moved'),
  ];

  static final Map<String, EmotionDefinition> _byId = {
    for (final emotion in values) emotion.id: emotion,
  };

  static List<EmotionDefinition> get cores => values.where((emotion) => emotion.isCore).toList();

  static EmotionDefinition get(String id) =>
      _byId[id] ?? (throw ArgumentError.value(id, 'id', 'Unknown emotion'));

  static List<EmotionDefinition> childrenOf(String id) =>
      values.where((emotion) => emotion.parentId == id).toList();
}

extension EmotionKeyPresentation on EmotionKey {
  Color get card => switch (this) {
        EmotionKey.joy => const Color(0xFFFDF3C0),
        EmotionKey.sadness => const Color(0xFFDBE9F8),
        EmotionKey.anger => const Color(0xFFFDDDD8),
        EmotionKey.fear => const Color(0xFFEBE0F8),
        EmotionKey.disgust => const Color(0xFFD6EEDE),
        EmotionKey.surprise => const Color(0xFFFDEAD8),
      };

  Color get border => switch (this) {
        EmotionKey.joy => const Color(0xFFE8C840),
        EmotionKey.sadness => const Color(0xFF8ABADC),
        EmotionKey.anger => const Color(0xFFE89080),
        EmotionKey.fear => const Color(0xFFB898DC),
        EmotionKey.disgust => const Color(0xFF80C098),
        EmotionKey.surprise => const Color(0xFFECA870),
      };

  Color get foreground => switch (this) {
        EmotionKey.joy => const Color(0xFF5A3E00),
        EmotionKey.sadness => const Color(0xFF1A3A5C),
        EmotionKey.anger => const Color(0xFF6A1A08),
        EmotionKey.fear => const Color(0xFF32147A),
        EmotionKey.disgust => const Color(0xFF174428),
        EmotionKey.surprise => const Color(0xFF6A2800),
      };

  Color soft(Color surface) => Color.alphaBlend(border.withValues(alpha: 0.20), surface);

  Color flood(Color surface) => Color.alphaBlend(border.withValues(alpha: 0.42), surface);

  Color foregroundOn(Color surface) =>
      ThemeData.estimateBrightnessForColor(surface) == Brightness.dark
          ? Color.alphaBlend(border.withValues(alpha: 0.35), Colors.white)
          : foreground;
}
