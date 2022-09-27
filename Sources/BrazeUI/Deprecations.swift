// MARK: - Pre feature-parity

// MARK: 08/25/2022

/// See ``GIFViewProvider-swift.struct/shared``.
@available(*, deprecated, renamed: "GIFViewProvider.shared")
public var gifViewProvider: GIFViewProvider {
  get { GIFViewProvider.shared }
  set { GIFViewProvider.shared = newValue }
}

// MARK: 08/26/2022

extension GIFViewProvider {

  /// See ``nonAnimating``.
  @available(*, deprecated, renamed: "nonAnimating")
  public static let `default`: GIFViewProvider = .nonAnimating

}
