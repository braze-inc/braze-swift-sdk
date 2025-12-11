import Foundation

/// Type-erased subset of `FileManager` used by BrazeUI components.
///
/// Exposed as a protocol so tests can inject lightweight file-system doubles.
protocol FileManaging {
  func createDirectory(
    at url: URL,
    withIntermediateDirectories: Bool,
    attributes: [FileAttributeKey: Any]?
  ) throws

  func fileExists(atPath path: String) -> Bool

  func removeItem(at url: URL) throws

  func write(_ data: Data, to url: URL, options: Data.WritingOptions) throws
}

extension FileManaging {
  func createDirectory(at url: URL, withIntermediateDirectories: Bool) throws {
    try createDirectory(
      at: url,
      withIntermediateDirectories: withIntermediateDirectories,
      attributes: nil
    )
  }
}

extension FileManager: FileManaging {

  func createDirectory(
    at url: URL,
    withIntermediateDirectories: Bool,
    attributes: [FileAttributeKey: Any]?
  ) throws {
    try createDirectory(
      atPath: url.path,
      withIntermediateDirectories: withIntermediateDirectories,
      attributes: attributes
    )
  }

  func removeItem(at url: URL) throws {
    try removeItem(atPath: url.path)
  }

  func write(_ data: Data, to url: URL, options: Data.WritingOptions) throws {
    try data.write(to: url, options: options)
  }

}
