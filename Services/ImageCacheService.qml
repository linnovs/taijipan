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
  readonly property int thumbnailSize: 384

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
  }

  Connections {
    target: checkMagickProcess
    function onExited(exitCode) {
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
    id: checkFileExistsComponent
    Process {
      required property string filePath
      command: ["test", "-f", filePath]
      stdout: StdioCollector {}
      stderr: StdioCollector {}
    }
  }

  function checkFileExists(filePath, callback) {
    queueCommand({
      name: "checkFileExists",
      component: checkFileExistsComponent,
      params: {
        filePath
      },
      callback: function (exitCode) {
        callback(exitCode === 0);
      },
      onError: function () {
        callback(false);
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
      command: ["magick", `${sourcePath}`, "-auto-orient", "-filter", "Lanczos", "-resize", `${width}x${height}^`, `${targetPath}`]
      stdout: StdioCollector {}
      stderr: StdioCollector {}
    }
  }

  function downscaleImage(sourcePath, targetPath, width, height, callback) {
    checkFileExists(targetPath, function (exists) {
      if (exists) {
        callback(targetPath);
        return;
      }

      queueCommand({
        name: "downscaleImage",
        component: downscaleImageComponent,
        params: {
          sourcePath,
          targetPath,
          width,
          height
        },
        callback: function (exitCode, processObj) {
          if (exitCode !== 0) {
            const errMsg = processObj.stderr.text.trim();
            const idx = errMsg.indexOf(":") + 1;
            const msg = errMsg.substring(0, idx).padStart(10, " ") + errMsg.substring(idx);
            Logger.e("ImageCacheService", "Failed to downscale image:", Paths.replaceHomeWithTilde(sourcePath));
            Logger.e("ImageCacheService", "  ->", Paths.replaceHomeWithTilde(targetPath));
            Logger.e("ImageCacheService", "  -> Exit code:", exitCode, "\n", msg);
          }
          callback(exitCode === 0);
        },
        onError: function () {
          callback(false);
        }
      });
    });
  }

  // callback will be called with the file path to the cached image, or empty string if original image should be used
  function getLarge(sourceImage, width, height, callback) {
    if (!magickAvailable) {
      Logger.d("ImageCacheService", "ImageMagick not available, use original:", Paths.replaceHomeWithTilde(sourceImage));
      callback("");
      return;
    }

    let imagePath = Paths.isFileUrl(sourceImage) ? Paths.strip(sourceImage) : sourceImage;
    getDimensions(imagePath, function (imgWidth, imgHeight) {
      const fitsScreen = imgWidth > 0 && imgHeight > 0 && imgWidth <= width && imgHeight <= height;

      if (fitsScreen) {
        if (isSupportedImageFormat(imagePath)) {
          Logger.d("ImageCacheService", "Image fits screen and is in supported format, use original:", Paths.replaceHomeWithTilde(sourceImage));
          callback("");
          return;
        }
        Logger.d("ImageCacheService", "Image fits screen but is in unsupported format, will convert to PNG:", Paths.replaceHomeWithTilde(sourceImage));
      }

      const targetWidth = fitsScreen ? imgWidth : width;
      const targetHeight = fitsScreen ? imgHeight : height;

      getMTime(imagePath, function (mtime) {
        const cacheKey = generateCacheKey(imagePath, targetWidth, targetHeight, mtime);
        const cacheFilePath = Paths.joinDir(root.bgFullDir, cacheKey + ".png");

        downscaleImage(imagePath, cacheFilePath, targetWidth, targetHeight, function (success) {
          if (success) {
            callback(Paths.toFileUrl(cacheFilePath));
          } else {
            callback("");
          }
        });
      });
    });
  }

  // callback will be called with the file path to the cached thumbnail, or empty string if original image should be used
  function getThumbnail(sourceImage, callback) {
    if (!magickAvailable) {
      Logger.d("ImageCacheService", "ImageMagick not available, use original:", Paths.replaceHomeWithTilde(sourceImage));
      callback("");
      return;
    }

    if (!sourceImage || sourceImage === "") {
      callback("");
      return;
    }

    let imagePath = Paths.isFileUrl(sourceImage) ? Paths.strip(sourceImage) : sourceImage;
    getMTime(imagePath, function (mtime) {
      const cacheKey = generateCacheKey(imagePath, thumbnailSize, thumbnailSize, mtime);
      const cacheFilePath = Paths.joinDir(root.bgThumbDir, cacheKey + ".png");

      downscaleImage(imagePath, cacheFilePath, thumbnailSize, thumbnailSize, function (success) {
        if (success) {
          callback(Paths.toFileUrl(cacheFilePath));
        } else {
          callback("");
        }
      });
    });
  }
}
