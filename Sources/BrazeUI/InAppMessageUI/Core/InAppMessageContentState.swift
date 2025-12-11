import Foundation
import UIKit

struct InAppMessageContentState: Equatable {

  var messageId: String?
  var contentHash: String
  var traitSignature: TraitSignature
  var extras: [String: AnyHashable]

  init(
    messageId: String?,
    contentHash: String,
    traits: UITraitCollection,
    extras: [String: AnyHashable] = [:]
  ) {
    self.messageId = messageId
    self.contentHash = contentHash
    self.traitSignature = .init(traits: traits)
    self.extras = extras
  }

  init(
    messageId: String?,
    contentHash: String,
    traitSignature: TraitSignature,
    extras: [String: AnyHashable] = [:]
  ) {
    self.messageId = messageId
    self.contentHash = contentHash
    self.traitSignature = traitSignature
    self.extras = extras
  }

  struct TraitSignature: Equatable {
    var userInterfaceStyle: UIUserInterfaceStyle
    var horizontalSizeClass: UIUserInterfaceSizeClass
    var verticalSizeClass: UIUserInterfaceSizeClass
    var contentSizeCategory: UIContentSizeCategory
    var displayScale: CGFloat

    init(
      userInterfaceStyle: UIUserInterfaceStyle,
      horizontalSizeClass: UIUserInterfaceSizeClass,
      verticalSizeClass: UIUserInterfaceSizeClass,
      contentSizeCategory: UIContentSizeCategory,
      displayScale: CGFloat
    ) {
      self.userInterfaceStyle = userInterfaceStyle
      self.horizontalSizeClass = horizontalSizeClass
      self.verticalSizeClass = verticalSizeClass
      self.contentSizeCategory = contentSizeCategory
      self.displayScale = displayScale
    }

    init(traits: UITraitCollection) {
      self.init(
        userInterfaceStyle: traits.userInterfaceStyle,
        horizontalSizeClass: traits.horizontalSizeClass,
        verticalSizeClass: traits.verticalSizeClass,
        contentSizeCategory: traits.preferredContentSizeCategory,
        displayScale: traits.displayScale
      )
    }
  }
}
