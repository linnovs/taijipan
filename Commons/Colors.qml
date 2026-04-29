pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
  id: root

  property bool isTransitioning: false

  QtObject {
    id: defaultColors

    readonly property color mBackground: "#141318"
    readonly property color mError: "#FFB4AB"
    readonly property color mErrorContainer: "#93000A"
    readonly property color mInverseOnSurface: "#322F35"
    readonly property color mInversePrimary: "#63568F"
    readonly property color mInverseSurface: "#E6E1E9"
    readonly property color mOnBackground: "#E6E1E9"
    readonly property color mOnError: "#690005"
    readonly property color mOnErrorContainer: "#FFDAD6"
    readonly property color mOnPrimary: "#34275E"
    readonly property color mOnPrimaryContainer: "#E8DEFF"
    readonly property color mOnPrimaryFixed: "#1F1048"
    readonly property color mOnPrimaryFixedVariant: "#4B3E76"
    readonly property color mOnSecondary: "#322E41"
    readonly property color mOnSecondaryContainer: "#E7DEF8"
    readonly property color mOnSecondaryFixed: "#1D192B"
    readonly property color mOnSecondaryFixedVariant: "#494458"
    readonly property color mOnSurface: "#E6E1E9"
    readonly property color mOnSurfaceVariant: "#CAC4CF"
    readonly property color mOnTertiary: "#492533"
    readonly property color mOnTertiaryContainer: "#FFD9E4"
    readonly property color mOnTertiaryFixed: "#31111E"
    readonly property color mOnTertiaryFixedVariant: "#633B4A"
    readonly property color mOutline: "#938F99"
    readonly property color mOutlineVariant: "#48454E"
    readonly property color mPrimary: "#CDBDFF"
    readonly property color mPrimaryContainer: "#4B3E76"
    readonly property color mPrimaryFixed: "#E8DEFF"
    readonly property color mPrimaryFixedDim: "#CDBDFF"
    readonly property color mScrim: "#000000"
    readonly property color mSecondary: "#CBC3DC"
    readonly property color mSecondaryContainer: "#494458"
    readonly property color mSecondaryFixed: "#E7DEF8"
    readonly property color mSecondaryFixedDim: "#CBC3DC"
    readonly property color mShadow: "#000000"
    readonly property color mSurface: "#141318"
    readonly property color mSurfaceBright: "#3A383E"
    readonly property color mSurfaceContainer: "#201F24"
    readonly property color mSurfaceContainerHigh: "#2B292F"
    readonly property color mSurfaceContainerHighest: "#36343A"
    readonly property color mSurfaceContainerLow: "#1C1B20"
    readonly property color mSurfaceContainerLowest: "#0F0D13"
    readonly property color mSurfaceDim: "#141318"
    readonly property color mSurfaceTint: "#CDBDFF"
    readonly property color mSurfaceVariant: "#48454E"
    readonly property color mTertiary: "#EEB8C9"
    readonly property color mTertiaryContainer: "#633B4A"
    readonly property color mTertiaryFixed: "#FFD9E4"
    readonly property color mTertiaryFixedDim: "#EEB8C9"
  }

  property color mBackground: defaultColors.mBackground
  property color mError: defaultColors.mError
  property color mErrorContainer: defaultColors.mErrorContainer
  property color mInverseOnSurface: defaultColors.mInverseOnSurface
  property color mInversePrimary: defaultColors.mInversePrimary
  property color mInverseSurface: defaultColors.mInverseSurface
  property color mOnBackground: defaultColors.mOnBackground
  property color mOnError: defaultColors.mOnError
  property color mOnErrorContainer: defaultColors.mOnErrorContainer
  property color mOnPrimary: defaultColors.mOnPrimary
  property color mOnPrimaryContainer: defaultColors.mOnPrimaryContainer
  property color mOnPrimaryFixed: defaultColors.mOnPrimaryFixed
  property color mOnPrimaryFixedVariant: defaultColors.mOnPrimaryFixedVariant
  property color mOnSecondary: defaultColors.mOnSecondary
  property color mOnSecondaryContainer: defaultColors.mOnSecondaryContainer
  property color mOnSecondaryFixed: defaultColors.mOnSecondaryFixed
  property color mOnSecondaryFixedVariant: defaultColors.mOnSecondaryFixedVariant
  property color mOnSurface: defaultColors.mOnSurface
  property color mOnSurfaceVariant: defaultColors.mOnSurfaceVariant
  property color mOnTertiary: defaultColors.mOnTertiary
  property color mOnTertiaryContainer: defaultColors.mOnTertiaryContainer
  property color mOnTertiaryFixed: defaultColors.mOnTertiaryFixed
  property color mOnTertiaryFixedVariant: defaultColors.mOnTertiaryFixedVariant
  property color mOutline: defaultColors.mOutline
  property color mOutlineVariant: defaultColors.mOutlineVariant
  property color mPrimary: defaultColors.mPrimary
  property color mPrimaryContainer: defaultColors.mPrimaryContainer
  property color mPrimaryFixed: defaultColors.mPrimaryFixed
  property color mPrimaryFixedDim: defaultColors.mPrimaryFixedDim
  property color mScrim: defaultColors.mScrim
  property color mSecondary: defaultColors.mSecondary
  property color mSecondaryContainer: defaultColors.mSecondaryContainer
  property color mSecondaryFixed: defaultColors.mSecondaryFixed
  property color mSecondaryFixedDim: defaultColors.mSecondaryFixedDim
  property color mShadow: defaultColors.mShadow
  property color mSurface: defaultColors.mSurface
  property color mSurfaceBright: defaultColors.mSurfaceBright
  property color mSurfaceContainer: defaultColors.mSurfaceContainer
  property color mSurfaceContainerHigh: defaultColors.mSurfaceContainerHigh
  property color mSurfaceContainerHighest: defaultColors.mSurfaceContainerHighest
  property color mSurfaceContainerLow: defaultColors.mSurfaceContainerLow
  property color mSurfaceContainerLowest: defaultColors.mSurfaceContainerLowest
  property color mSurfaceDim: defaultColors.mSurfaceDim
  property color mSurfaceTint: defaultColors.mSurfaceTint
  property color mSurfaceVariant: defaultColors.mSurfaceVariant
  property color mTertiary: defaultColors.mTertiary
  property color mTertiaryContainer: defaultColors.mTertiaryContainer
  property color mTertiaryFixed: defaultColors.mTertiaryFixed
  property color mTertiaryFixedDim: defaultColors.mTertiaryFixedDim

  Timer {
    id: transactionTimer
    interval: Theme.animationSlowest + Theme.animationBuffer
    onTriggered: root.isTransitioning = false
  }

  function startTransition() {
    root.isTransitioning = true;
    transactionTimer.restart();
  }

  Timer {
    id: colorReloadDebounceTimer
    running: false
    interval: Theme.animationBuffer
    onTriggered: {
      if (colorsFileView.path !== undefined) {
        Logger.i("Colors", "Reload colors after detected external change to file");
        colorsFileView.reload();
      }
    }
  }

  function scheduleColorsReload() {
    if (!Settings.createdDirectories || colorsFileView.path === undefined)
      return;
    colorReloadDebounceTimer.restart();
  }

  FileView {
    id: colorsFileView
    path: Settings.createdDirectories ? (Paths.configPath("colors.json")) : undefined
    printErrors: false
    watchChanges: true
    onFileChanged: scheduleColorsReload()
    onPathChanged: {
      if (path !== undefined)
        reload();
    }

    JsonAdapter {
      id: dataAdapter
      property color mBackground: defaultColors.mBackground
      property color mError: defaultColors.mError
      property color mErrorContainer: defaultColors.mErrorContainer
      property color mInverseOnSurface: defaultColors.mInverseOnSurface
      property color mInversePrimary: defaultColors.mInversePrimary
      property color mInverseSurface: defaultColors.mInverseSurface
      property color mOnBackground: defaultColors.mOnBackground
      property color mOnError: defaultColors.mOnError
      property color mOnErrorContainer: defaultColors.mOnErrorContainer
      property color mOnPrimary: defaultColors.mOnPrimary
      property color mOnPrimaryContainer: defaultColors.mOnPrimaryContainer
      property color mOnPrimaryFixed: defaultColors.mOnPrimaryFixed
      property color mOnPrimaryFixedVariant: defaultColors.mOnPrimaryFixedVariant
      property color mOnSecondary: defaultColors.mOnSecondary
      property color mOnSecondaryContainer: defaultColors.mOnSecondaryContainer
      property color mOnSecondaryFixed: defaultColors.mOnSecondaryFixed
      property color mOnSecondaryFixedVariant: defaultColors.mOnSecondaryFixedVariant
      property color mOnSurface: defaultColors.mOnSurface
      property color mOnSurfaceVariant: defaultColors.mOnSurfaceVariant
      property color mOnTertiary: defaultColors.mOnTertiary
      property color mOnTertiaryContainer: defaultColors.mOnTertiaryContainer
      property color mOnTertiaryFixed: defaultColors.mOnTertiaryFixed
      property color mOnTertiaryFixedVariant: defaultColors.mOnTertiaryFixedVariant
      property color mOutline: defaultColors.mOutline
      property color mOutlineVariant: defaultColors.mOutlineVariant
      property color mPrimary: defaultColors.mPrimary
      property color mPrimaryContainer: defaultColors.mPrimaryContainer
      property color mPrimaryFixed: defaultColors.mPrimaryFixed
      property color mPrimaryFixedDim: defaultColors.mPrimaryFixedDim
      property color mScrim: defaultColors.mScrim
      property color mSecondary: defaultColors.mSecondary
      property color mSecondaryContainer: defaultColors.mSecondaryContainer
      property color mSecondaryFixed: defaultColors.mSecondaryFixed
      property color mSecondaryFixedDim: defaultColors.mSecondaryFixedDim
      property color mShadow: defaultColors.mShadow
      property color mSurface: defaultColors.mSurface
      property color mSurfaceBright: defaultColors.mSurfaceBright
      property color mSurfaceContainer: defaultColors.mSurfaceContainer
      property color mSurfaceContainerHigh: defaultColors.mSurfaceContainerHigh
      property color mSurfaceContainerHighest: defaultColors.mSurfaceContainerHighest
      property color mSurfaceContainerLow: defaultColors.mSurfaceContainerLow
      property color mSurfaceContainerLowest: defaultColors.mSurfaceContainerLowest
      property color mSurfaceDim: defaultColors.mSurfaceDim
      property color mSurfaceTint: defaultColors.mSurfaceTint
      property color mSurfaceVariant: defaultColors.mSurfaceVariant
      property color mTertiary: defaultColors.mTertiary
      property color mTertiaryContainer: defaultColors.mTertiaryContainer
      property color mTertiaryFixed: defaultColors.mTertiaryFixed
      property color mTertiaryFixedDim: defaultColors.mTertiaryFixedDim
    }
  }

  Connections {
    target: dataAdapter

    function onMBackgroundChanged() {
      root.startTransition();
      root.mBackground = dataAdapter.mBackground;
    }

    function onMErrorChanged() {
      root.startTransition();
      root.mError = dataAdapter.mError;
    }

    function onMErrorContainerChanged() {
      root.startTransition();
      root.mErrorContainer = dataAdapter.mErrorContainer;
    }

    function onMInverseOnSurfaceChanged() {
      root.startTransition();
      root.mInverseOnSurface = dataAdapter.mInverseOnSurface;
    }

    function onMInversePrimaryChanged() {
      root.startTransition();
      root.mInversePrimary = dataAdapter.mInversePrimary;
    }

    function onMInverseSurfaceChanged() {
      root.startTransition();
      root.mInverseSurface = dataAdapter.mInverseSurface;
    }

    function onMOnBackgroundChanged() {
      root.startTransition();
      root.mOnBackground = dataAdapter.mOnBackground;
    }

    function onMOnErrorChanged() {
      root.startTransition();
      root.mOnError = dataAdapter.mOnError;
    }

    function onMOnErrorContainerChanged() {
      root.startTransition();
      root.mOnErrorContainer = dataAdapter.mOnErrorContainer;
    }

    function onMOnPrimaryChanged() {
      root.startTransition();
      root.mOnPrimary = dataAdapter.mOnPrimary;
    }

    function onMOnPrimaryContainerChanged() {
      root.startTransition();
      root.mOnPrimaryContainer = dataAdapter.mOnPrimaryContainer;
    }

    function onMOnPrimaryFixedChanged() {
      root.startTransition();
      root.mOnPrimaryFixed = dataAdapter.mOnPrimaryFixed;
    }

    function onMOnPrimaryFixedVariantChanged() {
      root.startTransition();
      root.mOnPrimaryFixedVariant = dataAdapter.mOnPrimaryFixedVariant;
    }

    function onMOnSecondaryChanged() {
      root.startTransition();
      root.mOnSecondary = dataAdapter.mOnSecondary;
    }

    function onMOnSecondaryContainerChanged() {
      root.startTransition();
      root.mOnSecondaryContainer = dataAdapter.mOnSecondaryContainer;
    }

    function onMOnSecondaryFixedChanged() {
      root.startTransition();
      root.mOnSecondaryFixed = dataAdapter.mOnSecondaryFixed;
    }

    function onMOnSecondaryFixedVariantChanged() {
      root.startTransition();
      root.mOnSecondaryFixedVariant = dataAdapter.mOnSecondaryFixedVariant;
    }

    function onMOnSurfaceChanged() {
      root.startTransition();
      root.mOnSurface = dataAdapter.mOnSurface;
    }

    function onMOnSurfaceVariantChanged() {
      root.startTransition();
      root.mOnSurfaceVariant = dataAdapter.mOnSurfaceVariant;
    }

    function onMOnTertiaryChanged() {
      root.startTransition();
      root.mOnTertiary = dataAdapter.mOnTertiary;
    }

    function onMOnTertiaryContainerChanged() {
      root.startTransition();
      root.mOnTertiaryContainer = dataAdapter.mOnTertiaryContainer;
    }

    function onMOnTertiaryFixedChanged() {
      root.startTransition();
      root.mOnTertiaryFixed = dataAdapter.mOnTertiaryFixed;
    }

    function onMOnTertiaryFixedVariantChanged() {
      root.startTransition();
      root.mOnTertiaryFixedVariant = dataAdapter.mOnTertiaryFixedVariant;
    }

    function onMOutlineChanged() {
      root.startTransition();
      root.mOutline = dataAdapter.mOutline;
    }

    function onMOutlineVariantChanged() {
      root.startTransition();
      root.mOutlineVariant = dataAdapter.mOutlineVariant;
    }

    function onMPrimaryChanged() {
      root.startTransition();
      root.mPrimary = dataAdapter.mPrimary;
    }

    function onMPrimaryContainerChanged() {
      root.startTransition();
      root.mPrimaryContainer = dataAdapter.mPrimaryContainer;
    }

    function onMPrimaryFixedChanged() {
      root.startTransition();
      root.mPrimaryFixed = dataAdapter.mPrimaryFixed;
    }

    function onMPrimaryFixedDimChanged() {
      root.startTransition();
      root.mPrimaryFixedDim = dataAdapter.mPrimaryFixedDim;
    }

    function onMScrimChanged() {
      root.startTransition();
      root.mScrim = dataAdapter.mScrim;
    }

    function onMSecondaryChanged() {
      root.startTransition();
      root.mSecondary = dataAdapter.mSecondary;
    }

    function onMSecondaryContainerChanged() {
      root.startTransition();
      root.mSecondaryContainer = dataAdapter.mSecondaryContainer;
    }

    function onMSecondaryFixedChanged() {
      root.startTransition();
      root.mSecondaryFixed = dataAdapter.mSecondaryFixed;
    }

    function onMSecondaryFixedDimChanged() {
      root.startTransition();
      root.mSecondaryFixedDim = dataAdapter.mSecondaryFixedDim;
    }

    function onMShadowChanged() {
      root.startTransition();
      root.mShadow = dataAdapter.mShadow;
    }

    function onMSurfaceChanged() {
      root.startTransition();
      root.mSurface = dataAdapter.mSurface;
    }

    function onMSurfaceBrightChanged() {
      root.startTransition();
      root.mSurfaceBright = dataAdapter.mSurfaceBright;
    }

    function onMSurfaceContainerChanged() {
      root.startTransition();
      root.mSurfaceContainer = dataAdapter.mSurfaceContainer;
    }

    function onMSurfaceContainerHighChanged() {
      root.startTransition();
      root.mSurfaceContainerHigh = dataAdapter.mSurfaceContainerHigh;
    }

    function onMSurfaceContainerHighestChanged() {
      root.startTransition();
      root.mSurfaceContainerHighest = dataAdapter.mSurfaceContainerHighest;
    }

    function onMSurfaceContainerLowChanged() {
      root.startTransition();
      root.mSurfaceContainerLow = dataAdapter.mSurfaceContainerLow;
    }

    function onMSurfaceContainerLowestChanged() {
      root.startTransition();
      root.mSurfaceContainerLowest = dataAdapter.mSurfaceContainerLowest;
    }

    function onMSurfaceDimChanged() {
      root.startTransition();
      root.mSurfaceDim = dataAdapter.mSurfaceDim;
    }

    function onMSurfaceTintChanged() {
      root.startTransition();
      root.mSurfaceTint = dataAdapter.mSurfaceTint;
    }

    function onMSurfaceVariantChanged() {
      root.startTransition();
      root.mSurfaceVariant = dataAdapter.mSurfaceVariant;
    }

    function onMTertiaryChanged() {
      root.startTransition();
      root.mTertiary = dataAdapter.mTertiary;
    }

    function onMTertiaryContainerChanged() {
      root.startTransition();
      root.mTertiaryContainer = dataAdapter.mTertiaryContainer;
    }

    function onMTertiaryFixedChanged() {
      root.startTransition();
      root.mTertiaryFixed = dataAdapter.mTertiaryFixed;
    }

    function onMTertiaryFixedDimChanged() {
      root.startTransition();
      root.mTertiaryFixedDim = dataAdapter.mTertiaryFixedDim;
    }
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
