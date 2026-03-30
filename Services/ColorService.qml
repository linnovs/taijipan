pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io
import qs.Commons

Singleton {
  id: root

  property string jsonFilePath: Paths.assetsDir + "/colors.json"
  property alias adapter: adapter

  function init() {
    Logger.i("ColorService", "Service started");
    colorsFileView.adapter = adapter;
  }

  FileView {
    id: colorsFileView
    path: root.jsonFilePath ? root.jsonFilePath : undefined
    printErrors: false
    watchChanges: true

    onFileChanged: {
      Logger.d("ColorService", "Reloading colors from file: " + root.jsonFilePath);
      reload()
    }
    onAdapterUpdated: {
      Logger.d("ColorService", "Writing colors to file: " + root.jsonFilePath);
      writeAdapter();
    }
    onLoadFailed: function (error) {
      if (error === 2 || error.toString().includes("No such file")) {
        writeAdapter();
      }
    }
  }

  JsonAdapter {
    id: adapter

    property color mBackground: "transparent"
    property color mError: "transparent"
    property color mErrorContainer: "transparent"
    property color mInverseOnSurface: "transparent"
    property color mInversePrimary: "transparent"
    property color mInverseSurface: "transparent"
    property color mOnBackground: "transparent"
    property color mOnError: "transparent"
    property color mOnErrorContainer: "transparent"
    property color mOnPrimary: "transparent"
    property color mOnPrimaryContainer: "transparent"
    property color mOnPrimaryFixed: "transparent"
    property color mOnPrimaryFixedVariant: "transparent"
    property color mOnSecondary: "transparent"
    property color mOnSecondaryContainer: "transparent"
    property color mOnSecondaryFixed: "transparent"
    property color mOnSecondaryFixedVariant: "transparent"
    property color mOnSurface: "transparent"
    property color mOnSurfaceVariant: "transparent"
    property color mOnTertiary: "transparent"
    property color mOnTertiaryContainer: "transparent"
    property color mOnTertiaryFixed: "transparent"
    property color mOnTertiaryFixedVariant: "transparent"
    property color mOutline: "transparent"
    property color mOutlineVariant: "transparent"
    property color mPrimary: "transparent"
    property color mPrimaryContainer: "transparent"
    property color mPrimaryFixed: "transparent"
    property color mPrimaryFixedDim: "transparent"
    property color mScrim: "transparent"
    property color mSecondary: "transparent"
    property color mSecondaryContainer: "transparent"
    property color mSecondaryFixed: "transparent"
    property color mSecondaryFixedDim: "transparent"
    property color mShadow: "transparent"
    property color mSurface: "transparent"
    property color mSurfaceBright: "transparent"
    property color mSurfaceContainer: "transparent"
    property color mSurfaceContainerHigh: "transparent"
    property color mSurfaceContainerHighest: "transparent"
    property color mSurfaceContainerLow: "transparent"
    property color mSurfaceContainerLowest: "transparent"
    property color mSurfaceDim: "transparent"
    property color mSurfaceTint: "transparent"
    property color mSurfaceVariant: "transparent"
    property color mTertiary: "transparent"
    property color mTertiaryContainer: "transparent"
    property color mTertiaryFixed: "transparent"
    property color mTertiaryFixedDim: "transparent"
  }
}
