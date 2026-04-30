pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io
import qs.Commons

Singleton {
  id: root

  property bool initialized: false
  property bool magickAvailable: false

  readonly property string bgThumbDir: Paths.cachePath("images", "wallpaper", "thumbnails")
  readonly property string bgFullDir: Paths.cachePath("images", "wallpaper", "full")

  readonly property list<string> supportedImageFormats: ["jpg", "jpeg", "png", "bmp"]

  function isSupportedImageFormat(filePath): bool {
    const ext = filePath.split(".").pop().toLowerCase();
    return supportedImageFormats.includes(ext);
  }

  function createCacheDirectories() {
    Quickshell.execDetached(["mkdir", "-p", bgThumbDir]);
    Quickshell.execDetached(["mkdir", "-p", bgFullDir]);
  }

  function clearCache() {
    Logger.i("ImageCacheService", "Clearing image cache");
    const dirs = [bgThumbDir, bgFullDir];
    dirs.forEach(dir => {
      Quickshell.execDetached(["find", dir, "-type", "f", "-mtime", "+15", "-delete"]);
    });
    Logger.i("ImageCacheService", "Finished clearing image cache, deleted files older than 15 days");
  }

  Process {
    id: checkMagickProcess
    command: ["sh", "-c", "command -v magick"]
    running: false
    onExited: exitCode => {
      if (exitCode === 0) {
        Logger.i("ImageCacheService", "ImageMagick is available, image processing features enabled");
        root.magickAvailable = true;
      } else {
        Logger.w("ImageCacheService", "ImageMagick is not available, image processing features disabled");
      }
      root.initialized = true;
    }
  }

  function init() {
    createCacheDirectories();
    clearCache();
    checkMagickProcess.running = true;
    Logger.i("ImageCacheService", "Loaded image cache service");
  }

  function generateCacheKey(sourceImage, width, height, mtime) {
    const keyString = `${sourceImage}@${width}x${height}@${mtime}`;
    return Checksum.sha256(keyString);
  }

  property var commandQueue: []
  property int runningCommands: 0
  readonly property int maxConcurrentCommands: 16

  function runCommand({
    name,
    component,
    params,
    callback,
    onError
  }) {
    runningCommands++;

    try {
      const procObj = component.createObject(root, params);

      procObj.exited.connect(function (exitCode) {
        procObj.destroy();
        runningCommands--;
        callback(exitCode, procObj);
        runCommandAsync();
      });

      procObj.running = true;
    } catch (e) {
      Logger.e("ImageCacheService", "Failed to create process", name + ":", e);
      runningCommands--;
      onError(e);
      runCommandAsync();
    }
  }

  function runCommandAsync() {
    while (runningCommands < maxConcurrentCommands && commandQueue.length > 0) {
      const request = commandQueue.shift();
      runCommand(request);
    }
  }

  function queueCommand(command) {
    commandQueue.push(command);
    runCommandAsync();
  }

  Component {
    id: getDimensionsComponent
    Process {
      required property string filePath
      command: ["identify", "-ping", "-format", "%w %h", filePath]
      stdout: StdioCollector {}
      stderr: StdioCollector {}
    }
  }

  // callback will be called with (width, height)
  function getDimensions(filePath, callback) {
    queueCommand({
      name: "getDimensions",
      component: getDimensionsComponent,
      params: {
        filePath
      },
      callback: function (exitCode, obj) {
        let width = 0, height = 0;
        if (exitCode === 0) {
          const parts = obj.stdout.text.trim().split(" ");
          if (parts.length === 2) {
            width = parseInt(parts[0]) || 0;
            height = parseInt(parts[1]) || 0;
          }
        }
        callback(width, height);
      },
      onError: function () {
        callback(0, 0);
      }
    });
  }

  Component {
    id: getMTimeComponent
    Process {
      required property string filePath
      command: ["stat", "-c", "%Y", filePath]
      stdout: StdioCollector {}
      stderr: StdioCollector {}
    }
  }

  // callback will be called with mtime as unix timestamp
  function getMTime(filePath, callback) {
    queueCommand({
      name: "getMTime",
      component: getMTimeComponent,
      params: {
        filePath
      },
      callback: function (exitCode, obj) {
        const mtime = exitCode === 0 ? obj.stdout.text.trim() : "";
        callback(mtime);
      },
      onError: function () {
        callback("");
      }
    });
  }

  Component {
    id: downscaleImageComponent
    Process {
      required property string sourcePath
      required property string targetPath
      required property int width
      required property int height
      command: ["magick", `'${sourcePath}'`, "-auto-orient", "-filter", "Lanczos", "-resize", `${width}x${height}^`, `'${targetPath}'`]
      stdout: StdioCollector {}
      stderr: StdioCollector {}
    }
  }

  function downscaleImage(sourcePath, targetPath, width, height, callback) {
    queueCommand({
      name: "downscaleImage",
      component: downscaleImageComponent,
      params: {
        sourcePath,
        targetPath,
        width,
        height
      },
      callback: function (exitCode) {
        callback(exitCode === 0);
      },
      onError: function () {
        callback(false);
      }
    });
  }

  // callback will be called with the file path to the cached image, or empty string if original image should be used
  function getLarge(sourceImage, width, height, callback) {
    if (!magickAvailable) {
      Logger.d("ImageCacheService", "ImageMagick not available, use original:", Paths.replaceHomeWithTilde(sourceImage));
      callback("");
      return;
    }

    let imageSource = sourceImage;

    if (Paths.isFileUrl(sourceImage)) {
      imageSource = Paths.strip(sourceImage);
    }

    getDimensions(imageSource, function (imgWidth, imgHeight) {
      const fitsScreen = imgWidth > 0 && imgHeight > 0 && imgWidth <= width && imgHeight <= height;

      if (fitsScreen) {
        if (isSupportedImageFormat(imageSource)) {
          Logger.d("ImageCacheService", "Image fits screen and is in supported format, use original:", Paths.replaceHomeWithTilde(sourceImage));
          callback("");
          return;
        }
        Logger.d("ImageCacheService", "Image fits screen but is in unsupported format, will convert to PNG:", Paths.replaceHomeWithTilde(sourceImage));
      }

      const targetWidth = fitsScreen ? imgWidth : width;
      const targetHeight = fitsScreen ? imgHeight : height;

      getMTime(imageSource, function (mtime) {
        const cacheKey = generateCacheKey(imageSource, targetWidth, targetHeight, mtime);
        const cacheFilePath = Paths.joinDir(root.bgFullDir, cacheKey + ".png");

        downscaleImage(imageSource, cacheFilePath, targetWidth, targetHeight, function (success) {
          if (success) {
            callback(Paths.toFileUrl(cacheFilePath));
          } else {
            callback("");
          }
        });
      });
    });
  }
}
