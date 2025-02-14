import 'package:flutter/material.dart';
import 'package:illemo/src/features/emotions/domain/models/category.dart';
import 'package:illemo/src/utils/capitalize.dart';

enum Emotion {
  sad(1, Category.sad, tier: 1),
  guilty(2, Category.sad, tier: 2),
  ashamed(3, Category.sad, tier: 2),
  lonely(4, Category.sad, tier: 2),
  depressed(5, Category.sad, tier: 2),
  bored(6, Category.sad, tier: 2),
  tired(7, Category.sad, tier: 2),
  remorseful(8, Category.sad, tier: 3),
  stupid(9, Category.sad, tier: 3),
  inferior(10, Category.sad, tier: 3),
  isolated(11, Category.sad, tier: 3),
  apathetic(12, Category.sad, tier: 3),
  sleepy(13, Category.sad, tier: 3),
  peaceful(14, Category.peaceful, tier: 1),
  content(15, Category.peaceful, tier: 2),
  thoughtful(16, Category.peaceful, tier: 2),
  intimate(17, Category.peaceful, tier: 2),
  loving(18, Category.peaceful, tier: 2),
  trusting(19, Category.peaceful, tier: 2),
  nurturing(20, Category.peaceful, tier: 2),
  relaxed(21, Category.peaceful, tier: 3),
  pensive(22, Category.peaceful, tier: 3),
  responsive(23, Category.peaceful, tier: 3),
  serene(24, Category.peaceful, tier: 3),
  secure(25, Category.peaceful, tier: 3),
  thankful(26, Category.peaceful, tier: 3),
  powerful(27, Category.powerful, tier: 1),
  faithful(28, Category.powerful, tier: 2),
  important(29, Category.powerful, tier: 2),
  appreciated(30, Category.powerful, tier: 2),
  respected(31, Category.powerful, tier: 2),
  proud(32, Category.powerful, tier: 2),
  aware(33, Category.powerful, tier: 2),
  confident(34, Category.powerful, tier: 3),
  discerning(35, Category.powerful, tier: 3),
  valuable(36, Category.powerful, tier: 3),
  worthwhile(37, Category.powerful, tier: 3),
  successful(38, Category.powerful, tier: 3),
  surprised(39, Category.powerful, tier: 3),
  joyful(40, Category.joyful, tier: 1),
  hopeful(41, Category.joyful, tier: 2),
  creative(42, Category.joyful, tier: 2),
  cheerful(43, Category.joyful, tier: 2),
  energetic(44, Category.joyful, tier: 2),
  sensuous(45, Category.joyful, tier: 2),
  excited(46, Category.joyful, tier: 2),
  optimistic(47, Category.joyful, tier: 3),
  playful(48, Category.joyful, tier: 3),
  amused(49, Category.joyful, tier: 3),
  stimulating(50, Category.joyful, tier: 3),
  fascinating(51, Category.joyful, tier: 3),
  daring(52, Category.joyful, tier: 3),
  scared(53, Category.scared, tier: 1),
  anxious(54, Category.scared, tier: 2),
  insecure(55, Category.scared, tier: 2),
  submissive(56, Category.scared, tier: 2),
  helpless(57, Category.scared, tier: 2),
  rejected(58, Category.scared, tier: 2),
  confused(59, Category.scared, tier: 2),
  overwhelmed(60, Category.scared, tier: 3),
  embarrassed(61, Category.scared, tier: 3),
  inadequate(62, Category.scared, tier: 3),
  insignificant(63, Category.scared, tier: 3),
  discouraged(64, Category.scared, tier: 3),
  bewildered(65, Category.scared, tier: 3),
  mad(66, Category.mad, tier: 1),
  critical(67, Category.mad, tier: 2),
  hateful(68, Category.mad, tier: 2),
  selfish(69, Category.mad, tier: 2),
  angry(70, Category.mad, tier: 2),
  hostile(71, Category.mad, tier: 2),
  hurt(72, Category.mad, tier: 2),
  skeptical(73, Category.mad, tier: 3),
  irritated(74, Category.mad, tier: 3),
  jealous(75, Category.mad, tier: 3),
  frustrated(76, Category.mad, tier: 3),
  sarcastic(77, Category.mad, tier: 3),
  distant(78, Category.mad, tier: 3),
  ;

  const Emotion(
    this.id,
    this.category, {
    this.tier = 1,
  });

  final int id;
  final Category category;
  final int tier;

  Color get color => category.getColor(tier);

  static final Map<int, Emotion> _emotionById = {
    for (var emotion in Emotion.values) emotion.id: emotion
  };

  static Emotion get(int id) {
    return _emotionById[id] ?? (throw ArgumentError('Emotion with id $id not found'));
  }

  @override
  String toString() {
    return name.capitalize();
  }
}
