import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:illemo/src/features/emotions/domain/models/emotion_log_model.dart';
import 'package:illemo/src/features/emotions/presentation/screens/dashboard.dart';
import 'package:illemo/src/features/emotions/service/emotion_today_service.dart';

class EmotionUpload extends ConsumerWidget {
  EmotionUpload({
    super.key,
    required args,
  })  : emotionIds = args['emotionIDs'] as List<int>,
        id = args['id'] as EmotionLogID?;

  static const path = '/emotion/upload';
  final List<int> emotionIds;
  final EmotionLogID? id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(uploadEmotionLogProvider(emotionIds, id));
    return Scaffold(
      body: state.when(
        loading: _buildLoading,
        error: (e, st) => _buildError(e, st, onPressed: () => context.go(DashboardScreen.path)),
        data: (_) => _buildSuccess(onPressed: () => context.go(DashboardScreen.path)),
      ),
    );
  }

  Widget _buildLoading() {
    return const Center(
      child: CircularProgressIndicator.adaptive(),
    );
  }

  Widget _buildSuccess({required onPressed}) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.check_circle,
            color: Colors.green,
            size: 100.0,
          ),
          SizedBox(height: 20.0),
          Text(
            'Success!',
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          ElevatedButton(
            onPressed: onPressed,
            child: const Text('Go to Dashboard'),
          ),
        ],
      ),
    );
  }

  Widget _buildError(error, stackTrace, {required onPressed}) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.error,
            color: Colors.red,
            size: 100.0,
          ),
          SizedBox(height: 20.0),
          Text(
            'Error',
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            '$error',
            style: TextStyle(
              fontSize: 16.0,
            ),
          ),
          ElevatedButton(
            onPressed: onPressed,
            child: const Text('Back to Dashboard'),
          ),
        ],
      ),
    );
  }
}
