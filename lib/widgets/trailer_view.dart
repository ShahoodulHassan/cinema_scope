import 'dart:math';

import 'package:cinema_scope/architecture/movie_view_model.dart';
import 'package:cinema_scope/architecture/youtube_view_model.dart';
import 'package:cinema_scope/utilities/generic_functions.dart';
import 'package:cinema_scope/widgets/route_aware_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../architecture/config_view_model.dart';


class TrailerView extends MultiProvider {
  /// It should always be non-empty
  final List<String> youtubeKeys;

  final String initialVideoId;

  TrailerView({
    required this.youtubeKeys,
    required this.initialVideoId,
    super.key,
  }) : super(
          providers: [
            ChangeNotifierProvider(
              create: (_) => YoutubeViewModel()
                ..currentKey = initialVideoId
                ..initialize(youtubeKeys),
            ),
          ],
          child: const _TrailerViewChild(),
        );
}

class _TrailerViewChild extends StatefulWidget {
  const _TrailerViewChild({Key? key}) : super(key: key);

  @override
  State<_TrailerViewChild> createState() => _TrailerViewChildState();
}

class _TrailerViewChildState extends RouteAwareState<_TrailerViewChild>
    with GenericFunctions {
  late final ConfigViewModel cvm;
  late final YoutubeViewModel yvm;
  late final MovieViewModel mvm;

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
      bottomActions: [],
    ),
    builder: (_, player) => player,
  );

  @override
  void initState() {
    super.initState();
    cvm = context.read<ConfigViewModel>()..addListener(_stateListener);
    yvm = context.read<YoutubeViewModel>();
    mvm = context.read<MovieViewModel>();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      builder,
      PlayerOverlay(
        controller: yvm.controller!,
        aspectRatio: builder.player.aspectRatio,
        timeOut: builder.player.controlsTimeOut,
      ),
    ]);
  }

  void _stateListener() {
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
    cvm.removeListener(_stateListener);
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

  const PlayerOverlay({
    Key? key,
    required this.controller,
    required this.aspectRatio,
    required this.timeOut,
  }) : super(key: key);

  @override
  State<PlayerOverlay> createState() => _PlayerOverlayState();
}

class _PlayerOverlayState extends State<PlayerOverlay> with GenericFunctions {
  late final YoutubeViewModel yvm;

  YoutubePlayerController get controller => widget.controller;

  /// Small icon size
  final double smallIconSize = 18.0;

  /// Small icon background size (the factor of 16 / 9 can be anything)
  late final double smallIconBgSize = smallIconSize * (16 / 9);

