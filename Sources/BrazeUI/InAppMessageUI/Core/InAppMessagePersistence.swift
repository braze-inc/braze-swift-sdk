import Foundation

/// Persistence interface for HTML-based in-app messages.
protocol InAppMessagePersistenceProtocol {
  typealias WriteCompletion = (Result<URL, Error>) -> Void

  func write(
    content: Data,
    named fileName: String,
    in directory: URL,
    completion: @escaping WriteCompletion
  )

  func availableFileURL(
    named fileName: String,
    in directory: URL
  ) -> URL?
}

/// Writes HTML payloads to disk on a background queue before handing them to a renderer.
final class InAppMessagePersistenceQueueWriter: InAppMessagePersistenceProtocol {

  private let queue: DispatchQueue
  private let callbackQueue: DispatchQueue
  private let fileManager: FileManaging
  private let dataWritingOptions: Data.WritingOptions

  init(
    label: String = "com.braze.inappmessage.persistence",
    qos: DispatchQoS = .userInitiated,
    callbackQueue: DispatchQueue = .main,
    fileManager: FileManaging = FileManager.default,
    dataWritingOptions: Data.WritingOptions = []
  ) {
    self.queue = DispatchQueue(label: label, qos: qos)
    self.callbackQueue = callbackQueue
    self.fileManager = fileManager
    self.dataWritingOptions = dataWritingOptions
  }

  func write(
    content: Data,
    named fileName: String,
    in directory: URL,
    completion: @escaping WriteCompletion
  ) {
    queue.async { [fileManager, callbackQueue, dataWritingOptions] in
      let destination = directory.appendingPathComponent(fileName)

      do {
        // Lazily create the directory so repeated presentations don't crash when it already exists.
        try fileManager.createDirectory(at: directory, withIntermediateDirectories: true)

        // Persist the HTML payload to disk using the configured write options (e.g. no atomic write).
        try fileManager.write(content, to: destination, options: dataWritingOptions)

        // Hop back to the caller queue with the resulting URL.
        callbackQueue.async {
          completion(.success(destination))
        }
      } catch {
        // Clean up any partially written files before reporting the failure.
        try? fileManager.removeItem(at: destination)
        callbackQueue.async {
          completion(.failure(error))
        }
      }
    }
  }

  func availableFileURL(
    named fileName: String,
    in directory: URL
  ) -> URL? {
    let destination = directory.appendingPathComponent(fileName)
    return fileManager.fileExists(atPath: destination.path) ? destination : nil
  }
}
