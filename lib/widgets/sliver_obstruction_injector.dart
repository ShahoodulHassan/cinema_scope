import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

/// Helps make pinned / sticky headers inside a TabBarView
/// Followed the pattern mentioned in
/// https://gist.github.com/letsar/2e3cc98d328b3e84170abacf154e545f
///
/// The code snippets of these classes have been copied from
/// https://github.com/letsar/flutter_sticky_header/issues/5#issuecomment-1539512346

class SliverObstructionInjector extends SliverOverlapInjector {
  /// Creates a sliver that is as tall as the value of the given [handle]'s
  /// layout extent.
  ///
  /// The [handle] must not be null.
  ///
  const SliverObstructionInjector(
      {super.key, required SliverOverlapAbsorberHandle handle, super.sliver})
      : super(handle: handle);

  @override
  RenderSliverObstructionInjector createRenderObject(BuildContext context) {
    return RenderSliverObstructionInjector(
      handle: handle,
    );
  }
}

/// A sliver that has a sliver geometry based on the values stored in a
/// [SliverOverlapAbsorberHandle].
///
/// The [RenderSliverOverlapAbsorber] must be an earlier descendant of a common
/// ancestor [RenderViewport] (probably a [RenderNestedScrollViewViewport]), so
/// that it will always be laid out before the [RenderSliverObstructionInjector]
/// during a particular frame.
class RenderSliverObstructionInjector extends RenderSliverOverlapInjector {
  /// Creates a sliver that is as tall as the value of the given [handle]'s extent.
  ///
  /// The [handle] must not be null.
  RenderSliverObstructionInjector({
    required SliverOverlapAbsorberHandle handle,
    RenderSliver? child,
  })  : _handle = handle,
        super(handle: handle);

  double _currentLayoutExtent = 0;
  double _currentMaxExtent = 0;

  /// The object that specifies how wide to make the gap injected by this render
  /// object.
  ///
  /// This should be a handle owned by a [RenderSliverOverlapAbsorber] and a
  /// [RenderNestedScrollViewViewport].
  @override
  SliverOverlapAbsorberHandle get handle => _handle;
  SliverOverlapAbsorberHandle _handle;

  @override
  set handle(SliverOverlapAbsorberHandle value) {
    if (handle == value) return;
    if (attached) {
      handle.removeListener(markNeedsLayout);
    }
    _handle = value;
    if (attached) {
      handle.addListener(markNeedsLayout);
      if (handle.layoutExtent != _currentLayoutExtent ||
          handle.scrollExtent != _currentMaxExtent) markNeedsLayout();
    }
  }

  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);
    handle.addListener(markNeedsLayout);
    if (handle.layoutExtent != _currentLayoutExtent ||
        handle.scrollExtent != _currentMaxExtent) {
      markNeedsLayout();
    }
  }

  @override
  void detach() {
    handle.removeListener(markNeedsLayout);
    super.detach();
  }

  @override
  void performLayout() {
    _currentLayoutExtent = handle.layoutExtent ?? 0;
    _currentMaxExtent = handle.layoutExtent ?? 0;
    geometry = SliverGeometry(
      scrollExtent: 0.0,
      paintExtent: _currentLayoutExtent,
      maxPaintExtent: _currentMaxExtent,
    );
  }
}