  @override
  void initState() {
    super.initState();
    yvm = context.read<YoutubeViewModel>();
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
                child: Selector<YoutubeViewModel, bool>(
                  selector: (_, yvm) => yvm.muted,
                  builder: (_, muted, __) {
                    return getIconButton(
                        muted
                            ? Icons.volume_off_rounded
                            : Icons.volume_up_rounded,
                        () => context.read<YoutubeViewModel>().toggleMute());
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
                getIconButton(Icons.close_rounded,
                    () => context.read<MovieViewModel>().initialVideoId = null),
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
    /// Size of PlayPauseButton
    const double playButtonSize = 60.0;

    /// Max one side padding allowed for the icons
    const double maxPadding = playButtonSize / 2;

    /// Allowed icon size
    const double iconSize = playButtonSize * 2 / 3;

    /// Number of icons required on each side of the play icon
    const double iconCount = 1;

    /// Total width available for icons and padding
    final availableWidth = (MediaQuery.of(context).size.width - playButtonSize);

    /// Available one side padding for the icons
    final double availablePadding =
        (availableWidth / 2 - (iconSize * iconCount)) / (iconCount + 1);

    /// Padding should be the lower of available and max padding
    final double padding = min(availablePadding, maxPadding);

    return Align(
      alignment: AlignmentDirectional.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Visibility(
            visible: controller.value.isControlsVisible &&
                yvm.youtubeKeys.length > 1,
            child: Padding(
              padding: EdgeInsets.only(right: padding),
              child: getIconButton(
                Icons.skip_previous_rounded,
                () => yvm.loadPrevious(),
                iconSize: iconSize,
                isBgRequired: false,
              ),
            ),
          ),
          PlayPauseButton(controller: controller),
          Visibility(
            visible: controller.value.isControlsVisible &&
                yvm.youtubeKeys.length > 1,
            child: Padding(
              padding: EdgeInsets.only(left: padding),
              child: getIconButton(
                Icons.skip_next_rounded,
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

//-------------------DISCARDED CLASSES-------------------//

abstract class PlayerOverlayState<T extends StatefulWidget> extends State<T> {
  late final YoutubePlayerController controller;

  void listener() {
    if (mounted) setState(() {});
  }

  Widget getIconButton(
    IconData icon,
    Function()? onPressed, {
    double iconSize = 18,
    bool isBgRequired = true,
  }) {
    var background = isBgRequired
        ? const ShapeDecoration(
            shape: CircleBorder(),
            color: Colors.black54,
          )
        : null;
    return Container(
      width: iconSize * 1.77778,
      height: iconSize * 1.77778,
      decoration: background,
      child: IconButton(
        padding: const EdgeInsets.all(0.0),
        onPressed: onPressed,
        iconSize: iconSize,
        icon: Icon(icon, color: Colors.white),
      ),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    controller = context.read<YoutubeViewModel>().controller!
      ..removeListener(listener)
      ..addListener(listener);
  }

  @override
  void dispose() {
    controller.removeListener(listener);
    super.dispose();
  }
}

class TopOverlay extends StatefulWidget {
  const TopOverlay({Key? key}) : super(key: key);

  @override
  State<TopOverlay> createState() => _TopOverlayState();
}

class _TopOverlayState extends PlayerOverlayState<TopOverlay> {
  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: controller.value.isControlsVisible,
      child: Positioned(
        top: 0,
        left: 0,
        right: 0,
        child: AnimatedOpacity(
          opacity: !controller.flags.hideControls &&
                  controller.value.isControlsVisible
              ? 1
              : 0,
          duration: const Duration(milliseconds: 300),
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: [
                getIconButton(Icons.close_rounded,
                    () => context.read<MovieViewModel>().initialVideoId = null),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CenterLeftOverlay extends StatefulWidget {
  const CenterLeftOverlay({Key? key}) : super(key: key);

  @override
  State<CenterLeftOverlay> createState() => _CenterLeftOverlayState();
}

class _CenterLeftOverlayState extends CenterOverlayState<CenterLeftOverlay> {
  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: controller.value.isControlsVisible,
      child: Align(
        alignment: AlignmentDirectional.centerStart,
        child: SizedBox(
          width: maxWidth,
          child: Row(
            children: [
              Expanded(child: Container()),
              getIconButton(
                Icons.skip_previous_rounded,
                () => context.read<MovieViewModel>().initialVideoId = null,
                iconSize: iconSize,
                isBgRequired: false,
              ),
              SizedBox(width: min(margin, maxMargin)),
              // getIconButton(
              //   Icons.close_rounded,
              //   () => context.read<MovieViewModel>().initialVideoId = null,
              //   iconSize: iconSize,
              // ),
              // SizedBox(width: min(margin, maxMargin)),
            ],
          ),
        ),
      ),
    );
  }
}

class CenterRightOverlay extends StatefulWidget {
  const CenterRightOverlay({Key? key}) : super(key: key);

  @override
  State<CenterRightOverlay> createState() => _CenterRightOverlayState();
}

class _CenterRightOverlayState extends CenterOverlayState<CenterRightOverlay> {
  @override
  Widget build(BuildContext context) {
    print('margin:$margin, maxMargin:$maxMargin');
    return Visibility(
      visible: controller.value.isControlsVisible,
      child: Align(
        alignment: AlignmentDirectional.centerEnd,
        child: SizedBox(
          width: maxWidth,
          child: Row(
            children: [
              SizedBox(width: min(margin, maxMargin)),
              getIconButton(
                Icons.skip_next_rounded,
                () => context.read<MovieViewModel>().initialVideoId = null,
                iconSize: iconSize,
                isBgRequired: false,
              ),
              // SizedBox(width: min(margin, maxMargin)),
              // getIconButton(
              //   Icons.close_rounded,
              //   () => context.read<MovieViewModel>().initialVideoId = null,
              //   iconSize: iconSize,
              // ),
              Expanded(child: Container()),
            ],
          ),
        ),
      ),
    );
  }
}

abstract class CenterOverlayState<T extends StatefulWidget>
    extends PlayerOverlayState<T> {
  final double playIconSize = 60.0;
  final double maxMargin = 30.0;
  final double iconSize = 40.0;
  final double iconCount = 1;
  late final width = MediaQuery.of(context).size.width;
  late final maxWidth = (width - playIconSize) / 2;
  late final double margin =
      (maxWidth - (iconSize * iconCount)) / (iconCount + 1);
}

class BottomOverlay extends StatefulWidget {
  const BottomOverlay({Key? key}) : super(key: key);

  @override
  State<BottomOverlay> createState() => _BottomOverlayState();
}

class _BottomOverlayState extends PlayerOverlayState<BottomOverlay> {
  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: controller.value.isControlsVisible,
      child: Positioned(
        bottom: 0,
        left: 0,
        right: 0,
        child: AnimatedOpacity(
          opacity: !controller.flags.hideControls &&
                  controller.value.isControlsVisible
              ? 1
              : 0,
          duration: const Duration(milliseconds: 300),
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Selector<YoutubeViewModel, bool>(
                  selector: (_, yvm) => yvm.muted,
                  builder: (_, muted, __) {
                    return getIconButton(
                        muted ? Icons.volume_off_sharp : Icons.volume_up_sharp,
                        () => context.read<YoutubeViewModel>().toggleMute());
                  },
                ),
                const SizedBox(width: 8.0),
                getIconButton(Icons.fullscreen_sharp,
                    () => controller.toggleFullScreenMode()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// class TrailerViewChild extends StatefulWidget {
//   const TrailerViewChild({Key? key}) : super(key: key);
//
//   @override
//   State<TrailerViewChild> createState() => _TrailerViewChildState();
// }
//
// class _TrailerViewChildState extends State<TrailerViewChild>
//     with GenericFunctions {
//   late final YoutubeViewModel yvm;
//
//   late final builder = YoutubePlayerBuilder(
//     player: YoutubePlayer(
//       // showVideoProgressIndicator: true,
//       controller: yvm.controller!,
//       onReady: () {
//         logIfDebug(
//             'isPinned-onReady called, isPlayerReady:${yvm.isPlayerReady}');
//         if (yvm.isPlayerReady) {
//           // yvm.resume();
//           // yvm.controller.play();
//         } else {
//           yvm.isPlayerReady = true;
//         }
//       },
//       onEnded: (data) => yvm.loadNext(),
//       topActions: <Widget>[
//         const SizedBox(width: 8.0),
//         Expanded(
//           child: Selector<YoutubeViewModel, String>(
//             builder: (_, title, __) {
//               logIfDebug('builder: ${yvm.videoTitle}');
//               return Text(
//                 yvm.videoTitle,
//                 style: const TextStyle(
//                   color: Colors.white,
//                   fontSize: 18.0,
//                 ),
//                 overflow: TextOverflow.ellipsis,
//                 maxLines: 1,
//               );
//             },
//             selector: (_, yvm) {
//               logIfDebug('selector: ${yvm.videoTitle}');
//               return yvm.videoTitle;
//             },
//           ),
//         ),
//         IconButton(
//           icon: const Icon(
//             Icons.cancel_outlined,
//             color: Colors.white,
//             // size: 25.0,
//           ),
//           onPressed: () {
//             context.read<MovieViewModel>().isTrailerPinned = false;
//           },
//         )
//       ],
//       bottomActions: [
//         CurrentPosition(),
//         ProgressBar(isExpanded: true),
//         Selector<YoutubeViewModel, bool>(
//           selector: (_, yvm) => yvm.muted,
//           builder: (_, isMuted, __) {
//             return IconButton(
//               icon: Icon(
//                 isMuted ? Icons.volume_off_sharp : Icons.volume_up_sharp,
//                 color: Colors.white,
//                 // size: 25.0,
//               ),
//               onPressed: () {
//                 yvm.toggleMute();
//                 // yvm.pause();
//                 // yvm.isReused = true;
//                 // context.read<MovieViewModel>().isTrailerPinned = !yvm.muted;
//               },
//             );
//           },
//         ),
//         IconButton(
//           icon: const Icon(
//             Icons.fullscreen_sharp,
//             color: Colors.white,
//             // size: 25.0,
//           ),
//           onPressed: () {
//             yvm.toggleFullScreenMode();
//           },
//         ),
//       ],
//     ),
//     builder: (_, player) => player,
//   );
//
//   @override
//   void initState() {
//     yvm = context.read<YoutubeViewModel>() /*..initialize()*/;
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     logIfDebug('isPinned, build called');
//     return builder;
//   }
//
//   @override
//   void deactivate() {
//     logIfDebug('deactivate called');
//     // // Pauses video while navigating to next page.
//     // yvm.pause();
//     super.deactivate();
//   }
//
//   @override
//   void dispose() {
//     logIfDebug('dispose called');
//     super.dispose();
//   }
//
//   @override
//   void activate() {
//     // if (yvm.controller.value.playerState == PlayerState.paused) yvm.controller.play();
//     super.activate();
//   }
// }
