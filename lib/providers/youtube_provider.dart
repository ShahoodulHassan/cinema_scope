import 'package:cinema_scope/utilities/generic_functions.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YoutubeProvider extends ChangeNotifier with GenericFunctions {
  YoutubePlayerController? controller;

  PlayerState playerState = PlayerState.unknown;
  YoutubeMetaData _videoMetaData = const YoutubeMetaData();
  bool muted = false;
  bool isPlayerReady = false;

  String? youtubeKey;

  late List<String> youtubeKeys;

  String oldLog = '';

  String get videoTitle => _videoMetaData.title;

  Duration get duration => _videoMetaData.duration;

  String? currentKey;

  PlayerState get controllerPlayerState =>
      controller?.value.playerState ?? PlayerState.unknown;



  YoutubeProvider();

  initialize(List<String> youtubeKeys) {
    if (controller == null) {
      this.youtubeKeys = youtubeKeys;
      if (youtubeKeys.isNotEmpty) {
        controller = YoutubePlayerController(
          initialVideoId: currentKey ??= this.youtubeKeys[0],
          flags: YoutubePlayerFlags(
            mute: muted,
            autoPlay: true,
            disableDragSeek: true,
            loop: youtubeKeys.length == 1,
            forceHD: false,
            enableCaption: false,
            useHybridComposition: false,
            hideControls: true,
          ),
        )..addListener(_listener);
      }
    }
  }

  void _listener() {
    String newLog =
        'isPinned, isReady:$isPlayerReady, '
        'state:${controller!.value.playerState}, '
        'currentKey:$currentKey';
    if (oldLog != newLog) {
      oldLog = newLog;
      logIfDebug(oldLog);
    }

    if (isPlayerReady) {
      playerState = controller!.value.playerState;
      if (playerState == PlayerState.playing) {
        if (controller!.metadata.videoId != _videoMetaData.videoId) {
          _videoMetaData = controller!.metadata;
          logIfDebug('title:${_videoMetaData.title}');
          notifyListeners();
        }
      }
    }
  }

  toggleMute() {
    muted = !muted;
    if (muted) {
      controller?.mute();
    } else {
      controller?.unMute();
    }
    notifyListeners();
  }

  loadNext() {
    if (!controller!.flags.loop) load(getNextKey());
  }

  loadPrevious() {
    if (!controller!.flags.loop) load(getPreviousKey());
  }

  load(String key) {
    if (isPlayerReady) {
      if (currentKey != key) currentKey = key;
      controller?.load(currentKey!);
    }
  }

  String getPreviousKey() =>
      youtubeKeys[(youtubeKeys.indexOf(currentKey!) - 1) % youtubeKeys.length];

  String getNextKey() =>
      youtubeKeys[(youtubeKeys.indexOf(currentKey!) + 1) % youtubeKeys.length];

  pause() {
    if (controllerPlayerState == PlayerState.playing ||
        controllerPlayerState == PlayerState.buffering) {
      controller?.pause();
    }
  }

  play() {
    if (controllerPlayerState == PlayerState.paused) {
      controller?.play();
    }
  }

  reset() => controller?.reset();

  toggleFullScreenMode() => controller?.toggleFullScreenMode();

  disposeController() => controller?.dispose();

  @override
  void dispose() {
    logIfDebug('isPinned, dispose called');
    // controller?.removeListener(_listener);
    // controller?.dispose();
    // controller = null;
    super.dispose();
  }
}
