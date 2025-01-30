import 'dart:math';

import 'package:cinema_scope/providers/movie_provider.dart';
import 'package:cinema_scope/providers/youtube_provider.dart';
import 'package:cinema_scope/utilities/generic_functions.dart';
import 'package:cinema_scope/widgets/route_aware_state.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../providers/configuration_provider.dart';
import '../providers/tv_provider.dart';
import '../constants.dart';

class TrailerView extends MultiProvider {
  /// It should always be non-empty
  final List<String> youtubeKeys;
  final MediaType mediaType;
  final String initialVideoId;

  TrailerView({
    required this.mediaType,
    required this.youtubeKeys,
    required this.initialVideoId,
    super.key,
  }) : super(
          providers: [
            ChangeNotifierProvider(
              create: (_) => YoutubeProvider()
                ..currentKey = initialVideoId
                ..initialize(youtubeKeys),
            ),
          ],
          child: _TrailerViewChild(mediaType: mediaType),
        );
}

class _TrailerViewChild extends StatefulWidget {
  final MediaType mediaType;

  const _TrailerViewChild({required this.mediaType, Key? key})
      : super(key: key);

  @override
  State<_TrailerViewChild> createState() => _TrailerViewChildState();
}

class _TrailerViewChildState extends RouteAwareState<_TrailerViewChild>
    with GenericFunctions {
  late final ConfigurationProvider cvm;
  late final YoutubeProvider yvm;

  // late final MovieViewModel mvm;

  late final builder = YoutubePlayerBuilder(
    player: YoutubePlayer(
      showVideoProgressIndicator: true,
      progressColors: const ProgressBarColors(
        playedColor: Colors.red,
      ),
      controller: yvm.controller!,
      onReady: () {
        logIfDebug(
            'isPinned-onReady called, isPlayerReady:${yvm.isPlayerReady}');
        if (!yvm.isPlayerReady) {
          yvm.isPlayerReady = true;
        }
      },
      onEnded: (data) => yvm.loadNext(),

      /// If we don't provide any bottom actions, the player will show the
      /// default row of action widgets. Since, we don't want that, we provided
      /// an empty list.
      bottomActions: const [],
    ),
    builder: (_, player) => player,
  );

  @override
  void initState() {
    super.initState();
    cvm = context.read<ConfigurationProvider>()..addListener(_appStateListener);
    yvm = context.read<YoutubeProvider>();
    // mvm = context.read<MovieViewModel>();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      builder,
      PlayerOverlay(
        mediaType: widget.mediaType,
        controller: yvm.controller!,
        aspectRatio: builder.player.aspectRatio,
        timeOut: builder.player.controlsTimeOut,
      ),
    ]);
  }

  void _appStateListener() {
    logIfDebug('stateListener state:${cvm.appState}');
    if (cvm.appState == AppLifecycleState.paused) {
      yvm.pause();
    } else if (cvm.appState == AppLifecycleState.resumed) {
      yvm.play;
    }
  }

  /// It means that the app is navigating to the next page
  @override
  void didPushNext() {
    // Pauses video while navigating to next page.
    yvm.pause();
    super.didPushNext();
  }

  /// It means that the app is navigating back from the next page
  @override
  void didPopNext() {
    super.didPopNext();
    // Resumes video while navigating from next page.
    yvm.play();
  }

  /// It means that the app has navigated from the previous page
  @override
  void didPush() {
    super.didPush();
  }

  /// It means that the app is navigating back to the previous page
  @override
  void didPop() {
    super.didPop();
  }

  @override
  void activate() {
    logIfDebug('activate called');
    super.activate();
  }

  @override
  void deactivate() {
    logIfDebug('deactivate called');
    super.deactivate();
  }

  @override
  void dispose() {
    logIfDebug('dispose called');
    // yvm.disposeController();
    logIfDebug('after controller dispose called');
    // mvm.removeListener(_routeListener);
    cvm.removeListener(_appStateListener);
    super.dispose();
  }
}

