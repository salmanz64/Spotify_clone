import 'package:client/core/providers/current_user_notifier.dart';
import 'package:client/core/theme/theme.dart';

import 'package:client/features/auth/viewmodels/auth_viewmodel.dart';

import 'package:client/features/auth/views/pages/signup_page.dart';
import 'package:client/features/home/view/pages/home_page.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:just_audio_background/just_audio_background.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final container = ProviderContainer();
  await container.read(authViewModelProvider.notifier).iniSharedPreference();
  await container.read(authViewModelProvider.notifier).getData();
  await Hive.initFlutter();
  await Hive.openBox('recentSongs');
  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
  );
  runApp(UncontrolledProviderScope(container: container, child: const MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserNotifierProvider);

    return MaterialApp(
      title: 'Music App',
      theme: AppTheme.darkThemeMode,
      debugShowCheckedModeBanner: false,
      home: currentUser == null ? const SignupPage() : HomePage(),
    );
  }
}
