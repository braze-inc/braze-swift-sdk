import Foundation

/// Executes `work` with MainActor isolation, assuming the caller is already on the main thread.
///
/// Use this to call `@MainActor`-isolated methods from nonisolated synchronous contexts that are
/// nonetheless guaranteed to run on the main thread — for example, `deinit` on a `UIView`
/// subclass, or a `NotificationCenter` observer block registered with `queue: .main`.
///
/// On iOS 13+, `MainActor.assumeIsolated` is used to satisfy the compiler without a dispatch.
/// On earlier OS versions, `DispatchQueue.main.async` is used as a fallback.
///
/// - SeeAlso: [Deinit and MainActor](https://archive.is/whA6f) and
///            [Isolated synchronous deinit](https://archive.is/9MfIY)
///
/// - Important: Only call this from a context that is guaranteed to execute on the main thread.
///              Calling from a background thread will result in a runtime crash on iOS 13+.
///
/// - Parameter work: The work to perform on the main actor.
func runOnMainActorIsolated(work: @MainActor @Sendable @escaping () -> Void) {
  if #available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *) {
    MainActor.assumeIsolated { work() }
  } else {
    DispatchQueue.main.async { work() }
  }
}