/// This is a replacement of the player controls and should be used by setting
/// hideControls to true in the controller flags.
///
/// Reasons for using a custom overlay instead of topActions and bottomActions
/// properties of the YoutubePlayer:
///
/// 1) I wanted to have two buttons for previous and next video in the center
/// (around the PlayPauseButton) but there was no provision for that.
///
/// 2) The player implemented top and bottom actions such that they were never
/// invisible; instead they were given an opacity of 0. So, in a scenario where
/// the user tapped the screen when the actions were invisible and the tap was
/// on the position of an action widget, although the widget was apparently
/// invisible, the tap would still be registered and the action performed.
/// It was totally unacceptable.
///
/// 3) I wanted to implement a custom current position widget (with total
/// duration and always visible) and making it a part of let's say bottomActions
/// wouldn't have helped achieve this.
///
/// 4) I wanted to experience the kind of freedom this customization provided,
/// and it provided full freedom.
///
/// NOTE: Also check out the docs of the build() method below
class PlayerOverlay extends StatefulWidget {
  final YoutubePlayerController controller;

  // The aspect ratio as set in the player
  final double aspectRatio;

  /// The timeout as set in the player.
  final Duration timeOut;

  final MediaType mediaType;

  const PlayerOverlay({
    Key? key,
    required this.mediaType,
    required this.controller,
    required this.aspectRatio,
    required this.timeOut,
  }) : super(key: key);

  @override
  State<PlayerOverlay> createState() => _PlayerOverlayState();
}

class _PlayerOverlayState extends State<PlayerOverlay> with GenericFunctions {
  late final YoutubeProvider yvm;

  YoutubePlayerController get controller => widget.controller;

  /// Small icon size
  final double smallIconSize = 18.0;

  /// Small icon background size (the factor of 16 / 9 can be anything)
  late final double smallIconBgSize = smallIconSize * (16 / 9);

  @override
  void initState() {
    super.initState();
    yvm = context.read<YoutubeProvider>();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    controller
      ..removeListener(listener)
      ..addListener(listener);
  }

  @override
  void dispose() {
    controller.removeListener(listener);
    super.dispose();
  }

  /// In case of any change in the controller, this listener get informed.
  /// Due to setState, the complete overlay is rebuilt to take effect of the
  /// change.
  void listener() {
    if (mounted) setState(() {});
  }

