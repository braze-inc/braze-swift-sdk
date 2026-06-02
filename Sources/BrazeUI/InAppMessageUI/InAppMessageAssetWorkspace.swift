import Foundation

/// Handles in-app message asset directory lifecycle for ``BrazeInAppMessageUI``.
///
/// The default implementation uses the caches directory under
/// ``BrazeInAppMessageUI/assetsDirectory()``. Tests may substitute a different implementation to
/// avoid disk access or to assert reset behavior.
///
/// Isolated to the main actor: callers use this from ``BrazeInAppMessageUI``, which is ``@MainActor``.
@MainActor
internal protocol InAppMessageAssetWorkspace {
  func resetAssetsDirectory() throws -> URL
}

internal struct DefaultInAppMessageAssetWorkspace: InAppMessageAssetWorkspace {
  func resetAssetsDirectory() throws -> URL {
    let fileManager = FileManager.default
    let assetsDirectory = try BrazeInAppMessageUI.assetsDirectory()

    if fileManager.fileExists(atPath: assetsDirectory.path) {
      try fileManager.removeItem(at: assetsDirectory)
    }
    try fileManager.createDirectory(at: assetsDirectory, withIntermediateDirectories: true)

    return assetsDirectory
  }
}
