import UIKit

/// VisibilityTracker keeps track of a list of visible identifiers and can report when they remain
/// visible for more than a specified time interval.
open class VisibilityTracker<Identifier: Hashable> {

  // MARK: - Properties

  private let interval: TimeInterval
  private let visibleIdentifiers: () -> [Identifier]
  private let visibleForInterval: (Identifier) -> Void
  private let exitVisible: (Identifier, _ afterInterval: Bool) -> Void

  private lazy var displayLink: CADisplayLink = createDisplayLink()
  private var identifiersMap: [Identifier: CFTimeInterval] = [:]
  private var previousTimestamp: CFTimeInterval = CACurrentMediaTime()

  // MARK: - Initialization

  /// Creates a visibility tracker.
  /// - Parameters:
  ///   - interval: The interval of time after which the `visibleForInterval` closure is called.
  ///   - visibleIdentifiers: Provide the currently visible identifiers to the visibility tracker.
  ///                         This closure is executed multiple times per second.
  ///   - visibleForInterval: A closure executed when an identifier has remained visible more than
  ///                         `interval` seconds.
  ///   - exitVisible: A closure executed when an identifier exits the list of visible identifiers.
  ///                  The second parameter indicates if the identifier has remained visible more
  ///                  than `interval` seconds before its exit.
  public init(
    interval: TimeInterval = 0.3,
    visibleIdentifiers: @escaping () -> [Identifier],
    visibleForInterval: @escaping (Identifier) -> Void = { _ in },
    exitVisible: @escaping (Identifier, _ afterInterval: Bool) -> Void = { _, _ in }
  ) {
    self.interval = interval
    self.visibleIdentifiers = visibleIdentifiers
    self.visibleForInterval = visibleForInterval
    self.exitVisible = exitVisible
  }

  // MARK: - Actions

  /// Starts tracking the identifiers visibility.
  public func start() {
    displayLink.invalidate()
    displayLink = createDisplayLink()
    previousTimestamp = CACurrentMediaTime()
    displayLink.add(to: .main, forMode: .common)
  }

  /// Stops tracking the identifiers visibility
  /// - Parameter setInvisible: Marks the current identifiers as invisible and execute the
  ///                           `exitVisible` closure.
  public func stop(setInvisible: Bool = true) {
    displayLink.invalidate()

    if setInvisible {
      identifiersMap.keys.forEach { exitVisible($0, false) }
      identifiersMap = [:]
    }
  }

  // MARK: - CADisplayLink Tick

  @objc
  private func displayLinkTick(_ displayLink: CADisplayLink) {
    defer { previousTimestamp = displayLink.timestamp }

    let previous = Set(identifiersMap.keys)
    let current = Set(visibleIdentifiers())

    let insertions = current.subtracting(previous)
    let deletions = previous.subtracting(current)
    let visibles = current.intersection(previous)

    insertions.forEach {
      identifiersMap[$0] = displayLink.timestamp
    }

    deletions.forEach {
      let afterInterval = identifiersMap[$0] == -1
      identifiersMap[$0] = nil
      exitVisible($0, afterInterval)
    }

    let visiblesAfterInterval =
      identifiersMap
      .filter { id, start in
        visibles.contains(id)
          && start != -1
          && displayLink.timestamp - start > interval
      }
      .keys
    visiblesAfterInterval
      .forEach {
        identifiersMap[$0] = -1
        visibleForInterval($0)
      }
  }

  // MARK: - Misc.

  private func createDisplayLink() -> CADisplayLink {
    let displayLink = CADisplayLink(target: self, selector: #selector(displayLinkTick))
    if #available(iOS 15.0, *) {
      displayLink.preferredFrameRateRange = .init(minimum: 10, maximum: 20, preferred: 15)
    } else {
      displayLink.preferredFramesPerSecond = 15
    }
    return displayLink
  }
}
