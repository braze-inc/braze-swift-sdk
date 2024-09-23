import Foundation

/// Method wrapping deinitialization work in a main actor context.
///
/// This method workaround the error _Call to main actor-isolated instance method '...' in a
/// synchronous nonisolated context_ when performing cleanup in a MainActor bound deinit method.
/// In that context, `deinit` is not isolated to the MainActor by Swift concurrency, but can be
/// guaranteed to the main thread for historical reasons (e.g. UIKit lifecycle).
///
/// - SeeAlso: [Deinit and MainActor](https://archive.is/whA6f) and
///            [Isolated synchronous deinit](https://archive.is/9MfIY)
///
/// - Important: This method should only ever be used in the `deinit` method of a class that is
///              guaranteed to be deinitialized on the main thread (e.g. `UIView`,
///              `UIViewController`).
///
/// - Parameter work: The deinitialization work to perform.
func isolatedMainActorDeinit(work: @MainActor @Sendable @escaping () -> Void) {
  #if compiler(>=5.10)
    if #available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *) {
      MainActor.assumeIsolated { work() }
    } else {
      DispatchQueue.main.async { work() }
    }
  #else
    if #available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *) {
      MainActor.assumeIsolated { work() }
    } else {
      DispatchQueue.main.async { work() }
    }
  #endif
}
