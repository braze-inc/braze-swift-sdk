#if !os(tvOS)

  import BrazeKit
  import CryptoKit
  import Foundation
  import UIKit

  /// Produces stable `InAppMessageContentState` instances that are used to decide when cached HTML payloads
  /// must be refreshed. The HTML implementation hashes together the markup and base URL so that
  /// concurrent renderers can safely compare states.
  enum InAppMessageContentStateFactory {

    static func html(
      message: Braze.InAppMessage.Html,
      baseURL: URL,
      traits: UITraitCollection
    ) -> InAppMessageContentState {
      InAppMessageContentState(
        messageId: message.data.id,
        contentHash: sha256(components: [message.message, baseURL.absoluteString]),
        traits: traits,
        extras: ["baseURL": AnyHashable(baseURL)]
      )
    }

    private static func sha256(components: [String]) -> String {
      let data = Data(components.joined(separator: "|").utf8)
      let digest = SHA256.hash(data: data)
      return digest.map { String(format: "%02x", $0) }.joined()
    }
  }

#endif
