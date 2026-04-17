pragma Singleton

import QtQuick
import Quickshell
import qs.Commons
import qs.Services

Singleton {
  id: root

  property bool isTransitioning: false
  property color mBackground: "#141318"
  property color mError: "#FFB4AB"
  property color mErrorContainer: "#93000A"
  property color mInverseOnSurface: "#322F35"
  property color mInversePrimary: "#63568F"
  property color mInverseSurface: "#E6E1E9"
  property color mOnBackground: "#E6E1E9"
  property color mOnError: "#690005"
  property color mOnErrorContainer: "#FFDAD6"
  property color mOnPrimary: "#34275E"
  property color mOnPrimaryContainer: "#E8DEFF"
  property color mOnPrimaryFixed: "#1F1048"
  property color mOnPrimaryFixedVariant: "#4B3E76"
  property color mOnSecondary: "#322E41"
  property color mOnSecondaryContainer: "#E7DEF8"
  property color mOnSecondaryFixed: "#1D192B"
  property color mOnSecondaryFixedVariant: "#494458"
  property color mOnSurface: "#E6E1E9"
  property color mOnSurfaceVariant: "#CAC4CF"
  property color mOnTertiary: "#492533"
  property color mOnTertiaryContainer: "#FFD9E4"
  property color mOnTertiaryFixed: "#31111E"
  property color mOnTertiaryFixedVariant: "#633B4A"
  property color mOutline: "#938F99"
  property color mOutlineVariant: "#48454E"
  property color mPrimary: "#CDBDFF"
  property color mPrimaryContainer: "#4B3E76"
  property color mPrimaryFixed: "#E8DEFF"
  property color mPrimaryFixedDim: "#CDBDFF"
  property color mScrim: "#000000"
  property color mSecondary: "#CBC3DC"
  property color mSecondaryContainer: "#494458"
  property color mSecondaryFixed: "#E7DEF8"
  property color mSecondaryFixedDim: "#CBC3DC"
  property color mShadow: "#000000"
  property color mSurface: "#141318"
  property color mSurfaceBright: "#3A383E"
  property color mSurfaceContainer: "#201F24"
  property color mSurfaceContainerHigh: "#2B292F"
  property color mSurfaceContainerHighest: "#36343A"
  property color mSurfaceContainerLow: "#1C1B20"
  property color mSurfaceContainerLowest: "#0F0D13"
  property color mSurfaceDim: "#141318"
  property color mSurfaceTint: "#CDBDFF"
  property color mSurfaceVariant: "#48454E"
  property color mTertiary: "#EEB8C9"
  property color mTertiaryContainer: "#633B4A"
  property color mTertiaryFixed: "#FFD9E4"
  property color mTertiaryFixedDim: "#EEB8C9"

  function startTransition() {
    root.isTransitioning = true;
    transactionTimer.restart();
  }

  Timer {
    id: transactionTimer

    interval: Theme.animationSlowest + Theme.animationBuffer
    onTriggered: root.isTransitioning = false
  }

  Connections {
    function onMBackgroundChanged() {
      root.startTransition();
      root.mBackground = ColorService.data.mBackground;
    }

    function onMErrorChanged() {
      root.startTransition();
      root.mError = ColorService.data.mError;
    }

    function onMErrorContainerChanged() {
      root.startTransition();
      root.mErrorContainer = ColorService.data.mErrorContainer;
    }

    function onMInverseOnSurfaceChanged() {
      root.startTransition();
      root.mInverseOnSurface = ColorService.data.mInverseOnSurface;
    }

    function onMInversePrimaryChanged() {
      root.startTransition();
      root.mInversePrimary = ColorService.data.mInversePrimary;
    }

    function onMInverseSurfaceChanged() {
      root.startTransition();
      root.mInverseSurface = ColorService.data.mInverseSurface;
    }

    function onMOnBackgroundChanged() {
      root.startTransition();
      root.mOnBackground = ColorService.data.mOnBackground;
    }

    function onMOnErrorChanged() {
      root.startTransition();
      root.mOnError = ColorService.data.mOnError;
    }

    function onMOnErrorContainerChanged() {
      root.startTransition();
      root.mOnErrorContainer = ColorService.data.mOnErrorContainer;
    }

    function onMOnPrimaryChanged() {
      root.startTransition();
      root.mOnPrimary = ColorService.data.mOnPrimary;
    }

    function onMOnPrimaryContainerChanged() {
      root.startTransition();
      root.mOnPrimaryContainer = ColorService.data.mOnPrimaryContainer;
    }

    function onMOnPrimaryFixedChanged() {
      root.startTransition();
      root.mOnPrimaryFixed = ColorService.data.mOnPrimaryFixed;
    }

    function onMOnPrimaryFixedVariantChanged() {
      root.startTransition();
      root.mOnPrimaryFixedVariant = ColorService.data.mOnPrimaryFixedVariant;
    }

    function onMOnSecondaryChanged() {
      root.startTransition();
      root.mOnSecondary = ColorService.data.mOnSecondary;
    }

    function onMOnSecondaryContainerChanged() {
      root.startTransition();
      root.mOnSecondaryContainer = ColorService.data.mOnSecondaryContainer;
    }

    function onMOnSecondaryFixedChanged() {
      root.startTransition();
      root.mOnSecondaryFixed = ColorService.data.mOnSecondaryFixed;
    }

    function onMOnSecondaryFixedVariantChanged() {
      root.startTransition();
      root.mOnSecondaryFixedVariant = ColorService.data.mOnSecondaryFixedVariant;
    }

    function onMOnSurfaceChanged() {
      root.startTransition();
      root.mOnSurface = ColorService.data.mOnSurface;
    }

    function onMOnSurfaceVariantChanged() {
      root.startTransition();
      root.mOnSurfaceVariant = ColorService.data.mOnSurfaceVariant;
    }

    function onMOnTertiaryChanged() {
      root.startTransition();
      root.mOnTertiary = ColorService.data.mOnTertiary;
    }

    function onMOnTertiaryContainerChanged() {
      root.startTransition();
      root.mOnTertiaryContainer = ColorService.data.mOnTertiaryContainer;
    }

    function onMOnTertiaryFixedChanged() {
      root.startTransition();
      root.mOnTertiaryFixed = ColorService.data.mOnTertiaryFixed;
    }

    function onMOnTertiaryFixedVariantChanged() {
      root.startTransition();
      root.mOnTertiaryFixedVariant = ColorService.data.mOnTertiaryFixedVariant;
    }

    function onMOutlineChanged() {
      root.startTransition();
      root.mOutline = ColorService.data.mOutline;
    }

    function onMOutlineVariantChanged() {
      root.startTransition();
      root.mOutlineVariant = ColorService.data.mOutlineVariant;
    }

    function onMPrimaryChanged() {
      root.startTransition();
      root.mPrimary = ColorService.data.mPrimary;
    }

    function onMPrimaryContainerChanged() {
      root.startTransition();
      root.mPrimaryContainer = ColorService.data.mPrimaryContainer;
    }

    function onMPrimaryFixedChanged() {
      root.startTransition();
      root.mPrimaryFixed = ColorService.data.mPrimaryFixed;
    }

    function onMPrimaryFixedDimChanged() {
      root.startTransition();
      root.mPrimaryFixedDim = ColorService.data.mPrimaryFixedDim;
    }

    function onMScrimChanged() {
      root.startTransition();
      root.mScrim = ColorService.data.mScrim;
    }

    function onMSecondaryChanged() {
      root.startTransition();
      root.mSecondary = ColorService.data.mSecondary;
    }

    function onMSecondaryContainerChanged() {
      root.startTransition();
      root.mSecondaryContainer = ColorService.data.mSecondaryContainer;
    }

    function onMSecondaryFixedChanged() {
      root.startTransition();
      root.mSecondaryFixed = ColorService.data.mSecondaryFixed;
    }

    function onMSecondaryFixedDimChanged() {
      root.startTransition();
      root.mSecondaryFixedDim = ColorService.data.mSecondaryFixedDim;
    }

    function onMShadowChanged() {
      root.startTransition();
      root.mShadow = ColorService.data.mShadow;
    }

    function onMSurfaceChanged() {
      root.startTransition();
      root.mSurface = ColorService.data.mSurface;
    }

    function onMSurfaceBrightChanged() {
      root.startTransition();
      root.mSurfaceBright = ColorService.data.mSurfaceBright;
    }

    function onMSurfaceContainerChanged() {
      root.startTransition();
      root.mSurfaceContainer = ColorService.data.mSurfaceContainer;
    }

    function onMSurfaceContainerHighChanged() {
      root.startTransition();
      root.mSurfaceContainerHigh = ColorService.data.mSurfaceContainerHigh;
    }

    function onMSurfaceContainerHighestChanged() {
      root.startTransition();
      root.mSurfaceContainerHighest = ColorService.data.mSurfaceContainerHighest;
    }

    function onMSurfaceContainerLowChanged() {
      root.startTransition();
      root.mSurfaceContainerLow = ColorService.data.mSurfaceContainerLow;
    }

    function onMSurfaceContainerLowestChanged() {
      root.startTransition();
      root.mSurfaceContainerLowest = ColorService.data.mSurfaceContainerLowest;
    }

    function onMSurfaceDimChanged() {
      root.startTransition();
      root.mSurfaceDim = ColorService.data.mSurfaceDim;
    }

    function onMSurfaceTintChanged() {
      root.startTransition();
      root.mSurfaceTint = ColorService.data.mSurfaceTint;
    }

    function onMSurfaceVariantChanged() {
      root.startTransition();
      root.mSurfaceVariant = ColorService.data.mSurfaceVariant;
    }

    function onMTertiaryChanged() {
      root.startTransition();
      root.mTertiary = ColorService.data.mTertiary;
    }

    function onMTertiaryContainerChanged() {
      root.startTransition();
      root.mTertiaryContainer = ColorService.data.mTertiaryContainer;
    }

    function onMTertiaryFixedChanged() {
      root.startTransition();
      root.mTertiaryFixed = ColorService.data.mTertiaryFixed;
    }

    function onMTertiaryFixedDimChanged() {
      root.startTransition();
      root.mTertiaryFixedDim = ColorService.data.mTertiaryFixedDim;
    }

    target: ColorService ? ColorService.data : null
  }

  Behavior on mBackground {
    ColorAnimation {
      duration: Theme.animationSlowest
      easing.type: Easing.OutCubic
    }
  }

  Behavior on mError {
    ColorAnimation {
      duration: Theme.animationSlowest
      easing.type: Easing.OutCubic
    }
  }

  Behavior on mErrorContainer {
    ColorAnimation {
      duration: Theme.animationSlowest
      easing.type: Easing.OutCubic
    }
  }

  Behavior on mInverseOnSurface {
    ColorAnimation {
      duration: Theme.animationSlowest
      easing.type: Easing.OutCubic
    }
  }

  Behavior on mInversePrimary {
    ColorAnimation {
      duration: Theme.animationSlowest
      easing.type: Easing.OutCubic
    }
  }

  Behavior on mInverseSurface {
    ColorAnimation {
      duration: Theme.animationSlowest
      easing.type: Easing.OutCubic
    }
  }

  Behavior on mOnBackground {
    ColorAnimation {
      duration: Theme.animationSlowest
      easing.type: Easing.OutCubic
    }
  }

  Behavior on mOnError {
    ColorAnimation {
      duration: Theme.animationSlowest
      easing.type: Easing.OutCubic
    }
  }

  Behavior on mOnErrorContainer {
    ColorAnimation {
      duration: Theme.animationSlowest
      easing.type: Easing.OutCubic
    }
  }

  Behavior on mOnPrimary {
    ColorAnimation {
      duration: Theme.animationSlowest
      easing.type: Easing.OutCubic
    }
  }

  Behavior on mOnPrimaryContainer {
    ColorAnimation {
      duration: Theme.animationSlowest
      easing.type: Easing.OutCubic
    }
  }

  Behavior on mOnPrimaryFixed {
    ColorAnimation {
      duration: Theme.animationSlowest
      easing.type: Easing.OutCubic
    }
  }

  Behavior on mOnPrimaryFixedVariant {
    ColorAnimation {
      duration: Theme.animationSlowest
      easing.type: Easing.OutCubic
    }
  }

  Behavior on mOnSecondary {
    ColorAnimation {
      duration: Theme.animationSlowest
      easing.type: Easing.OutCubic
    }
  }

  Behavior on mOnSecondaryContainer {
    ColorAnimation {
      duration: Theme.animationSlowest
      easing.type: Easing.OutCubic
    }
  }

  Behavior on mOnSecondaryFixed {
    ColorAnimation {
      duration: Theme.animationSlowest
      easing.type: Easing.OutCubic
    }
  }

  Behavior on mOnSecondaryFixedVariant {
    ColorAnimation {
      duration: Theme.animationSlowest
      easing.type: Easing.OutCubic
    }
  }

  Behavior on mOnSurface {
    ColorAnimation {
      duration: Theme.animationSlowest
      easing.type: Easing.OutCubic
    }
  }

  Behavior on mOnSurfaceVariant {
    ColorAnimation {
      duration: Theme.animationSlowest
      easing.type: Easing.OutCubic
    }
  }

  Behavior on mOnTertiary {
    ColorAnimation {
      duration: Theme.animationSlowest
      easing.type: Easing.OutCubic
    }
  }

  Behavior on mOnTertiaryContainer {
    ColorAnimation {
      duration: Theme.animationSlowest
      easing.type: Easing.OutCubic
    }
  }

  Behavior on mOnTertiaryFixed {
    ColorAnimation {
      duration: Theme.animationSlowest
      easing.type: Easing.OutCubic
    }
  }

  Behavior on mOnTertiaryFixedVariant {
    ColorAnimation {
      duration: Theme.animationSlowest
      easing.type: Easing.OutCubic
    }
  }

  Behavior on mOutline {
    ColorAnimation {
      duration: Theme.animationSlowest
      easing.type: Easing.OutCubic
    }
  }

  Behavior on mOutlineVariant {
    ColorAnimation {
      duration: Theme.animationSlowest
      easing.type: Easing.OutCubic
    }
  }

  Behavior on mPrimary {
    ColorAnimation {
      duration: Theme.animationSlowest
      easing.type: Easing.OutCubic
    }
  }

  Behavior on mPrimaryContainer {
    ColorAnimation {
      duration: Theme.animationSlowest
      easing.type: Easing.OutCubic
    }
  }

  Behavior on mPrimaryFixed {
    ColorAnimation {
      duration: Theme.animationSlowest
      easing.type: Easing.OutCubic
    }
  }

  Behavior on mPrimaryFixedDim {
    ColorAnimation {
      duration: Theme.animationSlowest
      easing.type: Easing.OutCubic
    }
  }

  Behavior on mScrim {
    ColorAnimation {
      duration: Theme.animationSlowest
      easing.type: Easing.OutCubic
    }
  }

  Behavior on mSecondary {
    ColorAnimation {
      duration: Theme.animationSlowest
      easing.type: Easing.OutCubic
    }
  }

  Behavior on mSecondaryContainer {
    ColorAnimation {
      duration: Theme.animationSlowest
      easing.type: Easing.OutCubic
    }
  }

  Behavior on mSecondaryFixed {
    ColorAnimation {
      duration: Theme.animationSlowest
      easing.type: Easing.OutCubic
    }
  }

  Behavior on mSecondaryFixedDim {
    ColorAnimation {
      duration: Theme.animationSlowest
      easing.type: Easing.OutCubic
    }
  }

  Behavior on mShadow {
    ColorAnimation {
      duration: Theme.animationSlowest
      easing.type: Easing.OutCubic
    }
  }

  Behavior on mSurface {
    ColorAnimation {
      duration: Theme.animationSlowest
      easing.type: Easing.OutCubic
    }
  }

  Behavior on mSurfaceBright {
    ColorAnimation {
      duration: Theme.animationSlowest
      easing.type: Easing.OutCubic
    }
  }

  Behavior on mSurfaceContainer {
    ColorAnimation {
      duration: Theme.animationSlowest
      easing.type: Easing.OutCubic
    }
  }

  Behavior on mSurfaceContainerHigh {
    ColorAnimation {
      duration: Theme.animationSlowest
      easing.type: Easing.OutCubic
    }
  }

  Behavior on mSurfaceContainerHighest {
    ColorAnimation {
      duration: Theme.animationSlowest
      easing.type: Easing.OutCubic
    }
  }

  Behavior on mSurfaceContainerLow {
    ColorAnimation {
      duration: Theme.animationSlowest
      easing.type: Easing.OutCubic
    }
  }

  Behavior on mSurfaceContainerLowest {
    ColorAnimation {
      duration: Theme.animationSlowest
      easing.type: Easing.OutCubic
    }
  }

  Behavior on mSurfaceDim {
    ColorAnimation {
      duration: Theme.animationSlowest
      easing.type: Easing.OutCubic
    }
  }

  Behavior on mSurfaceTint {
    ColorAnimation {
      duration: Theme.animationSlowest
      easing.type: Easing.OutCubic
    }
  }

  Behavior on mSurfaceVariant {
    ColorAnimation {
      duration: Theme.animationSlowest
      easing.type: Easing.OutCubic
    }
  }

  Behavior on mTertiary {
    ColorAnimation {
      duration: Theme.animationSlowest
      easing.type: Easing.OutCubic
    }
  }

  Behavior on mTertiaryContainer {
    ColorAnimation {
      duration: Theme.animationSlowest
      easing.type: Easing.OutCubic
    }
  }

  Behavior on mTertiaryFixed {
    ColorAnimation {
      duration: Theme.animationSlowest
      easing.type: Easing.OutCubic
    }
  }

  Behavior on mTertiaryFixedDim {
    ColorAnimation {
      duration: Theme.animationSlowest
      easing.type: Easing.OutCubic
    }
  }
}
