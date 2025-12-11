@MainActor
protocol InAppMessageRenderer {
  associatedtype Payload
  func update(with state: InAppMessageContentState, payload: Payload)
}
