import BrazeKit
import CommonCrypto
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
    if #available(iOS 13.0, tvOS 13.0, macOS 10.15, watchOS 6.0, *) {
      let digest = SHA256.hash(data: data)
      return digest.map { String(format: "%02x", $0) }.joined()
    } else {
      return legacySha256(data: data)
    }
  }

  private static func legacySha256(data: Data) -> String {
    var hash = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
    data.withUnsafeBytes { buffer in
      _ = CC_SHA256(buffer.baseAddress, CC_LONG(buffer.count), &hash)
    }
    return hash.map { String(format: "%02x", $0) }.joined()
  }
}