  /// I have followed the same hierarchy as found in the build() method of the
  /// player.
  ///
  /// Notice the use of TouchShutter widget below.
  /// This widget was used in the player to register the touch events and change
  /// the controls visibility accordingly, but it worked only if hideControls
  /// property was set to false. Since, in our case, hideControls is set to
  /// true, we had to implement it in our custom solution to get the same
  /// result.
  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: widget.aspectRatio,
      child: Stack(
        fit: StackFit.expand,
        clipBehavior: Clip.none,
        children: [
          /// This job of this widget is to reset the isControlsVisible property
          /// to false after the given timeout
          TouchShutter(
            controller: controller,
            disableDragSeek: controller.flags.disableDragSeek,
            timeOut: widget.timeOut,
          ),

          /// Top row of views
          getTopOverlay(context),

          /// Center row of views
          getCenterOverlay(),

          /// Bottom row of views
          getBottomOverlay(context),
        ],
      ),
    );
  }

  Widget getBottomOverlay(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            getPositionWidget(),
            Expanded(child: Container(height: smallIconBgSize)),
            Visibility(
              visible: controller.value.isControlsVisible,
              child: AnimatedOpacity(
                opacity: controller.value.isControlsVisible ? 1 : 0,
                duration: const Duration(milliseconds: 300),
                child: Selector<YoutubeProvider, bool>(
                  selector: (_, yvm) => yvm.muted,
                  builder: (_, muted, __) {
                    return getIconButton(
                        muted
                            ? Icons.volume_off_rounded
                            : Icons.volume_up_rounded,
                        () => context.read<YoutubeProvider>().toggleMute());
                  },
                ),
              ),
            ),
            const SizedBox(width: 8.0),
            Visibility(
              visible: controller.value.isControlsVisible,
              child: AnimatedOpacity(
                opacity: controller.value.isControlsVisible ? 1 : 0,
                duration: const Duration(milliseconds: 300),
                child: getIconButton(Icons.fullscreen_sharp,
                    () => controller.toggleFullScreenMode()),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getPositionWidget({bool showTotalDuration = true}) {
    var position = durationToMinSec(controller.value.position);
    var total = durationToMinSec(controller.metadata.duration);
    return Visibility(
      visible: controller.metadata.duration > const Duration(),
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 4.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6.0),
          color: Colors.black54,
        ),
        child: Text(
          '$position${showTotalDuration ? ' / $total' : ''}',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget getTopOverlay(BuildContext context) {
    return Visibility(
      visible: controller.value.isControlsVisible,
      child: Positioned(
        top: 0,
        left: 0,
        right: 0,
        child: AnimatedOpacity(
          opacity: controller.value.isControlsVisible ? 1 : 0,
          duration: const Duration(milliseconds: 300),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                getIconButton(Icons.close_rounded, () {
                  logIfDebug('mediaType:${widget.mediaType}');
                  if (widget.mediaType == MediaType.movie) {
                    return context.read<MovieViewModel>().initialVideoId = null;
                  } else if (widget.mediaType == MediaType.tv) {
                    return context.read<TvProvider>().initialVideoId = null;
                  }
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// PlayPauseButton has its own criteria for visibility, so other icons have
  /// been made visible independent of the PlayPauseButton.
  Widget getCenterOverlay() {
    /// Size of PlayPauseButton (including progress indicator)
    const double playButtonSize = 70.0;

    /// Max one side padding allowed for the icons
    const double maxPadding = playButtonSize / 1.5;

    /// Allowed icon size
    const double iconSize = playButtonSize * 2 / 4;

    /// Number of icons required on each side of the play icon
    const double iconCount = 1;

    /// Total width available for icons and padding
    final availableWidth = (MediaQuery.of(context).size.width - playButtonSize);

    /// Available one side padding for the icons
    final double availablePadding =
        (availableWidth / 2 - (iconSize * iconCount)) / (iconCount + 1);

    /// Padding should be the lower of available and max padding
    final double padding = min(availablePadding, maxPadding);
    logIfDebug('availablePadding:$availablePadding, maxPadding:$maxPadding');
    return Align(
      alignment: AlignmentDirectional.center,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Visibility(
            visible: controller.value.isControlsVisible &&
                yvm.youtubeKeys.length > 1,
            child: Padding(
              padding: EdgeInsets.only(right: padding),
              child: getIconButton(
                FontAwesomeIcons.backwardStep,
                () => yvm.loadPrevious(),
                iconSize: iconSize,
                isBgRequired: false,
              ),
            ),
          ),
          SizedBox(
            width: playButtonSize,
            child: Center(child: PlayPauseButton(controller: controller)),
          ),
          Visibility(
            visible: controller.value.isControlsVisible &&
                yvm.youtubeKeys.length > 1,
            child: Padding(
              padding: EdgeInsets.only(left: padding),
              child: getIconButton(
                FontAwesomeIcons.forwardStep,
                () => yvm.loadNext(),
                iconSize: iconSize,
                isBgRequired: false,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget getIconButton(
    IconData icon,
    Function()? onPressed, {
    double? iconSize,
    bool isBgRequired = true,
  }) {
    var background = isBgRequired
        ? const ShapeDecoration(
            shape: CircleBorder(),
            color: Colors.black54,
          )
        : null;
    return Container(
      width: smallIconBgSize,
      height: smallIconBgSize,
      decoration: background,
      child: IconButton(
        padding: const EdgeInsets.all(0.0),
        onPressed: onPressed,
        iconSize: iconSize ?? smallIconSize,
        icon: Icon(icon, color: Colors.white),
      ),
    );
  }
}
